WITH ranked_salaries AS (
    SELECT
        salary,
        DENSE_RANK() OVER (ORDER BY salary DESC) AS rnk
    FROM Employee
)
SELECT
    MAX(salary) AS SecondHighestSalary
FROM ranked_salaries
WHERE rnk = 2;
