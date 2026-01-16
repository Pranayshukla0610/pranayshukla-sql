# Write your MySQL query statement below
WITH first_login AS (
    SELECT player_id,
           MIN(event_date) AS first_date
    FROM Activity
    GROUP BY player_id
),
next_login AS (
    SELECT a.player_id
    FROM Activity a 
    JOIN first_login b ON a.player_id = b.player_id
    WHERE a.event_date = DATE_ADD(b.first_date, INTERVAL 1 DAY)
)
SELECT
    ROUND(
        COUNT(DISTINCT player_id) * 1.0 /
        (SELECT COUNT(DISTINCT player_id) FROM Activity),
        2
    ) AS fraction
FROM next_login;