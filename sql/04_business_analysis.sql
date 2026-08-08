/*==============================================================================
  PROJECT: Olist Brazilian E-Commerce Customer Analytics
  FILE: 04_business_analysis.sql

  DESCRIPTION:
  Business analysis queries for sales, customers, products,
  sellers, payments and delivery performance.

  AUTHOR: Adeleke Jubril
==============================================================================*/


/*===========================================================
  PHASE 1
  SALES PERFORMANCE ANALYSIS
===========================================================*/


/*===========================================================
  4.1 OVERALL BUSINESS PERFORMANCE
===========================================================*/

SELECT
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(SUM(oi.price), 2) AS total_revenue,
    COUNT(DISTINCT o.customer_id) AS total_customers,
    ROUND(SUM(oi.price) / COUNT(DISTINCT o.order_id), 2) AS average_order_value
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id;
    
    
/*===========================================================
  4.2 MONTHLY SALES TREND
===========================================================*/

SELECT
    DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m') AS order_month,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(SUM(oi.price), 2) AS total_revenue
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
GROUP BY DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m')
ORDER BY order_month;


/*===========================================================
  4.3 TOP 10 PRODUCT CATEGORIES BY REVENUE
===========================================================*/

SELECT
    ct.product_category_name_english AS product_category,
    ROUND(SUM(oi.price), 2) AS total_revenue,
    COUNT(DISTINCT oi.order_id) AS total_orders
FROM order_items oi
JOIN products p
    ON oi.product_id = p.product_id
JOIN category_translation ct
    ON p.product_category_name = ct.product_category_name
GROUP BY ct.product_category_name_english
ORDER BY total_revenue DESC
LIMIT 10;


/*===========================================================
  4.4 TOP 10 BEST-SELLING PRODUCTS
===========================================================*/

SELECT
    oi.product_id,
    COUNT(*) AS units_sold,
    ROUND(SUM(oi.price), 2) AS total_revenue
FROM order_items oi
GROUP BY oi.product_id
ORDER BY units_sold DESC, total_revenue DESC
LIMIT 10;

/*===========================================================
  4.5 TOP 10 CUSTOMERS BY SPENDING
===========================================================*/

SELECT
    c.customer_unique_id,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(SUM(oi.price), 2) AS total_spent
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
JOIN order_items oi
    ON o.order_id = oi.order_id
GROUP BY c.customer_unique_id
ORDER BY total_spent DESC
LIMIT 10;


/*===========================================================
  4.6 TOP 10 SELLERS BY REVENUE
===========================================================*/

SELECT
    oi.seller_id,
    COUNT(DISTINCT oi.order_id) AS total_orders,
    ROUND(SUM(oi.price), 2) AS total_revenue,
    ROUND(AVG(oi.price), 2) AS average_order_value
FROM order_items oi
GROUP BY oi.seller_id
ORDER BY total_revenue DESC
LIMIT 10;

/*===========================================================
  4.7 DELIVERY PERFORMANCE ANALYSIS
===========================================================*/

SELECT
    ROUND(AVG(DATEDIFF(order_delivered_customer_date,
                       order_purchase_timestamp)), 2) AS average_delivery_days,

    MIN(DATEDIFF(order_delivered_customer_date,
                 order_purchase_timestamp)) AS fastest_delivery_days,

    MAX(DATEDIFF(order_delivered_customer_date,
                 order_purchase_timestamp)) AS slowest_delivery_days

FROM orders
WHERE order_delivered_customer_date IS NOT NULL;


/*===========================================================
  4.8 REVENUE BY CUSTOMER STATE
===========================================================*/

SELECT
    c.customer_state,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(SUM(oi.price), 2) AS total_revenue
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
JOIN order_items oi
    ON o.order_id = oi.order_id
GROUP BY c.customer_state
ORDER BY total_revenue DESC;


/*===========================================================
  4.9 PAYMENT METHOD ANALYSIS
===========================================================*/

SELECT
    p.payment_type,
    COUNT(DISTINCT p.order_id) AS total_orders,
    ROUND(SUM(p.payment_value), 2) AS total_payment_value,
    ROUND(AVG(p.payment_value), 2) AS average_payment_value
FROM payments p
GROUP BY p.payment_type
ORDER BY total_payment_value DESC;

/*===========================================================
  4.10 CUSTOMER REVIEW ANALYSIS
===========================================================*/

SELECT
    review_score,
    COUNT(*) AS total_reviews,
    ROUND(
        COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (),
        2
    ) AS percentage_of_reviews
FROM reviews
GROUP BY review_score
ORDER BY review_score;


/*===========================================================
  4.11 DELIVERY TIME VS CUSTOMER REVIEW SCORE
===========================================================*/

SELECT
    r.review_score,
    ROUND(
        AVG(
            DATEDIFF(
                o.order_delivered_customer_date,
                o.order_purchase_timestamp
            )
        ),
        2
    ) AS average_delivery_days,
    COUNT(*) AS total_reviews
FROM reviews r
JOIN orders o
    ON r.order_id = o.order_id
WHERE o.order_delivered_customer_date IS NOT NULL
GROUP BY r.review_score
ORDER BY r.review_score;


/*===========================================================
  4.12 REPEAT CUSTOMER ANALYSIS
===========================================================*/

