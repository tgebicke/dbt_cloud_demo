select
    id                                      as transaction_item_id,
    transaction_id,
    barcode,
    product_name_at_sale,
    quantity,
    unit_price,
    'pos'                                   as _source,
    current_timestamp()                     as _ingested_at,
    _metadata.file_path                     as _metadata_file_path,
    _metadata.file_modification_time        as _metadata_file_modified_at
from {{ source('pos_raw', 'transaction_items') }}
