{% docs gold_product_performance %}

## Overview

Product-level sales performance aggregated across both channels. One row per product, with revenue and units split between online and in-store. Ordered by total revenue descending.

## Source Models

- `silver_order_lines` — line item quantities and revenue
- `silver_orders` — used to filter to completed orders only
- `silver_products` — canonical product names and categories

## Filters Applied

- `order_status = 'completed'` — returns and cancellations are excluded

## Channel Split Columns

Each product has four channel-specific metrics in addition to the combined totals:

| Column | Description |
|--------|-------------|
| `online_units` | Units sold via Shopify |
| `in_store_units` | Units sold via POS |
| `online_revenue` | Revenue from Shopify in USD |
| `in_store_revenue` | Revenue from POS in USD |

`online_units + in_store_units = units_sold` and `online_revenue + in_store_revenue = total_revenue` for all products.

## Unmatched POS Products

Products sold in-store where the POS barcode could not be matched to a Shopify product will appear with:
- `sku` = the POS product name (fallback)
- `category` = `'Unknown'`
- `price` = null

In the demo dataset all barcodes are matched, so this case does not occur.

## Key Use Cases

- **Top sellers** — order by `total_revenue` or `units_sold` desc
- **Channel preference by product** — compare `online_units` vs `in_store_units`
- **Category performance** — group by `category`
- **Online-exclusive vs in-store-exclusive** — filter where `in_store_units = 0` or `online_units = 0`

{% enddocs %}
