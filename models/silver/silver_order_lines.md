{% docs silver_order_lines %}

## Overview

Unified order line items across both channels. Each row represents one product within an order, with product details resolved to canonical names and categories from `silver_products`.

## Source Models

- `bronze_shopify_order_items` — Shopify line items (joined to `silver_products` on `sku`)
- `bronze_pos_transaction_items` — POS line items (joined to `silver_products` on `barcode`)

## Product Name Resolution

POS line items store product names as free-text at time of sale, which can differ from the canonical Shopify product name:

| POS product_name_at_sale | Canonical product_name |
|--------------------------|------------------------|
| `Hoodie - Discounted` | `Hoodie` |
| `Water Bottle - Promo` | `Water Bottle` |
| `Running Shoes` | `Running Shoes` (exact match) |

The model applies `regexp_replace` to strip promotional suffixes, then falls back to the Shopify product name when a barcode match is found.

## Unmatched Products

If a POS barcode cannot be matched to a Shopify product (e.g. a product sold in-store that was never listed online), `product_id`, `sku`, and `category` will be null. The `product_name` will be the cleaned `product_name_at_sale`.

## Return Line Items

`unit_price` and `line_total` are negative for return line items from the POS system. These are included in aggregations so revenue figures in gold models correctly net out returns.

## Downstream Usage

`order_line_key` and `order_key` are the join keys used by all gold models. Always filter on `silver_orders.order_status = 'completed'` when computing revenue to exclude returns and voided transactions.

{% enddocs %}
