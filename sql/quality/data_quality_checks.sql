SELECT COUNT(*) AS total_raw
FROM raw.supply_chain_raw;

SELECT COUNT(*) AS total_staging
FROM staging.supply_chain_clean;

SELECT COUNT(*) AS total_analytics
FROM analytics.delivery_performance;

SELECT
    sla_status,
    COUNT(*) AS total
FROM analytics.delivery_performance
GROUP BY sla_status
ORDER BY total DESC;