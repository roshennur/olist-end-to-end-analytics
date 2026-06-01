CREATE SCHEMA IF NOT EXISTS silver;

DROP TABLE IF EXISTS silver.olist_customers_dataset;
CREATE TABLE silver.olist_customers_dataset (
	customer_id varchar(100) NOT NULL,
	customer_unique_id varchar(100),
	customer_zip_code_prefix varchar(20),
	customer_city varchar(50),
	customer_state varchar(20)
);

DROP TABLE IF EXISTS silver.olist_geolocation_dataset;
CREATE TABLE silver.olist_geolocation_dataset (
	geolocation_zip_code_prefix varchar(20),
	geolocation_lat numeric,
	geolocation_lng numeric,
	geolocation_city varchar(50),
	geolocation_state varchar(20)
);

DROP TABLE IF EXISTS silver.olist_order_items_dataset;
CREATE TABLE silver.olist_order_items_dataset (
	order_id varchar(100) NOT NULL,
	order_item_id int,
	product_id varchar(100),
	seller_id varchar(100),
	shipping_limit_date timestamp with time zone,
	price numeric,
	freight_value numeric,
	total_amount numeric
);

DROP TABLE IF EXISTS silver.olist_order_payments_dataset;
CREATE TABLE silver.olist_order_payments_dataset (
	order_id varchar(100),
	payment_sequential numeric,
	payment_type varchar(50),
	payment_installments numeric,
	payment_value numeric(10,2)	
);

DROP TABLE IF EXISTS silver.olist_order_reviews_dataset;
CREATE TABLE silver.olist_order_reviews_dataset (
	review_id varchar(100),
	order_id varchar(100),
	review_score int,
	review_comment_title varchar(50),
	review_comment_message text,
	review_creation_date timestamptz,
	review_answer_timestamp timestamptz
);

DROP TABLE IF EXISTS silver.olist_orders_dataset;
CREATE TABLE silver.olist_orders_dataset (
	order_id varchar(100) NOT NULL,
	customer_id varchar(100),
	order_status varchar(20),
	order_purchase_timestamp timestamptz,
	order_approved_at timestamptz,
	order_delivered_carrier_date timestamptz,
	order_delivered_customer_date timestamptz,
	order_estimated_delivery_date timestamptz
);

DROP TABLE IF EXISTS silver.olist_products;
CREATE TABLE silver.olist_products (
	product_id varchar(100) PRIMARY KEY,
	product_category_name varchar(50),
	product_name_lenght numeric,
	product_description_lenght numeric,
	product_photos_qty numeric,
	product_weight_g numeric,
	product_length_cm numeric,
	product_height_cm numeric,
	product_width_cm numeric,
	product_category_name_english varchar(50),
	product_name_english varchar(100)
);

DROP TABLE IF EXISTS silver.olist_sellers_dataset;
CREATE TABLE silver.olist_sellers_dataset (
	seller_id varchar(100),
	seller_zip_code_prefix varchar(20),
	seller_city varchar(50),
	seller_state varchar(20)
);