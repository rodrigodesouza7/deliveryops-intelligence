select
    "Order Region" as order_region,

    "Order Country" as order_country,

    count(*) as total_orders,

    sum("Sales") as total_sales,

    avg("Order Profit Per Order") as avg_profit

from {{ ref('int_delivery_performance') }}

group by 1,2