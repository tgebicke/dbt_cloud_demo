-- Monthly revenue by channel (online vs in_store).
-- Only completed orders are included; returns and cancellations are excluded.

with completed_order_revenue as (
    select
        o.order_key,
        o.channel,
        date_trunc('month', o.order_timestamp) as order_month,
        sum(l.line_total)                      as order_total
    from {{ ref('silver_orders') }} o
    join {{ ref('silver_order_lines') }} l using (order_key)
    where o.order_status = 'completed'
    group by 1, 2, 3
)

select
    order_month,
    channel,
    count(distinct order_key)   as order_count,
    sum(order_total)            as revenue,
    avg(order_total)            as avg_order_value
from completed_order_revenue
group by 1, 2
order by 1, 2
