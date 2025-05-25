-- DML скрипты для заполнения таблиц фактов и измерений

-- Заполняем таблицу покупателей (уникальные комбинации)
INSERT INTO dim_customers (first_name, last_name, age, email, country, postal_code)
SELECT DISTINCT
    customer_first_name,
    customer_last_name,
    customer_age,
    customer_email,
    customer_country,
    customer_postal_code
FROM mock_data;

-- Заполняем таблицу питомцев покупателей
INSERT INTO dim_customer_pets (customer_id, pet_type, pet_name, pet_breed)
SELECT DISTINCT
    c.customer_id,
    m.customer_pet_type,
    m.customer_pet_name,
    m.customer_pet_breed
FROM mock_data m
JOIN dim_customers c ON 
    c.first_name = m.customer_first_name AND
    c.last_name = m.customer_last_name AND
    c.email = m.customer_email;

-- Заполняем таблицу продавцов
INSERT INTO dim_sellers (first_name, last_name, email, country, postal_code)
SELECT DISTINCT
    seller_first_name,
    seller_last_name,
    seller_email,
    seller_country,
    seller_postal_code
FROM mock_data;

-- Заполняем таблицу магазинов
INSERT INTO dim_stores (name, location, city, state, country, phone, email)
SELECT DISTINCT
    store_name,
    store_location,
    store_city,
    store_state,
    store_country,
    store_phone,
    store_email
FROM mock_data;

-- Заполняем таблицу поставщиков
INSERT INTO dim_suppliers (name, contact, email, phone, address, city, country)
SELECT DISTINCT
    supplier_name,
    supplier_contact,
    supplier_email,
    supplier_phone,
    supplier_address,
    supplier_city,
    supplier_country
FROM mock_data;

-- Заполняем таблицу продуктов
INSERT INTO dim_products (
    name, category, price, weight, color, size, brand, 
    material, description, rating, reviews, 
    release_date, expiry_date, supplier_id
)
SELECT DISTINCT
    m.product_name,
    m.product_category,
    m.product_price,
    m.product_weight,
    m.product_color,
    m.product_size,
    m.product_brand,
    m.product_material,
    m.product_description,
    m.product_rating,
    m.product_reviews,
    m.product_release_date,
    m.product_expiry_date,
    s.supplier_id
FROM mock_data m
JOIN dim_suppliers s ON 
    s.name = m.supplier_name AND
    s.email = m.supplier_email;

-- Заполняем таблицу фактов продаж
INSERT INTO fact_sales (
    customer_id, seller_id, product_id, store_id,
    sale_date, quantity, total_price,
    original_file_id, original_id
)
SELECT DISTINCT ON (m.file_id, m.original_id)
    c.customer_id,
    s.seller_id,
    p.product_id,
    st.store_id,
    m.sale_date,
    m.sale_quantity,
    m.sale_total_price,
    m.file_id,
    m.original_id
FROM mock_data m
JOIN dim_customers c ON 
    c.first_name = m.customer_first_name AND
    c.last_name = m.customer_last_name AND
    c.email = m.customer_email
JOIN dim_sellers s ON 
    s.first_name = m.seller_first_name AND
    s.last_name = m.seller_last_name AND
    s.email = m.seller_email
JOIN dim_products p ON 
    p.name = m.product_name AND
    p.category = m.product_category AND
    p.price = m.product_price
JOIN dim_stores st ON 
    st.name = m.store_name AND
    st.location = m.store_location AND
    st.email = m.store_email; 