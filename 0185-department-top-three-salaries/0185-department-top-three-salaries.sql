# Write your MySQL query statement below
WITH unique_salaries AS (
    SELECT *,
           DENSE_RANK() OVER (PARTITION BY departmentId
           ORDER BY salary DESC) AS rnk
    FROM Employee
)
SELECT b.name AS Department,
       a.name AS Employee,
       a.Salary
FROM unique_salaries a 
JOIN Department b ON a.departmentId = b.id
WHERE rnk <= 3