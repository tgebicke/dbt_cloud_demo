select
    id            as product_id,
    sku,
    name          as product_name,
    category,
    price,
    is_active,
    created_at,
    'shopify'     as _source
from {{ source('shopify_raw', 'products') }}
