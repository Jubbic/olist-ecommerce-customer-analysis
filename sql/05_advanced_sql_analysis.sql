/*===========================================================
  Project: Olist Brazilian E-Commerce Analytics
  File: 05_advanced_sql_analysis.sql

  Description:
  Advanced SQL analysis for customer analytics, sales trends,
  window functions, CTEs, ranking functions, cohort analysis,
  and other interview-level business scenarios.

  Author: Adeleke Jubril
===========================================================*/

/*===========================================================
  5.1 MONTH-OVER-MONTH (MoM) REVENUE GROWTH ANALYSIS
===========================================================*/

WITH monthly_revenue AS (

    SELECT
        DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m') AS order_month,
        ROUND(SUM(oi.price), 2) AS monthly_revenue
    FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id
    GROUP BY DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m')

)

SELECT
    order_month,
    monthly_revenue,

    LAG(monthly_revenue) OVER (
        ORDER BY order_month
    ) AS previous_month_revenue,

    ROUND(
        monthly_revenue -
        LAG(monthly_revenue) OVER (
            ORDER BY order_month
        ),
        2
    ) AS revenue_change,

    ROUND(
        (
            (monthly_revenue -
            LAG(monthly_revenue) OVER (
                ORDER BY order_month
            ))
            /
            LAG(monthly_revenue) OVER (
                ORDER BY order_month
            )
        ) * 100,
        2
    ) AS growth_percentage

FROM monthly_revenue
ORDER BY order_month;

/*===========================================================
  5.2 RUNNING REVENUE ANALYSIS
===========================================================*/

WITH monthly_revenue AS (

    SELECT
        DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m') AS order_month,
        ROUND(SUM(oi.price), 2) AS monthly_revenue
    FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id
    GROUP BY DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m')

)

SELECT
    order_month,
    monthly_revenue,

    ROUND(
        SUM(monthly_revenue) OVER (
            ORDER BY order_month
        ),
        2
    ) AS cumulative_revenue

FROM monthly_revenue
ORDER BY order_month;
/*
Expected Result:
One row per month showing:
- Monthly Revenue
- Cumulative Revenue
*/


/*===========================================================
  5.3 ROLLING 3-MONTH AVERAGE REVENUE
===========================================================*/

WITH monthly_revenue AS (

    SELECT
        DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m') AS order_month,
        ROUND(SUM(oi.price), 2) AS monthly_revenue
    FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id
    GROUP BY DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m')

)

SELECT
    order_month,
    monthly_revenue,

    ROUND(
        AVG(monthly_revenue) OVER (
            ORDER BY order_month
            ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
        ),
        2
    ) AS rolling_3_month_average

FROM monthly_revenue
ORDER BY order_month;
/*
Expected Result:

One row per month showing:
- Order Month
- Monthly Revenue
- Rolling 3-Month Average Revenue

The first month will average only itself.
The second month will average the first two months.
From the third month onward, the average will be based on the current month and the two preceding months.
*/


/*===========================================================
  5.4 PRODUCT REVENUE RANKING
===========================================================*/

WITH product_revenue AS (

    SELECT
        oi.product_id,
        ROUND(SUM(oi.price), 2) AS total_revenue
    FROM order_items oi
    GROUP BY oi.product_id

)

SELECT
    product_id,
    total_revenue,

    RANK() OVER (
        ORDER BY total_revenue DESC
    ) AS revenue_rank,

    DENSE_RANK() OVER (
        ORDER BY total_revenue DESC
    ) AS dense_revenue_rank

FROM product_revenue
ORDER BY total_revenue DESC
LIMIT 20;
/*
Expected Result:

Top 20 products showing:
- Product ID
- Total Revenue
- Revenue Rank
- Dense Revenue Rank

If two products have the same revenue:
- RANK() skips the next rank.
- DENSE_RANK() does not skip ranks.
*/


/*===========================================================
  5.5 CUSTOMER VALUE SEGMENTATION USING NTILE()
===========================================================*/

