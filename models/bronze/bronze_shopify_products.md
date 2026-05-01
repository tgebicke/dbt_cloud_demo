{% docs bronze_shopify_products %}

## Overview

Lightly transformed product catalog from the Shopify online storefront. This model renames source columns to consistent naming conventions and adds a `_source` tag.

## Source

Reads directly from `cat_demo.shopify_raw.products` via the `shopify_raw` source definition.

## Transformations

| Change | Detail |
|--------|--------|
| Column rename | `id` → `product_id` |
| Column rename | `name` → `product_name` |
| Added column | `_source = 'shopify'` |

No filtering, casting, or business logic is applied at this layer.

## SKU and Cross-Source Product Resolution

The `sku` column (e.g. `SKU-FOOT-001`) is the Shopify product identifier. The POS system identifies products by barcode instead. The `silver_products` model bridges these two identifier systems using a static SKU-to-barcode mapping, enabling unified product analysis across both channels.

## Contract

This model has an enforced dbt contract. Prices are stored as `decimal(5,2)` — a type change at the source (e.g. to `double` or `string`) will cause this model to fail at materialization time.

{% enddocs %}
