
-- Check Table structure in PostgreSQL
SELECT 
	column_name, 
	data_type, 
	is_nullable
FROM information_schema.columns
WHERE table_name = 'olist_order_items_dataset'
  AND table_schema = 'bronze';

-- Check if primary key in Fact Table has NULLs
SELECT 
	COUNT(*) FILTER (WHERE order_id IS NULL) AS null_count
FROM bronze.olist_order_items_dataset;


-- Check for Duplicates 
SELECT 
    product_id,
    COUNT(*) AS cnt
FROM bronze.olist_products
GROUP BY product_id
HAVING COUNT(*) > 1
ORDER BY cnt DESC;

-- Fix NULL values
SELECT 
	COALESCE(price, 0) AS price,
	COALESCE(freight_value, 0) AS freight_value
FROM bronze.olist_order_items_dataset

-- Impute new calculated column in Table
ALTER TABLE bronze.olist_order_items_dataset
ADD COLUMN total_amount numeric;

UPDATE bronze.olist_order_items_dataset
SET total_amount = price + freight_value;

-- Summary Statistics & Outlier Detection
SELECT 
    MIN(total_amount), 
    MAX(total_amount), 
    ROUND(AVG(total_amount),2) AS mean_amount,
	PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY total_amount) AS median_amount
FROM bronze.olist_order_items_dataset;

-- Data Consistency Check
SELECT *
FROM bronze.olist_orders_dataset
WHERE order_delivered_customer_date < order_purchase_timestamp;

-- Data Normalization
SELECT 
	INITCAP(TRIM(customer_city))
FROM bronze.olist_customers_dataset;

-- Verify how many orders delivered successfull
SELECT
	INITCAP(TRIM(order_status)) AS status,
	COUNT(*) AS cnt
FROM bronze.olist_orders_dataset
GROUP BY INITCAP(TRIM(order_status))
ORDER BY cnt DESC;

-- Relationship test between tables
SELECT 
	*
FROM silver.olist_order_items_dataset AS i
LEFT JOIN silver.olist_orders_dataset AS o
	ON i.order_id = o.order_id
WHERE o.order_id IS NULL;
