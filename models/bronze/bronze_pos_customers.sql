select
    id                                      as customer_id,
    first_name,
    last_name,
    phone,
    loyalty_card_number,
    home_store_id,
    created_at,
    'pos'                                   as _source,
    current_timestamp()                     as _ingested_at,
    _metadata.file_path                     as _metadata_file_path,
    _metadata.file_modification_time        as _metadata_file_modified_at
from {{ source('pos_raw', 'customers') }}
