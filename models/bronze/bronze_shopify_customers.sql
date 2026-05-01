select
    id                                      as customer_id,
    email,
    first_name,
    last_name,
    phone,
    country,
    marketing_opt_in,
    created_at,
    'shopify'                               as _source,
    current_timestamp()                     as _ingested_at,
    _metadata.file_path                     as _metadata_file_path,
    _metadata.file_modification_time        as _metadata_file_modified_at
from {{ source('shopify_raw', 'customers') }}
