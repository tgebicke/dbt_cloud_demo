{% docs bronze_pos_transactions %}

## Overview

Lightly transformed transaction records from the Point of Sale system across all 5 store locations. Includes sales, returns, and voided transactions.

## Source

Reads directly from `cat_demo.pos_raw.transactions` via the `pos_raw` source definition.

## Transformations

| Change | Detail |
|--------|--------|
| Column rename | `id` → `transaction_id` |
| Added column | `_source = 'pos'` |

No filtering, casting, or business logic is applied at this layer. VOID transactions are preserved here and filtered out in `silver_orders`.

## Transaction Types

| Type | Meaning | silver_orders status |
|------|---------|----------------------|
| `SALE` | Standard purchase | `completed` |
| `RETURN` | Merchandise return | `returned` |
| `VOID` | Cancelled/error transaction | `cancelled` (excluded from revenue) |

## Timestamp Handling

`local_transaction_timestamp` is stored as a **string** (e.g. `'2023-06-17 13:20:00'`) because the POS system exports timestamps without timezone information. The silver layer is responsible for casting this to a proper timestamp type. This is a known characteristic of the source system, not a data quality issue.

## Guest Transactions

3 of the 45 transactions have a `NULL` `customer_id`, representing walk-in customers who did not present a loyalty card. These transactions are included in revenue totals but excluded from customer-level attribution in gold models.

## Contract

This model has an enforced dbt contract. `customer_id` is intentionally nullable. `total_amount` is `decimal(5,2)` and can be negative for RETURN transactions.

{% enddocs %}
