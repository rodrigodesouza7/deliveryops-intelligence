select
    "Customer Id" as customer_id,

    "Customer Segment" as customer_segment,

    count(*) as total_orders,

    sum("Sales") as total_customer_revenue

from {{ ref('int_delivery_performance') }}

group by 1,2