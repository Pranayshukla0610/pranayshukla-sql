# Write your MySQL query statement below
WITH extract_month AS (
    SELECT driver_id,
           EXTRACT(month FROM trip_date) AS trip_month,
           distance_km/fuel_consumed AS efficiency,
           fuel_consumed
    FROM trips
),
halves_month AS (
    SELECT AVG(CASE WHEN trip_month BETWEEN 1 AND 6 THEN efficiency END
        ) AS first_half_avg,
           AVG(CASE WHEN trip_month BETWEEN 7 AND 12 THEN efficiency END
        ) AS second_half_avg,
        driver_id
    FROM extract_month
    GROUP BY driver_id
)
SELECT a.driver_id,
       b.driver_name,
       ROUND(a.first_half_avg,2) AS first_half_avg,
       ROUND(a.second_half_avg,2) AS second_half_avg,
       ROUND(a.second_half_avg - a.first_half_avg,2) AS efficiency_improvement
FROM halves_month a 
JOIN drivers b ON a.driver_id = b.driver_id
WHERE a.first_half_avg IS NOT NULL
AND   a.second_half_avg IS NOT NULL
AND a.second_half_avg > a.first_half_avg
ORDER BY efficiency_improvement DESC, driver_name ASC