DROP TABLE IF EXISTS staging.supply_chain_clean;

CREATE TABLE staging.supply_chain_clean AS
SELECT
    "Type" AS payment_type,

    "Days for shipping (real)" AS days_shipping_real,
    "Days for shipment (scheduled)" AS days_shipping_scheduled,

    "Benefit per order" AS benefit_per_order,
    "Sales per customer" AS sales_per_customer,

    "Delivery Status" AS delivery_status,
    "Late_delivery_risk" AS late_delivery_risk,

    "Category Id" AS category_id,
    "Category Name" AS category_name,

    "Customer Id" AS customer_id,
    TRIM("Customer Fname") AS customer_first_name,
    TRIM("Customer Lname") AS customer_last_name,
    "Customer Segment" AS customer_segment,
    "Customer City" AS customer_city,
    "Customer Country" AS customer_country,
    "Customer State" AS customer_state,
    "Customer Zipcode" AS customer_zipcode,

    "Department Id" AS department_id,
    "Department Name" AS department_name,

    "Latitude" AS customer_latitude,
    "Longitude" AS customer_longitude,

    "Market" AS market,

    "Order City" AS order_city,
    "Order Country" AS order_country,
    "Order Region" AS order_region,
    "Order State" AS order_state,
    "Order Zipcode" AS order_zipcode,

    TO_TIMESTAMP(
        "order date (DateOrders)",
        'MM/DD/YYYY HH24:MI'
    ) AS order_date,

    TO_TIMESTAMP(
        "shipping date (DateOrders)",
        'MM/DD/YYYY HH24:MI'
    ) AS shipping_date,

    "Order Id" AS order_id,
    "Order Customer Id" AS order_customer_id,
    "Order Status" AS order_status,

    "Order Item Id" AS order_item_id,
    "Order Item Cardprod Id" AS order_item_cardprod_id,

    "Order Item Discount" AS order_item_discount,
    "Order Item Discount Rate" AS order_item_discount_rate,
    "Order Item Product Price" AS order_item_product_price,
    "Order Item Profit Ratio" AS order_item_profit_ratio,
    "Order Item Quantity" AS order_item_quantity,
    "Order Item Total" AS order_item_total,

    "Sales" AS sales,
    "Order Profit Per Order" AS order_profit_per_order,

    "Product Card Id" AS product_card_id,
    "Product Category Id" AS product_category_id,

    "Product Name" AS product_name,
    "Product Price" AS product_price,
    "Product Status" AS product_status,

    "Shipping Mode" AS shipping_mode

FROM raw.datacosupplychaindataset;