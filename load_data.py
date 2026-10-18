import csv, sqlite3, sys, os
from datetime import datetime

src, dbpath = sys.argv[1], sys.argv[2]
if os.path.exists(dbpath):
    os.remove(dbpath)

def iso(d):
    return datetime.strptime(d, "%d/%m/%Y").strftime("%Y-%m-%d")

rows = list(csv.DictReader(open(src, newline="", encoding="utf-8")))
print("rows:", len(rows))

# --- sanity checks on keys before normalising ---
from collections import defaultdict
def multi(keyf, valf):
    m = defaultdict(set)
    for r in rows:
        m[r[keyf]].add(tuple(r[v] for v in valf))
    return {k: v for k, v in m.items() if len(v) > 1}

print("customers with >1 (name,segment):", len(multi("Customer ID", ["Customer Name", "Segment"])))
pm = multi("Product ID", ["Product Name", "Category", "Sub-Category"])
print("products with >1 (name,cat,subcat):", len(pm))
om = multi("Order ID", ["Order Date", "Ship Date", "Ship Mode", "Customer ID", "City", "State", "Region", "Postal Code"])
print("orders with >1 header:", len(om))
print("blank postal codes:", sum(1 for r in rows if not r["Postal Code"].strip()))
print("exact duplicate rows (ignoring Row ID):",
      len(rows) - len({tuple(v for k, v in r.items() if k != "Row ID") for r in rows}))

con = sqlite3.connect(dbpath)
con.executescript("""
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
""")

customers, products, orders = {}, {}, {}
items = []
for r in rows:
    customers.setdefault(r["Customer ID"], (r["Customer ID"], r["Customer Name"], r["Segment"]))
    # if a product id has more than one name, keep the first seen
    products.setdefault(r["Product ID"], (r["Product ID"], r["Product Name"], r["Category"], r["Sub-Category"]))
    orders.setdefault(r["Order ID"], (
        r["Order ID"], iso(r["Order Date"]), iso(r["Ship Date"]), r["Ship Mode"], r["Customer ID"],
        r["Country"], r["State"], r["City"], r["Postal Code"].strip() or None, r["Region"]))
    items.append((int(r["Row ID"]), r["Order ID"], r["Product ID"], float(r["Sales"])))

con.executemany("INSERT INTO customers VALUES (?,?,?)", customers.values())
con.executemany("INSERT INTO products VALUES (?,?,?,?)", products.values())
con.executemany("INSERT INTO orders VALUES (?,?,?,?,?,?,?,?,?,?)", orders.values())
con.executemany("INSERT INTO order_items VALUES (?,?,?,?)", items)
con.commit()

for t in ("customers", "products", "orders", "order_items"):
    print(t, con.execute(f"SELECT COUNT(*) FROM {t}").fetchone()[0])
print("total sales:", round(con.execute("SELECT SUM(sales) FROM order_items").fetchone()[0], 2))
print("date range:", con.execute("SELECT MIN(order_date), MAX(order_date) FROM orders").fetchone())
con.close()
