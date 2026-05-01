{% docs silver_orders %}

## Overview

Unified order model combining Shopify online orders and POS transactions into a single table with a consistent schema. Each row represents one order or transaction from either channel.

## Source Models

- `bronze_shopify_orders` — online orders
- `bronze_pos_transactions` — in-store transactions

## Key Transformations

**Status normalization** — each source uses different vocabulary:

| Shopify status | POS transaction_type | Unified order_status |
|----------------|----------------------|----------------------|
| `fulfilled` | `SALE` | `completed` |
| `refunded` | `RETURN` | `returned` |
| `pending` | — | `pending` |
| — | `VOID` | `cancelled` |

VOID transactions are included in this model but excluded from revenue calculations in gold models.

**Surrogate order_key** — Shopify and POS use independent integer ID sequences, so a simple integer key would cause collisions. Each record is assigned a source-prefixed key:

- Shopify: `shopify-1`, `shopify-2`, ..., `shopify-50`
- POS: `pos-3001`, `pos-3002`, ..., `pos-3045`

**Customer resolution** — source-specific customer IDs are resolved to the unified `customer_key` from `silver_customers` using a left join on Shopify or POS customer ID.

## Channel-Specific Columns

| Column | Online | In-store |
|--------|--------|----------|
| `device_type` | desktop / mobile / tablet | null |
| `promo_code` | code or null | null |
| `store_id` | null | store identifier |

## Timestamp Note

`order_timestamp` is stored as `timestamp` type. Shopify timestamps are UTC; POS timestamps are local store time (no timezone conversion is applied in this demo). In production, UTC normalization should be applied during silver transformation.

{% enddocs %}
