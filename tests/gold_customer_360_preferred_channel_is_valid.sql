-- preferred_channel must be 'online', 'in_store', or null.
-- Null is valid for customers who have no completed orders.
-- Any other value indicates a bug in the channel normalization logic.
select
    customer_key,
    preferred_channel
from {{ ref('gold_customer_360') }}
where preferred_channel is not null
  and preferred_channel not in ('online', 'in_store')
