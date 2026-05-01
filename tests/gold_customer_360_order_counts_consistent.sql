-- completed_orders + returned_orders must not exceed total_orders.
-- total_orders excludes cancelled (VOID) transactions, so the
-- sum of completed and returned should always be <= total.
select
    customer_key,
    total_orders,
    completed_orders,
    returned_orders,
    completed_orders + returned_orders as sum_of_parts
from {{ ref('gold_customer_360') }}
where completed_orders + returned_orders > total_orders
