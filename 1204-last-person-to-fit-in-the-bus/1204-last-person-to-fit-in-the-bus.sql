# Write your MySQL query statement below
SELECT person_name
FROM (
    SELECT person_name,
       SUM(weight) OVER (ORDER BY turn) AS Total_Weight
    FROM Queue
) t
WHERE Total_Weight <= 1000
ORDER BY Total_Weight DESC LIMIT 1

