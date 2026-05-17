select
    count(*) as total_orders,
    count(distinct order_id) as unique_orders
from {{ ref('int_delivery_performance') }}
