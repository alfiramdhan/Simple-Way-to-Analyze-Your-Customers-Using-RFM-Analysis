## Create RFM Cell
- STEP - 3

```sql
with RFM_Quantiles as(
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
         total_order,
         total_sales,
         ntile(4) OVER (ORDER BY last_order ASC) as rfm_recency,
         ntile(4) OVER (ORDER BY total_order DESC) as rfm_frequency,
         ntile(4) OVER (ORDER BY total_sales DESC) as rfm_monetary
  FROM RFM_Value
  ORDER BY rfm_recency DESC
)
SELECT customer_id,
  rfm_recency,
  rfm_frequency,
  rfm_monetary,
  rfm_recency*100 + rfm_frequency*10 + rfm_monetary as rfm_cell
  FROM RFM_Quantiles;
  ```
