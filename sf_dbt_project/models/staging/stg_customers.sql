SELECT 
    customer_id,
    first_name,
    last_name,
    first_name||' '||last_name as customer_name,
    email,
    customer_segment AS segment,
    city,
    state,
    country,
    registration_date
FROM {{ source('raw','dim_customers') }}
