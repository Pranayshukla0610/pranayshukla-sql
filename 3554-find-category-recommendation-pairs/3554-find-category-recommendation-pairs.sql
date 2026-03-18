# Write your MySQL query statement below
WITH merge_table AS (
    SELECT DISTINCT a.user_id,
           b.category
    FROM ProductPurchases a 
    JOIN ProductInfo b ON a.product_id = b.product_id
),
category_pairs AS (
    SELECT a.user_id, a.category AS category1,
           b.category AS category2
    FROM merge_table a 
    JOIN merge_table b ON a.user_id = b.user_id
    WHERE a.category < b.category
)
SELECT category1,
       category2,
       COUNT(DISTINCT user_id) AS customer_count
FROM category_pairs
GROUP BY category1, category2
HAVING COUNT(DISTINCT user_id) >= 3
ORDER BY 
    customer_count DESC,
    category1 ASC,
    category2 ASC;
