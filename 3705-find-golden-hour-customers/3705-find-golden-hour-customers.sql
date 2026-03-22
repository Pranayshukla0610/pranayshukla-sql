WITH sort_data AS (
    SELECT customer_id,
           ROUND(SUM(CASE WHEN TIME(order_timestamp) BETWEEN '11:00:00' AND '14:00:00'
           OR TIME(order_timestamp) BETWEEN '18:00:00' AND '21:00:00'
           THEN 1 ELSE 0 END)*100.0/COUNT(*)) AS peak_hour_percentage,
           ROUND(AVG(order_rating),2) AS average_rating,
           COUNT(order_id) AS total_orders,
           COUNT(order_rating) AS rated_orders
    FROM restaurant_orders
    GROUP BY customer_id
)
SELECT customer_id,
       total_orders,
       peak_hour_percentage,
       average_rating
FROM sort_data
WHERE total_orders >= 3
AND average_rating >= 4.0
AND rated_orders*1.0 / total_orders >= 0.5
AND peak_hour_percentage >= 60
ORDER BY 
    average_rating DESC,
    customer_id DESC
       