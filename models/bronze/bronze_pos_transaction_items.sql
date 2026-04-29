select
    id                    as transaction_item_id,
    transaction_id,
    barcode,
    product_name_at_sale,
    quantity,
    unit_price,
    'pos'                 as _source
from {{ source('pos_raw', 'transaction_items') }}
