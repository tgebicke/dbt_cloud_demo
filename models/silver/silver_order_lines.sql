-- Unified order line items across both channels.
-- POS line items reference products by barcode and store the name at time of sale
-- (which can include noise like "Hoodie - Discounted"). Product resolution uses
-- silver_products to normalize back to a canonical SKU and product_name.

with shopify_lines as (
    select
        'shopify-' || cast(order_item_id as string) as order_line_key,
        'shopify-' || cast(order_id as string)      as order_key,
        p.product_id,
        p.sku,
        p.product_name,
        p.category,
        oi.quantity,
        oi.unit_price,
        oi.quantity * oi.unit_price                 as line_total,
        'shopify'                                   as source_system
    from {{ ref('bronze_shopify_order_items') }} oi
    left join {{ ref('silver_products') }} p on oi.sku = p.sku
),

pos_lines as (
    select
        'pos-' || cast(transaction_item_id as string) as order_line_key,
        'pos-' || cast(transaction_id as string)      as order_key,
        p.product_id,
        p.sku,
        -- Strip POS-specific suffixes (e.g. "Hoodie - Discounted" -> "Hoodie")
        coalesce(p.product_name, trim(regexp_replace(ti.product_name_at_sale, ' - (Discounted|Promo).*$', ''))) as product_name,
        p.category,
        ti.quantity,
        ti.unit_price,
        ti.quantity * ti.unit_price                   as line_total,
        'pos'                                         as source_system
    from {{ ref('bronze_pos_transaction_items') }} ti
    left join {{ ref('silver_products') }} p on ti.barcode = p.barcode
)

select * from shopify_lines
union all
select * from pos_lines
