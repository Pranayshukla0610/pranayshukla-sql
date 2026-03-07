# Write your MySQL query statement below
WITH data_sort AS (
    SELECT t.client_id,
           t.status,
           t.request_at AS Day
    FROM Trips t 
    JOIN Users a ON a.users_id = t.client_id 
    JOIN Users b ON b.users_id = t.driver_id 
    WHERE t.request_at BETWEEN '2013-10-01' AND '2013-10-03'
    AND a.banned = 'No' AND b.banned = 'No'
),
rate AS (
    SELECT Day,
           SUM(CASE WHEN status IN ('cancelled_by_driver','cancelled_by_client') THEN 
           1 ELSE 0 END) AS cancelled_trips,
           COUNT(*) AS Total_Users
    FROM data_sort
    GROUP BY Day
)
SELECT Day,
       ROUND(cancelled_trips/Total_Users,2) AS "Cancellation Rate"
FROM rate