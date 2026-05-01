{% docs silver_products %}

## Overview

Unified product catalog that bridges the two identifier systems used across channels. Shopify identifies products by SKU; the POS system identifies products by barcode. This model maps them together, enabling cross-channel product analysis in the gold layer.

## Source Models

- `bronze_shopify_products` — Shopify product catalog (source of truth for product metadata)

## Identifier Mapping

The POS system does not share a product database with Shopify. The mapping between SKU and barcode is maintained as a static lookup table embedded in this model:

| SKU | Barcode | Product |
|-----|---------|---------|
| SKU-FOOT-001 | 700100000001 | Running Shoes |
| SKU-ELEC-003 | 700100000013 | Smart Watch |
| SKU-HOME-001 | 700100000009 | Coffee Maker |
| ... | ... | ... |

In a production system, this mapping would typically come from an ERP or master data management system rather than a hardcoded VALUES clause.

## Product Coverage

All 20 products in the Shopify catalog have a corresponding barcode mapping, so `barcode` is never null in the current dataset. If new products are added to Shopify without updating the mapping, `barcode` would be null for those products — and their POS line items would appear as unmatched in `silver_order_lines`.

## Downstream Usage

- `silver_order_lines` joins to this model on both `sku` (Shopify lines) and `barcode` (POS lines)
- `gold_product_performance` uses this model for canonical product names and categories

{% enddocs %}
