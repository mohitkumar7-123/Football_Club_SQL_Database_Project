--Show all players from English nationality
SELECT * FROM players
where nationality = 'English';

--List defenders with market value above €50 million
SELECT  player_name, 
position, market_value 
from players
where position = 'Defender' AND market_value >5000000;

--Find matches where home team scored more than 2 goals
SELECT match_id, home_team_id, away_team_id, home_team_score
FROM matches
WHERE home_team_score > 2;

-- Display players whose contract ends in 2025
SELECT player_name, contract_end_date
FROM players
WHERE EXTRACT(YEAR FROM contract_end_date) = 2025;

--Count total players by position
SELECT position, COUNT(*) as total_player
FROM players
GROUP BY position;

--Calculate average market value by nationality
SELECT nationality, ROUND(AVG(market_value),1) as avg_market_value
FROM players
GROUP BY nationality;

--Find total goals scored in each competition
SELECT competition,SUM(home_team_score + away_team_score) as total_goal
FROM matches
GROUP BY competition;

--Show maximum and minimum player salaries by position
SELECT 
    position,
    MAX(weekly_salary) AS max_salary,
    MIN(weekly_salary) AS min_salary
FROM players
GROUP BY position
ORDER BY position;

--Group players by nationality and show count, having more than 2 players
SELECT nationality, COUNT(*) AS player_count
FROM players
GROUP BY nationality 
HAVING COUNT(*) > 2;

-- Find positions where average salary is more than €200,000
SELECT position, ROUND(AVG(weekly_salary),1) as avg_salary
FROM players
GROUP BY position
HAVING AVG (weekly_salary) >200000

--- List competitions with total attendance more than 100,000
SELECT competition, SUM(attendance) as total_attendance
FROM matches
GROUP BY competition
HAVING SUM(attendance) > 100000;

--Show players with their team details
SELECT p.player_name,p.position,t.team_name,t.city
FROM players p
INNER JOIN teams t ON p.team_id = t.team_id;

--List all teams and their players
SELECT t.team_name, p.player_name
FROM players p
LEFT JOIN teams t on t.team_id = p.team_id;

--Show all matches with team names
SELECT m.match_id, ht.team_name as home_team, at.team_name as away_team
FROM matches m
RIGHT JOIN teams ht ON m.home_team_id = ht.team_id
RIGHT JOIN teams at ON m.away_team_id = at.team_id;

--Find players with salary higher than average for their position
SELECT player_name, position, weekly_salary
FROM players p1
WHERE weekly_salary > (
    SELECT AVG(weekly_salary)
    FROM players p2
    WHERE p2.position = p1.position
);

--Show matches where attendance was above stadium average
SELECT 
    m1.competition,
    m1.attendance
FROM matches m1
WHERE m1.attendance > (
    SELECT AVG(m2.attendance)
    FROM matches m2
    WHERE m2.stadium = m1.stadium
);
-- List players who never scored a goal
SELECT player_name
FROM players
WHERE player_id NOT IN (
    SELECT DISTINCT player_id
    FROM player_stats
    WHERE goals > 0
);

--Find teams that played more matches than average
SELECT t.team_name, COUNT(*) as matches_played
FROM teams t
JOIN matches m ON t.team_id IN (m.home_team_id, m.away_team_id)
GROUP BY t.team_name
HAVING COUNT(*) > (
    SELECT AVG(match_count)
    FROM (
        SELECT COUNT(*) as match_count
        FROM matches m2
        JOIN teams t2 ON t2.team_id IN (m2.home_team_id, m2.away_team_id)
        GROUP BY t2.team_name
    ) as team_matches
);

-- Rank players by market value within their position
SELECT player_name, position, market_value,
       RANK() OVER (PARTITION BY position ORDER BY market_value DESC) as rank_in_position
FROM players;

--Calculate running total of goals by match date
SELECT match_date, home_team_score + away_team_score as goals,
       SUM(home_team_score + away_team_score) OVER (ORDER BY match_date) as running_total
FROM matches;

--Compare each player's salary with team average
SELECT 
    player_name, 
    weekly_salary,
    ROUND(AVG(weekly_salary) OVER (PARTITION BY team_id), 2) AS team_avg_salary,
    ROUND(weekly_salary - AVG(weekly_salary) OVER (PARTITION BY team_id), 2) AS diff_from_avg
FROM players
ORDER BY diff_from_avg DESC;

-- Use LAG/LEAD to show market value changes
SELECT player_name, market_value,
       LAG(market_value) OVER (ORDER BY market_value) as previous_value,
       LEAD(market_value) OVER (ORDER BY market_value) as next_value
FROM players;

-- Assign dense ranks to players by weekly salary
SELECT player_name, weekly_salary,
       DENSE_RANK() OVER (ORDER BY weekly_salary DESC) as salary_rank
FROM players;

SELECT *
FROM (
    SELECT 
        player_name,
        position,
        ROW_NUMBER() OVER (ORDER BY player_name) AS row_num
    FROM players
) AS ranked
WHERE row_num BETWEEN 1 AND 10;

--Rank teams by total goals scored
WITH team_goals AS (
    SELECT 
        t.team_id,
        t.team_name,
        SUM(
            CASE 
                WHEN m.home_team_id = t.team_id THEN m.home_team_score
                WHEN m.away_team_id = t.team_id THEN m.away_team_score
                ELSE 0 
            END
        ) AS total_goals
    FROM teams t
    JOIN matches m 
        ON t.team_id IN (m.home_team_id, m.away_team_id)
    GROUP BY t.team_id, t.team_name
)
SELECT 
    team_name,
    total_goals,
    RANK() OVER (ORDER BY total_goals DESC) AS goal_rank
