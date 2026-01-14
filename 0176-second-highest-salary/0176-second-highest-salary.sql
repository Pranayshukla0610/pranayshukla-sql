WITH second_highest AS (
    SELECT id,
           salary,
           DENSE_RANK() OVER (ORDER BY salary DESC) AS rnk
    FROM Employee
)
SELECT MAX(salary) AS SecondHighestSalary
FROM second_highest
WHERE rnk = 2
