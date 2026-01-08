# Write your MySQL query statement below
WITH total_prompt AS (
    SELECT user_id, 
           COUNT(*) AS prompt_count,
           ROUND(AVG(tokens),2) AS avg_tokens
    FROM prompts
    GROUP BY user_id
    HAVING COUNT(*) >= 3
),
qualified_users AS (
    SELECT p.user_id
    FROM prompts p 
    JOIN total_prompt t ON p.user_id = t.user_id
    WHERE p.tokens > t.avg_tokens
)
SELECT DISTINCT t.user_id,
       t.prompt_count,
       t.avg_tokens
FROM total_prompt t
JOIN qualified_users u ON t.user_id = u.user_id
ORDER BY t.avg_tokens DESC, t.user_id ASC