# Write your MySQL query statement below
WITH rank_score AS (
    SELECT id,
           score,
           DENSE_RANK() OVER (ORDER BY score DESC) AS 'rank'
    FROM Scores
)
SELECT score,
       'rank'
FROM rank_score


