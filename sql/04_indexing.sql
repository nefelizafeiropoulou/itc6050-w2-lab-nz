SET search_path TO shop;
-- Q1: Look up a customer by email
EXPLAIN ANALYZE
SELECT *
FROM customer
WHERE email = 'cust5000@example.com';
-- Q2: All orders for a given customer in date order
EXPLAIN ANALYZE
SELECT order_id, order_date, total
FROM orders
WHERE customer_id = 5000
ORDER BY order_date;
-- Q3: All products in a given category
EXPLAIN ANALYZE
SELECT p.name,
    SUM(oi.quantity * oi.unit_price_at_sale) AS revenue
FROM order_item oi
JOIN orders o USING (order_id)
JOIN product p USING (product_id)
WHERE o.order_date >= NOW() - INTERVAL '90 days'
GROUP BY p.name
ORDER BY revenue DESC
LIMIT 10;
-- Speed up customer-by-email lookup
CREATE INDEX idx_customer_email ON customer (email);
-- Speed up "orders for a customer, recent first"
CREATE INDEX idx_orders_customer_date ON orders (customer_id, order_date
DESC);
-- Speed up the date-range scan in Q3
CREATE INDEX idx_orders_date ON orders (order_date);
-- Speed up the join + aggregation in Q3
CREATE INDEX idx_order_item_order ON order_item (order_id);
CREATE INDEX idx_order_item_product ON order_item (product_id);
ANALYZE;