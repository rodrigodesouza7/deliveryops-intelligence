select
    count(*)                      as total_orders,
    avg(days_shipping_real)       as avg_real_shipping_days,
    avg(days_shipping_scheduled)  as avg_scheduled_shipping_days,
    avg(shipping_delay)           as avg_shipping_delay
from {{ ref('int_delivery_performance') }}