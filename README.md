# Super Store Sales Analysis (SQL)

SQL analysis of the Kaggle **Superstore Sales** dataset (9,800 order lines, 2015-2018) using **PostgreSQL** and **pgAdmin 4**.

## What I did
- Loaded the CSV into PostgreSQL (`superstore` table).
- Created a `customers` table (one row per customer, with a primary key) to practice JOINs.
- Wrote 10 queries covering aggregation, GROUP BY, subqueries, CTEs, JOIN, and window functions (RANK, LAG, PARTITION BY).

All queries and the setup steps are in [`superstore_queries.sql`](superstore_queries.sql).

## Key results
| Metric | Result |
|---|---|
| Total sales | 2,261,536.78 |
| Total orders | 4,922 |
| Total customers | 793 |

**Sales by category**

| Category | Sales | Share |
|---|---|---|
| Technology | 827,455.87 | 36.59% |
| Furniture | 728,658.58 | 32.22% |
| Office Supplies | 705,422.33 | 31.19% |

Office Supplies has the most orders (3,676) but the lowest sales.

**Sales by region**

| Region | Sales | Share |
|---|---|---|
| West | 710,219.68 | 31.40% |
| East | 669,518.73 | 29.60% |
| Central | 492,646.91 | 21.78% |
| South | 389,151.46 | 17.21% |

**Year-over-year growth**

| Year | Sales | Growth |
|---|---|---|
| 2015 | 479,856.21 | - |
| 2016 | 459,436.01 | -4.26% |
| 2017 | 600,192.55 | +30.64% |
| 2018 | 722,052.02 | +20.30% |

- Top customer: Sean Miller (25,043.05 sales, 5 orders).
- Top product: Canon imageCLASS 2200 Advanced Copier (61,599.82 sales).

## SQL concepts used
`SELECT`, `WHERE`, `GROUP BY`, `ORDER BY`, `LIMIT`, `COUNT(DISTINCT)`, subquery, `JOIN`, CTE (`WITH`), `RANK() OVER`, `LAG() OVER`, `PARTITION BY`, `TO_DATE`, `EXTRACT`

## Related
Power BI dashboard on the same dataset: https://github.com/md-zafarali/superstore-powerbi-dashboard

## Note
I wrote and ran these queries myself in pgAdmin while learning SQL, with step-by-step guidance from an AI assistant.
