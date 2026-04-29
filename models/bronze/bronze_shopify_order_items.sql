select
    id            as order_item_id,
    order_id,
    product_id,
    sku,
    quantity,
    unit_price,
    'shopify'     as _source
from {{ source('shopify_raw', 'order_items') }}
