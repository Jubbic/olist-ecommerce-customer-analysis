/*==============================================================================
  PROJECT: Olist Brazilian E-Commerce Customer Analytics
  FILE: 03_data_quality_checks.sql

  DESCRIPTION:
  This script validates the quality of data before business analysis.
  The checks identify missing values, duplicate records, invalid values,
  and data inconsistencies that could affect reporting and decision-making.

==============================================================================*/

USE olist_ecommerce;

/*===========================================================
  3.1 RECORD COUNT
===========================================================*/

SELECT 'customers' AS table_name, COUNT(*) AS total_records
FROM customers

UNION ALL

SELECT 'geolocation', COUNT(*)
FROM geolocation

UNION ALL

SELECT 'order_items', COUNT(*)
FROM order_items

UNION ALL

SELECT 'payments', COUNT(*)
FROM payments

UNION ALL

SELECT 'reviews', COUNT(*)
FROM reviews

UNION ALL

SELECT 'orders', COUNT(*)
FROM orders

UNION ALL

SELECT 'products', COUNT(*)
FROM products

UNION ALL

SELECT 'sellers', COUNT(*)
FROM sellers

UNION ALL

SELECT 'category_translation', COUNT(*)
FROM category_translation;

/*===========================================================
  3.2 MISSING VALUES - CUSTOMERS
===========================================================*/

SELECT
    SUM(customer_id IS NULL) AS customer_id_nulls,
    SUM(customer_unique_id IS NULL) AS customer_unique_id_nulls,
    SUM(customer_zip_code_prefix IS NULL) AS zip_code_nulls,
    SUM(customer_city IS NULL) AS city_nulls,
    SUM(customer_state IS NULL) AS state_nulls
FROM customers;

/*===========================================================
  3.3 MISSING VALUES - ORDERS
===========================================================*/

SELECT
    SUM(order_id IS NULL) AS order_id_nulls,
    SUM(customer_id IS NULL) AS customer_id_nulls,
    SUM(order_status IS NULL) AS status_nulls,
    SUM(order_purchase_timestamp IS NULL) AS purchase_date_nulls,
    SUM(order_approved_at IS NULL) AS approved_date_nulls,
    SUM(order_delivered_carrier_date IS NULL) AS carrier_date_nulls,
    SUM(order_delivered_customer_date IS NULL) AS delivered_date_nulls,
    SUM(order_estimated_delivery_date IS NULL) AS estimated_delivery_nulls
FROM orders;

/*===========================================================
  3.4 MISSING VALUES - PRODUCTS
===========================================================*/

SELECT
    SUM(product_id IS NULL) AS product_id_nulls,
    SUM(product_category_name IS NULL) AS category_nulls,
    SUM(product_name_lenght IS NULL) AS product_name_length_nulls,
    SUM(product_description_lenght IS NULL) AS description_length_nulls,
    SUM(product_photos_qty IS NULL) AS photos_nulls,
    SUM(product_weight_g IS NULL) AS weight_nulls,
    SUM(product_length_cm IS NULL) AS length_nulls,
    SUM(product_height_cm IS NULL) AS height_nulls,
    SUM(product_width_cm IS NULL) AS width_nulls
FROM products;

/*===========================================================
  3.5 DUPLICATE CHECK - CUSTOMERS
===========================================================*/

SELECT
    customer_id,
    COUNT(*) AS duplicate_count
FROM customers
GROUP BY customer_id
HAVING COUNT(*) > 1;

/*===========================================================
  3.6 DUPLICATE CHECK - ORDERS
===========================================================*/

SELECT
    order_id,
    COUNT(*) AS duplicate_count
FROM orders
GROUP BY order_id
HAVING COUNT(*) > 1;

/*===========================================================
  3.7 DUPLICATE CHECK - PRODUCTS
===========================================================*/

SELECT
    product_id,
    COUNT(*) AS duplicate_count
FROM products
GROUP BY product_id
HAVING COUNT(*) > 1;

/*===========================================================
  3.8 DUPLICATE CHECK - SELLERS
===========================================================*/

SELECT
    seller_id,
    COUNT(*) AS duplicate_count
FROM sellers
GROUP BY seller_id
HAVING COUNT(*) > 1;

