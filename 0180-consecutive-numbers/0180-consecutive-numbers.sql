# Write your MySQL query statement below
WITH cons_num AS (
    SELECT id,
           num,
           LAG(num,1) OVER (ORDER BY id) AS prev,
           LAG(num,2) OVER (ORDER BY id) AS prev2
    FROM Logs
)
SELECT DISTINCT num AS ConsecutiveNums
FROM cons_num
WHERE num = prev
AND num = prev2