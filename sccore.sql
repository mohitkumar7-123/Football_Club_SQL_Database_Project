--Show 
-- FOOTBALL CLUB DATABASE

-- PLAYERS TABLE
CREATE TABLE players (
    player_id INT PRIMARY KEY,
    player_name VARCHAR(100),
    position VARCHAR(20),
    nationality VARCHAR(50),
    date_of_birth DATE,
    jersey_number INT,
    market_value DECIMAL(10,2),
    weekly_salary DECIMAL(10,2),
    contract_end_date DATE
);

-- TEAMS TABLE
CREATE TABLE teams (
    team_id INT PRIMARY KEY,
    team_name VARCHAR(100),
    city VARCHAR(50),
    stadium VARCHAR(100),
    founded_year INT,
    manager VARCHAR(100),
    budget DECIMAL(12,2)
);

-- MATCHES TABLE
CREATE TABLE matches (
    match_id INT PRIMARY KEY,
    home_team_id INT,
    away_team_id INT,
    match_date DATE,
    stadium VARCHAR(100),
    competition VARCHAR(50),
    home_team_score INT,
    away_team_score INT,
    attendance INT,
    FOREIGN KEY (home_team_id) REFERENCES teams(team_id),
    FOREIGN KEY (away_team_id) REFERENCES teams(team_id)
);

-- PLAYER_STATS TABLE
CREATE TABLE player_stats (
    stat_id INT PRIMARY KEY,
    player_id INT,
    match_id INT,
    goals INT,
    assists INT,
    minutes_played INT,
    yellow_cards INT,
    red_cards INT,
    passes_completed INT,
    FOREIGN KEY (player_id) REFERENCES players(player_id),
    FOREIGN KEY (match_id) REFERENCES matches(match_id)
);

-- TRANSFERS TABLE
CREATE TABLE transfers (
    transfer_id INT PRIMARY KEY,
    player_id INT,
    from_team_id INT,
    to_team_id INT,
    transfer_date DATE,
    transfer_fee DECIMAL(12,2),
    contract_length_years INT,
    FOREIGN KEY (player_id) REFERENCES players(player_id),
    FOREIGN KEY (from_team_id) REFERENCES teams(team_id),
    FOREIGN KEY (to_team_id) REFERENCES teams(team_id)
);

-- INSERT TEAMS
INSERT INTO teams VALUES
(1, 'Manchester United', 'Manchester', 'Old Trafford', 1878, 'Erik ten Hag', 500000000),
(2, 'Manchester City', 'Manchester', 'Etihad Stadium', 1880, 'Pep Guardiola', 600000000),
(3, 'Liverpool FC', 'Liverpool', 'Anfield', 1892, 'Jurgen Klopp', 450000000),
(4, 'Chelsea FC', 'London', 'Stamford Bridge', 1905, 'Mauricio Pochettino', 480000000),
(5, 'Arsenal FC', 'London', 'Emirates Stadium', 1886, 'Mikel Arteta', 420000000);

-- INSERT PLAYERS
INSERT INTO players VALUES
(101, 'Marcus Rashford', 'Forward', 'English', '1997-10-31', 10, 80000000, 200000, '2025-06-30'),
(102, 'Kevin De Bruyne', 'Midfielder', 'Belgian', '1991-06-28', 17, 75000000, 350000, '2026-06-30'),
(103, 'Mohamed Salah', 'Forward', 'Egyptian', '1992-06-15', 11, 90000000, 350000, '2025-06-30'),
(104, 'Erling Haaland', 'Forward', 'Norwegian', '2000-07-21', 9, 180000000, 375000, '2027-06-30'),
(105, 'Bukayo Saka', 'Midfielder', 'English', '2001-09-05', 7, 120000000, 195000, '2027-06-30'),
(106, 'Bruno Fernandes', 'Midfielder', 'Portuguese', '1994-09-08', 8, 85000000, 240000, '2026-06-30'),
(107, 'Virgil van Dijk', 'Defender', 'Dutch', '1991-07-08', 4, 45000000, 220000, '2025-06-30'),
(108, 'Rodri', 'Midfielder', 'Spanish', '1996-06-22', 16, 90000000, 180000, '2027-06-30'),
(109, 'Declan Rice', 'Midfielder', 'English', '1999-01-14', 41, 100000000, 250000, '2028-06-30'),
(110, 'William Saliba', 'Defender', 'French', '2001-03-24', 2, 65000000, 150000, '2027-06-30');

-- INSERT MATCHES
INSERT INTO matches VALUES
(1001, 1, 2, '2024-03-03', 'Old Trafford', 'Premier League', 2, 1, 74310),
(1002, 3, 4, '2024-03-02', 'Anfield', 'Premier League', 3, 1, 53289),
(1003, 5, 1, '2024-02-24', 'Emirates Stadium', 'Premier League', 2, 2, 60284),
(1004, 2, 3, '2024-02-17', 'Etihad Stadium', 'Premier League', 1, 1, 53400),
(1005, 4, 5, '2024-02-10', 'Stamford Bridge', 'Premier League', 0, 1, 40043);

-- INSERT PLAYER_STATS
INSERT INTO player_stats VALUES
(1, 101, 1001, 1, 1, 90, 0, 0, 42),
(2, 102, 1001, 0, 1, 85, 1, 0, 65),
(3, 104, 1001, 1, 0, 90, 0, 0, 28),
(4, 103, 1002, 2, 0, 90, 0, 0, 38),
(5, 105, 1003, 1, 1, 90, 0, 0, 47),
(6, 106, 1003, 1, 0, 90, 1, 0, 52),
(7, 107, 1004, 0, 0, 90, 0, 0, 58),
(8, 108, 1004, 0, 0, 90, 1, 0, 71),
(9, 109, 1005, 0, 0, 90, 0, 0, 49),
(10, 110, 1005, 0, 0, 90, 0, 0, 45);

-- INSERT TRANSFERS
INSERT INTO transfers VALUES
(1, 104, 7, 2, '2022-07-01', 60000000, 5),
(2, 109, 6, 5, '2023-07-01', 105000000, 5),
(3, 110, 8, 5, '2022-07-01', 30000000, 4),
(4, 106, 9, 1, '2020-01-29', 55000000, 5),
(5, 103, 10, 3, '2017-07-01', 42000000, 5);


all players from English nationality
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


