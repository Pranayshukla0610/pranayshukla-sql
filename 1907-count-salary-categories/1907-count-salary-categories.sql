# Write your MySQL query statement below
SELECT category,
       SUM(accounts_count) AS accounts_count
FROM (
    SELECT 'Low Salary' AS category,
           CASE WHEN income < 20000 THEN 1 ELSE 0 END AS accounts_count
    FROM Accounts

    UNION ALL

    SELECT 'Average Salary',
           CASE WHEN income BETWEEN 20000 AND 50000 THEN 1 ELSE 0 END
    FROM Accounts

    UNION ALL

    SELECT 'High Salary',
            CASE WHEN income > 50000 THEN 1 ELSE 0 END
    FROM Accounts
)t
GROUP BY category