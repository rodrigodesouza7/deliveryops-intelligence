WITH vendas_por_cliente AS (
    SELECT
        customer_id,
        COUNT(DISTINCT order_id) AS qtd_pedidos,
        SUM(sales) AS total_gasto
    FROM analytics.delivery_performance
    GROUP BY customer_id
),

media_geral AS (
    SELECT
        AVG(total_gasto) AS media
    FROM vendas_por_cliente
)

SELECT
    v.customer_id,
    v.qtd_pedidos,
    ROUND(v.total_gasto::numeric, 2) AS total_gasto,
    ROUND(m.media::numeric, 2) AS media_geral,
    ROUND((v.total_gasto - m.media)::numeric, 2) AS diferenca_para_media,

    CASE
        WHEN v.total_gasto > m.media * 2 THEN 'VIP Premium'
        WHEN v.total_gasto > m.media * 1.5 THEN 'VIP'
        ELSE 'Acima da média'
    END AS classificacao

FROM vendas_por_cliente v
CROSS JOIN media_geral m
WHERE v.total_gasto > m.media
ORDER BY v.total_gasto DESC
LIMIT 100;