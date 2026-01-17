WITH product_pairs AS (
    SELECT
        a.user_id,
        a.product_id AS product1_id,
        b.product_id AS product2_id
    FROM ProductPurchases a
    JOIN ProductPurchases b
        ON a.user_id = b.user_id
       AND a.product_id < b.product_id
),
pair_counts AS (
    SELECT
        product1_id,
        product2_id,
        COUNT(DISTINCT user_id) AS customer_count
    FROM product_pairs
    GROUP BY product1_id, product2_id
    HAVING COUNT(DISTINCT user_id) >= 3
)
SELECT
    pc.product1_id,
    pc.product2_id,
    p1.category AS product1_category,
    p2.category AS product2_category,
    pc.customer_count
FROM pair_counts pc
JOIN ProductInfo p1 ON pc.product1_id = p1.product_id
JOIN ProductInfo p2 ON pc.product2_id = p2.product_id
ORDER BY
    pc.customer_count DESC,
    pc.product1_id,
    pc.product2_id;
