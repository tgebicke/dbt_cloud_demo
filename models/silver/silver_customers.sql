-- Unify customers across Shopify and POS systems.
-- Phone number is the shared identifier used to match cross-channel customers.
-- Result: one row per unique person with a stable customer_key.

with shopify as (
    select * from {{ ref('bronze_shopify_customers') }}
),

pos as (
    select * from {{ ref('bronze_pos_customers') }}
),

-- Customers who exist in both systems (matched on phone)
cross_channel as (
    select
        s.customer_id   as shopify_customer_id,
        p.customer_id   as pos_customer_id,
        s.email,
        s.first_name,
        s.last_name,
        s.phone,
        s.country,
        s.marketing_opt_in,
        least(s.created_at, p.created_at) as created_at,
        'cross_channel' as customer_type
    from shopify s
    inner join pos p on s.phone = p.phone
),

-- Online-only customers (no matching POS record)
online_only as (
    select
        s.customer_id   as shopify_customer_id,
        cast(null as int) as pos_customer_id,
        s.email,
        s.first_name,
        s.last_name,
        s.phone,
        s.country,
        s.marketing_opt_in,
        s.created_at,
        'online_only'   as customer_type
    from shopify s
    left join cross_channel cc on s.customer_id = cc.shopify_customer_id
    where cc.shopify_customer_id is null
),

-- In-store-only customers (no matching Shopify account)
in_store_only as (
    select
        cast(null as int) as shopify_customer_id,
        p.customer_id   as pos_customer_id,
        cast(null as string) as email,
        p.first_name,
        p.last_name,
        p.phone,
        cast(null as string) as country,
        cast(null as boolean) as marketing_opt_in,
        p.created_at,
        'in_store_only' as customer_type
    from pos p
    left join cross_channel cc on p.customer_id = cc.pos_customer_id
    where cc.pos_customer_id is null
),

unified as (
    select * from cross_channel
    union all
    select * from online_only
    union all
    select * from in_store_only
)

select
    row_number() over (
        order by created_at, coalesce(cast(shopify_customer_id as string), cast(pos_customer_id as string))
    )                   as customer_key,
    shopify_customer_id,
    pos_customer_id,
    email,
    first_name,
    last_name,
    phone,
    country,
    marketing_opt_in,
    created_at,
    customer_type
from unified
