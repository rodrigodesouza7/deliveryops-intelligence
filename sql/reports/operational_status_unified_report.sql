SELECT DISTINCT
    order_status AS status,
    'ORDER_STATUS' AS origem
FROM analytics.delivery_performance
WHERE order_status IS NOT NULL

UNION

SELECT DISTINCT
    delivery_status AS status,
    'DELIVERY_STATUS' AS origem
FROM analytics.delivery_performance
WHERE delivery_status IS NOT NULL

UNION

SELECT DISTINCT
    sla_status AS status,
    'SLA_STATUS' AS origem
FROM analytics.delivery_performance
WHERE sla_status IS NOT NULL

ORDER BY origem, status;