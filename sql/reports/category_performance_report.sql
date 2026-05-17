SELECT
    category_id,
    category_name,
    COUNT(DISTINCT product_card_id) AS total_produtos,
    COUNT(DISTINCT order_id) AS total_pedidos,
    ROUND(MIN(sales)::numeric, 2) AS menor_venda,
    ROUND(AVG(sales)::numeric, 2) AS venda_media,
    ROUND(MAX(sales)::numeric, 2) AS maior_venda,
    SUM(order_item_quantity) AS quantidade_total_vendida,
    ROUND(SUM(sales)::numeric, 2) AS valor_total_vendido
FROM analytics.delivery_performance
GROUP BY category_id, category_name
HAVING
    COUNT(DISTINCT product_card_id) > 5
    AND SUM(sales) > 5000
ORDER BY valor_total_vendido DESC;