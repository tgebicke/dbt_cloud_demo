{% docs bronze_shopify_orders %}

## Overview

Lightly transformed order records from the Shopify online storefront. Includes channel metadata (device type, promotional codes) that is only available from the online channel.

## Source

Reads directly from `cat_demo.shopify_raw.orders` via the `shopify_raw` source definition.

## Transformations

| Change | Detail |
|--------|--------|
| Column rename | `id` → `order_id` |
| Added column | `_source = 'shopify'` |

No filtering, casting, or business logic is applied at this layer.

## Status Vocabulary

Shopify order statuses (`fulfilled`, `refunded`, `pending`) differ from POS transaction types (`SALE`, `RETURN`, `VOID`). The `silver_orders` model normalizes both into a common vocabulary:

| Shopify status | Unified status |
|----------------|----------------|
| `fulfilled` | `completed` |
| `refunded` | `returned` |
| `pending` | `pending` |

## Online-Only Columns

`device_type` and `promo_code` are online-channel metadata with no equivalent in the POS system. They are preserved in `silver_orders` as nullable columns and used in gold-layer channel analysis.

## Contract

This model has an enforced dbt contract. `device_type` and `promo_code` are intentionally nullable (no `not_null` constraint) as they are not required for all orders.

{% enddocs %}
