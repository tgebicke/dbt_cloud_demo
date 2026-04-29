-- Unified product catalog mapping Shopify SKUs to POS barcodes.
-- POS stores product names at time of sale rather than product IDs,
-- so this mapping table is the bridge for cross-source order line analysis.

with shopify_products as (
    select * from {{ ref('bronze_shopify_products') }}
),

-- SKU-to-barcode mapping (POS uses barcodes, Shopify uses SKUs)
barcode_mapping as (
    select * from values
        ('SKU-FOOT-001', '700100000001'),
        ('SKU-FIT-001',  '700100000002'),
        ('SKU-ELEC-001', '700100000003'),
        ('SKU-ACC-001',  '700100000004'),
        ('SKU-ACC-002',  '700100000005'),
        ('SKU-CLO-001',  '700100000006'),
        ('SKU-ACC-003',  '700100000007'),
        ('SKU-ELEC-002', '700100000008'),
        ('SKU-HOME-001', '700100000009'),
        ('SKU-HOME-002', '700100000010'),
        ('SKU-FOOT-002', '700100000011'),
        ('SKU-FIT-002',  '700100000012'),
        ('SKU-ELEC-003', '700100000013'),
        ('SKU-ACC-004',  '700100000014'),
        ('SKU-CLO-002',  '700100000015'),
        ('SKU-HOME-003', '700100000016'),
        ('SKU-ELEC-004', '700100000017'),
        ('SKU-FIT-003',  '700100000018'),
        ('SKU-FOOT-003', '700100000019'),
        ('SKU-HOME-004', '700100000020')
    as t(sku, barcode)
)

select
    p.product_id,
    p.sku,
    m.barcode,
    p.product_name,
    p.category,
    p.price,
    p.is_active
from shopify_products p
left join barcode_mapping m on p.sku = m.sku
