-- Both 'online' and 'in_store' channels must have revenue data.
-- If either channel is missing entirely it signals a broken pipeline
-- or a source system outage that should be investigated.
select 'missing_channel' as failure_reason
from (
    select count(distinct channel) as channel_count
    from {{ ref('gold_revenue_by_channel') }}
) counts
where channel_count < 2
