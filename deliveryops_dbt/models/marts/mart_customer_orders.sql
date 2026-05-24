select
    customer_id,
    customer_segment,
    count(*)   as total_orders,
    sum(sales) as total_customer_revenue
from {{ ref('int_delivery_performance') }}
group by 1, 2