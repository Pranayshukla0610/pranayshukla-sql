# Write your MySQL query statement below
WITH highest_sal AS (
    SELECT e.name AS Employee,
           d.name AS Department,
           e.salary AS Salary,
           MAX(salary) OVER (PARTITION BY e.departmentId) AS highest_salary
    FROM Employee e JOIN Department d ON e.departmentId = d.id
)
SELECT Department, Employee, Salary
FROM highest_sal
WHERE salary = highest_salary