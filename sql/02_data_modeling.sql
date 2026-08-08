-- ==========================================
-- OLIST SQL CUSTOMER ANALYTICS PROJECT
-- File: 02_data_modeling.sql
-- Purpose: Add Primary Keys, Foreign Keys,
--          and Indexes

-- Author: Adeleke Jubril
-- ==========================================

USE olist_ecommerce;

-- ==================================================
-- STEP 1: ADD PRIMARY KEYS
-- ==================================================

ALTER TABLE customers
ADD PRIMARY KEY (customer_id);

ALTER TABLE orders
ADD PRIMARY KEY (order_id);

ALTER TABLE products
ADD PRIMARY KEY (product_id);

ALTER TABLE sellers
ADD PRIMARY KEY (seller_id);

ALTER TABLE payments
ADD PRIMARY KEY (order_id, payment_sequential);

ALTER TABLE reviews
ADD PRIMARY KEY (review_id);

/* Added later during troubleshooting */
ALTER TABLE category_translation
ADD PRIMARY KEY (product_category_name);

-- ==================================================
-- STEP 2: CREATE INDEXES
-- ==================================================

CREATE INDEX idx_orders_customer
ON orders(customer_id);

CREATE INDEX idx_orderitems_order
ON order_items(order_id);

CREATE INDEX idx_orderitems_product
ON order_items(product_id);

CREATE INDEX idx_orderitems_seller
ON order_items(seller_id);

CREATE INDEX idx_payments_order
ON payments(order_id);

CREATE INDEX idx_reviews_order
ON reviews(order_id);

CREATE INDEX idx_products_category
ON products(product_category_name);

-- ================================================== 
-- STEP 3: STANDARDIZE COLUMN TYPES
-- ================================================== 

-- Fixed during troubleshooting 

ALTER TABLE customers
MODIFY customer_id VARCHAR(32) NOT NULL;


-- ==================================================
-- STEP 4: CREATE FOREIGN KEYS
-- ==================================================

-- Orders → Customers
ALTER TABLE orders
ADD CONSTRAINT fk_orders_customers
FOREIGN KEY (customer_id)
REFERENCES customers(customer_id);

-- Order Items → Orders
ALTER TABLE order_items
ADD CONSTRAINT fk_orderitems_orders
FOREIGN KEY (order_id)
REFERENCES orders(order_id);

-- Order Items → Products
ALTER TABLE order_items
ADD CONSTRAINT fk_orderitems_products
FOREIGN KEY (product_id)
REFERENCES products(product_id);

-- Order Items → Sellers
ALTER TABLE order_items
ADD CONSTRAINT fk_orderitems_sellers
FOREIGN KEY (seller_id)
REFERENCES sellers(seller_id);

-- Payments → Orders
ALTER TABLE payments
ADD CONSTRAINT fk_payments_orders
FOREIGN KEY (order_id)
REFERENCES orders(order_id);

-- Reviews → Orders
ALTER TABLE reviews
ADD CONSTRAINT fk_reviews_orders
FOREIGN KEY (order_id)
REFERENCES orders(order_id);

-- Products → Category Translation

-- NOTE:
-- This relationship could not be created because some product_category_name values 
-- exist in products but do not exist in category_translation

-- This will be resolved in 03_data_quality_checks.sql before creating the foreign key.

-- ==================================================
-- STEP 5: VERIFY FOREIGN KEYS
-- ==================================================

SELECT
    TABLE_NAME,
    COLUMN_NAME,
    CONSTRAINT_NAME,
    REFERENCED_TABLE_NAME,
    REFERENCED_COLUMN_NAME
FROM information_schema.KEY_COLUMN_USAGE
WHERE TABLE_SCHEMA = 'olist_ecommerce'
AND REFERENCED_TABLE_NAME IS NOT NULL
ORDER BY TABLE_NAME;


-- ==================================================
-- FILE STATUS
-- ====================================================

/*==================================================
 FILE STATUS
====================================================

File Name: 02_data_modeling.sql

Status: Completed

Relationships Successfully Created:
 Order Items → Orders
 Order Items → Products
 Order Items → Sellers
 Payments → Orders

Relationships Verified Logically:
 Orders → Customers
 Reviews → Orders
 Products → Category Translation

See PROJECT_DOCUMENTATION.md
for implementation notes.
==================================================*/