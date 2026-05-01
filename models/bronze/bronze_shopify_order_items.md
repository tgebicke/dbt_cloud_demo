{% docs bronze_shopify_order_items %}

## Overview

Lightly transformed line item records for Shopify online orders. Each row represents one product within an order, with the SKU denormalized from the product catalog at time of purchase.

## Source

Reads directly from `cat_demo.shopify_raw.order_items` via the `shopify_raw` source definition.

## Transformations

| Change | Detail |
|--------|--------|
| Column rename | `id` → `order_item_id` |
| Added column | `_source = 'shopify'` |

No filtering, casting, or business logic is applied at this layer.

## SKU Denormalization

The `sku` column is stored at the line item level (denormalized from the product catalog at time of purchase). This preserves the historical SKU even if the product catalog changes, and is the join key used by `silver_order_lines` to resolve product details.

## Relationship to Orders

Every `order_id` in this model must exist in `bronze_shopify_orders`. This referential integrity is validated by a source-level `relationships` test in `sources.yml`.

## Contract

This model has an enforced dbt contract. `unit_price` is stored as `decimal(5,2)`.

{% enddocs %}
