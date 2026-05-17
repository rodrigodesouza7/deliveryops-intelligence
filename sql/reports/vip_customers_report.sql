SELECT
    customer_id,
    total_pedidos,
    ROUND(total_gasto::numeric, 2) AS total_gasto,
    ROUND(media_geral::numeric, 2) AS media_geral_clientes
FROM (
    SELECT
        customer_id,
        COUNT(DISTINCT order_id) AS total_pedidos,
        SUM(sales) AS total_gasto
    FROM analytics.delivery_performance
    GROUP BY customer_id
) AS clientes
CROSS JOIN (
    SELECT
        AVG(total_gasto) AS media_geral
    FROM (
        SELECT
            customer_id,
            SUM(sales) AS total_gasto
        FROM analytics.delivery_performance
        GROUP BY customer_id
    ) AS gastos
) AS media
WHERE total_gasto > media_geral
ORDER BY total_gasto DESC
LIMIT 100;