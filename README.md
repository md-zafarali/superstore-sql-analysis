# Super Store Sales Analysis (SQL)

SQL analysis of the Superstore Sales dataset (Kaggle): 9,800 order lines, 4,922 orders, 793 customers, January 2015 to December 2018.
The same data is visualised in my Power BI project, [Super Store Sales Dashboard](ADD-YOUR-GITHUB-LINK-HERE).

## Business questions answered

| # | Question | SQL used |
|---|---|---|
| 1 | What are the overall business numbers? | JOIN, SUM, COUNT DISTINCT |
| 2 | Which categories and sub-categories bring the most sales? | JOIN, GROUP BY, window SUM OVER |
| 3 | How are sales split across regions? | JOIN, GROUP BY, window SUM OVER |
| 4 | Who are the top 10 customers? | 3-table JOIN, ORDER BY, LIMIT |
| 5 | Which are the top 10 products? | JOIN, GROUP BY |
| 6 | How did sales grow year over year? | CTE, LAG window function |
| 7 | Which months of the year are strongest? | CTE, strftime, CASE |
| 8 | How fast is delivery for each ship mode? | julianday date arithmetic, AVG, MAX |
| 9 | How do customer segments compare? | 3-table JOIN, per-customer ratios |
| 10 | Top 3 sub-categories in each region? | CTE, RANK() OVER (PARTITION BY) |

All queries are in [`queries.sql`](queries.sql); their output is in [`results.md`](results.md).

## Key findings

- Total sales of **2.26M** from **4,922 orders** and **793 customers**; average order value **459.48**.
- **Technology** is the largest category (36.59% of sales). **Phones** (14.49%) and **Chairs** (14.27%) are the top sub-categories.
- **West** (31.40%) and **East** (29.60%) bring over 60% of sales; South is the smallest region (17.21%).
- Sales fell 4.26% in 2016, then grew **30.64%** in 2017 and **20.30%** in 2018.
- **November, December and September** are the strongest months on average; **February and January** are the weakest.
- **Standard Class** takes 5.00 days on average to ship, Second Class 3.24, First Class 2.19, Same Day 0.05.
- Consumer is the biggest segment by sales (1.15M, 409 customers), but sales per customer are similar across segments (about 2,800 to 2,900).
- **Phones** are the top sub-category in East and South; **Chairs** lead in Central and West.

## Data model

The flat CSV was split into four related tables (see [`schema.sql`](schema.sql)):

`customers` (793) · `products` (1,861) · `orders` (4,922) · `order_items` (9,800)

Dates were converted from dd/mm/yyyy to ISO `YYYY-MM-DD`.

## How to run

The raw data is not included in this repo. Download `train.csv` from the Kaggle dataset page linked below, then:

1. Install Python and **DB Browser for SQLite** (free).
2. Build the database from the CSV: `python load_data.py train.csv superstore.db`
3. Open `superstore.db` in DB Browser, go to **Execute SQL**, paste a query from `queries.sql`, and run it.

You can also read the output of every query directly in [`results.md`](results.md).

## Data notes

- 1 exact duplicate order line (Order US-2015-150119, Row IDs 3406 and 3407) was kept, so totals match the source file and my Power BI dashboard.
- 32 Product IDs appear with more than one product name; the first name found is kept.
- 11 rows have a blank Postal Code (stored as NULL).
- The dataset has no Profit or Quantity column, so the analysis is based on Sales.

## Tools

SQLite · SQL (JOIN, GROUP BY, CTE, window functions) · DB Browser for SQLite

Dataset: [Superstore Sales Dataset](https://www.kaggle.com/datasets/rohitsahoo/sales-forecasting) (`train.csv`) by rohitsahoo on Kaggle, licensed GPL 2. The raw data is not redistributed in this repo.