/*===========================================================
  3.9 DUPLICATE CHECK - PAYMENTS
===========================================================*/

SELECT
    order_id,
    payment_sequential,
    COUNT(*) AS duplicate_count
FROM payments
GROUP BY order_id, payment_sequential
HAVING COUNT(*) > 1;

/*===========================================================
  3.10 DUPLICATE CHECK - REVIEWS
===========================================================*/

SELECT
    review_id,
    COUNT(*) AS duplicate_count
FROM reviews
GROUP BY review_id
HAVING COUNT(*) > 1;

SELECT *
FROM reviews
LIMIT 5;

/*===========================================================
  4.1 REFERENTIAL INTEGRITY
  ORDERS → CUSTOMERS
===========================================================*/

SELECT
    o.order_id,
    o.customer_id
FROM orders o
LEFT JOIN customers c
    ON o.customer_id = c.customer_id
WHERE c.customer_id IS NULL;

/*===========================================================
  4.2 REFERENTIAL INTEGRITY
  ORDER_ITEMS → ORDERS
===========================================================*/

SELECT
    oi.order_id
FROM order_items oi
LEFT JOIN orders o
    ON oi.order_id = o.order_id
WHERE o.order_id IS NULL;

/*===========================================================
  4.3 REFERENTIAL INTEGRITY
  ORDER_ITEMS → PRODUCTS
===========================================================*/

SELECT
    oi.product_id
FROM order_items oi
LEFT JOIN products p
    ON oi.product_id = p.product_id
WHERE p.product_id IS NULL;

/*===========================================================
  4.4 REFERENTIAL INTEGRITY
  ORDER_ITEMS → SELLERS
===========================================================*/

SELECT
    oi.seller_id
FROM order_items oi
LEFT JOIN sellers s
    ON oi.seller_id = s.seller_id
WHERE s.seller_id IS NULL;

/*===========================================================
  5.1 BUSINESS RULE VALIDATION
  CHECK FOR INVALID PRODUCT PRICES
===========================================================*/

SELECT *
FROM order_items
WHERE price <= 0;

/*===========================================================
  5.2 BUSINESS RULE VALIDATION
===========================================================*/

SELECT *
FROM order_items
WHERE freight_value < 0;

/*===========================================================
  5.3 BUSINESS RULE VALIDATION
  CHECK FOR NEGATIVE PAYMENT VALUES
===========================================================*/

SELECT *
FROM payments
WHERE payment_value < 0;


/*===========================================================
  5.4 BUSINESS RULE VALIDATION
===========================================================*/

SELECT *
FROM reviews
WHERE review_score NOT BETWEEN 1 AND 5;

/*===========================================================
  5.5 DATA CLEANING
  REMOVE HIDDEN CARRIAGE RETURN CHARACTERS
===========================================================*/

-- Verify hidden carriage return characters

SELECT
    product_category_name_english,
    HEX(product_category_name_english)
FROM category_translation
WHERE product_category_name_english LIKE '%health%';

-- Remove hidden carriage return characters

UPDATE category_translation
SET product_category_name_english =
    TRIM(REPLACE(product_category_name_english, CHAR(13), ''));

-- Verify the cleanup

SELECT
    product_category_name_english,
    HEX(product_category_name_english)
FROM category_translation
WHERE product_category_name_english LIKE '%health%';




/*==============================================================================
DATA QUALITY SUMMARY

  Record counts verified for all tables.

  Customers table contains no missing values.

  Orders table contains no missing values.

  Products table contains no missing values.

  No duplicate records found in:
     customers
     orders
     products
	 sellers
     payments

  Review IDs appear multiple times. Investigation confirmed this is an expected
  characteristic of the Olist dataset and not an accidental duplication.

  Referential integrity checks passed:
     Orders → Customers
     Order Items → Orders
     Order Items → Products
     Order Items → Sellers

  Business rule validation passed:
     No invalid product prices.
     No negative freight values.
     No negative payment values.
     Review scores are within the valid range (1–5).

  Nine payment records had a payment value of 0.00.
  These were investigated and confirmed to be valid business cases
  associated with voucher and not_defined payment types.

DATA QUALITY STATUS:
READY FOR BUSINESS ANALYSIS
==============================================================================*/