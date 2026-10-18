-- Schema for the Super Store SQL project (SQLite)
-- The Kaggle CSV is one flat table; here it is split into 4 related tables.

CREATE TABLE customers (
    customer_id   TEXT PRIMARY KEY,
    customer_name TEXT NOT NULL,
    segment       TEXT NOT NULL
);

CREATE TABLE products (
    product_id   TEXT PRIMARY KEY,
    product_name TEXT NOT NULL,
    category     TEXT NOT NULL,
    sub_category TEXT NOT NULL
);

CREATE TABLE orders (
    order_id    TEXT PRIMARY KEY,
    order_date  TEXT NOT NULL,   -- YYYY-MM-DD
    ship_date   TEXT NOT NULL,   -- YYYY-MM-DD
    ship_mode   TEXT NOT NULL,
    customer_id TEXT NOT NULL REFERENCES customers(customer_id),
    country     TEXT NOT NULL,
    state       TEXT NOT NULL,
    city        TEXT NOT NULL,
    postal_code TEXT,
    region      TEXT NOT NULL
);

CREATE TABLE order_items (
    row_id     INTEGER PRIMARY KEY,
    order_id   TEXT NOT NULL REFERENCES orders(order_id),
    product_id TEXT NOT NULL REFERENCES products(product_id),
    sales      REAL NOT NULL
);
