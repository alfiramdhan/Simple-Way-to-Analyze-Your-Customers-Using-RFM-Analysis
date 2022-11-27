## Create RFM Value :
- STEP - 1

```sql
SELECT customer_id,
        MAX(order_date) as last_order,
        COUNT(*) as total_order,
        AVG(sales) as total_sales
FROM store_data
WHERE sales IS NOT Null
GROUP BY 1;
```
