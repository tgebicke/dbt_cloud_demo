select
    id                                      as order_id,
    customer_id,
    status,
    channel,
    device_type,
    promo_code,
    created_at,
    updated_at,
    'shopify'                               as _source,
    current_timestamp()                     as _ingested_at,
    _metadata.file_path                     as _metadata_file_path,
    _metadata.file_modification_time        as _metadata_file_modified_at
from {{ source('shopify_raw', 'orders') }}
