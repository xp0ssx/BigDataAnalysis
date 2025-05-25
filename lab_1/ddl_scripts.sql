-- DDL скрипты для создания таблиц фактов и измерений

-- Удаление существующих таблиц, если они есть
DROP TABLE IF EXISTS fact_sales CASCADE;
DROP TABLE IF EXISTS dim_customer_pets CASCADE;
DROP TABLE IF EXISTS dim_products CASCADE;
DROP TABLE IF EXISTS dim_customers CASCADE;
DROP TABLE IF EXISTS dim_sellers CASCADE;
DROP TABLE IF EXISTS dim_stores CASCADE;
DROP TABLE IF EXISTS dim_suppliers CASCADE;

-- Создание таблиц измерений (dimensions)

-- Измерение: Покупатели (Customers)
CREATE TABLE dim_customers (
    customer_id SERIAL PRIMARY KEY,
    first_name VARCHAR(255),
    last_name VARCHAR(255),
    age INTEGER,
    email VARCHAR(255),
    country VARCHAR(255),
    postal_code VARCHAR(20)
);

-- Измерение: Питомцы покупателей (Customer Pets)
CREATE TABLE dim_customer_pets (
    pet_id SERIAL PRIMARY KEY,
    customer_id INTEGER REFERENCES dim_customers(customer_id),
    pet_type VARCHAR(50),
    pet_name VARCHAR(255),
    pet_breed VARCHAR(255)
);

-- Измерение: Продавцы (Sellers)
CREATE TABLE dim_sellers (
    seller_id SERIAL PRIMARY KEY,
    first_name VARCHAR(255),
    last_name VARCHAR(255),
    email VARCHAR(255),
    country VARCHAR(255),
    postal_code VARCHAR(20)
);

-- Измерение: Магазины (Stores)
CREATE TABLE dim_stores (
    store_id SERIAL PRIMARY KEY,
    name VARCHAR(255),
    location VARCHAR(255),
    city VARCHAR(255),
    state VARCHAR(255),
    country VARCHAR(255),
    phone VARCHAR(20),
    email VARCHAR(255)
);

-- Измерение: Поставщики (Suppliers)
CREATE TABLE dim_suppliers (
    supplier_id SERIAL PRIMARY KEY,
    name VARCHAR(255),
    contact VARCHAR(255),
    email VARCHAR(255),
    phone VARCHAR(20),
    address VARCHAR(255),
    city VARCHAR(255),
    country VARCHAR(255)
);

-- Измерение: Продукты (Products)
CREATE TABLE dim_products (
    product_id SERIAL PRIMARY KEY,
    name VARCHAR(255),
    category VARCHAR(50),
    price DECIMAL(10,2),
    weight DECIMAL(10,1),
    color VARCHAR(50),
    size VARCHAR(20),
    brand VARCHAR(255),
    material VARCHAR(50),
    description TEXT,
    rating DECIMAL(2,1),
    reviews INTEGER,
    release_date DATE,
    expiry_date DATE,
    supplier_id INTEGER REFERENCES dim_suppliers(supplier_id)
);

-- Создание таблицы фактов (facts)

-- Факты: Продажи (Sales)
CREATE TABLE fact_sales (
    sale_id SERIAL PRIMARY KEY,
    customer_id INTEGER REFERENCES dim_customers(customer_id),
    seller_id INTEGER REFERENCES dim_sellers(seller_id),
    product_id INTEGER REFERENCES dim_products(product_id),
    store_id INTEGER REFERENCES dim_stores(store_id),
    sale_date DATE,
    quantity INTEGER,
    total_price DECIMAL(10,2),
    original_file_id INTEGER,
    original_id INTEGER
);

-- Создание индексов для оптимизации запросов
CREATE INDEX idx_fact_sales_date ON fact_sales(sale_date);
CREATE INDEX idx_fact_sales_customer ON fact_sales(customer_id);
CREATE INDEX idx_fact_sales_product ON fact_sales(product_id);
CREATE INDEX idx_fact_sales_seller ON fact_sales(seller_id);
CREATE INDEX idx_fact_sales_store ON fact_sales(store_id);
CREATE INDEX idx_products_supplier ON dim_products(supplier_id);
CREATE INDEX idx_customer_pets_customer ON dim_customer_pets(customer_id); 