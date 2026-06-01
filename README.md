# ITC 6050 — Week 2 Lab

-- Q1: Look up a customer by email
-- Execution Time: 0.069 ms

-- Q2: All orders for a given customer in date order
-- Execution Time: 7.313 ms

-- Q3: All products in a given category
-- Execution Time: 58.386 ms

After speeding up:
-- Q1: Look up a customer by email
-- Execution Time: 0.056 ms

-- Q2: All orders for a given customer in date order
-- Execution Time: 0.182 ms

-- Q3: All products in a given category
-- Execution Time: 57.584 ms

1. Which query saw the biggest speed-up? Why?
Q2 improved from 7.313 ms to 0.182 ms, making it about 40 times faster. The composite index on (customer_id, order_date) let PostgreSQL quickly find a customer's orders and return them in date order.

2. Look at Q2's plan — did Postgres also use the index for ordering, or did it sort separately? 
How can you tell from the plan?
Yes, the execution plan shows an Index Scan on idx_orders_customer_date and no Sort node. This means the index provided the rows in the required order.

3. We added idx_order_item_product but never queried by product_id alone in Q1–Q3. Why is it still useful?
It helps future queries and joins involving products, such as finding all order items for a product or generating product sales reports.

4. Cost of indexes: what trade-off did we make by adding all these indexes? Name two operations
that are now slightly slower.
Indexes make reads faster but increase write overhead. INSERT and UPDATE operations become slightly slower because PostgreSQL must also update the indexes.
