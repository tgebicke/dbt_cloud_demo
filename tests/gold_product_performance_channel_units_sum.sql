-- online_units + in_store_units must equal units_sold for every product.
-- These are computed as CASE WHEN sums over the same set of rows,
-- so any mismatch indicates a logic error in the aggregation.
select
    sku,
    product_name,
    units_sold,
    online_units,
    in_store_units,
    online_units + in_store_units as calculated_total
from {{ ref('gold_product_performance') }}
where online_units + in_store_units != units_sold
