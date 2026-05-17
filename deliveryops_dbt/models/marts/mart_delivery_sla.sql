select
    count(*) as total_orders,

    avg("Days for shipping (real)") as avg_real_shipping_days,

    avg("Days for shipment (scheduled)") as avg_scheduled_shipping_days,

    avg(
        "Days for shipping (real)"
        -
        "Days for shipment (scheduled)"
    ) as avg_shipping_delay

from {{ ref('int_delivery_performance') }}