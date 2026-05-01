{% docs silver_customers %}

## Overview

Unified customer table combining records from the Shopify online storefront and the POS loyalty program. Each row represents one unique person, with a stable `customer_key` that persists regardless of which source system a customer originally came from.

## Source Models

- `bronze_shopify_customers` — online storefront accounts
- `bronze_pos_customers` — in-store loyalty program records

## Identity Resolution

Phone number is the shared identifier used to match customers across both systems. Shopify stores `email` and `phone`; POS stores only `phone` and `loyalty_card_number`. The join is performed on exact phone match.

| Scenario | customer_type |
|----------|---------------|
| Phone exists in both Shopify and POS | `cross_channel` |
| Phone exists only in Shopify | `online_only` |
| Phone exists only in POS | `in_store_only` |

## Customer Distribution

Of the 45 total customers in the demo dataset:
- **10** are `cross_channel` — shop both online and in-store
- **15** are `online_only` — Shopify account, no POS loyalty card
- **10** are `in_store_only` — POS loyalty card, no Shopify account

## Nullable Columns

Several columns are intentionally nullable because they only exist in one source:

| Column | Null when |
|--------|-----------|
| `email` | `in_store_only` customers |
| `shopify_customer_id` | `in_store_only` customers |
| `pos_customer_id` | `online_only` customers |
| `country` | `in_store_only` customers |
| `marketing_opt_in` | `in_store_only` customers |

## Downstream Usage

`customer_key` is the join key used by `silver_orders` and `gold_customer_360`. Always join on `customer_key` — never join directly on source system IDs.

{% enddocs %}
