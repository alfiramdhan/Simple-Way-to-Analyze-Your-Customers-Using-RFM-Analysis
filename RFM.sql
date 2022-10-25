-- calculating RFM for sales_database
-- Find last_order (R), count_order (F) and avg_amount (M) value
-- with RFM_Cell as (
	with RFM_Quantiles as(
		-- Create RFM Value :
		with RFM_Value as(
			SELECT customer_id,
					MAX(order_date) as last_order,
					COUNT(*) as total_order,
					AVG(sales) as total_sales
			FROM store_data
			WHERE sales IS NOT Null
			GROUP BY 1
		)	
		
			-- Lets divides all users into quartiles using the NTILE function
			-- To create the quintiles,
			-- we’ll use an ntile window function that requires just a few lines of additional SQL at the top of your raw RFM Values Query.
			-- Create RFM Quintiles :
		SELECT customer_id,
				last_order,
				total_order,
				total_sales,
				ntile(4) OVER (ORDER BY last_order ASC) as rfm_recency,
				ntile(4) OVER (ORDER BY total_order DESC) as rfm_frequency,
				ntile(4) OVER (ORDER BY total_sales DESC) as rfm_monetary
		FROM RFM_Value
		ORDER BY rfm_recency DESC
	)	

-- let’s make the quintile rank for each metric to create a 3-digit number also known as a ‘cell’.
-- Creating RFM Cell
-- 	SELECT customer_id,
--   rfm_recency,
--   rfm_frequency,
--   rfm_monetary,
--   rfm_recency*100 + rfm_frequency*10 + rfm_monetary as rfm_cell
--   FROM RFM_Quantiles;
-- )
-- Once you’ve identified the segments you want to address and the conditions
-- for inclusion which is the RFM cell values associated with each
-- To do that, just use CASEstatements to return the segment name based on the RFM cell value:

SELECT customer_id,
		last_order,
		total_order,
		total_sales,
		rfm_recency,
		rfm_frequency,
		rfm_monetary,
		rfm_recency*100 + rfm_frequency*10 + rfm_monetary as rfm_cell,
CASE WHEN (rfm_recency >= 3) AND (rfm_frequency  >= 3 ) AND (rfm_monetary >= 3)  THEN 'Loyal Customer'
	WHEN (rfm_recency >= 3) AND (rfm_frequency  >= 3 ) AND (rfm_monetary between 1 and 3)  THEN 'Active Customer'
	WHEN (rfm_recency >= 3) AND (rfm_frequency between 1 and 2 ) AND (rfm_monetary >=3 )  THEN 'Promising New Customer'
	WHEN (rfm_recency >= 3) AND (rfm_frequency between 1 and 2 ) AND (rfm_monetary between 1 and 2)  THEN 'New Customer'
	WHEN (rfm_recency between 2 and 3) AND (rfm_frequency between 1 and 3 ) AND (rfm_monetary >=3 ) THEN 'Potential Churners'
	WHEN (rfm_recency between 2 and 3) AND (rfm_frequency between 1 and 4 ) AND (rfm_monetary between 1 and 4 )  THEN 'Need Attention'
	WHEN (rfm_recency between 1 and 2) AND (rfm_frequency between 1 and 4) AND (rfm_monetary between 1 and 4 ) THEN 'Lost'
ELSE 'other' END as rfm_segment
FROM RFM_Quantiles
ORDER BY rfm_segment DESC;
