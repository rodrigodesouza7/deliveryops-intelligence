WITH pedidos AS (
    SELECT DISTINCT
        order_id,
        customer_id,
        order_date,
        sla_status,
        delay_days,
        order_region,
        order_country
    FROM analytics.delivery_performance
),

clientes AS (
    SELECT DISTINCT
        customer_id,
        customer_first_name,
        customer_last_name,
        customer_segment
    FROM staging.supply_chain_clean
),

itens AS (
    SELECT
        order_id,
        product_card_id,
        sales,
        order_item_quantity
    FROM analytics.delivery_performance
),

produtos AS (
    SELECT DISTINCT
        product_card_id,
        product_name,
        category_id
    FROM analytics.delivery_performance
),

categorias AS (
    SELECT DISTINCT
        category_id,
        category_name
    FROM analytics.delivery_performance
)

SELECT
    p.order_id,
    p.order_date,

    CONCAT(
        c.customer_first_name,
        ' ',
        c.customer_last_name
    ) AS cliente,

    c.customer_segment,

    pr.product_name AS produto,

    cat.category_name AS categoria,

    i.order_item_quantity AS quantidade,

    i.sales AS venda,

    p.sla_status,

    p.delay_days,

    p.order_region,

    p.order_country

FROM pedidos p

INNER JOIN clientes c
    ON p.customer_id = c.customer_id

INNER JOIN itens i
    ON p.order_id = i.order_id

INNER JOIN produtos pr
    ON i.product_card_id = pr.product_card_id

INNER JOIN categorias cat
    ON pr.category_id = cat.category_id

WHERE p.sla_status = 'LATE'
  AND i.sales > 500

ORDER BY i.sales DESC

LIMIT 100;