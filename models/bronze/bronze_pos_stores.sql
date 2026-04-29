select
    id            as store_id,
    name          as store_name,
    city,
    state_code,
    country,
    opened_at,
    'pos'         as _source
from {{ source('pos_raw', 'stores') }}
