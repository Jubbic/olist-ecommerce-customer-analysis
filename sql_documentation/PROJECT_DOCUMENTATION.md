# Olist SQL Customer Analytics Project Documentation

## Section 1: Data Modeling

### File
02_data_modeling.sql

### Status
Completed

### Summary
The Olist database was modeled by defining primary keys, indexes, and foreign key relationships to establish a relational schema suitable for analytics.

### Successfully Implemented

- Primary keys created for all required tables.
- Performance indexes created on foreign key columns.
- Foreign key relationships successfully created:
  - Order Items → Orders
  - Order Items → Products
  - Order Items → Sellers
  - Payments → Orders

### Challenges Encountered

#### Orders → Customers Foreign Key

Issue:
MySQL returned an Incorrect datetime value error while attempting to create the foreign key.

Investigation:
- Verified matching data types (`VARCHAR(32)`).
- Verified customers.customer_id is the primary key.
- Verified orders.customer_id is indexed.
- Verified both tables use the InnoDB storage engine.
- Verified no orphan customer records (`invalid_customers = 0`).

Outcome:
The relationship was logically verified, but MySQL did not enforce the foreign key under the current database configuration.

---

#### Products → Category Translation Foreign Key

Issue:
MySQL returned Error Code: 1452.

Cause:
Some values in products.product_category_name do not have matching records in category_translation.product_category_name.

Resolution:
Deferred to the Data Quality Checks phase, where missing category mappings will be identified and resolved before attempting the foreign key again.



# 03_data_quality_checks.sql

## Objective

The objective of this phase was to assess the overall quality of the Olist Brazilian E-Commerce dataset before conducting business analysis. Data quality validation was performed to ensure the dataset is complete, consistent, accurate, and reliable for analytical reporting.

---

## Tasks Completed

### 1. Record Count Validation

Verified the total number of records in all imported tables to ensure the dataset was imported successfully and all required tables were available.

Tables Validated:

- Customers
- Geolocation
- Order Items
- Orders
- Payments
- Reviews
- Products
- Sellers
- Category Translation

Result

-  All tables were successfully validated.
-  Record counts were returned for all nine tables.

---

# 06 - Advanced Business Analysis

Project: Olist Brazilian E-Commerce Customer Analytics Project

File: 06_advanced_business_analysis.sql

Description: Advanced SQL business analysis using the Olist Brazilian E-Commerce dataset to answer strategic business questions and generate executive-level insights.

Author: Adeleke Jubril

---

# Overview

This file applies advanced SQL techniques to solve real-world business problems using transactional e-commerce data. The analysis focuses on customer behavior, sales performance, logistics, payment preferences, seller performance, and executive reporting.

The objective is to demonstrate SQL skills expected from a Data Analyst by transforming raw business data into actionable insights.

---

# Business Questions Answered

- Revenue trend over time
- Customer retention and repeat purchase behavior
- Customer cohort analysis
- Churn risk identification
- Best-performing cities by revenue
- Top-performing sellers
- Lowest-performing product categories
- Customer value segmentation
- Delivery performance by state
- Payment method performance
- Customer purchase frequency
- Executive business KPI summary

---

# SQL Skills Demonstrated

- Common Table Expressions (CTEs)
- Window Functions
- CASE WHEN Expressions
- Aggregate Functions
- Date Functions
- JOIN Operations
- Customer Segmentation
- Revenue Analysis
- Business KPI Reporting
- Ranking Techniques
- Performance Analysis

---

# Key Business Insights

- Credit cards generated the highest order volume and revenue.
- São Paulo recorded the fastest average delivery time.
- Northern Brazilian states experienced the longest delivery times.
- Marketplace revenue exceeded 27 million.
- Average customer review score remained above 4.0, indicating high customer satisfaction.
- A small group of loyal customers generated multiple repeat purchases.
- Several product categories contributed very little revenue, suggesting opportunities for product portfolio optimization.
- Seller performance varied significantly, with a small number of sellers contributing a substantial share of marketplace revenue.

---

# Conclusion

