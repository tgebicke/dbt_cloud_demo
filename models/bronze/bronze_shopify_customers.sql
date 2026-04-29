select
    id                as customer_id,
    email,
    first_name,
    last_name,
    phone,
    country,
    marketing_opt_in,
    created_at,
    'shopify'         as _source
from {{ source('shopify_raw', 'customers') }}
