WITH ranked_products AS (
    SELECT
        s.store_id,
        s.store_name,
        s.location,
        i.product_name,
        i.quantity,
        i.price,
        ROW_NUMBER() OVER (PARTITION BY s.store_id ORDER BY i.price DESC) AS price_desc_rn,
        ROW_NUMBER() OVER (PARTITION BY s.store_id ORDER BY i.price ASC)  AS price_asc_rn,
        COUNT(*) OVER (PARTITION BY s.store_id) AS product_count
    FROM stores s
    JOIN inventory i
        ON s.store_id = i.store_id
),

store_extremes AS (
    SELECT
        store_id,
        store_name,
        location,
        MAX(CASE WHEN price_desc_rn = 1 THEN product_name END) AS most_exp_product,
        MAX(CASE WHEN price_desc_rn = 1 THEN quantity END)     AS most_exp_quantity,
        MAX(CASE WHEN price_asc_rn  = 1 THEN product_name END) AS cheapest_product,
        MAX(CASE WHEN price_asc_rn  = 1 THEN quantity END)     AS cheapest_quantity
    FROM ranked_products
    WHERE product_count >= 3
    GROUP BY store_id, store_name, location
)

SELECT
    store_id,
    store_name,
    location,
    most_exp_product,
    cheapest_product,
    ROUND(cheapest_quantity / most_exp_quantity, 2) AS imbalance_ratio
FROM store_extremes
WHERE most_exp_quantity < cheapest_quantity
ORDER BY imbalance_ratio DESC, store_name ASC;
