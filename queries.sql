-- =====================================================================
-- Super Store Sales Analysis (SQL)
-- Dataset : Superstore Sales (Kaggle), 9,800 order lines, 2015-2018
-- Dialect : SQLite (works in DB Browser for SQLite). Only the date
--           functions (strftime, julianday) need changing for MySQL/SQL Server.
-- Tables  : customers, products, orders, order_items  (see schema.sql)
-- =====================================================================


-- Q1: What are the overall business numbers?
SELECT
    ROUND(SUM(oi.sales), 2)                          AS total_sales,
    COUNT(DISTINCT oi.order_id)                      AS total_orders,
    COUNT(DISTINCT o.customer_id)                    AS total_customers,
    ROUND(SUM(oi.sales) / COUNT(DISTINCT oi.order_id), 2) AS avg_order_value
FROM order_items AS oi
JOIN orders      AS o ON o.order_id = oi.order_id;


-- Q2: Which categories and sub-categories bring the most sales, and what share of total is each?
SELECT
    p.category,
    p.sub_category,
    ROUND(SUM(oi.sales), 2)                                          AS sales,
    ROUND(100.0 * SUM(oi.sales) / SUM(SUM(oi.sales)) OVER (), 2)     AS pct_of_total
FROM order_items AS oi
JOIN products    AS p ON p.product_id = oi.product_id
GROUP BY p.category, p.sub_category
ORDER BY sales DESC;


-- Q3: How are sales split across regions?
SELECT
    o.region,
    COUNT(DISTINCT o.order_id)                                       AS orders,
    ROUND(SUM(oi.sales), 2)                                          AS sales,
    ROUND(100.0 * SUM(oi.sales) / SUM(SUM(oi.sales)) OVER (), 2)     AS pct_of_total
FROM order_items AS oi
JOIN orders      AS o ON o.order_id = oi.order_id
GROUP BY o.region
ORDER BY sales DESC;


-- Q4: Who are the top 10 customers by sales?
SELECT
    c.customer_id,
    c.customer_name,
    c.segment,
    COUNT(DISTINCT o.order_id)  AS orders,
    ROUND(SUM(oi.sales), 2)     AS sales
FROM order_items AS oi
JOIN orders      AS o ON o.order_id    = oi.order_id
JOIN customers   AS c ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name, c.segment
ORDER BY sales DESC
LIMIT 10;


-- Q5: Which are the top 10 products by sales?
SELECT
    p.product_id,
    p.product_name,
    p.sub_category,
    ROUND(SUM(oi.sales), 2)  AS sales
FROM order_items AS oi
JOIN products    AS p ON p.product_id = oi.product_id
GROUP BY p.product_id, p.product_name, p.sub_category
ORDER BY sales DESC
LIMIT 10;


-- Q6: How did sales grow year over year? (CTE + LAG window function)
WITH yearly AS (
    SELECT
        CAST(strftime('%Y', o.order_date) AS INTEGER) AS year,
        SUM(oi.sales)                                 AS sales
    FROM order_items AS oi
    JOIN orders      AS o ON o.order_id = oi.order_id
    GROUP BY year
)
SELECT
    year,
    ROUND(sales, 2)                                                     AS sales,
    ROUND(LAG(sales) OVER (ORDER BY year), 2)                           AS previous_year_sales,
    ROUND(100.0 * (sales - LAG(sales) OVER (ORDER BY year))
                / LAG(sales) OVER (ORDER BY year), 2)                   AS growth_pct
FROM yearly
ORDER BY year;


-- Q7: Which months of the year are strongest? (average monthly sales over the 4 years)
WITH monthly AS (
    SELECT
        strftime('%Y', o.order_date) AS year,
        strftime('%m', o.order_date) AS month_no,
        SUM(oi.sales)                AS sales
    FROM order_items AS oi
    JOIN orders      AS o ON o.order_id = oi.order_id
    GROUP BY year, month_no
)
SELECT
    month_no,
    CASE month_no
        WHEN '01' THEN 'Jan' WHEN '02' THEN 'Feb' WHEN '03' THEN 'Mar' WHEN '04' THEN 'Apr'
        WHEN '05' THEN 'May' WHEN '06' THEN 'Jun' WHEN '07' THEN 'Jul' WHEN '08' THEN 'Aug'
        WHEN '09' THEN 'Sep' WHEN '10' THEN 'Oct' WHEN '11' THEN 'Nov' WHEN '12' THEN 'Dec'
    END                         AS month,
    ROUND(AVG(sales), 2)        AS avg_monthly_sales
FROM monthly
GROUP BY month_no
ORDER BY avg_monthly_sales DESC;


-- Q8: How fast is delivery for each ship mode?
SELECT
    o.ship_mode,
    COUNT(*)                                                         AS orders,
    ROUND(AVG(julianday(o.ship_date) - julianday(o.order_date)), 2)  AS avg_delivery_days,
    MAX(CAST(julianday(o.ship_date) - julianday(o.order_date) AS INTEGER)) AS max_delivery_days
FROM orders AS o
GROUP BY o.ship_mode
ORDER BY avg_delivery_days;


-- Q9: How do the customer segments compare? (customers, orders, sales, sales per customer)
SELECT
    c.segment,
    COUNT(DISTINCT c.customer_id)                                       AS customers,
    COUNT(DISTINCT o.order_id)                                          AS orders,
    ROUND(SUM(oi.sales), 2)                                             AS sales,
    ROUND(SUM(oi.sales) / COUNT(DISTINCT c.customer_id), 2)             AS sales_per_customer,
    ROUND(SUM(oi.sales) / COUNT(DISTINCT o.order_id), 2)                AS avg_order_value
FROM order_items AS oi
JOIN orders      AS o ON o.order_id    = oi.order_id
JOIN customers   AS c ON c.customer_id = o.customer_id
GROUP BY c.segment
ORDER BY sales DESC;


-- Q10: What are the top 3 sub-categories in each region? (RANK window function)
WITH region_sub AS (
    SELECT
        o.region,
        p.sub_category,
        SUM(oi.sales) AS sales
    FROM order_items AS oi
    JOIN orders      AS o ON o.order_id   = oi.order_id
    JOIN products    AS p ON p.product_id = oi.product_id
    GROUP BY o.region, p.sub_category
),
ranked AS (
    SELECT
        region,
        sub_category,
        ROUND(sales, 2) AS sales,
        RANK() OVER (PARTITION BY region ORDER BY sales DESC) AS rank_in_region
    FROM region_sub
)
SELECT region, rank_in_region, sub_category, sales
FROM ranked
WHERE rank_in_region <= 3
ORDER BY region, rank_in_region;
