SELECT
    ano,
    mes,
    total_vendas,
    total_pedidos,

    RANK() OVER (
        ORDER BY total_vendas DESC
    ) AS ranking_vendas,

    LAG(total_vendas) OVER (
        ORDER BY ano, mes
    ) AS vendas_mes_anterior,

    total_vendas - LAG(total_vendas) OVER (
        ORDER BY ano, mes
    ) AS variacao_vendas,

    CASE
        WHEN total_vendas > LAG(total_vendas) OVER (
            ORDER BY ano, mes
        )
        THEN 'CRESCIMENTO'

        WHEN total_vendas < LAG(total_vendas) OVER (
            ORDER BY ano, mes
        )
        THEN 'QUEDA'

        ELSE 'ESTAVEL'
    END AS tendencia

FROM (
    SELECT
        EXTRACT(YEAR FROM order_date) AS ano,
        EXTRACT(MONTH FROM order_date) AS mes,
        ROUND(SUM(sales)::numeric, 2) AS total_vendas,
        COUNT(DISTINCT order_id) AS total_pedidos
    FROM analytics.delivery_performance
    WHERE sla_status <> 'CANCELED'
    GROUP BY
        EXTRACT(YEAR FROM order_date),
        EXTRACT(MONTH FROM order_date)
) AS vendas_mensais

ORDER BY ano, mes;