# Write your MySQL query statement below
WITH rank_score AS (
    SELECT id,
           score,
           DENSE_RANK() OVER (ORDER BY score DESC) AS rnk
    FROM Scores
)
SELECT score, rnk AS 'rank'
FROM rank_score
ORDER BY score DESC


