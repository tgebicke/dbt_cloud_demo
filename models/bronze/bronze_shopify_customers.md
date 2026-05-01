{% docs bronze_shopify_customers %}

## Overview

Lightly transformed customer records from the Shopify online storefront. This model renames the source `id` column to `customer_id` for clarity and adds a `_source` tag to identify the originating system.

## Source

Reads directly from `cat_demo.shopify_raw.customers` via the `shopify_raw` source definition.

## Transformations

| Change | Detail |
|--------|--------|
| Column rename | `id` → `customer_id` |
| Added column | `_source = 'shopify'` |

No filtering, casting, or business logic is applied at this layer. All rows from the source are preserved as-is.

## Cross-Channel Identity

The `phone` column is the key used by `silver_customers` to match Shopify customers with POS loyalty records. Shopify customers who share a phone number with a POS customer are classified as `cross_channel` in the silver layer.

## Contract

This model has an enforced dbt contract. Any change to column names, data types, or column count in the source will cause this model to fail — protecting downstream silver and gold models from silent schema drift.

{% enddocs %}
