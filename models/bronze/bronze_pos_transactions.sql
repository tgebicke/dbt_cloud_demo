select
    id                                      as transaction_id,
    store_id,
    register_id,
    cashier_id,
    customer_id,
    transaction_type,
    local_transaction_timestamp,
    total_amount,
    'pos'                                   as _source,
    current_timestamp()                     as _ingested_at,
    _metadata.file_path                     as _metadata_file_path,
    _metadata.file_modification_time        as _metadata_file_modified_at
from {{ source('pos_raw', 'transactions') }}