FROM team_goals;
--Show percentile rank of players by market value
SELECT 
    player_name,
    market_value,
    CASE 
        WHEN market_value > (SELECT AVG(market_value) FROM players) THEN 'Above Average'
        WHEN market_value = (SELECT AVG(market_value) FROM players) THEN 'Average'
        ELSE 'Below Average'
    END AS value_category
FROM players;

--Categorize players by age

SELECT player_name, 
       EXTRACT(YEAR FROM AGE(CURRENT_DATE, date_of_birth)) as age,
       CASE 
           WHEN EXTRACT(YEAR FROM AGE(CURRENT_DATE, date_of_birth)) < 23 THEN 'Youth'
           WHEN EXTRACT(YEAR FROM AGE(CURRENT_DATE, date_of_birth)) BETWEEN 23 AND 30 THEN 'Prime'
           ELSE 'Veteran'
       END as age_category
FROM players;

--Classify matches by attendance
SELECT match_id, attendance,
       CASE 
           WHEN attendance > 50000 THEN 'High'
           WHEN attendance BETWEEN 25000 AND 50000 THEN 'Medium'
           ELSE 'Low'
       END as attendance_category
FROM matches;

--Label transfer fees
SELECT 
  transfer_fee,
    CASE 
        WHEN transfer_fee > 100000000 THEN 'Record'
        WHEN transfer_fee > 50000000 THEN 'Expensive'
        WHEN transfer_fee > 10000000 THEN 'Moderate'
        ELSE 'Cheap'
    END AS transfer_category
FROM transfers
ORDER BY transfer_fee DESC;

--Create performance tiers
SELECT p.player_name,
       COALESCE(SUM(ps.goals), 0) as total_goals,
       COALESCE(SUM(ps.assists), 0) as total_assists,
       CASE 
           WHEN COALESCE(SUM(ps.goals), 0) >= 10 OR COALESCE(SUM(ps.assists), 0) >= 10 THEN 'Elite'
           WHEN COALESCE(SUM(ps.goals), 0) >= 5 OR COALESCE(SUM(ps.assists), 0) >= 5 THEN 'Good'
           ELSE 'Average'
       END as performance_tier
FROM players p
LEFT JOIN player_stats ps ON p.player_id = ps.player_id
GROUP BY p.player_id, p.player_name;

--Calculate team performance metrics
WITH team_goals AS (
    SELECT t.team_name,
           SUM(CASE WHEN m.home_team_id = t.team_id THEN m.home_team_score
                    WHEN m.away_team_id = t.team_id THEN m.away_team_score
                    ELSE 0 END) as goals_for,
           SUM(CASE WHEN m.home_team_id = t.team_id THEN m.away_team_score
                    WHEN m.away_team_id = t.team_id THEN m.home_team_score
                    ELSE 0 END) as goals_against
    FROM teams t
    JOIN matches m ON t.team_id IN (m.home_team_id, m.away_team_id)
    GROUP BY t.team_name
),
team_performance AS (
    SELECT team_name,
           goals_for,
           goals_against,
           goals_for - goals_against as goal_difference
    FROM team_goals
)
SELECT * FROM team_performance
ORDER BY goal_difference DESC;

--Find players who transferred between rival teams
WITH rival_teams AS (
    SELECT t1.team_id as team1, t2.team_id as team2
    FROM teams t1
    CROSS JOIN teams t2
    WHERE t1.city = t2.city AND t1.team_id != t2.team_id
)
SELECT p.player_name, t1.team_name as from_team, t2.team_name as to_team
FROM transfers tr
JOIN players p ON tr.player_id = p.player_id
JOIN teams t1 ON tr.from_team_id = t1.team_id
JOIN teams t2 ON tr.to_team_id = t2.team_id
JOIN rival_teams r ON (tr.from_team_id = r.team1 AND tr.to_team_id = r.team2)
    OR (tr.from_team_id = r.team2 AND tr.to_team_id = r.team1);

--Complex player statistics using nested CTEs
WITH player_matches AS (
    SELECT p.player_id, p.player_name, COUNT(ps.match_id) as matches_played
    FROM players p
    LEFT JOIN player_stats ps ON p.player_id = ps.player_id
    GROUP BY p.player_id, p.player_name
),
player_goals AS (
    SELECT p.player_id, COALESCE(SUM(ps.goals), 0) as total_goals
    FROM players p
    LEFT JOIN player_stats ps ON p.player_id = ps.player_id
    GROUP BY p.player_id
),
player_assists AS (
    SELECT p.player_id, COALESCE(SUM(ps.assists), 0) as total_assists
    FROM players p
    LEFT JOIN player_stats ps ON p.player_id = ps.player_id
    GROUP BY p.player_id
)
SELECT pm.player_name, 
       pm.matches_played,
       pg.total_goals,
       pa.total_assists,
       ROUND(pg.total_goals * 1.0 / NULLIF(pm.matches_played, 0), 2) as goals_per_match
FROM player_matches pm
JOIN player_goals pg ON pm.player_id = pg.player_id
JOIN player_assists pa ON pm.player_id = pa.player_id
ORDER BY goals_per_match DESC;

--DATE/TIME FUNCTIONS
-- Extract month and year from match dates
SELECT match_id, match_date,
       EXTRACT(YEAR FROM match_date) as year,
       EXTRACT(MONTH FROM match_date) as month,
       TO_CHAR(match_date, 'Month') as month_name
FROM matches;

--Calculate player age from date of birth
SELECT player_name, date_of_birth,
       EXTRACT(YEAR FROM AGE(CURRENT_DATE, date_of_birth)) as age_years,
       AGE(CURRENT_DATE, date_of_birth) as exact_age
FROM players;