This file demonstrates the ability to perform advanced SQL analytics for business decision-making. It combines multiple SQL techniques to answer executive-level business questions and produce insights that support strategy, operations, marketing, customer retention, and marketplace performance evaluation.

The analyses in this file complete the SQL phase of the Olist Customer Analytics Portfolio Project and provide a strong foundation for building interactive dashboards in Power BI.

### 2. Missing Value Analysis

Checked for NULL values in the most critical business tables.

Tables Checked

- Customers
- Orders
- Products

Result

-  No missing values were found in the Customers table.
-  No missing values were found in the Orders table.
-  No missing values were found in the Products table.

---

### 3. Duplicate Record Detection

Performed duplicate checks on primary business identifiers.

Tables Checked

- Customers
- Orders
- Products
- Sellers
- Payments
- Reviews

Result

-  No duplicate records were found in Customers.
-  No duplicate records were found in Orders.
-  No duplicate records were found in Products.
-  No duplicate records were found in Sellers.
-  No duplicate records were found in Payments.

Observation

The Reviews table returned multiple occurrences of review_id. After investigation, this was confirmed to be an expected characteristic of the Olist dataset rather than an accidental duplicate. Therefore, no records were removed.

---

### 4. Referential Integrity Validation

Validated relationships between related tables.

Relationships Tested

- Orders → Customers
- Order Items → Orders
- Order Items → Products
- Order Items → Sellers

Result

-  No orphan records were detected.
-  All relationships passed referential integrity validation.

---

### 5. Business Rule Validation

Validated important business rules to identify invalid data.

Checks Performed

- Product Price > 0
- Freight Value ≥ 0
- Payment Value ≥ 0
- Review Score between 1 and 5

Result

-  No invalid product prices found.
-  No negative freight values found.
-  No negative payment values found.
-  All review scores fall within the valid range.

Additional Finding

Nine payment records had a payment value of 0.00.

Further investigation showed these records were associated with the voucher and not_defined payment types. These were determined to be legitimate business transactions rather than data quality issues and were retained in the dataset.

---

## Key Outcomes

- Successfully validated data completeness across the core business tables.
- Confirmed there are no critical missing values.
- Verified there are no duplicate records in the primary business entities.
- Confirmed referential integrity across related tables.
- Validated business rules and investigated exceptional cases.
- Established that the dataset is clean, reliable, and ready for business analysis.

---

## Skills Demonstrated

- SQL Data Validation
- Data Quality Assessment
- Missing Value Analysis
- Duplicate Detection
- Referential Integrity Validation
- Business Rule Validation
- Data Investigation
- Analytical Documentation

---

## Interview Insight

Data quality assessment is a critical phase of every analytics project. Before performing analysis or building dashboards, analysts must verify that the underlying data is complete, accurate, and logically consistent. Identifying anomalies, investigating exceptional cases, and documenting findings demonstrates a professional analytical workflow and improves the reliability of business insights.

### Additional Data Cleaning

During business analysis, hidden carriage return characters (`CHAR(13)`) were discovered in the product_category_name_english column of the category_translation table. Although these characters were not visible in MySQL Workbench, they appeared when exporting or copying data and could have affected grouping and reporting.

The issue was confirmed using the HEX() function and resolved by removing the hidden characters with the following SQL statement:
UPDATE category_translation
SET product_category_name_english =
    TRIM(REPLACE(product_category_name_english, CHAR(13), ''));

The update was verified by confirming that the hexadecimal representation of the values no longer ended with 0D.

---

## Status

Completed 

The dataset successfully passed all major data quality assessments and is ready for the Business Analysis phase.

# 04_business_analysis.sql

## Overview

The 04_business_analysis.sql file focuses on transforming raw e-commerce data into meaningful business insights. Using the Olist Brazilian E-Commerce dataset, this file answers real-world business questions related to sales performance, customer behavior, product performance, seller performance, logistics, payment trends, and customer satisfaction.

The objective of this file is to demonstrate how SQL can be used not only for querying data but also for solving business problems and supporting data-driven decision-making.

