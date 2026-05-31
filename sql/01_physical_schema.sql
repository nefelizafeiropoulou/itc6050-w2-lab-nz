-- sql/01_physical_schema.sql
DROP SCHEMA IF EXISTS shop CASCADE;
CREATE SCHEMA shop;
SET search_path TO shop;

CREATE TABLE customer (
    customer_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    email VARCHAR(255) NOT NULL UNIQUE,
    first_name VARCHAR(80) NOT NULL,
    last_name VARCHAR(80) NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE address (
    address_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    customer_id BIGINT NOT NULL REFERENCES customer ON DELETE CASCADE,
    line1 VARCHAR(120) NOT NULL,
    city VARCHAR(80) NOT NULL,
    postcode VARCHAR(20) NOT NULL,
    country CHAR(2) NOT NULL,
    is_default BOOLEAN NOT NULL DEFAULT FALSE
);

CREATE TABLE category (
    category_id  BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name         VARCHAR(80) NOT NULL UNIQUE,
    created_at   TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE product (
    product_id   BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    category_id  BIGINT NOT NULL
                    REFERENCES category (category_id) ON DELETE RESTRICT,
    name         VARCHAR(160)  NOT NULL,
    unit_price   NUMERIC(10,2) NOT NULL CHECK (unit_price >= 0),
    is_active    BOOLEAN       NOT NULL DEFAULT TRUE,
    created_at   TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
    UNIQUE (category_id, name)
);

CREATE TABLE orders (
    order_id     BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    customer_id  BIGINT NOT NULL
                    REFERENCES customer (customer_id) ON DELETE RESTRICT,
    order_date   TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
    status       VARCHAR(20)   NOT NULL
                    CHECK (status IN ('new','paid','shipped','delivered','cancelled')),
    total        NUMERIC(12,2) NOT NULL CHECK (total >= 0)
);

CREATE TABLE order_item (
    order_item_id        BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    order_id             BIGINT NOT NULL
                            REFERENCES orders (order_id) ON DELETE RESTRICT,
    product_id           BIGINT NOT NULL
                            REFERENCES product (product_id) ON DELETE RESTRICT,
    quantity             INT           NOT NULL CHECK (quantity > 0),
    unit_price_at_sale   NUMERIC(10,2) NOT NULL CHECK (unit_price_at_sale >= 0)
);

SELECT table_name
FROM   information_schema.tables
WHERE  table_schema = 'shop'
ORDER  BY table_name;