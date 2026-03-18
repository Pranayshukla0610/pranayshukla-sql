# Write your MySQL query statement below
WITH review_sort AS (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY employee_id ORDER BY review_date DESC) AS rn
    FROM performance_reviews
),
reviews_rank AS (
    SELECT MAX(CASE WHEN rn = 1 THEN rating END) AS r1,
           MAX(CASE WHEN rn = 2 THEN rating END) AS r2,
           MAX(CASE WHEN rn = 3 THEN rating END) AS r3,
           employee_id
    FROM review_sort
    WHERE rn <= 3
    GROUP BY employee_id
)
SELECT a.employee_id,
       e.name,
       (a.r1 - a.r3) AS improvement_score
FROM reviews_rank a 
JOIN employees e ON e.employee_id = a.employee_id
WHERE r3<r2 AND r2<r1
ORDER BY improvement_score DESC, e.name ASC