CREATE OR REPLACE PROCEDURE bronze.load_bronze()
LANGUAGE plpgsql AS $$
BEGIN

	TRUNCATE TABLE bronze.olist_customers_dataset;
	COPY bronze.olist_customers_dataset
	FROM 'C:\olist_customers_dataset.csv'
	WITH (FORMAT CSV, HEADER);
	
	TRUNCATE TABLE bronze.olist_geolocation_dataset;
	COPY bronze.olist_geolocation_dataset
	FROM 'C:\olist_geolocation_dataset.csv'
	WITH (FORMAT CSV, HEADER);
	
	TRUNCATE TABLE bronze.olist_order_items_dataset;
	COPY bronze.olist_order_items_dataset
	FROM 'C:\olist_order_items_dataset.csv'
	WITH (FORMAT CSV, HEADER);
	
	TRUNCATE TABLE bronze.olist_order_payments_dataset;
	COPY bronze.olist_order_payments_dataset
	FROM 'C:\olist_order_payments_dataset.csv'
	WITH(FORMAT CSV, HEADER);
	
	TRUNCATE TABLE bronze.olist_order_reviews_dataset;
	COPY bronze.olist_order_reviews_dataset
	FROM 'C:\olist_order_reviews_dataset.csv'
	WITH (FORMAT CSV, HEADER);
	
	TRUNCATE TABLE bronze.olist_orders_dataset;
	COPY bronze.olist_orders_dataset
	FROM 'C:\olist_orders_dataset.csv'
	WITH (FORMAT CSV, HEADER);

	TRUNCATE TABLE bronze.olist_products;
	COPY bronze.olist_products
	FROM 'C:\olist_products_dataset.csv'
	WITH (FORMAT CSV, HEADER);

	TRUNCATE TABLE bronze.olist_sellers_dataset;
	COPY bronze.olist_sellers_dataset
	FROM 'C:\olist_sellers_dataset.csv'
	WITH (FORMAT CSV, HEADER);

END; 
$$;

CALL bronze.load_bronze();