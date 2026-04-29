-- Product performance across both channels.
-- Breaks down units sold and revenue by online vs in-store.

select
    coalesce(p.sku, l.product_name)                                             as sku,
    coalesce(p.product_name, l.product_name)                                    as product_name,
    coalesce(p.category, 'Unknown')                                             as category,
    p.price,
    count(distinct l.order_line_key)                                            as transaction_count,
    sum(l.quantity)                                                             as units_sold,
    sum(l.line_total)                                                           as total_revenue,
    sum(case when l.source_system = 'shopify' then l.quantity   else 0 end)    as online_units,
    sum(case when l.source_system = 'pos'     then l.quantity   else 0 end)    as in_store_units,
    sum(case when l.source_system = 'shopify' then l.line_total else 0 end)    as online_revenue,
    sum(case when l.source_system = 'pos'     then l.line_total else 0 end)    as in_store_revenue
from {{ ref('silver_order_lines') }} l
join {{ ref('silver_orders') }} o using (order_key)
left join {{ ref('silver_products') }} p on l.sku = p.sku
where o.order_status = 'completed'
group by 1, 2, 3, 4
order by total_revenue desc
