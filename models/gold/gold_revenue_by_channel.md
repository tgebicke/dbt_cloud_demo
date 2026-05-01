{% docs gold_revenue_by_channel %}

## Overview

Monthly revenue summary broken down by sales channel. One row per channel per month, covering only completed orders. This is the primary table for trend analysis and channel comparison reporting.

## Source Models

- `silver_orders` — order metadata and channel
- `silver_order_lines` — line item revenue

## Filters Applied

- `order_status = 'completed'` — returns and cancellations are excluded
- Revenue is summed at the line item level, not the order total, to account for partial returns

## Channels

| channel | Description |
|---------|-------------|
| `online` | Orders placed through the Shopify web storefront |
| `in_store` | Transactions processed through the POS system |

## Date Coverage

The demo dataset covers January 2023 through December 2023, providing a full year of monthly data across both channels.

## Key Use Cases

- **Channel trend analysis** — plot `revenue` over `order_month` by `channel`
- **Channel share** — calculate online vs in-store revenue as a percentage of total
- **Seasonality** — identify peak months across channels
- **Average order value trends** — track `avg_order_value` over time

## Notes

`order_month` is a `timestamp` (the result of `date_trunc('month', ...)`) representing the first moment of the month. Cast to `date` in BI tools if a date type is preferred.

{% enddocs %}
