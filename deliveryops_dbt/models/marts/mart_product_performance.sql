select
    "Product Name" as product_name,

    "Category Name" as category_name,

    count(*) as total_orders,

    sum("Sales") as total_sales,

    avg("Order Item Profit Ratio") as avg_profit_ratio

from {{ ref('int_delivery_performance') }}

group by 1,2