{% docs gold_customer_360 %}

## Overview

One row per customer with lifetime purchase metrics aggregated across both the online and in-store channels. This is the primary customer analytics table for reporting and segmentation.

## Source Models

- `silver_customers` — customer identity and attributes
- `silver_orders` — order history
- `silver_order_lines` — line item revenue

## Metrics Defined

| Metric | Definition |
|--------|------------|
| `total_orders` | Distinct orders with status `completed` or `returned` (excludes `cancelled`) |
| `completed_orders` | Distinct orders with status `completed` |
| `returned_orders` | Distinct orders with status `returned` |
| `lifetime_value` | Sum of `line_total` for all `completed` orders |
| `preferred_channel` | Channel (`online` or `in_store`) with the highest count of completed orders |

## Customer Segmentation by Type

| customer_type | email | online orders | in-store orders |
|---------------|-------|---------------|-----------------|
| `cross_channel` | ✓ | ✓ | ✓ |
| `online_only` | ✓ | ✓ | — |
| `in_store_only` | — | — | ✓ |

Customers with no orders will have `total_orders = 0` and `lifetime_value = 0` (coalesced from null). `preferred_channel`, `first_order_at`, and `last_order_at` will be null for customers with no completed orders.

## Key Use Cases

- **Customer LTV ranking** — order by `lifetime_value` desc
- **Channel preference analysis** — group by `customer_type`, `preferred_channel`
- **Churn identification** — filter on `last_order_at` older than N days
- **Marketing segmentation** — filter on `marketing_opt_in = true` and `customer_type`

{% enddocs %}
