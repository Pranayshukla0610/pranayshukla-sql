# Write your MySQL query statement below
WITH filtered_data AS (
    SELECT id,
           visit_date,
           people
    FROM Stadium
    WHERE people >= 100
),
grouped AS (
    SELECT id,
           visit_date,
           people,
           id - ROW_NUMBER() OVER (ORDER BY id) AS grp
    FROM filtered_data
)
SELECT id,
       visit_date,
       people
FROM grouped
WHERE grp IN (SELECT grp FROM grouped GROUP BY grp HAVING COUNT(*)>=3)
ORDER BY visit_date