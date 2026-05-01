select
    id                                      as order_item_id,
    order_id,
    product_id,
    sku,
    quantity,
    unit_price,
    'shopify'                               as _source,
    current_timestamp()                     as _ingested_at,
    _metadata.file_path                     as _metadata_file_path,
    _metadata.file_modification_time        as _metadata_file_modified_at
from {{ source('shopify_raw', 'order_items') }}
