# Olist E-Commerce Customer Analytics

##  Project Overview

The **Olist E-Commerce Customer Analytics Project** is an end-to-end **Data Analytics and Business Intelligence project** built with **MySQL and Power BI**.

The project analyzes the Brazilian Olist e-commerce marketplace across sales, customers, products, sellers, payments, reviews, delivery performance, and geographic trends.

> **Project flow:** Raw Data → MySQL → Data Modeling → Data Quality → SQL Analysis → Advanced SQL → Business Case Studies → Power BI → Business Insights

---

##  Business Objectives

* Measure overall revenue and sales performance
* Analyze sales trends over time
* Identify high-performing product categories
* Identify high-volume product categories
* Analyze seller performance by city
* Measure customer retention and repeat purchasing
* Analyze customer and seller geography
* Understand payment-method usage
* Measure average order value and delivery performance
* Identify actionable business opportunities

---

#  Tools & Technologies

## SQL

* MySQL 8.0
* SQL
* Relational Database Design
* Data Import
* Data Modeling
* Data Quality Checks
* Joins
* Aggregations
* CTEs
* Subqueries
* Window Functions
* Advanced SQL Analysis
* Business Case Analysis

## Power BI

* Power BI Desktop
* Power Query
* Data Modeling
* DAX
* KPI Development
* Interactive Slicers
* Data Visualization
* Geographic Analysis
* Dashboard Design
* Business Intelligence

---

#  Dataset

The project uses the **Brazilian E-Commerce Public Dataset by Olist**.

The dataset contains approximately 100,000 orders and multiple related datasets covering:

* Customers
* Orders
* Order Items
* Payments
* Reviews
* Products
* Sellers
* Geolocation
* Product Categories

---

#  End-to-End Analytics Workflow

```text
Raw Olist Dataset
        ↓
MySQL Database Setup
        ↓
Data Modeling
        ↓
Data Quality Checks
        ↓
Business Analysis
        ↓
Advanced SQL Analysis
        ↓
Business Case Studies
        ↓
Power BI Data Preparation
        ↓
Power BI Data Modeling
        ↓
DAX Measures
        ↓
Interactive Dashboard
        ↓
Business Insights
```

---

#  SQL Analysis

The SQL component was completed in **six structured phases**.

## Phase 1 — Database Setup

Created the MySQL database, tables, and imported the Olist datasets.

**File:** `01_database_setup.sql`

## Phase 2 — Data Modeling

Established relationships between customers, orders, order items, products, sellers, payments, reviews, and geolocation.

**File:** `02_data_modeling.sql`

## Phase 3 — Data Quality Checks

Validated missing values, duplicates, dates, referential integrity, record counts, and data consistency.

**File:** `03_data_quality_checks.sql`

## Phase 4 — Business Analysis

Analyzed revenue, orders, customers, AOV, products, categories, payments, customer segmentation, delivery, sellers, geography, and monthly trends.

**File:** `04_business_analysis.sql`

## Phase 5 — Advanced SQL Analysis

Applied CTEs, subqueries, window functions, ranking, comparative analysis, and advanced aggregations.

**File:** `05_advanced_sql_analysis.sql`

## Phase 6 — Business Case Studies

Applied SQL to practical business scenarios covering customer retention, product performance, seller performance, revenue concentration, geography, operations, and growth opportunities.

**File:** `06_business_case_studies.sql`

---

#  Key SQL Results

| Metric                |     Result |
| --------------------- | ---------: |
| Total Customers       |     99,441 |
| Total Orders          |     98,666 |
| Product Revenue       |     13.59M |
| Average Order Value   |     137.75 |
| Average Delivery Time | 12.50 days |
| Average Review Score  |       4.09 |
| Repeat Customers      |      2,997 |
| One-Time Customers    |     93,099 |

> **Note:** SQL and Power BI metrics may differ where different business definitions or source tables are used. Product Revenue is based on order-item prices, while Total Revenue is the broader revenue KPI used on the Executive Dashboard.

---

#  Power BI Dashboard

The Power BI solution contains **three interactive dashboard pages**.

## 1. Executive Dashboard

### KPIs

* **Total Revenue:** 16.01M
* **Total Orders:** 99K
* **Total Customers:** 96K
* **Total Products Sold:** 113K
* **Average Order Value:** 160.99
* **Average Review Score:** 4.09
* **Average Delivery Days:** 12.50

### Visualizations

* Monthly Revenue Trend
* Revenue by Payment Method
* Revenue by Brazilian State
* Order Status Distribution

### Purpose

Provides an executive-level view of overall business, sales, customer, payment, geographic, and operational performance.

---

## 2. Customer Insights Dashboard

### KPIs

* **Total Customers:** 96K
* **Repeat Customer Rate:** 3.03%
* **Revenue per Customer:** 166.59
* **Repeat Customers:** 3K
* **One-Time Customers:** 93K

### Visualizations

* Customer Growth Trend
* Top 10 Customer Cities
* Customers by Brazilian State
* Customer Segmentation

### Slicers

* Customer City
* Customer State
* Order Date

### Purpose

Provides insight into customer growth, retention, segmentation, and geographic distribution.

---

## 3. Products & Sales Performance Dashboard

