-- Create dimension tables
CREATE TABLE IF NOT EXISTS default.dim_customers
(
    customer_key UInt32,
    customer_first_name String,
    customer_last_name String,
    customer_email String,
    customer_country String,
    customer_postal_code String
) ENGINE = MergeTree()
ORDER BY customer_key;

CREATE TABLE IF NOT EXISTS default.dim_products
(
    product_key UInt32,
    product_name String,
    product_category String,
    product_brand String,
    product_price Decimal64(2),
    product_rating Decimal32(2)
) ENGINE = MergeTree()
ORDER BY product_key;

CREATE TABLE IF NOT EXISTS default.dim_stores
(
    store_key UInt64,
    store_name String,
    store_location String,
    store_city String,
    store_state String,
    store_country String
) ENGINE = MergeTree()
ORDER BY store_key;

CREATE TABLE IF NOT EXISTS default.fact_sales
(
    sale_date Date,
    sale_customer_id UInt32,
    sale_product_id UInt32,
    sale_quantity UInt32,
    sale_total_price Decimal64(2)
) ENGINE = MergeTree()
PARTITION BY toYYYYMM(sale_date)
ORDER BY (sale_date, sale_customer_id); 