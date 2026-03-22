WITH sort_event AS (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY user_id 
           ORDER BY event_date DESC) AS rn
    FROM subscription_events
),
last_event AS (
    SELECT user_id,
           event_date,
           event_type,
           plan_name,
           monthly_amount
    FROM sort_event
    WHERE rn = 1
),
value_sort AS (
    SELECT user_id,
           MIN(event_date) AS first_date,
           MAX(event_date) AS last_date,
           MAX(monthly_amount) AS max_amount,
           SUM(CASE WHEN event_type='downgrade' 
           THEN 1 ELSE 0 END) AS downgrade_count
    FROM subscription_events
    GROUP BY user_id
)
SELECT a.user_id,
       a.plan_name AS current_plan,
       a.monthly_amount AS current_monthly_amount,
       b.max_amount AS max_historical_amount,
       DATEDIFF(b.last_date,b.first_date) AS days_as_subscriber
FROM last_event a 
JOIN value_sort b ON a.user_id = b.user_id
WHERE a.event_type != 'cancel'
AND b.downgrade_count >= 1
AND DATEDIFF(b.last_date,b.first_date) >= 60
AND a.monthly_amount < 0.5 * b.max_amount
ORDER BY days_as_subscriber DESC, user_id ASC
       