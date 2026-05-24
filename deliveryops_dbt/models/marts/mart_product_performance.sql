select
    product_name,
    category_name,
    count(*)                     as total_orders,
    sum(sales)                   as total_sales,
    avg(order_item_profit_ratio) as avg_profit_ratio
from {{ ref('int_delivery_performance') }}
group by 1, 2