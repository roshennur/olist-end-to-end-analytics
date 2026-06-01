CREATE OR REPLACE PROCEDURE silver.load_silver()
LANGUAGE plpgsql AS $$
BEGIN

	TRUNCATE TABLE silver.olist_customers_dataset;
	INSERT INTO silver.olist_customers_dataset
	SELECT 
		customer_id,
		customer_unique_id,
		customer_zip_code_prefix,
		INITCAP(TRIM(customer_city)) AS customer_city,
		customer_state
	FROM bronze.olist_customers_dataset;
	
	TRUNCATE TABLE silver.olist_geolocation_dataset;
	INSERT INTO silver.olist_geolocation_dataset 
	SELECT 
		geolocation_zip_code_prefix,
		geolocation_lat,
		geolocation_lng,
		INITCAP(TRIM(geolocation_city)) AS geolocation_city,
		geolocation_state
	FROM bronze.olist_geolocation_dataset;
	
	TRUNCATE TABLE silver.olist_order_items_dataset;
	INSERT INTO silver.olist_order_items_dataset
	SELECT 
		order_id,
		order_item_id AS item_nr,
		product_id,
		seller_id,
		shipping_limit_date,
		price,
		freight_value,
		total_amount
	FROM bronze.olist_order_items_dataset;
	
	TRUNCATE TABLE silver.olist_order_payments_dataset;
	INSERT INTO silver.olist_order_payments_dataset
	SELECT 
		order_id,
		payment_sequential,
		payment_type,
		payment_installments,
		payment_value	
	FROM bronze.olist_order_payments_dataset;
	
	TRUNCATE TABLE silver.olist_order_reviews_dataset;
	INSERT INTO silver.olist_order_reviews_dataset
	SELECT 
		review_id,
		order_id,
		review_score,
		review_comment_title,
		review_comment_message,
		review_creation_date,
		review_answer_timestamp
	FROM bronze.olist_order_reviews_dataset;
	
	TRUNCATE TABLE silver.olist_orders_dataset;
	INSERT INTO silver.olist_orders_dataset
	SELECT 
		order_id,
		customer_id,
		INITCAP(TRIM(order_status)) AS order_status,
		order_purchase_timestamp,
		order_approved_at,
		order_delivered_carrier_date,
		order_delivered_customer_date,
		order_estimated_delivery_date
	FROM bronze.olist_orders_dataset;
	
	TRUNCATE TABLE silver.olist_products;
	INSERT INTO silver.olist_products
	SELECT 
		product_id,
		product_category_name,
		product_name_lenght,
		product_description_lenght,
		product_photos_qty,
		product_weight_g,
		product_length_cm,
		product_height_cm,
		product_width_cm,
		INITCAP(TRIM(product_category_name_english)) AS product_category_name_english,
		INITCAP(TRIM(product_name_english)) AS product_name_english
	FROM bronze.olist_products;
	
	TRUNCATE TABLE silver.olist_sellers_dataset;
	INSERT INTO silver.olist_sellers_dataset
	SELECT 
		seller_id,
		seller_zip_code_prefix,
		INITCAP(TRIM(seller_city)) AS seller_city,
		seller_state
	FROM bronze.olist_sellers_dataset;

END; 
$$;

CALL silver.load_silver();
