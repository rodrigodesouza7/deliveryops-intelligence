-- Full Data Audit - DeliveryOps Intelligence

-- 1. Volumetria geral
SELECT
    'raw.supply_chain_raw' AS tabela,
    COUNT(*) AS total_linhas
FROM raw.supply_chain_raw

UNION ALL

SELECT
    'staging.supply_chain_clean' AS tabela,
    COUNT(*) AS total_linhas
FROM staging.supply_chain_clean

UNION ALL

SELECT
    'analytics.delivery_performance' AS tabela,
    COUNT(*) AS total_linhas
FROM analytics.delivery_performance;


-- 2. Verificar nulos críticos
SELECT
    COUNT(*) AS total_linhas,
    COUNT(*) FILTER (WHERE order_id IS NULL) AS order_id_null,
    COUNT(*) FILTER (WHERE customer_id IS NULL) AS customer_id_null,
    COUNT(*) FILTER (WHERE product_card_id IS NULL) AS product_id_null,
    COUNT(*) FILTER (WHERE order_date IS NULL) AS order_date_null,
    COUNT(*) FILTER (WHERE shipping_date IS NULL) AS shipping_date_null,
    COUNT(*) FILTER (WHERE sales IS NULL) AS sales_null,
    COUNT(*) FILTER (WHERE delivery_status IS NULL) AS delivery_status_null,
    COUNT(*) FILTER (WHERE order_status IS NULL) AS order_status_null
FROM staging.supply_chain_clean;


-- 3. Duplicidade por item de pedido
SELECT
    order_item_id,
    COUNT(*) AS total
FROM staging.supply_chain_clean
GROUP BY order_item_id
HAVING COUNT(*) > 1
ORDER BY total DESC;


-- 4. Valores financeiros inválidos
SELECT
    COUNT(*) AS registros_invalidos
FROM staging.supply_chain_clean
WHERE sales < 0
   OR order_item_total < 0
   OR product_price < 0
   OR order_item_quantity <= 0;


-- 5. Datas inválidas
SELECT
    COUNT(*) AS datas_invalidas
FROM staging.supply_chain_clean
WHERE shipping_date < order_date;


-- 6. Status de entrega
SELECT
    delivery_status,
    COUNT(*) AS total
FROM staging.supply_chain_clean
GROUP BY delivery_status
ORDER BY total DESC;


-- 7. Status de pedido
SELECT
    order_status,
    COUNT(*) AS total
FROM staging.supply_chain_clean
GROUP BY order_status
ORDER BY total DESC;


-- 8. Modos de envio
SELECT
    shipping_mode,
    COUNT(*) AS total
FROM staging.supply_chain_clean
GROUP BY shipping_mode
ORDER BY total DESC;


-- 9. Países com possíveis inconsistências textuais
SELECT
    customer_country,
    COUNT(*) AS total
FROM staging.supply_chain_clean
GROUP BY customer_country
ORDER BY total DESC;


-- 10. Estados/regiões com possíveis inconsistências textuais
SELECT
    order_state,
    COUNT(*) AS total
FROM staging.supply_chain_clean
GROUP BY order_state
ORDER BY total DESC;


-- 11. Produtos sem categoria
SELECT
    COUNT(*) AS produtos_sem_categoria
FROM staging.supply_chain_clean
WHERE category_id IS NULL
   OR category_name IS NULL
   OR TRIM(category_name) = '';


-- 12. Clientes sem nome
SELECT
    COUNT(*) AS clientes_sem_nome
FROM staging.supply_chain_clean
WHERE customer_first_name IS NULL
   OR TRIM(customer_first_name) = ''
   OR customer_last_name IS NULL
   OR TRIM(customer_last_name) = '';


-- 13. SLA atual
SELECT
    sla_status,
    COUNT(*) AS total
FROM analytics.delivery_performance
GROUP BY sla_status
ORDER BY total DESC;