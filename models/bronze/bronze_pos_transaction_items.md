{% docs bronze_pos_transaction_items %}

## Overview

Lightly transformed line item records from the Point of Sale system. Each row represents one product scanned within a transaction. Products are identified by barcode rather than a product ID, and the product name is captured as a free-text string at time of sale.

## Source

Reads directly from `cat_demo.pos_raw.transaction_items` via the `pos_raw` source definition.

## Transformations

| Change | Detail |
|--------|--------|
| Column rename | `id` → `transaction_item_id` |
| Added column | `_source = 'pos'` |

No filtering, casting, or business logic is applied at this layer.

## Product Identification

The POS system does not store product IDs. Instead it stores:

- **`barcode`** — the physical barcode scanned at the register (e.g. `700100000001`). This maps to Shopify SKUs via the static mapping in `silver_products`.
- **`product_name_at_sale`** — the product name as it appeared at time of purchase. This may include promotional suffixes such as `- Discounted` or `- Promo` that are stripped in `silver_order_lines`.

## Name Noise

Some POS line items contain modified product names that do not exactly match the Shopify product catalog:

| Raw name | Cleaned name (silver) |
|----------|-----------------------|
| `Hoodie - Discounted` | `Hoodie` |
| `Water Bottle - Promo` | `Water Bottle` |

The `silver_order_lines` model uses `regexp_replace` to strip these suffixes before joining to the product catalog.

## Return Line Items

For `RETURN` transactions, `unit_price` is negative (e.g. `-34.99`). These flow through to `silver_order_lines` and are used to correctly net out revenue in gold models.

## Contract

This model has an enforced dbt contract. `unit_price` is `decimal(5,2)` and may be negative.

{% enddocs %}
