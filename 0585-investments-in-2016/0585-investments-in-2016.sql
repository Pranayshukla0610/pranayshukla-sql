# Write your MySQL query statement below
WITH dup_tiv2015 AS (
    SELECT tiv_2015
    FROM Insurance
    GROUP BY tiv_2015
    HAVING COUNT(tiv_2015) > 1
),
uniq_loc AS (
    SELECT lat,
           lon
    FROM Insurance
    GROUP BY lat, lon
    HAVING COUNT(*) = 1
)
SELECT ROUND(SUM(tiv_2016),2) AS tiv_2016
FROM Insurance a 
JOIN dup_tiv2015 b ON a.tiv_2015 = b.tiv_2015
JOIN uniq_loc c ON a.lat = c.lat AND a.lon = c.lon
