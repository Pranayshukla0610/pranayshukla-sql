# Write your MySQL query statement below
SELECT u.name,
       SUM(t.amount) AS balance
FROM Users u 
JOIN Transactions t ON u.account = t.account
WHERE SUM(t.amount) > 10000
GROUP BY u.name
