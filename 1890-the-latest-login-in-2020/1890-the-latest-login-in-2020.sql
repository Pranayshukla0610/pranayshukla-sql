# Write your MySQL query statement below
WITH latest_login AS (
    SELECT user_id,
           MAX(time_stamp) AS last_stamp
    FROM Logins
    WHERE YEAR(time_stamp) = 2020
    GROUP BY user_id
)
SELECT user_id, last_stamp
FROM latest_login