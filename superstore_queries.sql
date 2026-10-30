-- Super Store Sales Analysis (PostgreSQL)
-- Dataset: Kaggle "Superstore Sales Dataset" (9,800 rows)
-- Author: Md Zafar Ali

-- =========================================================
-- SETUP
-- =========================================================
-- 1) Create the main table (dates are loaded as TEXT, format DD/MM/YYYY)
CREATE TABLE superstore (
  row_id INTEGER,
  order_id TEXT,
  order_date TEXT,
  ship_date TEXT,
  ship_mode TEXT,
  customer_id TEXT,
  customer_name TEXT,
  segment TEXT,
  country TEXT,
  city TEXT,
  state TEXT,
  postal_code TEXT,
  region TEXT,
  product_id TEXT,
  category TEXT,
  sub_category TEXT,
  product_name TEXT,
  sales NUMERIC
);

-- 2) Load the CSV (run in psql):
-- \copy superstore FROM 'C:/Users/mdzaf/Downloads/archive/train.csv' CSV HEADER ENCODING 'UTF8'

-- 3) Create a customers table (one row per customer) for the JOIN query
CREATE TABLE customers AS
SELECT
  customer_id,
  MIN(customer_name) AS customer_name,
  MIN(segment) AS segment
FROM superstore
GROUP BY customer_id;

ALTER TABLE customers ADD PRIMARY KEY (customer_id);

-- =========================================================
-- QUERIES
-- =========================================================

-- Query 1: Preview the data
SELECT * FROM superstore LIMIT 10;

-- Query 2: Total sales, orders and customers
SELECT
  ROUND(SUM(sales), 2)        AS total_sales,
  COUNT(DISTINCT order_id)    AS total_orders,
  COUNT(DISTINCT customer_id) AS total_customers
FROM superstore;

-- Query 3: Sales and orders by category
SELECT
  category,
  ROUND(SUM(sales), 2) AS total_sales,
  COUNT(DISTINCT order_id) AS total_orders
FROM superstore
GROUP BY category
ORDER BY total_sales DESC;

-- Query 4: Share of total sales by category (subquery)
SELECT
  category,
  ROUND(SUM(sales), 2) AS total_sales,
  ROUND(100 * SUM(sales) / (SELECT SUM(sales) FROM superstore), 2) AS pct_of_total
FROM superstore
GROUP BY category
ORDER BY total_sales DESC;

-- Query 5: Sales by region with ranking (RANK window function)
SELECT
  region,
  ROUND(SUM(sales), 2) AS total_sales,
  ROUND(100 * SUM(sales) / (SELECT SUM(sales) FROM superstore), 2) AS pct_of_total,
  RANK() OVER (ORDER BY SUM(sales) DESC) AS sales_rank
FROM superstore
GROUP BY region
ORDER BY sales_rank;

-- Query 6: Sales by year
SELECT
  EXTRACT(YEAR FROM TO_DATE(order_date, 'DD/MM/YYYY')) AS order_year,
  ROUND(SUM(sales), 2) AS total_sales,
  COUNT(DISTINCT order_id) AS total_orders
FROM superstore
GROUP BY order_year
ORDER BY order_year;

-- Query 7: Year-over-year sales growth (CTE + LAG)
WITH yearly AS (
  SELECT
    EXTRACT(YEAR FROM TO_DATE(order_date, 'DD/MM/YYYY')) AS order_year,
    SUM(sales) AS total_sales
  FROM superstore
  GROUP BY order_year
)
SELECT
  order_year,
  ROUND(total_sales, 2) AS total_sales,
  ROUND(LAG(total_sales) OVER (ORDER BY order_year), 2) AS prev_year_sales,
  ROUND(
    100 * (total_sales - LAG(total_sales) OVER (ORDER BY order_year))
        / LAG(total_sales) OVER (ORDER BY order_year),
    2
  ) AS growth_pct
FROM yearly
ORDER BY order_year;

-- Query 8: Top 10 products by sales
SELECT
  product_name,
  category,
  ROUND(SUM(sales), 2) AS total_sales,
  COUNT(DISTINCT order_id) AS total_orders
FROM superstore
GROUP BY product_name, category
ORDER BY total_sales DESC
LIMIT 10;

-- Query 9: Top 10 customers by sales (JOIN)
SELECT
  c.customer_name,
  c.segment,
  ROUND(SUM(s.sales), 2) AS total_sales,
  COUNT(DISTINCT s.order_id) AS total_orders
FROM superstore s
JOIN customers c
  ON s.customer_id = c.customer_id
GROUP BY c.customer_id, c.customer_name, c.segment
ORDER BY total_sales DESC
LIMIT 10;

-- Query 10: Top 3 products in each category (CTE + RANK with PARTITION BY)
WITH product_sales AS (
  SELECT
    category,
    product_name,
    SUM(sales) AS total_sales
  FROM superstore
  GROUP BY category, product_name
),
ranked AS (
  SELECT
    category,
    product_name,
    ROUND(total_sales, 2) AS total_sales,
    RANK() OVER (PARTITION BY category ORDER BY total_sales DESC) AS rnk
  FROM product_sales
)
SELECT category, product_name, total_sales, rnk
FROM ranked
WHERE rnk <= 3
ORDER BY category, rnk;
