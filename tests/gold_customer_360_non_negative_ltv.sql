-- Lifetime value must never be negative.
-- LTV is summed from completed order lines only, so even customers
-- with returns should net to >= 0.
select
    customer_key,
    first_name,
    last_name,
    lifetime_value
from {{ ref('gold_customer_360') }}
where lifetime_value < 0
