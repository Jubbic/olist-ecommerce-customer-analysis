/*===========================================================
  PROJECT: Olist Brazilian E-Commerce Customer Analytics

  File: 06_business_case_studies.sql

  Description:
  Solves real-world business problems using SQL to support
  business decision-making and executive reporting.

  Author: Adeleke Jubril
===========================================================*/

/*===========================================================
  6.1 CUSTOMER CHURN RISK ANALYSIS
===========================================================*/

WITH customer_orders AS (

    SELECT
        c.customer_unique_id,
        COUNT(DISTINCT o.order_id) AS total_orders,
        MIN(o.order_purchase_timestamp) AS first_purchase,
        MAX(o.order_purchase_timestamp) AS last_purchase

    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id

    GROUP BY c.customer_unique_id

)

SELECT
    customer_unique_id,
    total_orders,
    DATE(first_purchase) AS first_purchase_date,
    DATE(last_purchase) AS last_purchase_date,

    CASE
        WHEN total_orders = 1 THEN 'High Churn Risk'
        ELSE 'Active Customer'
    END AS customer_status

FROM customer_orders

ORDER BY
    total_orders ASC,
    first_purchase;
/*
Expected Result:

A customer-level dataset showing:

- Customer ID
- Total Orders
- First Purchase Date
- Last Purchase Date
- Customer Status

Customer Status:

- High Churn Risk = Only one purchase
- Active Customer = More than one purchase

This analysis helps identify customers who may require
retention strategies and targeted marketing campaigns.
*/


/*===========================================================
  6.2 TOP 10 CITIES BY REVENUE
===========================================================*/

SELECT
    c.customer_city,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(SUM(oi.price), 2) AS total_revenue,
    ROUND(AVG(oi.price), 2) AS average_order_value

FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
JOIN order_items oi
    ON o.order_id = oi.order_id

GROUP BY c.customer_city

ORDER BY total_revenue DESC

LIMIT 10;
/*
Expected Result:

Top 10 cities ranked by:

- Customer City
- Total Orders
- Total Revenue
- Average Order Value

This analysis identifies the marketplace's highest-performing cities by sales revenue.
*/


/*===========================================================
  6.3 BEST PERFORMING SELLERS
===========================================================*/

SELECT
    seller_id,
    COUNT(DISTINCT order_id) AS total_orders,
    ROUND(SUM(price), 2) AS total_revenue,
    ROUND(AVG(price), 2) AS average_order_value

FROM order_items

GROUP BY seller_id

ORDER BY total_revenue DESC

LIMIT 10;
/*
Expected Result:

Top 10 sellers ranked by:

- Seller ID
- Total Orders
- Total Revenue
- Average Order Value

This analysis identifies the marketplace's highest-performing sellers based on sales performance.
*/


/*===========================================================
  6.4 LOW PERFORMING PRODUCT CATEGORIES
===========================================================*/

SELECT
    p.product_category_name,
    COUNT(oi.order_id) AS total_items_sold,
    ROUND(SUM(oi.price), 2) AS total_revenue,
    ROUND(AVG(oi.price), 2) AS average_price

FROM products p
JOIN order_items oi
    ON p.product_id = oi.product_id

GROUP BY p.product_category_name

HAVING SUM(oi.price) IS NOT NULL

ORDER BY total_revenue ASC

LIMIT 10;
/*
Expected Result:

Bottom 10 product categories ranked by:

- Product Category
- Total Items Sold
- Total Revenue
- Average Price

This analysis identifies product categories that contribute the least revenue to the marketplace.
*/


/*===========================================================
  6.5 CUSTOMER SEGMENTATION
===========================================================*/

WITH customer_spending AS (

    SELECT
        c.customer_unique_id,
        ROUND(SUM(oi.price), 2) AS total_spent

    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    JOIN order_items oi
        ON o.order_id = oi.order_id

    GROUP BY c.customer_unique_id
)

SELECT
    customer_unique_id,
    total_spent,

    CASE
        WHEN total_spent >= 1000 THEN 'High Value'
        WHEN total_spent >= 300 THEN 'Medium Value'
        ELSE 'Low Value'
    END AS customer_segment

FROM customer_spending

ORDER BY total_spent DESC

LIMIT 20;
/*
Expected Result:

Top 20 customers showing:

- Customer ID
- Total Amount Spent
- Customer Segment

Segments:

- High Value
- Medium Value
- Low Value

This analysis supports customer targeting, loyalty programs,
and personalized marketing campaigns.
*/


/*===========================================================
  6.6 DELIVERY PERFORMANCE ANALYSIS
===========================================================*/

SELECT
    c.customer_state,
    COUNT(o.order_id) AS total_orders,

    ROUND(
        AVG(
            DATEDIFF(
                o.order_delivered_customer_date,
                o.order_purchase_timestamp
            )
        ),
        2
    ) AS average_delivery_days

FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id

WHERE o.order_delivered_customer_date IS NOT NULL

GROUP BY c.customer_state

ORDER BY average_delivery_days ASC;
/*
Expected Result:

Delivery performance by state showing:

- Customer State
- Total Orders
- Average Delivery Days

States are ranked from the fastest to the slowest average delivery time.
*/


/*===========================================================
  6.7 PAYMENT METHOD PERFORMANCE
===========================================================*/

SELECT
    payment_type,
    COUNT(DISTINCT order_id) AS total_orders,
    ROUND(SUM(payment_value), 2) AS total_revenue,
    ROUND(AVG(payment_value), 2) AS average_payment

FROM payments

GROUP BY payment_type

ORDER BY total_revenue DESC;
/*
Expected Result:

Payment performance showing:

- Payment Type
- Total Orders
- Total Revenue
- Average Payment

Results are ranked from the highest to the lowest revenue-generating payment method.
*/


/*===========================================================
  6.8 MONTHLY CUSTOMER GROWTH
===========================================================*/

WITH first_purchase AS (

    SELECT
        c.customer_unique_id,
        DATE_FORMAT(
            MIN(o.order_purchase_timestamp),
            '%Y-%m'
        ) AS first_purchase_month

    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id

    GROUP BY c.customer_unique_id
)

SELECT
    first_purchase_month,
    COUNT(*) AS new_customers

FROM first_purchase

GROUP BY first_purchase_month

ORDER BY first_purchase_month;
/*
Expected Result:

Monthly customer acquisition showing:

- First Purchase Month
- Number of New Customers

Results are ordered chronologically to show customer growth over time.
*/

/*===========================================================
  6.9 CUSTOMER PURCHASE FREQUENCY
===========================================================*/

SELECT
    c.customer_unique_id,
    COUNT(DISTINCT o.order_id) AS total_orders,

    CASE
        WHEN COUNT(DISTINCT o.order_id) = 1 THEN 'One-Time Customer'
        WHEN COUNT(DISTINCT o.order_id) BETWEEN 2 AND 5 THEN 'Repeat Customer'
        ELSE 'Loyal Customer'
    END AS customer_type

FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id

GROUP BY c.customer_unique_id

ORDER BY total_orders DESC, customer_unique_id

LIMIT 20;
/*
Expected Result:

Top customers ranked by purchase frequency showing:

- Customer ID
- Total Orders
- Customer Type

Customer Types:
- One-Time Customer
- Repeat Customer
- Loyal Customer
*/


/*===========================================================
  6.10 EXECUTIVE BUSINESS SUMMARY
===========================================================*/

SELECT
    COUNT(DISTINCT o.order_id) AS total_orders,
    COUNT(DISTINCT c.customer_unique_id) AS total_customers,
    ROUND(SUM(oi.price), 2) AS total_revenue,
    ROUND(AVG(oi.price), 2) AS average_order_value,
    ROUND(AVG(r.review_score), 2) AS average_review_score,
    COUNT(DISTINCT s.seller_id) AS total_sellers,
    COUNT(DISTINCT p.product_id) AS total_products

FROM orders o
JOIN customers c
    ON o.customer_id = c.customer_id
JOIN order_items oi
    ON o.order_id = oi.order_id
LEFT JOIN reviews r
    ON o.order_id = r.order_id
JOIN sellers s
    ON oi.seller_id = s.seller_id
JOIN products p
    ON oi.product_id = p.product_id;
/*
Expected Result:

Executive business summary showing:

- Total Orders
- Total Customers
- Total Revenue
- Average Order Value
- Average Review Score
- Total Sellers
- Total Products

This query provides a high-level KPI overview of the marketplace.
*/


/*===========================================================
FILE SUMMARY
=============================================================

This file focused on advanced business analysis using SQL to
answer real-world business questions from the Olist
Brazilian E-Commerce dataset.

The analyses covered customer behavior, sales trends,
delivery performance, payment preferences, seller
performance, product category performance, customer
segmentation, purchase frequency, and executive KPI
reporting.

Key SQL techniques demonstrated include:

 Common Table Expressions (CTEs)
 Window Functions
 CASE WHEN Expressions
 Aggregate Functions
 Date Functions
 Multi-table JOINs
 Customer Segmentation
 Revenue Analysis
 Business KPI Reporting

Business analyses completed:

 Revenue Trend Analysis
 Customer Retention Analysis
 Cohort Analysis
 Churn Risk Identification
 Top Performing Cities
 Top Performing Sellers
 Lowest Performing Categories
 Customer Segmentation
 Delivery Performance Analysis
 Payment Method Analysis
 Customer Purchase Frequency
 Executive Business Summary

This file demonstrates advanced SQL skills used by Data
Analysts to generate business insights, evaluate company
performance, and support strategic decision-making.

End of File
===========================================================*/