---

## Business Objectives

- Analyze overall marketplace performance.
- Measure sales trends over time.
- Identify top-performing product categories and products.
- Evaluate customer purchasing behavior.
- Identify top customers and sellers.
- Assess logistics and delivery performance.
- Analyze payment preferences.
- Measure customer satisfaction.
- Evaluate customer retention.
- Apply customer segmentation using RFM analysis.
- Perform Pareto (80/20) revenue analysis.
- Build an executive-level KPI summary.

---

## Business Questions Answered

This file answers the following business questions:

1. How is the marketplace performing overall?
2. How have sales changed over time?
3. Which product categories generate the highest revenue?
4. Which products sell the most?
5. Who are the highest-spending customers?
6. Which sellers generate the highest revenue?
7. How efficient is the delivery process?
8. Which customer states generate the most revenue?
9. Which payment methods are used most frequently?
10. How satisfied are customers based on review scores?
11. Does delivery speed affect customer satisfaction?
12. What percentage of customers are repeat buyers?
13. Who are the marketplace's highest-value customers using RFM analysis?
14. Is revenue concentrated among a small group of customers?
15. What KPIs summarize the marketplace's overall performance?

---

## SQL Concepts Demonstrated

The following SQL concepts were applied throughout this file:

- Aggregate Functions (`SUM`, COUNT, AVG, `MAX`)
- GROUP BY
- ORDER BY
- CASE Statements
- INNER JOINs
- Common Table Expressions (CTEs)
- Window Functions
- ROW_NUMBER()
- Running Totals (Cumulative Revenue)
- Date Functions (`DATEDIFF`, `DATE_FORMAT`)
- Scalar Subqueries
- Business KPI Calculations

---

## Key Business Insights

### Marketplace Performance

- Processed 99,441 orders from 96,096 unique customers.
- Generated 13,591,643.70 in total revenue.
- Average Order Value (AOV) was 137.75.

### Product Performance

- Health & Beauty generated the highest total revenue.
- Product sales were well distributed across multiple categories, indicating a diverse marketplace.

### Customer Behavior

- 96.88% of customers placed only one order.
- Only 3.12% were repeat customers, highlighting customer retention as a major growth opportunity.

### Customer Satisfaction

- The average review score was 4.09 / 5.
- Approximately 77% of all reviews were rated 4 or 5 stars, indicating high overall customer satisfaction.

### Logistics Performance

- Average delivery time was 12.50 days.
- Customers who received faster deliveries consistently gave higher review scores, demonstrating a strong relationship between delivery performance and customer satisfaction.

### Geographic Performance

- São Paulo (SP) recorded the highest order volume and generated the highest revenue.

### Payment Analysis

- Credit Card was the most frequently used payment method across the marketplace.

### Customer Analytics

- RFM analysis identified high-value customers using Recency, Frequency, and Monetary metrics.
- Pareto analysis showed that revenue is broadly distributed across the customer base rather than relying on a small number of customers.

---

## Business Value

This analysis demonstrates how SQL supports business decision-making by:

- Measuring marketplace performance.
- Identifying revenue-driving products and sellers.
- Understanding customer purchasing behavior.
- Measuring customer satisfaction.
- Evaluating delivery performance.
- Identifying customer retention opportunities.
- Supporting executive reporting through KPI development.

---

## Skills Demonstrated

- Advanced SQL Querying
- Business Analytics
- Customer Analytics
- Sales Analytics
- Product Analytics
- Logistics Analysis
- Payment Analysis
- KPI Development
- Window Functions
- Common Table Expressions (CTEs)
- Executive Reporting
- Data Storytelling

---

## Deliverables

- 04_business_analysis.sql

---

## Project Status

Completed 

This file successfully answers key business questions using SQL and demonstrates the ability to convert transactional data into actionable business insights suitable for executive reporting and decision-making.

---

## Interview Takeaways

Through this file, I demonstrated the ability to:

