### Q1: What are the overall business numbers?

| total_sales | total_orders | total_customers | avg_order_value |
|---|---|---|---|
| 2,261,536.78 | 4922 | 793 | 459.48 |

### Q2: Which categories and sub-categories bring the most sales, and what share of total is each?

| category | sub_category | sales | pct_of_total |
|---|---|---|---|
| Technology | Phones | 327,782.45 | 14.49 |
| Furniture | Chairs | 322,822.73 | 14.27 |
| Office Supplies | Storage | 219,343.39 | 9.70 |
| Furniture | Tables | 202,810.63 | 8.97 |
| Office Supplies | Binders | 200,028.79 | 8.84 |
| Technology | Machines | 189,238.63 | 8.37 |
| Technology | Accessories | 164,186.70 | 7.26 |
| Technology | Copiers | 146,248.09 | 6.47 |
| Furniture | Bookcases | 113,813.20 | 5.03 |
| Office Supplies | Appliances | 104,618.40 | 4.63 |
| Furniture | Furnishings | 89,212.02 | 3.94 |
| Office Supplies | Paper | 76,828.30 | 3.40 |
| Office Supplies | Supplies | 46,420.31 | 2.05 |
| Office Supplies | Art | 26,705.41 | 1.18 |
| Office Supplies | Envelopes | 16,128.05 | 0.71 |
| Office Supplies | Labels | 12,347.73 | 0.55 |
| Office Supplies | Fasteners | 3,001.96 | 0.13 |

### Q3: How are sales split across regions?

| region | orders | sales | pct_of_total |
|---|---|---|---|
| West | 1587 | 710,219.68 | 31.40 |
| East | 1369 | 669,518.73 | 29.60 |
| Central | 1156 | 492,646.91 | 21.78 |
| South | 810 | 389,151.46 | 17.21 |

### Q4: Who are the top 10 customers by sales?

| customer_id | customer_name | segment | orders | sales |
|---|---|---|---|---|
| SM-20320 | Sean Miller | Home Office | 5 | 25,043.05 |
| TC-20980 | Tamara Chand | Corporate | 5 | 19,052.22 |
| RB-19360 | Raymond Buch | Consumer | 6 | 15,117.34 |
| TA-21385 | Tom Ashbrook | Home Office | 4 | 14,595.62 |
| AB-10105 | Adrian Barton | Consumer | 10 | 14,473.57 |
| KL-16645 | Ken Lonsdale | Consumer | 12 | 14,175.23 |
| SC-20095 | Sanjit Chand | Consumer | 9 | 14,142.33 |
| HL-15040 | Hunter Lopez | Consumer | 6 | 12,873.30 |
| SE-20110 | Sanjit Engle | Consumer | 11 | 12,209.44 |
| CC-12370 | Christopher Conant | Consumer | 5 | 12,129.07 |

### Q5: Which are the top 10 products by sales?

| product_id | product_name | sub_category | sales |
|---|---|---|---|
| TEC-CO-10004722 | Canon imageCLASS 2200 Advanced Copier | Copiers | 61,599.82 |
| OFF-BI-10003527 | Fellowes PB500 Electric Punch Plastic Comb Binding Machine with Manual Bind | Binders | 27,453.38 |
| TEC-MA-10002412 | Cisco TelePresence System EX90 Videoconferencing Unit | Machines | 22,638.48 |
| FUR-CH-10002024 | HON 5400 Series Task Chairs for Big and Tall | Chairs | 21,870.58 |
| OFF-BI-10001359 | GBC DocuBind TL300 Electric Binding System | Binders | 19,823.48 |
| OFF-BI-10000545 | GBC Ibimaster 500 Manual ProClick Binding System | Binders | 19,024.50 |
| TEC-CO-10001449 | Hewlett Packard LaserJet 3310 Copier | Copiers | 18,839.69 |
| TEC-MA-10001127 | HP Designjet T520 Inkjet Large Format Printer - 24" Color | Machines | 18,374.90 |
| OFF-BI-10004995 | GBC DocuBind P400 Electric Binding System | Binders | 17,965.07 |
| OFF-SU-10000151 | High Speed Automatic Electric Letter Opener | Supplies | 17,030.31 |

### Q6: How did sales grow year over year? (CTE + LAG window function)

| year | sales | previous_year_sales | growth_pct |
|---|---|---|---|
| 2015 | 479,856.21 |  |  |
| 2016 | 459,436.01 | 479,856.21 | -4.26 |
| 2017 | 600,192.55 | 459,436.01 | 30.64 |
| 2018 | 722,052.02 | 600,192.55 | 20.30 |

### Q7: Which months of the year are strongest? (average monthly sales over the 4 years)

| month_no | month | avg_monthly_sales |
|---|---|---|
| 11 | Nov | 87,540.43 |
| 12 | Dec | 80,370.04 |
| 09 | Sep | 75,025.85 |
| 10 | Oct | 49,874.07 |
| 03 | Mar | 49,393.40 |
| 08 | Aug | 39,328.98 |
| 05 | May | 38,521.68 |
| 06 | Jun | 36,459.38 |
| 07 | Jul | 36,383.92 |
| 04 | Apr | 34,070.75 |
| 01 | Jan | 23,572.91 |
| 02 | Feb | 14,842.78 |

### Q8: How fast is delivery for each ship mode?

| ship_mode | orders | avg_delivery_days | max_delivery_days |
|---|---|---|---|
| Same Day | 261 | 0.05 | 1 |
| First Class | 772 | 2.19 | 4 |
| Second Class | 944 | 3.24 | 5 |
| Standard Class | 2945 | 5.00 | 7 |

### Q9: How do the customer segments compare? (customers, orders, sales, sales per customer)

| segment | customers | orders | sales | sales_per_customer | avg_order_value |
|---|---|---|---|---|---|
| Consumer | 409 | 2537 | 1,148,060.53 | 2,806.99 | 452.53 |
| Corporate | 236 | 1491 | 688,494.07 | 2,917.35 | 461.77 |
| Home Office | 148 | 894 | 424,982.18 | 2,871.50 | 475.37 |

### Q10: What are the top 3 sub-categories in each region? (RANK window function)

| region | rank_in_region | sub_category | sales |
|---|---|---|---|
| Central | 1 | Chairs | 82,372.78 |
| Central | 2 | Phones | 71,939.95 |
| Central | 3 | Binders | 56,865.01 |
| East | 1 | Phones | 99,884.66 |
| East | 2 | Chairs | 95,687.51 |
| East | 3 | Storage | 69,428.66 |
| South | 1 | Phones | 58,098.34 |
| South | 2 | Machines | 53,890.96 |
| South | 3 | Chairs | 44,739.25 |
| West | 1 | Chairs | 100,023.20 |
| West | 2 | Phones | 97,859.50 |
| West | 3 | Tables | 81,016.23 |
