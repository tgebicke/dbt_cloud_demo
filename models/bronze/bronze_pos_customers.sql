select
    id                    as customer_id,
    first_name,
    last_name,
    phone,
    loyalty_card_number,
    home_store_id,
    created_at,
    'pos'                 as _source
from {{ source('pos_raw', 'customers') }}
