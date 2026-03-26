# Write your MySQL query statement below
WITH valid_days AS (
    -- Step 1: Keep only days where user has exactly one action
    SELECT user_id, action_date, action
    FROM activity
    GROUP BY user_id, action_date, action
    HAVING COUNT(*) = 1
),

streak_groups AS (
    -- Step 2: Create grouping key for consecutive dates
    SELECT 
        user_id,
        action,
        action_date,
        DATE_SUB(action_date, INTERVAL ROW_NUMBER() OVER (
            PARTITION BY user_id, action 
            ORDER BY action_date
        ) DAY) AS grp
    FROM valid_days
),

streaks AS (
    -- Step 3: Aggregate streaks
    SELECT 
        user_id,
        action,
        COUNT(*) AS streak_length,
        MIN(action_date) AS start_date,
        MAX(action_date) AS end_date
    FROM streak_groups
    GROUP BY user_id, action, grp
    HAVING COUNT(*) >= 5
),

ranked AS (
    -- Step 4: Pick longest streak per user
    SELECT *,
           ROW_NUMBER() OVER (
               PARTITION BY user_id 
               ORDER BY streak_length DESC
           ) AS rn
    FROM streaks
)

-- Step 5: Final result
SELECT 
    user_id,
    action,
    streak_length,
    start_date,
    end_date
FROM ranked
WHERE rn = 1
ORDER BY streak_length DESC, user_id ASC;