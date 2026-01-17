# Write your MySQL query statement below
WITH reaction_counts AS (
    SELECT
        user_id,
        reaction,
        COUNT(*) AS reaction_count
    FROM reactions
    GROUP BY user_id, reaction
),
total_counts AS (
    SELECT
        user_id,
        COUNT(*) AS total_reactions
    FROM reactions
    GROUP BY user_id
),
ranked_reactions AS (
    SELECT
        rc.user_id,
        rc.reaction,
        rc.reaction_count,
        tc.total_reactions,
        ROW_NUMBER() OVER (
            PARTITION BY rc.user_id
            ORDER BY rc.reaction_count DESC
        ) AS rn
    FROM reaction_counts rc
    JOIN total_counts tc
        ON rc.user_id = tc.user_id
)
SELECT
    user_id,
    reaction AS dominant_reaction,
    ROUND(reaction_count * 1.0 / total_reactions, 2) AS reaction_ratio
FROM ranked_reactions
WHERE rn = 1
  AND total_reactions >= 5
  AND reaction_count * 1.0 / total_reactions >= 0.60
ORDER BY reaction_ratio DESC, user_id ASC;

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            