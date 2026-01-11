# Write your MySQL query statement below
WITH pointers AS (
    SELECT SUM(CASE WHEN transaction_type = 'purchase' THEN 1 ELSE 0 END) AS purchase_trans,
           SUM(CASE WHEN transaction_type='refund' THEN 1 ELSE 0 END) AS refund_trans,
           COUNT(*) AS number_transactions,
           DATEDIFF(MAX(transaction_date),MIN(transaction_date)) AS active_days
           customer_id,
    FROM customer_transactions
    GROUP BY customer_id
)
SELECT customer_id
FROM pointers
WHERE purchase_trans >= 3,
      AND active_days >= 30,
      AND refund_trans * 1.0 / number_transactions < 0.20
ORDER BY customer_id