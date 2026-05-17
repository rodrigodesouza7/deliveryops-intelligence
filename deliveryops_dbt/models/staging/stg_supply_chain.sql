select
    "Order Id" as order_id,
    *
from {{ source('raw', 'supply_chain_raw') }}