select
    order_region,
    order_country,
    count(*)                    as total_orders,
    sum(sales)                  as total_sales,
    avg(order_profit_per_order) as avg_profit
from {{ ref('int_delivery_performance') }}
group by 1, 2