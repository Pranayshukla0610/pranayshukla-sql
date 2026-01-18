# Write your MySQL query statement below
WITH high_earners AS (
    SELECT e.id,
           e.name AS Employee,
           e.salary AS Salary,
           d.name AS Department,
           DENSE_RANK() OVER (PARTITION BY d.name ORDER BY e.salary DESC) AS rnk
    FROM Employee e 
    JOIN Department d ON e.departmentId = d.id
)
SELECT Department, Employee, Salary
FROM high_earners
WHERE rnk <= 3