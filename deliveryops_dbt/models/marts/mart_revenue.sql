select
    order_region,
    count(*)                    as total_orders,
    sum(sales)                  as total_revenue,
    avg(sales)                  as avg_order_value,
    sum(order_profit_per_order) as total_profit
from {{ ref('int_delivery_performance') }}
group by 1