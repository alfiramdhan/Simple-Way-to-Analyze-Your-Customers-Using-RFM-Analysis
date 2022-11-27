## Create RFM Value :
- STEP - 1

```sql
		with RFM_Value as(
			SELECT customer_id,
					MAX(order_date) as last_order,
					COUNT(*) as total_order,
					AVG(sales) as total_sales
			FROM store_data
			WHERE sales IS NOT Null
			GROUP BY 1
		)	
		 SELECT customer_id,
				last_order,
				total_order,
				total_sales,
				ntile(4) OVER (ORDER BY last_order ASC) as rfm_recency,
				ntile(4) OVER (ORDER BY total_order DESC) as rfm_frequency,
				ntile(4) OVER (ORDER BY total_sales DESC) as rfm_monetary
		FROM RFM_Value
		ORDER BY rfm_recency DESC;
    ```
