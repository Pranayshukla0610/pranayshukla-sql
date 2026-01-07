# Write your MySQL query statement below
WITH second_sal AS (
    SELECT id,
           salary,
           DENSE_RANK() OVER (ORDER BY salary DESC) rnk
    FROM Employee
)
SELECT MAX(salary) AS SecondHighestSalary
FROM second_sal
WHERE rnk = 2