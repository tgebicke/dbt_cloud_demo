{% docs bronze_pos_stores %}

## Overview

Lightly transformed store location records from the Point of Sale system. Represents the 5 physical retail locations across the US.

## Source

Reads directly from `cat_demo.pos_raw.stores` via the `pos_raw` source definition.

## Transformations

| Change | Detail |
|--------|--------|
| Column rename | `id` → `store_id` |
| Column rename | `name` → `store_name` |
| Added column | `_source = 'pos'` |

No filtering, casting, or business logic is applied at this layer.

## Store Locations

| Store | City | State |
|-------|------|-------|
| Manhattan Flagship | New York | NY |
| Beverly Hills | Los Angeles | CA |
| Chicago Loop | Chicago | IL |
| South Congress | Austin | TX |
| Capitol Hill | Seattle | WA |

## Usage

`store_id` is referenced by `bronze_pos_transactions` (where the transaction occurred) and `bronze_pos_customers` (where the customer enrolled in the loyalty program). It is surfaced in gold-layer models for store-level performance analysis.

## Contract

This model has an enforced dbt contract. All columns are required (`not_null` constraints applied to every field).

{% enddocs %}
