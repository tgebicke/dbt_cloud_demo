-- One row per customer with lifetime metrics across both channels.
-- Preferred channel is determined by whichever channel has the most completed orders.

with completed_orders as (
    select
        customer_key,
        order_key,
        channel,
        order_timestamp
    from {{ ref('silver_orders') }}
    where order_status = 'completed'
),

order_revenue as (
    select
        o.customer_key,
        sum(l.line_total)   as order_total
    from {{ ref('silver_order_lines') }} l
    join completed_orders o using (order_key)
    group by 1
),

order_counts as (
    select
        customer_key,
        count(distinct order_key)                                               as total_orders,
        count(distinct case when order_status = 'completed' then order_key end) as completed_orders,
        count(distinct case when order_status = 'returned'  then order_key end) as returned_orders,
        min(order_timestamp)                                                    as first_order_at,
        max(order_timestamp)                                                    as last_order_at
    from {{ ref('silver_orders') }}
    where order_status != 'cancelled'
    group by 1
),

-- Preferred channel = the one with the most completed orders per customer
channel_counts as (
    select
        customer_key,
        channel,
        count(*) as cnt,
        row_number() over (partition by customer_key order by count(*) desc) as rn
    from completed_orders
    group by 1, 2
),

preferred_channel as (
    select customer_key, channel as preferred_channel
    from channel_counts
    where rn = 1
),

lifetime_value as (
    select
        customer_key,
        sum(order_total) as lifetime_value
    from order_revenue
    group by 1
)

select
    c.customer_key,
    c.first_name,
    c.last_name,
    c.email,
    c.phone,
    c.country,
    c.customer_type,
    coalesce(oc.total_orders, 0)        as total_orders,
    coalesce(oc.completed_orders, 0)    as completed_orders,
    coalesce(oc.returned_orders, 0)     as returned_orders,
    pc.preferred_channel,
    oc.first_order_at,
    oc.last_order_at,
    coalesce(lv.lifetime_value, 0)      as lifetime_value
from {{ ref('silver_customers') }} c
left join order_counts oc       using (customer_key)
left join preferred_channel pc  using (customer_key)
left join lifetime_value lv     using (customer_key)
