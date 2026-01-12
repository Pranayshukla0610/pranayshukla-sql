WITH rank_product AS (
    SELECT
        s.store_id,
        s.store_name,
        s.location,
        i.inventory_id,
        i.product_name,
        i.quantity,
        i.price,
        ROW_NUMBER() OVER (PARTITION BY s.store_id ORDER BY i.price DESC) AS high_rank,
        ROW_NUMBER() OVER (PARTITION BY s.store_id ORDER BY i.price ASC)  AS low_rank,
        COUNT(*) OVER (PARTITION BY s.store_id) AS product_count
    FROM stores s
    JOIN inventory i
        ON s.store_id = i.store_id
),

conditions AS (
    SELECT
        store_id,
        store_name,
        location,
        MAX(CASE WHEN high_rank = 1 THEN product_name END) AS most_exp_product,
        MAX(CASE WHEN high_rank = 1 THEN quantity END)     AS most_exp_quantity,
        MAX(CASE WHEN low_rank  = 1 THEN product_name END) AS cheapest_product,
        MAX(CASE WHEN low_rank  = 1 THEN quantity END)     AS cheapest_quantity
    FROM rank_product
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
FROM conditions
WHERE most_exp_quantity < cheapest_quantity
ORDER BY imbalance_ratio DESC, store_name ASC;

