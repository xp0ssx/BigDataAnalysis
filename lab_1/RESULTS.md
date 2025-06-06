# Результаты трансформации данных в снежинкообразную схему

## Подготовка и запуск окружения

1. Запуск контейнера с PostgreSQL:
```bash
# Запуск контейнера
docker-compose up -d


# Проверить статус можно командой:
docker ps

```

## Порядок выполнения скриптов
1. Подключаемся к базе данных(Пароль:password):
```bash
psql -h localhost -p 5432 -U postgres -d pet_store
```

2. Создание структуры таблиц (DDL):
```sql
\i ddl_scripts.sql
```
Создаст все необходимые таблицы измерений и фактов, а также индексы.

3. Заполнение данными (DML):
```sql
\i dml_scripts.sql
```
Загрузит данные из исходной таблицы в структуру снежинки.

4. Проверка результатов:
```sql
\i verification_scripts.sql
```
Выполнит комплексную проверку данных.

## Результаты трансформации

### 1. Количество записей в таблицах
```
    table_name     | count 
-------------------+-------
 dim_customer_pets | 10000
 dim_customers     | 10000
 dim_products      | 10000
 dim_sellers       | 10000
 dim_stores        | 10000
 dim_suppliers     | 10000
 fact_sales        | 10000
 mock_data         | 10000
```
Все таблицы содержат корректное количество записей.

### 2. Целостность данных
Проверка показала отсутствие проблем с целостностью данных:
- Нет "сирот" в связях между таблицами
- Все внешние ключи корректно связаны

### 3. Уникальность ключевых полей
```
        check_type         | duplicates 
---------------------------+------------
 Duplicate customer emails |          0
 Duplicate seller emails   |          0
 Duplicate store emails    |          0
 Duplicate supplier emails |          0
```
Все ключевые поля уникальны, дубликатов нет.

### 4. Распределение данных

#### Топ-5 стран по количеству покупателей:
```
       analysis       |   country   | count 
----------------------+-------------+-------
 Customers by country | China       |  1738
 Customers by country | Indonesia   |  1174
 Customers by country | Russia      |   628
 Customers by country | Philippines |   555
 Customers by country | Brazil      |   385
```

#### Распределение по категориям товаров:
```
       analysis       | category | count 
----------------------+----------+-------
 Products by category | Toy      |  3406
 Products by category | Cage     |  3327
 Products by category | Food     |  3267
```

#### Статистика продаж по месяцам:
```
    analysis    |         month          | sales_count | total_amount 
----------------+------------------------+-------------+--------------
 Sales by month | 2021-01-01 00:00:00+00 |         874 |    224158.54
 Sales by month | 2021-02-01 00:00:00+00 |         739 |    192348.31
 Sales by month | 2021-03-01 00:00:00+00 |         843 |    207282.20
 Sales by month | 2021-04-01 00:00:00+00 |         837 |    206592.82
 Sales by month | 2021-05-01 00:00:00+00 |         828 |    211764.86
```

## Структура полученной схемы

1. **Таблицы измерений**:
   - `dim_customers` - информация о покупателях
   - `dim_customer_pets` - информация о питомцах покупателей
   - `dim_sellers` - информация о продавцах
   - `dim_stores` - информация о магазинах
   - `dim_suppliers` - информация о поставщиках
   - `dim_products` - информация о продуктах

2. **Таблица фактов**:
   - `fact_sales` - информация о продажах, связывающая все измерения

3. **Индексы**:
   - Созданы индексы для всех внешних ключей
   - Оптимизированы запросы по датам продаж

## Заключение

Трансформация данных выполнена успешно:
- Данные корректно распределены по таблицам измерений
- Сохранена целостность данных
- Обеспечена уникальность ключевых полей
- Создана эффективная структура для аналитических запросов 