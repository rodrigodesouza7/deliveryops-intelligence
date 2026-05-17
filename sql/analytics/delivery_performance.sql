DROP TABLE IF EXISTS analytics.delivery_performance;

CREATE TABLE analytics.delivery_performance AS
SELECT
    order_id,

    order_item_id,

    customer_id,

    product_card_id,
    product_name,

    category_id,
    category_name,

    department_name,

    market,
    order_region,
    order_country,
    order_state,
    order_city,

    order_date,
    shipping_date,

    shipping_mode,

    order_status,
    delivery_status,

    late_delivery_risk,

    days_shipping_real,
    days_shipping_scheduled,

    days_shipping_real - days_shipping_scheduled AS delay_days,

    CASE
        WHEN delivery_status = 'Shipping canceled'
        THEN 'CANCELED'

        WHEN days_shipping_real > days_shipping_scheduled
        THEN 'LATE'

        WHEN days_shipping_real = days_shipping_scheduled
        THEN 'ON_TIME'

        WHEN days_shipping_real < days_shipping_scheduled
        THEN 'EARLY'

        ELSE 'UNKNOWN'
    END AS sla_status,

    sales,

    order_item_quantity,
    order_item_total,

    order_profit_per_order,

    benefit_per_order

FROM staging.supply_chain_clean;