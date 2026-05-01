-- online_revenue + in_store_revenue must equal total_revenue for every product.
-- A tolerance of 0.01 is applied to account for decimal precision in aggregation.
-- Any larger discrepancy indicates a logic error in the channel split.
select
    sku,
    product_name,
    total_revenue,
    online_revenue,
    in_store_revenue,
    online_revenue + in_store_revenue           as calculated_total,
    total_revenue - (online_revenue + in_store_revenue) as discrepancy
from {{ ref('gold_product_performance') }}
where abs(total_revenue - (online_revenue + in_store_revenue)) > 0.01