WITH customer_orders AS (
    SELECT
        c.customer_unique_id,
        COUNT(DISTINCT o.order_id) AS total_orders
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    GROUP BY c.customer_unique_id
)

SELECT
    CASE
        WHEN total_orders = 1 THEN 'One-Time Customer'
        ELSE 'Repeat Customer'
    END AS customer_type,
    COUNT(*) AS total_customers,
    ROUND(
        COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (),
        2
    ) AS percentage
FROM customer_orders
GROUP BY customer_type;


/*===========================================================
  4.13 RFM CUSTOMER ANALYSIS
===========================================================*/

SELECT
    c.customer_unique_id,

    MAX(DATE(o.order_purchase_timestamp)) AS last_purchase_date,

    DATEDIFF(
        (SELECT MAX(DATE(order_purchase_timestamp)) FROM orders),
        MAX(DATE(o.order_purchase_timestamp))
    ) AS recency_days,

    COUNT(DISTINCT o.order_id) AS frequency,

    ROUND(SUM(oi.price), 2) AS monetary_value

FROM customers c

JOIN orders o
    ON c.customer_id = o.customer_id

JOIN order_items oi
    ON o.order_id = oi.order_id

GROUP BY c.customer_unique_id

ORDER BY monetary_value DESC
LIMIT 20;


/*===========================================================
  4.14 PARETO (80/20) REVENUE ANALYSIS
===========================================================*/

WITH customer_revenue AS (

    SELECT
        c.customer_unique_id,
        ROUND(SUM(oi.price),2) AS total_revenue
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    JOIN order_items oi
        ON o.order_id = oi.order_id
    GROUP BY c.customer_unique_id

),

pareto_analysis AS (

    SELECT
        customer_unique_id,
        total_revenue,

        ROW_NUMBER() OVER (
            ORDER BY total_revenue DESC
        ) AS customer_rank,

        SUM(total_revenue) OVER (
            ORDER BY total_revenue DESC
        ) AS cumulative_revenue,

        SUM(total_revenue) OVER () AS overall_revenue

    FROM customer_revenue

)

SELECT

    customer_rank,

    customer_unique_id,

    total_revenue,

    ROUND(
        cumulative_revenue,
        2
    ) AS cumulative_revenue,

    ROUND(
    cumulative_revenue * 100 / overall_revenue,
    2
) AS cumulative_revenue_percent

FROM pareto_analysis

ORDER BY customer_rank

LIMIT 20;


/*===========================================================
  4.15 EXECUTIVE KPI SUMMARY
===========================================================*/

SELECT

    /* Business Performance */
    (SELECT COUNT(DISTINCT order_id)
     FROM orders) AS total_orders,

    (SELECT COUNT(DISTINCT customer_unique_id)
     FROM customers) AS total_customers,

    (SELECT ROUND(SUM(price),2)
     FROM order_items) AS total_revenue,

    (SELECT ROUND(SUM(price) /
                  COUNT(DISTINCT order_id),2)
     FROM order_items) AS average_order_value,

    /* Customer Satisfaction */
    (SELECT ROUND(AVG(review_score),2)
     FROM reviews) AS average_review_score,

    /* Delivery Performance */
    (SELECT ROUND(AVG(
        DATEDIFF(order_delivered_customer_date,
                 order_purchase_timestamp)
    ),2)
     FROM orders
     WHERE order_delivered_customer_date IS NOT NULL)
     AS average_delivery_days,

    /* Payment */
    (SELECT payment_type
     FROM payments
     GROUP BY payment_type
     ORDER BY COUNT(*) DESC
     LIMIT 1) AS most_used_payment_method;
     
/*===========================================================
  FILE SUMMARY
=============================================================

File Name:
04_business_analysis.sql

Objective:
Analyze the Olist e-commerce dataset to answer real-world
business questions and generate actionable insights.

Business Analyses Completed:

 4.1 Overall Business Performance
 4.2 Monthly Sales Trend
 4.3 Top Product Categories by Revenue
 4.4 Top 10 Best-Selling Products
 4.5 Top Customers by Spending
 4.6 Top Sellers by Revenue
 4.7 Delivery Performance Analysis
 4.8 Revenue by Customer State
 4.9 Payment Method Analysis
 4.10 Customer Review Analysis
 4.11 Delivery Time vs. Review Score Analysis
 4.12 Repeat Customer Analysis
 4.13 RFM Customer Analysis
 4.14 Pareto Revenue Analysis
 4.15 Executive KPI Summary

Key Business Findings:

 Total Revenue: 13,591,643.70
 Total Orders: 99,441
 Total Customers: 96,096
 Average Order Value: 137.75
 Average Review Score: 4.09 / 5
 Average Delivery Time: 12.50 Days
 Most Used Payment Method: Credit Card

Major Insights:

 Health & Beauty generated the highest revenue.
 Customer satisfaction is high, with an average review score of 4.09.
 Faster deliveries are associated with higher review scores.
 Only 3.12% of customers are repeat customers, indicating a major opportunity to improve retention.
 Revenue is broadly distributed across the customer base rather than relying on a small number of customers.

Status:
COMPLETED

Next File:
05_advanced_sql_analysis.sql

===========================================================*/