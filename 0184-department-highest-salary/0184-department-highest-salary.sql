# Write your MySQL query statement below
WITH highest_sal AS (
    SELECT name,
           salary,
           departmentId,
           MAX(salary) OVER (PARTITION BY departmentId ORDER BY salary DESC) AS rnk
    FROM Employee
)
SELECT b.name AS Department,
       a.name AS Employee,
       salary AS Salary
FROM highest_sal a 
JOIN Department b ON a.departmentId = b.id
WHERE salary = rnk