### KPIs

* **Product Revenue:** 13.59M
* **Total Orders:** 99K
* **Total Products Sold:** 113K
* **Average Order Value:** 160.99
* **Average Product Price:** 120.65

### Visualizations

* Revenue by Product Category
* Top 10 Categories by Units Sold
* Top 10 Seller Cities by Revenue

### Slicers

* Product Category
* Seller City

### Purpose

Provides insight into product revenue, sales volume, product pricing, and seller geography.

---

#  Key Business Insights

### Customer Retention

Only approximately **3% of customers are repeat customers**, indicating a major opportunity for loyalty programs, personalized marketing, post-purchase engagement, and customer reactivation.

### Product Performance

Revenue and units sold vary considerably across product categories, creating opportunities for category-level inventory, marketing, and sales optimization.

### Seller Geography

Seller revenue is geographically concentrated, with major commercial centers such as São Paulo contributing strongly to marketplace performance.

### Payment Methods

Credit cards represent the largest share of payment activity, highlighting the importance of a reliable card-payment experience.

### Delivery Performance

Average delivery time is approximately **12.5 days**, making logistics and fulfillment an important operational performance area.

### Geographic Performance

Revenue and customer activity vary across Brazilian states and cities, supporting regional marketing, logistics, seller acquisition, and expansion decisions.

---

#  Key Metric Definitions

### Total Revenue

The broader revenue measure used as the primary revenue KPI on the Executive Dashboard.

### Product Revenue

Revenue calculated from product prices at the order-item level and primarily used for product and category analysis.

### Average Order Value

The average value spent per order.

### Repeat Customer Rate

The percentage of customers who completed more than one order.

### Revenue per Customer

Average revenue generated per customer.

### Average Product Price

Average price of individual products sold.

### Average Delivery Days

Average number of days between order purchase and delivery.

---

#  Repository Structure

```text
Olist-Ecommerce-Customer-Analytics/
│
├── README.md
│
├── SQL/
│   ├── 01_database_setup.sql
│   ├── 02_data_modeling.sql
│   ├── 03_data_quality_checks.sql
│   ├── 04_business_analysis.sql
│   ├── 05_advanced_sql_analysis.sql
│   └── 06_business_case_studies.sql
│
├── Documentation/
│   └── SQL_Project_Documentation.md
│
├── PowerBI/
│   └── Olist_Ecommerce_Customer_Analytics.pbix
│
└── Screenshots/
    ├── executive-dashboard.png
    ├── customer-insights-dashboard.png
    └── products-sales-performance.png
```

---

#  Project Documentation

The repository contains separate detailed documentation for the SQL component.

The **README** provides the high-level overview of the complete SQL + Power BI project, while the **SQL documentation** provides the detailed technical record of the SQL work.

---

#  Dashboard Preview

## Executive Dashboard

(https://github.com/Jubbic/olist-ecommerce-customer-analysis/blob/main/Screenshots/customer_insights.png)

## Customer Insights Dashboard

*Add Customer Insights Dashboard screenshot here.*

## Products & Sales Performance Dashboard

*Add Products & Sales Performance Dashboard screenshot here.*

---

#  Analytical Coverage

| Business Area  | Analysis                           |
| -------------- | ---------------------------------- |
| Sales          | Revenue, orders, AOV               |
| Customers      | Growth and segmentation            |
| Retention      | Repeat vs one-time customers       |
| Products       | Category revenue and units sold    |
| Sellers        | Seller city revenue                |
| Payments       | Payment method distribution        |
| Geography      | State and city performance         |
| Operations     | Delivery time and order status     |
| Reviews        | Review score performance           |
| Business Cases | Practical decision-making analysis |

---

#  Skills Demonstrated

* SQL
* MySQL
* Database Design
* Data Import
* Data Modeling
* Data Cleaning
* Data Quality Validation
* Joins
* Aggregations
* CTEs
* Subqueries
* Window Functions
* Advanced SQL
* Business Case Analysis
* Power BI
* Power Query
* DAX
* KPI Development
* Dashboard Design
* Customer Segmentation
* Customer Retention Analysis
* Sales Analysis
* Product Analysis
* Seller Analysis
* Geographic Analysis
* Business Intelligence
* Data Storytelling

---

#  Project Outcome

This project demonstrates a complete **end-to-end data analytics workflow**, from raw transactional data to actionable business intelligence.

The final solution combines MySQL and Power BI to help stakeholders understand:

* Overall business performance
* Customer behavior and retention
* Product performance
* Seller performance
* Geographic trends
* Payment behavior
* Delivery performance
* Sales opportunities

---

#  Author

## Adeleke Jubril Adedeji

**Junior Data Analyst**

* **LinkedIn:** [Jubril Adeleke](https://www.linkedin.com/in/jubril-adeleke-41bab8241)
* **GitHub:** [Jubbic](https://github.com/Jubbic)
* **Portfolio:** [Jubbic Portfolio](https://jubbic.github.io/)

---

#  Project Type

**End-to-End Data Analytics & Business Intelligence Project**

**Technologies:** `MySQL` • `SQL` • `Power BI` • `DAX` • `Power Query`

**Dataset:** **Brazilian E-Commerce Public Dataset by Olist**
