# Write your MySQL query statement below
SELECT id,
       SUM(CASE WHEN month='Jan' THEN revenue END) AS Jan_Revenue,
       SUM(CASE WHEN month='Feb' THEN revenue END) AS Feb_revenue,
       SUM(CASE WHEN month='Mar' THEN revenue END) AS Mar_revenue,
       SUM(CASE WHEN month='Apr' THEN revenue END) AS Apr_revenue,
       SUM(CASE WHEN month='May' THEN revenue END) AS May_revenue,
       SUM(CASE WHEN month='Jun' THEN revenue END) AS Jun_revenue,
       SUM(CASE WHEN month='Jul' THEN revenue END) AS Jul_revenue,
       SUM(CASE WHEN month='Aug' THEN revenue END) AS Aug_revenue,
       SUM(CASE WHEN month='Sep' THEN revenue END) AS Sep_revenue,
       SUM(CASE WHEN month='Oct' THEN revenue END) AS Oct_revenue,
       SUM(CASE WHEN month='Nov' THEN revenue END) AS Nov_revenue,
       SUM(CASE WHEN month='Dec' THEN revenue END) AS Dec_revenue
FROM Department
GROUP BY id