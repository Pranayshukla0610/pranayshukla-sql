# Write your MySQL query statement below
WITH not_red AS (
    SELECT sales_id
    FROM Orders o JOIN Company c ON o.com_id = c.com_id
    WHERE c.name = "RED"
)
SELECT s.name
FROM SalesPerson s 
WHERE s.sales_id NOT IN (SELECT sales_id FROM not_red);