-- Скрипты проверки результатов трансформации данных

-- 1. Проверка количества записей в каждой таблице
SELECT 'mock_data' as table_name, COUNT(*) as count FROM mock_data
UNION ALL
SELECT 'dim_customers', COUNT(*) FROM dim_customers
UNION ALL
SELECT 'dim_customer_pets', COUNT(*) FROM dim_customer_pets
UNION ALL
SELECT 'dim_sellers', COUNT(*) FROM dim_sellers
UNION ALL
SELECT 'dim_stores', COUNT(*) FROM dim_stores
UNION ALL
SELECT 'dim_suppliers', COUNT(*) FROM dim_suppliers
UNION ALL
SELECT 'dim_products', COUNT(*) FROM dim_products
UNION ALL
SELECT 'fact_sales', COUNT(*) FROM fact_sales
ORDER BY table_name;

-- 2. Проверка целостности связей между таблицами
WITH integrity_check AS (
    -- Проверка связей питомцев с покупателями
    SELECT 'Pets without customers' as check_type, COUNT(*) as issues
    FROM dim_customer_pets p
    LEFT JOIN dim_customers c ON p.customer_id = c.customer_id
    WHERE c.customer_id IS NULL
    
    UNION ALL
    
    -- Проверка связей продуктов с поставщиками
    SELECT 'Products without suppliers', COUNT(*)
    FROM dim_products p
    LEFT JOIN dim_suppliers s ON p.supplier_id = s.supplier_id
    WHERE s.supplier_id IS NULL
    
    UNION ALL
    
    -- Проверка связей в таблице фактов
    SELECT 'Sales without customers', COUNT(*)
    FROM fact_sales f
    LEFT JOIN dim_customers c ON f.customer_id = c.customer_id
    WHERE c.customer_id IS NULL
    
    UNION ALL
    
    SELECT 'Sales without sellers', COUNT(*)
    FROM fact_sales f
    LEFT JOIN dim_sellers s ON f.seller_id = s.seller_id
    WHERE s.seller_id IS NULL
    
    UNION ALL
    
    SELECT 'Sales without products', COUNT(*)
    FROM fact_sales f
    LEFT JOIN dim_products p ON f.product_id = p.product_id
    WHERE p.product_id IS NULL
    
    UNION ALL
    
    SELECT 'Sales without stores', COUNT(*)
    FROM fact_sales f
    LEFT JOIN dim_stores s ON f.store_id = s.store_id
    WHERE s.store_id IS NULL
)
SELECT * FROM integrity_check WHERE issues > 0;

-- 3. Проверка уникальности ключевых бизнес-идентификаторов
SELECT 'Duplicate customer emails' as check_type, COUNT(*) as duplicates
FROM (
    SELECT email, COUNT(*) as cnt
    FROM dim_customers
    GROUP BY email
    HAVING COUNT(*) > 1
) t
UNION ALL
SELECT 'Duplicate seller emails', COUNT(*)
FROM (
    SELECT email, COUNT(*) as cnt
    FROM dim_sellers
    GROUP BY email
    HAVING COUNT(*) > 1
) t
UNION ALL
SELECT 'Duplicate store emails', COUNT(*)
FROM (
    SELECT email, COUNT(*) as cnt
    FROM dim_stores
    GROUP BY email
    HAVING COUNT(*) > 1
) t
UNION ALL
SELECT 'Duplicate supplier emails', COUNT(*)
FROM (
    SELECT email, COUNT(*) as cnt
    FROM dim_suppliers
    GROUP BY email
    HAVING COUNT(*) > 1
) t;

-- 4. Проверка соответствия данных источнику
WITH source_check AS (
    -- Проверка общих сумм продаж
    SELECT 
        'Total sales amount match' as check_type,
        ABS(SUM(m.sale_total_price) - SUM(f.total_price)) as difference
    FROM mock_data m
    FULL OUTER JOIN fact_sales f ON m.file_id = f.original_file_id 
        AND m.original_id = f.original_id
    
    UNION ALL
    
    -- Проверка количества уникальных покупателей
    SELECT 
        'Customer count match',
        ABS(COUNT(DISTINCT m.customer_email) - COUNT(DISTINCT c.email))
    FROM mock_data m
    CROSS JOIN dim_customers c
    GROUP BY ()
    
    UNION ALL
    
    -- Проверка количества уникальных продавцов
    SELECT 
        'Seller count match',
        ABS(COUNT(DISTINCT m.seller_email) - COUNT(DISTINCT s.email))
    FROM mock_data m
    CROSS JOIN dim_sellers s
    GROUP BY ()
)
SELECT * FROM source_check WHERE difference > 0;

-- 5. Статистика по измерениям
SELECT 'Customers by country' as analysis, country, COUNT(*) as count
FROM dim_customers
GROUP BY country
ORDER BY count DESC
LIMIT 5;

SELECT 'Products by category' as analysis, category, COUNT(*) as count
FROM dim_products
GROUP BY category
ORDER BY count DESC
LIMIT 5;

SELECT 'Stores by country' as analysis, country, COUNT(*) as count
FROM dim_stores
GROUP BY country
ORDER BY count DESC
LIMIT 5;

-- 6. Проверка временных характеристик продаж
SELECT 
    'Sales by month' as analysis,
    DATE_TRUNC('month', sale_date) as month,
    COUNT(*) as sales_count,
    SUM(total_price) as total_amount
FROM fact_sales
GROUP BY DATE_TRUNC('month', sale_date)
ORDER BY month
LIMIT 5; 