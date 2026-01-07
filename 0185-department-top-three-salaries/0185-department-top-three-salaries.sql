# Write your MySQL query statement below
WITH rank_earners AS (
    SELECT e.id, 
           e.name AS Employee,
           d.name AS Department,
           e.departmentId,
           e.salary AS Salary,
           DENSE_RANK() OVER (PARTITION BY e.departmentId ORDER BY salary DESC) AS rnk
    FROM Employee e 
    JOIN Department d ON e.departmentId = d.id
)
SELECT Department, Employee, Salary
FROM rank_earners
WHERE rnk <= 3