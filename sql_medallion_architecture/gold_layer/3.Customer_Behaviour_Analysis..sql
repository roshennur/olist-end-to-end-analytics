/*

Customer Behaviour Analysis:

Analysis:
	- Annual Customer Segmentation Analysis.
    - What is the customer repeat rate?
    - How many percent of revenue comes from Loyal customers?
    - Does AOV increased or decreased yearly: Loyal vs Non-Loyal?
	- Monthly Retention Cohort Analysis.
	
*/


-----------------------------------------
-- Annual Customer Segmentation Analysis.
-----------------------------------------

WITH customer_orders AS (
    SELECT 
        c.customer_unique_id,
        EXTRACT(YEAR FROM o.order_purchase_timestamp) AS order_year,
        COUNT(o.order_id) AS total_orders
    FROM gold.orders o
    JOIN gold.customers c
        ON o.customer_id = c.customer_id
    GROUP BY 1, 2
)
SELECT
    order_year,
    COUNT(DISTINCT customer_unique_id) AS total_customers,
    SUM(CASE WHEN total_orders > 1 
		THEN 1 
        ELSE 0 
    END) AS loyal_customers,
    SUM(CASE WHEN total_orders = 1 
		THEN 1 
        ELSE 0 
    END) AS non_loyal_customers,
    ROUND(
        SUM(CASE WHEN total_orders > 1 THEN 1 ELSE 0 END) * 100.0
        / COUNT(DISTINCT customer_unique_id), 
    2) AS repeat_rate
FROM customer_orders
GROUP BY 1
ORDER BY 1;


------------------------------------
-- What is the customer repeat rate?
------------------------------------

WITH customer_orders AS (
	SELECT 
		c.customer_unique_id,
		COUNT(o.order_id) AS total_orders
	FROM gold.orders o
    JOIN gold.customers c
        ON o.customer_id = c.customer_id
	GROUP BY 1
)
SELECT
	COUNT(*) AS total_customers,
	SUM(CASE WHEN total_orders > 1 
		THEN 1 
		ELSE 0 
	END) AS repeat_customers,
	ROUND(SUM(CASE WHEN total_orders > 1 THEN 1
		ELSE 0
	END) * 100 / COUNT(*), 1) || '%' AS repeat_customer_rate	
FROM customer_orders;


----------------------------------------------------------
-- How many percent of revenue comes from Loyal customers?
----------------------------------------------------------

WITH base_orders AS (
	SELECT
		o.order_id,
		c.customer_unique_id,
		p.payment_value
	FROM gold.orders o
    JOIN gold.customers c
        ON o.customer_id = c.customer_id
	JOIN gold.payments p
		ON o.order_id = p.order_id
),
customer_loyalty AS (
	SELECT
		customer_unique_id,
		COUNT(DISTINCT order_id) AS total_orders
	FROM base_orders
	GROUP BY 1
),
customer_revenue AS (
	SELECT
		b.customer_unique_id,
		SUM(b.payment_value) AS revenue
	FROM base_orders b
	GROUP BY 1
)
SELECT
	ROUND(SUM(CASE WHEN cl.total_orders > 1 THEN cr.revenue ELSE 0 END) * 100.0 / SUM(cr.revenue), 2) || '%' AS loyal_customer_revenue_percent
FROM customer_revenue cr
JOIN customer_loyalty cl
ON cr.customer_unique_id = cl.customer_unique_id;


--------------------------------------------------------------
-- Does AOV increased or decreased yearly: Loyal vs Non-Loyal.
--------------------------------------------------------------

WITH cust_orders AS (
	SELECT 
		c.customer_unique_id,
		COUNT(o.order_id) AS total_orders
	FROM gold.orders o
    JOIN gold.customers c
        ON o.customer_id = c.customer_id
	GROUP BY 1
),
cust_segment AS (
	SELECT
		customer_unique_id,
		CASE 
			WHEN total_orders > 1 THEN 'Loyal'
			ELSE 'Non-Loyal'
		END AS customer_type
	FROM cust_orders
),
order_revenue AS (
	SELECT
		o.order_id,
		c.customer_unique_id,
		EXTRACT(YEAR FROM o.order_purchase_timestamp) AS order_year,
		p.payment_value
	FROM silver.olist_orders_dataset o
	LEFT JOIN silver.olist_customers_dataset c
		ON o.customer_id = c.customer_id
	LEFT JOIN silver.olist_order_payments_dataset p
		ON o.order_id = p.order_id
	WHERE o.order_status = 'Delivered'
)
SELECT
	orv.order_year,
	cs.customer_type,
	ROUND(SUM(orv.payment_value) / COUNT(DISTINCT orv.order_id), 2) AS aov
FROM order_revenue orv
JOIN cust_segment cs
	ON orv.customer_unique_id = cs.customer_unique_id
GROUP BY 1, 2
ORDER BY 1, 2


-------------------------------------
-- Monthly Retention Cohort Analysis.
-------------------------------------

WITH customer_first_purchase AS (
    SELECT 
        c.customer_unique_id,
        MIN(DATE_TRUNC('month', o.order_purchase_timestamp::timestamp)) AS cohort_month
    FROM gold.orders o
    JOIN gold.customers c
        ON o.customer_id = c.customer_id
    GROUP BY 1
),
order_activities AS (
    SELECT 
        c.customer_unique_id,
        DATE_TRUNC('month', o.order_purchase_timestamp::timestamp) AS activity_month
    FROM silver.olist_orders_dataset o
    LEFT JOIN silver.olist_customers_dataset c 
		ON o.customer_id = c.customer_id
    WHERE o.order_status = 'Delivered'
),
cohort_counts AS (
    SELECT 
        cfp.cohort_month,
        oa.activity_month,
        (EXTRACT(YEAR FROM AGE(oa.activity_month, cfp.cohort_month)) * 12 +
         EXTRACT(MONTH FROM AGE(oa.activity_month, cfp.cohort_month))) AS month_number,
        COUNT(DISTINCT cfp.customer_unique_id) AS active_customers
    FROM customer_first_purchase cfp
    LEFT JOIN order_activities oa 
		ON cfp.customer_unique_id = oa.customer_unique_id
    GROUP BY 1, 2, 3
)
SELECT 
    TO_CHAR(cohort_month, 'YYYY-MM') AS cohort,
    COALESCE(MAX(CASE WHEN month_number = 0 THEN active_customers END), 0) AS m0,
    COALESCE(MAX(CASE WHEN month_number = 1 THEN active_customers END), 0) AS m1,
    COALESCE(MAX(CASE WHEN month_number = 2 THEN active_customers END), 0) AS m2,
    COALESCE(MAX(CASE WHEN month_number = 3 THEN active_customers END), 0) AS m3
FROM cohort_counts
GROUP BY 1
ORDER BY 1;





























