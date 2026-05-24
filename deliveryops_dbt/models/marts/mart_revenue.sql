select
    "Order Region" as order_region,

    count(*) as total_orders,

    sum("Sales") as total_revenue,

    avg("Sales") as avg_order_value,

    sum("Order Profit Per Order") as total_profit

from {{ ref('int_delivery_performance') }}

group by 1