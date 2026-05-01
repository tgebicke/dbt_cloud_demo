-- Revenue must be positive for every channel/month combination.
-- Only completed orders are included, so returns are already excluded.
-- A zero or negative value would indicate a data pipeline error.
select
    order_month,
    channel,
    order_count,
    revenue
from {{ ref('gold_revenue_by_channel') }}
where revenue <= 0
