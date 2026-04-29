-- Unified order model combining Shopify online orders and POS transactions.
-- Key transformations:
--   - Status normalization: Shopify 'fulfilled'/'refunded' and POS 'SALE'/'RETURN'/'VOID'
--     all map to a common vocabulary: completed / returned / cancelled
--   - Surrogate order_key prefixed by source to avoid ID collisions
--   - customer_key resolved via silver_customers using source-specific IDs

with shopify_orders as (
    select
        'shopify-' || cast(order_id as string)  as order_key,
        customer_id                             as shopify_customer_id,
        cast(null as int)                       as pos_customer_id,
        case status
            when 'fulfilled' then 'completed'
            when 'refunded'  then 'returned'
            else status
        end                                     as order_status,
        'online'                                as channel,
        device_type,
        promo_code,
        created_at                              as order_timestamp,
        cast(null as int)                       as store_id,
        'shopify'                               as source_system
    from {{ ref('bronze_shopify_orders') }}
),

pos_transactions as (
    select
        'pos-' || cast(transaction_id as string) as order_key,
        cast(null as int)                        as shopify_customer_id,
        customer_id                              as pos_customer_id,
        case transaction_type
            when 'SALE'   then 'completed'
            when 'RETURN' then 'returned'
            when 'VOID'   then 'cancelled'
            else transaction_type
        end                                      as order_status,
        'in_store'                               as channel,
        cast(null as string)                     as device_type,
        cast(null as string)                     as promo_code,
        -- POS timestamps are local store time; kept as-is for demo simplicity
        local_transaction_timestamp              as order_timestamp,
        store_id,
        'pos'                                    as source_system
    from {{ ref('bronze_pos_transactions') }}
),

all_orders as (
    select * from shopify_orders
    union all
    select * from pos_transactions
)

select
    o.order_key,
    c.customer_key,
    o.order_status,
    o.channel,
    o.device_type,
    o.promo_code,
    o.order_timestamp,
    o.store_id,
    o.source_system
from all_orders o
left join {{ ref('silver_customers') }} c
    on  o.shopify_customer_id = c.shopify_customer_id
    or  o.pos_customer_id     = c.pos_customer_id
