/*

Logistics and Customer Satisfaction Analysis:

Analysis:
    - How is the Review Score Distributed?
    - On-time vs Late delivery rate.
    - In which cities 'Late deliveries' occurs most?
	- Bottleneck Analysis: which stage of business causes 'Late Delivery' often?
	
*/

---------------------------------------
-- How is the Review Score Distributed?
---------------------------------------

SELECT 
	review_score,
	COUNT(*) AS total_reviews, 
	ROUND(COUNT(*) * 100 / SUM(COUNT(*)) OVER (), 2) || '%' AS reviews_percentage
FROM gold.reviews
GROUP BY 1
ORDER BY 1;


---------------------------------
-- On-time vs Late delivery rate.
---------------------------------

WITH delivery_metrics AS (
	SELECT
		order_status,
		order_delivered_customer_date,
		order_estimated_delivery_date,
		(order_estimated_delivery_date::DATE - order_delivered_customer_date::DATE) AS date_diff
	FROM gold.orders
	WHERE order_delivered_customer_date IS NOT NULL
) 
SELECT
	CASE WHEN date_diff < 0 THEN 'Late'
		 WHEN date_diff = 0 THEN 'On-Time (Exact)'
		 ELSE 'Early'
	END AS performance,
	COUNT(*) AS total_orders,
	ROUND(COUNT(*) * 100 / SUM(COUNT(*)) OVER (), 2) AS percentage
FROM delivery_metrics
GROUP BY 1


-------------------------------------------------
-- In which cities 'Late deliveries' occurs most?
-------------------------------------------------

WITH city_performance AS (
	SELECT 
		INITCAP(c.customer_city) AS delivery_city,
		CASE WHEN o.order_delivered_customer_date > o.order_estimated_delivery_date THEN 1
			ELSE 0
		END AS is_late
	FROM gold.orders o
    JOIN gold.customers c
        ON o.customer_id = c.customer_id
)
SELECT 
	delivery_city,
	SUM(is_late) AS total_late_orders,
	COUNT(*) AS total_orders,
	ROUND(SUM(is_late) * 100 / COUNT(*),1) AS late_pct_city
FROM city_performance
GROUP BY 1
HAVING COUNT(*) > 10
ORDER BY 3 DESC;


-----------------------------------------------------
-- Correlation between low-rating and late-deliveries
-----------------------------------------------------

WITH delivery_stat AS (
    SELECT 
        DISTINCT o.order_id,
        CASE WHEN o.order_delivered_customer_date > o.order_estimated_delivery_date THEN 'Late'
            ELSE 'On-Time/Early'
        END AS delivery_status,
        r.review_score
    FROM gold.orders o
    LEFT JOIN gold.reviews r 
		ON o.order_id = r.order_id
)
SELECT 
    delivery_status,
    COUNT(*) AS total_orders,
    ROUND(AVG(review_score), 2) AS avg_review_score,
    ROUND(SUM(
		CASE WHEN review_score <= 3 THEN 1 
			ELSE 0 
			END) * 100.0 / COUNT(*), 2) AS negative_review_rate_pct
FROM delivery_stat
GROUP BY 1;


-----------------------------------------------------------------------------
-- Bottleneck Analysis: which stage of business causes 'Late Delivery' often?
-----------------------------------------------------------------------------

WITH logistics_check AS (
	SELECT
		f.order_id,
		CASE WHEN f.shipping_limit_date < f.order_delivered_carrier_date THEN 1 ELSE 0
			END AS is_seller_late,
		CASE WHEN f.order_estimated_delivery_date < f.order_delivered_customer_date THEN 1 ELSE 0
			END AS is_carrier_late,
		r.review_score
	FROM gold.fact_sales f
	LEFT JOIN gold.reviews r 
		ON f.order_id = r.order_id
), 
summary AS (
	SELECT 
		CASE WHEN is_seller_late = 0 AND is_carrier_late = 0 THEN '1. Both On-Time!'
			 WHEN is_seller_late = 1 AND is_carrier_late = 0 THEN '2. Seller Late (Carrier Saved It!)'
			 WHEN is_seller_late = 0 AND is_carrier_late = 1 THEN '3. Carrier Late (Seller On-Time!)'
			 WHEN is_seller_late = 1 AND is_carrier_late = 1 THEN '4. Both Late!'
		END AS check_stages,
		COUNT(DISTINCT order_id) AS total_orders,
		ROUND(AVG(review_score), 2) AS avg_customer_rating
	FROM logistics_check
	GROUP BY 1
)
SELECT
	check_stages,
	total_orders,
	ROUND(total_orders * 100 / SUM(total_orders) OVER (), 2) || '%' AS pct_of_total,
	avg_customer_rating
FROM summary
ORDER BY 1;








