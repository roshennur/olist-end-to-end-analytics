/*

Product Performance Analysis:

Analysis:
    - Total Revenue & AOV & Cumulative revenue percentage by Product Category.
    - Total orders and Order share percent volume by Product Category.
    - Categories with high revenue & low rating nr.
	- Most ordered and Highest revenue products.
	
*/

----------------------------------------------------------------------------
--  Total Revenue & AOV & Cumulative revenue percentage by Product Category.
----------------------------------------------------------------------------

WITH category_revenue AS (
	SELECT 
		p.category AS category_name,
		SUM(f.total_amount) AS total_revenue,
		COUNT(DISTINCT f.order_id) AS total_orders
	FROM gold.fact_sales f
	JOIN gold.products p
		ON f.product_id = p.product_id
	GROUP BY 1
), 
category_analysis AS (
	SELECT
		category_name,
		total_revenue,
		total_orders,
		ROUND(total_revenue / total_orders, 2) AS aov,
		ROUND(
			total_revenue / SUM(total_revenue) OVER () * 100
		, 2) AS revenue_per,
		ROUND( 
			SUM(total_revenue) OVER (ORDER BY total_revenue DESC)
			/ SUM(total_revenue) OVER () * 100
		, 2 ) AS cumulative_revenue_per
	FROM category_revenue
)
SELECT *
FROM category_analysis
ORDER BY 2 DESC;


-----------------------------------------------------------
-- Total orders and Order share percent volume by category.
-----------------------------------------------------------

SELECT 
	p.category AS category_name,
	COUNT(DISTINCT f.order_id) AS total_orders,
	ROUND(
		COUNT(DISTINCT f.order_id) / 
		SUM(COUNT(DISTINCT f.order_id)) OVER () * 100
	, 2) AS order_share_percent
FROM gold.fact_sales f
JOIN gold.products p
	ON f.product_id = p.product_id
GROUP BY 1
ORDER BY 2 DESC;


------------------------------------------------
-- Categories with high revenue & low rating nr.
------------------------------------------------

SELECT
    p.category AS category_name,
	ROUND(SUM(DISTINCT f.total_amount), 2) AS total_revenue,
	COUNT(DISTINCT f.order_id) AS total_orders,
    ROUND(AVG(r.review_score),2) AS avg_review_score,
    COUNT(DISTINCT r.review_id) AS total_reviews
FROM gold.fact_sales f
JOIN gold.reviews r
    ON r.order_id = f.order_id
JOIN gold.products p
    ON f.product_id = p.product_id
GROUP BY 1
HAVING ROUND(AVG(r.review_score),2) < 3.8
ORDER BY 2 DESC;


---------------------------------------------
-- Most ordered and Highest revenue products.
---------------------------------------------

SELECT 
	p.product AS product_name,
	p.category AS category_name,
	COUNT(*) AS total_ordered,
	SUM(f.total_amount) AS total_revenue
FROM gold.fact_sales f
LEFT JOIN gold.products p
	ON f.product_id = p.product_id
GROUP BY 1, 2
ORDER BY 3 DESC;






