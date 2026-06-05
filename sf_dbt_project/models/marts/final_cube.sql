{{
    config(
        materialized='table'
    )
}}

SELECT
    d.year,
    d.quarter,
    d.month_name,
    d.is_weekend,
    c.segment            AS customer_segment,
    c.state              AS customer_state,
    p.category           AS product_category,
    p.sub_category       AS product_sub_category,
    p.brand              AS product_brand,
    s.store_name,
    s.store_type,
    s.region             AS store_region,
    COUNT(o.order_id)                                      AS total_orders,
    SUM(o.quantity)                                        AS total_units_sold,
    SUM(o.total_amount)                                    AS total_revenue,
    SUM(o.quantity * p.cost_price)                         AS total_cost,
    SUM(o.total_amount) - SUM(o.quantity * p.cost_price)   AS total_profit,
    AVG(o.total_amount)                                    AS avg_order_value,
    AVG(o.discount_pct)                                    AS avg_discount_pct
FROM {{ ref('stg_orders') }} o
LEFT JOIN {{ ref('stg_customers') }} c ON o.customer_id = c.customer_id
LEFT JOIN {{ ref('stg_products') }} p ON o.product_id = p.product_id
LEFT JOIN {{ ref('stg_stores') }} s ON o.store_id = s.store_id
LEFT JOIN {{ ref('stg_dates') }} d ON o.order_date = d.date_key
GROUP BY
    d.year,
    d.quarter,
    d.month_name,
    d.is_weekend,
    c.segment,
    c.state,
    p.category,
    p.sub_category,
    p.brand,
    s.store_name,
    s.store_type,
    s.region