WITH customer_revenue AS (

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

    NTILE(4) OVER (
        ORDER BY total_spent DESC
    ) AS customer_segment

FROM customer_revenue
ORDER BY total_spent DESC
LIMIT 20;
/*
Expected Result:

Customer spending groups showing:
- Customer ID
- Total Amount Spent
- Customer Segment

Segment interpretation:

1 = Highest-value customers
2 = High-value customers
3 = Medium-value customers
4 = Lowest-value customers
*/


/*===========================================================
  5.6 CUSTOMER COHORT ANALYSIS
===========================================================*/

WITH customer_orders AS (

    SELECT
        c.customer_unique_id,
        o.order_id,
        DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m') AS order_month
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id

),

customer_cohort AS (

    SELECT
        customer_unique_id,
        MIN(order_month) AS cohort_month
    FROM customer_orders
    GROUP BY customer_unique_id

),

cohort_activity AS (

    SELECT
        cc.cohort_month,
        co.order_month,
        COUNT(DISTINCT co.customer_unique_id) AS active_customers
    FROM customer_orders co
    JOIN customer_cohort cc
        ON co.customer_unique_id = cc.customer_unique_id
    GROUP BY
        cc.cohort_month,
        co.order_month

)

SELECT
    cohort_month,
    order_month,
    active_customers

FROM cohort_activity
ORDER BY
    cohort_month,
    order_month;
/*
Expected Result:

Customer retention table showing:

- Cohort Month:
  The month customers made their first purchase.

- Order Month:
  The month customers made another purchase.

- Active Customers:
  Number of customers from each cohort who purchased during that month.
*/

/*===========================================================
  5.7 CUSTOMER PURCHASE SEQUENCE ANALYSIS
===========================================================*/

WITH customer_purchase_history AS (

    SELECT
        c.customer_unique_id,
        o.order_id,
        o.order_purchase_timestamp,

        ROW_NUMBER() OVER (
            PARTITION BY c.customer_unique_id
            ORDER BY o.order_purchase_timestamp
        ) AS purchase_number

    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id

)

SELECT
    customer_unique_id,
    order_id,
    order_purchase_timestamp,
    purchase_number

FROM customer_purchase_history

ORDER BY
    customer_unique_id,
    purchase_number;
/*
Expected Result:

Customer purchase history showing:

- Customer ID
- Order ID
- Purchase Date
- Purchase Number

Purchase Number Meaning:

1 = First purchase
2 = Second purchase
3 = Third purchase
...

This allows identification of repeat purchasing behavior.
*/


/*===========================================================
  5.8 CUSTOMER LIFETIME VALUE (CLV) ANALYSIS
===========================================================*/

WITH customer_lifetime_value AS (

    SELECT
        c.customer_unique_id,
        COUNT(DISTINCT o.order_id) AS total_orders,
        ROUND(SUM(oi.price), 2) AS lifetime_value

    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    JOIN order_items oi
        ON o.order_id = oi.order_id

    GROUP BY c.customer_unique_id

)

SELECT
    customer_unique_id,
    total_orders,
    lifetime_value,

    DENSE_RANK() OVER (
        ORDER BY lifetime_value DESC
    ) AS customer_rank

FROM customer_lifetime_value

ORDER BY lifetime_value DESC
LIMIT 20;
/*
Expected Result:

Top 20 highest-value customers showing:

- Customer ID
- Total Orders
- Lifetime Value
- Customer Rank

Higher lifetime value indicates customers who have generated the most revenue over their relationship with the marketplace.
*/


/*===========================================================
  5.9 PARETO ANALYSIS (80/20 RULE)
===========================================================*/

WITH customer_revenue AS (

    SELECT
        c.customer_unique_id,
        ROUND(SUM(oi.price), 2) AS lifetime_value
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    JOIN order_items oi
        ON o.order_id = oi.order_id
    GROUP BY c.customer_unique_id

),

ranked_customers AS (

    SELECT
        customer_unique_id,
        lifetime_value,

        SUM(lifetime_value) OVER (
            ORDER BY lifetime_value DESC
        ) AS cumulative_revenue,

        SUM(lifetime_value) OVER () AS total_revenue

    FROM customer_revenue

)

SELECT
    customer_unique_id,
    lifetime_value,
    cumulative_revenue,

    ROUND(
        cumulative_revenue / total_revenue,
        4
    ) AS cumulative_percentage

FROM ranked_customers
ORDER BY lifetime_value DESC
LIMIT 20;
/*
Expected Result:

Top customers showing:

- Customer ID
- Lifetime Value
- Cumulative Revenue
- Cumulative Percentage of Total Revenue

This helps identify how quickly the top customers contribute to overall revenue and supports Pareto (80/20) analysis.
*/


/*===========================================================
  5.10 EXECUTIVE KPI DASHBOARD DATASET (FINAL VERSION)
===========================================================*/

SELECT

    /* Orders */
    (SELECT COUNT(*)
     FROM orders) AS total_orders,

    /* Customers */
    (SELECT COUNT(DISTINCT customer_unique_id)
     FROM customers) AS total_customers,

    /* Revenue */
    (SELECT ROUND(SUM(price),2)
     FROM order_items) AS total_revenue,

    /* Average Order Value */
    (
        SELECT ROUND(SUM(price) /
               COUNT(DISTINCT order_id),2)
        FROM order_items
    ) AS average_order_value,

    /* Average Review Score */
    (
        SELECT ROUND(AVG(review_score),2)
        FROM reviews
    ) AS average_review_score,

    /* Average Delivery Days */
    (
        SELECT ROUND(
            AVG(DATEDIFF(order_delivered_customer_date,
                         order_purchase_timestamp)),2)
        FROM orders
        WHERE order_delivered_customer_date IS NOT NULL
    ) AS average_delivery_days,

    /* Total Products Sold */
    (
        SELECT COUNT(DISTINCT product_id)
        FROM order_items
    ) AS total_products,

    /* Total Sellers */
    (
        SELECT COUNT(*)
        FROM sellers
    ) AS total_sellers,

    /* Most Used Payment Method */
    (
        SELECT payment_type
        FROM payments
        GROUP BY payment_type
        ORDER BY COUNT(*) DESC
        LIMIT 1
    ) AS most_used_payment_method;
    
/*===========================================================
FILE SUMMARY
=============================================================


Advanced Customer Analytics was performed using Common Table
Expressions (CTEs), Window Functions, Aggregate Functions,
and Ranking Functions to generate deeper business insights
from the Olist Brazilian E-Commerce dataset.

Key analyses completed include:

 Customer Lifetime Value (CLV) Analysis
 Monthly Revenue Growth Analysis
 Customer Purchase Sequence Analysis
 Customer Cohort Retention Analysis
 Pareto (80/20) Revenue Analysis
 Executive KPI Dashboard Dataset
 Revenue Trend Analysis
 Advanced Customer Ranking
 Repeat Customer Analysis
 Running Total and Cumulative Revenue Analysis

Key Business Insights:

 The marketplace generated over 13.59 million in total revenue.
 Most customers placed only one order, indicating an opportunity to improve customer retention.
 Average Order Value was 137.75.
 Customer satisfaction remained high with an average review score of 4.09/5.
 Average delivery time was 12.50 days.
 Credit cards were the dominant payment method.
 Revenue growth accelerated significantly during 2017 and early 2018 before slowing toward the end of the available dataset.
 Customer Lifetime Value analysis identified the marketplace’s highest-value customers for potential loyalty and retention strategies.
 Cohort analysis showed that customer retention declines after the first purchase, highlighting the importance of re-engagement campaigns.

This file demonstrates advanced SQL analytical techniques commonly used by Data Analysts and Business Intelligence professionals to support executive reporting and strategic decision-making.

===========================================================*/