- Write complex SQL queries using joins, CTEs, and window functions.
- Analyze business performance using real-world e-commerce data.
- Generate executive-level KPIs and actionable business recommendations.
- Connect operational metrics (delivery performance) with customer outcomes (review scores).
- Apply customer analytics techniques such as RFM and Pareto analysis to support business strategy.

---

## Next Step

Proceed to 05_advanced_sql_analysis.sql, where the project will focus on advanced SQL techniques, including advanced window functions, cohort analysis, customer lifetime value (CLV), rolling metrics, growth analysis, and interview-level SQL scenarios.


# 05 - Advanced Customer Analytics

## Overview

This phase of the project focuses on applying advanced SQL techniques to perform customer analytics and generate actionable business insights from the Olist Brazilian E-Commerce dataset. Advanced SQL features such as Common Table Expressions (CTEs), Window Functions, ranking functions, running totals, and cohort analysis were used to solve real-world business problems and prepare data for executive reporting.

---

## Objectives

- Perform advanced customer analytics using SQL.
- Analyze customer lifetime value (CLV).
- Measure monthly revenue growth.
- Analyze customer purchase behavior.
- Evaluate customer retention using cohort analysis.
- Apply Window Functions for ranking and trend analysis.
- Build an executive KPI dataset for dashboard reporting.

---

## Key Analyses Performed

### 5.1 Customer Lifetime Value (CLV) Analysis

Calculated each customer's lifetime spending and ranked customers based on their overall revenue contribution to identify high-value customers.

### 5.2 Monthly Revenue Growth Analysis

Analyzed monthly revenue performance using the LAG() Window Function to calculate month-over-month revenue growth and growth percentages.

### 5.3 Customer Purchase Sequence Analysis

Assigned sequential purchase numbers to every customer's orders using ROW_NUMBER() to distinguish first purchases from repeat purchases.

### 5.4 Cohort Retention Analysis

Grouped customers by their first purchase month and tracked their purchasing activity over subsequent months to evaluate customer retention.

### 5.5 Pareto (80/20) Revenue Analysis

Calculated cumulative customer revenue contribution using Window Functions to identify the customers contributing the highest share of marketplace revenue.

### 5.6 Executive KPI Dashboard Dataset

Created a production-ready executive KPI summary containing the most important business metrics required for reporting and Power BI dashboards.

---

## SQL Techniques Used

- Common Table Expressions (CTEs)
- Window Functions
- ROW_NUMBER()
- DENSE_RANK()
- LAG()
- SUM() OVER()
- Running Totals
- Cumulative Percentage Analysis
- Aggregate Functions
- Scalar Subqueries
- GROUP BY
- ORDER BY
- Date Functions
- Multiple Table Joins

---

## Key Business Insights

- Total Orders: 99,441
- Total Customers: 96,096
- Total Revenue: 13,591,643.70
- Average Order Value: 137.75
- Average Review Score: 4.09 / 5
- Average Delivery Time: 12.50 days
- Total Products Sold: 32,951
- Total Sellers: 3,095
- Most Used Payment Method: Credit Card

Additional findings:

- Most customers placed only one order, highlighting an opportunity to improve customer retention.
- Customer Lifetime Value (CLV) analysis identified the marketplace's highest-value customers.
- Revenue experienced significant growth throughout 2017 and early 2018.
- Cohort analysis revealed declining customer retention after the first purchase, indicating the need for customer re-engagement strategies.
- Pareto analysis demonstrated how cumulative revenue contribution can be used to identify the customers driving overall business performance.

---

## Business Value

The analyses performed in this phase provide valuable insights into customer behavior, revenue trends, customer retention, and marketplace performance. These findings support executive reporting, customer segmentation, loyalty program development, marketing optimization, and Power BI dashboard creation.

---

## Conclusion

This file demonstrates advanced SQL capabilities by combining analytical thinking with business intelligence techniques. The use of CTEs, Window Functions, ranking methods, Customer Lifetime Value (CLV), cohort analysis, Pareto analysis, and executive KPI reporting reflects real-world SQL practices used by professional Data Analysts and Business Intelligence professionals.