WITH vendas_mensais AS (
    SELECT
        EXTRACT(YEAR FROM order_date) AS ano,
        EXTRACT(MONTH FROM order_date) AS mes,
        ROUND(SUM(sales)::numeric, 2) AS total_vendas,
        COUNT(DISTINCT order_id) AS total_pedidos,
        COUNT(DISTINCT customer_id) AS total_clientes
    FROM analytics.delivery_performance
    WHERE sla_status <> 'CANCELED'
    GROUP BY
        EXTRACT(YEAR FROM order_date),
        EXTRACT(MONTH FROM order_date)
),

media_mensal AS (
    SELECT
        AVG(total_vendas) AS media_vendas
    FROM vendas_mensais
),

ranking_mensal AS (
    SELECT
        vm.*,
        RANK() OVER (
            ORDER BY total_vendas DESC
        ) AS ranking_vendas
    FROM vendas_mensais vm
)

SELECT
    r.ano,
    r.mes,
    r.total_vendas,
    r.total_pedidos,
    r.total_clientes,
    ROUND(m.media_vendas::numeric, 2) AS media_mensal,
    r.ranking_vendas,

    CASE
        WHEN r.total_vendas > m.media_vendas THEN 'ACIMA_DA_MEDIA'
        ELSE 'ABAIXO_DA_MEDIA'
    END AS performance_mensal

FROM ranking_mensal r
CROSS JOIN media_mensal m
ORDER BY r.ano, r.mes;