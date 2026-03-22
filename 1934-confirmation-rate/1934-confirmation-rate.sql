# Write your MySQL query statement below
WITH confirmation_rate AS (
    SELECT s.user_id,
           COUNT(*) AS requested_message,
           SUM(CASE WHEN c.action='confirmed' THEN 1 ELSE 0 END) AS confirmed_message
    FROM Signups s
    LEFT JOIN Confirmations c ON s.user_id = c.user_id
    GROUP BY s.user_id
)
SELECT user_id,
       ROUND(confirmed_message/requested_message,2) AS confirmation_rate
FROM confirmation_rate