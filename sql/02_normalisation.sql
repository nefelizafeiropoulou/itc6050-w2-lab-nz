CREATE SCHEMA IF NOT EXISTS bad;
SET search_path TO bad;

CREATE TABLE sales_record (
    sale_id BIGINT,
    sale_date DATE,
    customer_name VARCHAR(160),
    customer_email VARCHAR(255),
    customer_phones VARCHAR(255), # comma-separated! e.g. '555-1212,555-3434' 
    customer_city VARCHAR(80),
    customer_country VARCHAR(60),
    product_name VARCHAR(120),
    product_category VARCHAR(60),
    product_price NUMERIC(10,2),
    quantity INT,
    line_total NUMERIC(10,2)
);

-- 1. 1NF violation: 
-- The multi-valued column is customer_phones, because the comment indicates it stores multiple phone numbers 
-- in a single field as a comma-separated list (e.g., '555-1212, 555-3434'). 
-- That means one row can contain multiple values for the same attribute, violating 1NF.

-- 2. Functional dependency 1:
-- 3NF violation: product_name, product_category, product_price
-- Since product_name, category and price depend on sale_id transitively
-- through a non-key attribute (product_name), 3NF gets violated.

-- 3. Functional dependency 2:
-- 3NF violation: customer_email, customer_name, customer_city, customer_country
-- Since customer_email, name, city and country depend transitively on sale_id
-- through a non-key attribute (customer_email), 3NF gets violated.

-- 4. Update anomaly example:
-- If a product price changes, it must be updated in every row of Sales_Record
-- where that product appears. If one row is missed, the database becomes inconsistent
-- with different prices for the same product.

-- Clean 3NF decomposition of the sales schema

CREATE SCHEMA IF NOT EXISTS clean;
SET search_path TO clean;

-- CUSTOMER
CREATE TABLE customer (
    customer_id BIGSERIAL PRIMARY KEY,
    email VARCHAR(255) NOT NULL UNIQUE,
    name VARCHAR(160) NOT NULL,
    city VARCHAR(80),
    country VARCHAR(60)
);

-- CUSTOMER PHONE 
CREATE TABLE customer_phone (
    customer_id BIGINT NOT NULL,
    phone VARCHAR(30) NOT NULL,
    PRIMARY KEY (customer_id, phone),
    FOREIGN KEY (customer_id) REFERENCES customer(customer_id)
        ON DELETE CASCADE
);

-- PRODUCT
CREATE TABLE product (
    product_id BIGSERIAL PRIMARY KEY,
    name VARCHAR(120) NOT NULL UNIQUE,
    category VARCHAR(60),
    unit_price NUMERIC(10,2) NOT NULL
);

-- SALE (header)
CREATE TABLE sale (
    sale_id BIGSERIAL PRIMARY KEY,
    customer_id BIGINT NOT NULL,
    sale_date DATE NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES customer(customer_id)
);

-- SALE ITEM (line items)
CREATE TABLE sale_item (
    sale_id BIGINT NOT NULL,
    product_id BIGINT NOT NULL,
    quantity INT NOT NULL CHECK (quantity > 0),
    unit_price_at_sale NUMERIC(10,2) NOT NULL,
    line_total NUMERIC(10,2) NOT NULL,
    PRIMARY KEY (sale_id, product_id),
    FOREIGN KEY (sale_id) REFERENCES sale(sale_id)
        ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES product(product_id)
);