SELECT
    COUNT(*) AS total_registros_criticos,
    COUNT(DISTINCT order_id) AS total_pedidos_criticos,
    COUNT(DISTINCT customer_id) AS total_clientes_afetados,
    COUNT(DISTINCT product_card_id) AS total_produtos_afetados,
    ROUND(SUM(sales)::numeric, 2) AS valor_total_afetado,
    ROUND(AVG(sales)::numeric, 2) AS ticket_medio_afetado,
    MIN(delay_days) AS menor_atraso,
    MAX(delay_days) AS maior_atraso,
    ROUND(AVG(delay_days)::numeric, 2) AS atraso_medio
FROM analytics.delivery_performance
WHERE sla_status = 'LATE'
  AND sales > 500;