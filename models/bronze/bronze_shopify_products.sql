select
    id                                      as product_id,
    sku,
    name                                    as product_name,
    category,
    price,
    is_active,
    created_at,
    'shopify'                               as _source,
    current_timestamp()                     as _ingested_at,
    _metadata.file_path                     as _metadata_file_path,
    _metadata.file_modification_time        as _metadata_file_modified_at
from {{ source('shopify_raw', 'products') }}
