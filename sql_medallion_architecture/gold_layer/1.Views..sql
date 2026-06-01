-- Create gold schema
CREATE SCHEMA IF NOT EXISTS gold;


-- create view for Fact Table Sales
DROP VIEW gold.fact_sales;
CREATE VIEW gold.fact_sales AS
SELECT
	o.order_id,
	o.customer_id,
	o.order_delivered_carrier_date,
	o.order_estimated_delivery_date,
	o.order_delivered_customer_date,
	o.order_purchase_timestamp,
	i.total_amount,
	i.shipping_limit_date,
	i.product_id
FROM silver.olist_order_items_dataset i
JOIN silver.olist_orders_dataset o
	ON i.order_id = o.order_id
WHERE o.order_status = 'Delivered'


-- create view for customer table
DROP VIEW gold.customers;
CREATE VIEW gold.customers AS
SELECT
	customer_id,
	customer_unique_id,
	customer_city,
	customer_state
FROM silver.olist_customers_dataset;


-- create view for products table
DROP VIEW gold.products;
CREATE VIEW gold.products AS
SELECT
	product_id,
	product_category_name_english AS category,
	product_name_english AS product
FROM silver.olist_products;

-- create view for reviews table
DROP VIEW gold.reviews;
CREATE VIEW gold.reviews AS
SELECT
	review_id,
	order_id,
	review_score
FROM silver.olist_order_reviews_dataset;

-- create view for orders table
DROP VIEW gold.orders;
CREATE VIEW gold.orders AS
SELECT
	*
FROM silver.olist_orders_dataset
WHERE order_status = 'Delivered' 
	AND order_delivered_customer_date IS NOT NULL;

-- create view for payments table
DROP VIEW gold.payments;
CREATE VIEW gold.payments AS
SELECT
	order_id,
	payment_value
FROM silver.olist_order_payments_dataset;