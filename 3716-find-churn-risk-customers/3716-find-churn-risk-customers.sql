WITH first_event AS (
    SELECT 
        user_id,
        MIN(event_date) AS first_date
    FROM subscription_events
    GROUP BY user_id
),

last_event AS (
    SELECT *
    FROM (
        SELECT *,
               ROW_NUMBER() OVER(PARTITION BY user_id ORDER BY event_date DESC) AS rn
        FROM subscription_events
    ) t
    WHERE rn = 1
),

max_amount AS (
    SELECT 
        user_id,
        MAX(monthly_amount) AS max_historical_amount
    FROM subscription_events
    GROUP BY user_id
),

downgrade_users AS (
    SELECT DISTINCT user_id
    FROM subscription_events
    WHERE event_type = 'downgrade'
)

SELECT
    l.user_id,
    l.plan_name AS current_plan,
    l.monthly_amount AS current_monthly_amount,
    m.max_historical_amount,
    DATEDIFF(l.event_date, f.first_date) AS days_as_subscriber
FROM last_event l
JOIN first_event f ON l.user_id = f.user_id
JOIN max_amount m ON l.user_id = m.user_id
JOIN downgrade_users d ON l.user_id = d.user_id
WHERE 
    l.event_type <> 'cancel'
    AND l.monthly_amount < 0.5 * m.max_historical_amount
    AND DATEDIFF(l.event_date, f.first_date) >= 60
ORDER BY 
    days_as_subscriber DESC,
    l.user_id ASC;
