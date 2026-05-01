{% docs bronze_pos_customers %}

## Overview

Lightly transformed loyalty program customer records from the Point of Sale system. Unlike Shopify customers, POS customers have no email address — `phone` is the sole cross-channel identifier.

## Source

Reads directly from `cat_demo.pos_raw.customers` via the `pos_raw` source definition.

## Transformations

| Change | Detail |
|--------|--------|
| Column rename | `id` → `customer_id` |
| Added column | `_source = 'pos'` |

No filtering, casting, or business logic is applied at this layer.

## ID Space

POS `customer_id` values (201–220) occupy a completely separate ID space from Shopify `customer_id` values (1–25). These IDs must never be compared or joined directly — use the unified `customer_key` in `silver_customers` instead.

## Cross-Channel Identity Resolution

10 of the 20 POS customers also have Shopify accounts. They are identified by matching `phone` across both systems. These customers are classified as `cross_channel` in `silver_customers`.

The remaining 10 POS customers have no Shopify account and are classified as `in_store_only`.

## Contract

This model has an enforced dbt contract. All columns are required except `customer_id` — walk-in guests without a loyalty card may have no POS customer record at all (they appear as `NULL customer_id` in transactions instead).

{% enddocs %}
