## Create RFM Quintiles :

- Lets divides all users into quartiles using the NTILE function
- To create the quintiles, we’ll use an ntile window function that requires just a few lines of additional SQL at the top of your raw RFM Values Query.

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
    total_order, #you can show or not#
    total_sales, #you can show or not#
    ntile(4) OVER (ORDER BY last_order ASC) as rfm_recency,
    ntile(4) OVER (ORDER BY total_order DESC) as rfm_frequency,
    ntile(4) OVER (ORDER BY total_sales DESC) as rfm_monetary
  FROM RFM_Value
  ORDER BY rfm_recency DESC;
  ```
