select
    id            as order_id,
    customer_id,
    status,
    channel,
    device_type,
    promo_code,
    created_at,
    updated_at,
    'shopify'     as _source
from {{ source('shopify_raw', 'orders') }}
