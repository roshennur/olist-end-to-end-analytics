/*

Sales and Trend Analysis:

Analysis:
    - Calculate total revenue, total order and AOV for each year.
    - Month-Over-Month revenue growth in percentage.
    - What is the highest/lowest revenue months each year?
	- Which states has highest contribution to total revenue?
	
*/

--------------------------------------------------------------
-- Calculate total revenue, total order and AOV for each year.
--------------------------------------------------------------

SELECT
	EXTRACT(YEAR FROM order_purchase_timestamp) AS order_date,
	ROUND(SUM(total_amount), 2) AS total_revenue,
	COUNT(DISTINCT order_id) AS total_order,
	ROUND(SUM(total_amount) / COUNT(DISTINCT order_id), 2)  AS aov
FROM gold.fact_sales
GROUP BY 1
ORDER BY 1;

-------------------------------------------------
-- Month-Over-Month revenue growth in percentage.
-------------------------------------------------

WITH monthly_order AS (
	SELECT 
		EXTRACT(YEAR FROM order_purchase_timestamp) AS order_year,
		EXTRACT(MONTH FROM order_purchase_timestamp) AS order_month,
		ROUND(SUM(total_amount), 2) AS total_revenue
	FROM gold.fact_sales
	GROUP BY 1, 2
), 
previous_revenue AS (
	SELECT 
		order_year,
		order_month,
		total_revenue,
		LAG(total_revenue) OVER (ORDER BY order_year, order_month) AS prev_revenue
	FROM monthly_order
)
SELECT
	order_year,
	order_month,
	ROUND(total_revenue,2) AS total_revenue,
	ROUND(total_revenue - prev_revenue,2) AS mom_revenue,
	ROUND((total_revenue - prev_revenue) / NULLIF(prev_revenue, 0) * 100,1) || '%' AS mom_percentage
FROM previous_revenue
ORDER BY 1, 2;


-------------------------------------------------------
-- What is the highest/lowest revenue months each year?
-------------------------------------------------------

WITH monthly_revenue AS (
	SELECT 
		EXTRACT(YEAR FROM order_purchase_timestamp) AS order_year,
		EXTRACT(MONTH FROM order_purchase_timestamp) AS order_month,
		SUM(total_amount) AS revenue
	FROM gold.fact_sales
	GROUP BY 1, 2
),
ranked_months AS (
	SELECT 
		order_year,
		order_month,
		revenue,
		RANK() OVER (PARTITION BY order_year ORDER BY revenue DESC) AS highest_rank,
		RANK() OVER (PARTITION BY order_year ORDER BY revenue ASC) AS lowest_rank
	FROM monthly_revenue
)
SELECT
	order_year,
	order_month,
	revenue,
	CASE WHEN highest_rank = 1 THEN 'Highest Revenue Month'
		WHEN lowest_rank = 1 THEN 'Lowest Revenue Month'
	END AS revenue_rank
FROM ranked_months
WHERE highest_rank = 1 OR lowest_rank = 1
ORDER BY 1, 3;


----------------------------------------------------------
-- Which states has highest contribution to total revenue?
----------------------------------------------------------

SELECT 
	c.customer_state,
	SUM(f.total_amount) AS revenue,
	ROUND(SUM(f.total_amount) / 
		SUM(SUM(f.total_amount)) OVER () * 100, 2) AS revenue_share_per
FROM gold.fact_sales f
JOIN gold.customers c
	ON f.customer_id = c.customer_id
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;




