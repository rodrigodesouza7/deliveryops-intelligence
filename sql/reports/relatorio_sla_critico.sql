SELECT
    product_name AS produto,
    order_region AS regiao,
    sales AS venda,
    delay_days AS dias_atraso,
    sla_status
FROM analytics.delivery_performance
WHERE sla_status IN ('LATE', 'CANCELED')
  AND sales > 500
ORDER BY delay_days DESC, sales DESC
LIMIT 100;