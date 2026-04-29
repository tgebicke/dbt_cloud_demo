select
    id                           as transaction_id,
    store_id,
    register_id,
    cashier_id,
    customer_id,
    transaction_type,
    local_transaction_timestamp,
    total_amount,
    'pos'                        as _source
from {{ source('pos_raw', 'transactions') }}
