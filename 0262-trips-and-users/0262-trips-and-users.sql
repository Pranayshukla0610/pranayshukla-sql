# Write your MySQL query statement below
WITH date_range AS (
    SELECT 
           t.status,
           t.request_at AS Day
    FROM Trips t 
    JOIN Users c ON c.users_id = t.client_id AND c.banned = 'No'
    JOIN Users d ON d.users_id = t.driver_id AND d.banned = 'No'
    WHERE request_at BETWEEN '2013-10-01' AND '2013-10-03'  
),
calc_rate AS (
    SELECT Day,
           SUM(CASE WHEN status IN ('cancelled_by_driver','cancelled_by_client') 
           THEN 1 ELSE 0 END) AS cancelled_trips,
           COUNT(*) AS total_trips
    FROM date_range
    GROUP BY Day
)
SELECT Day, 
      ROUND(cancelled_trips/total_trips, 2) AS `Cancellation Rate`
FROM calc_rate