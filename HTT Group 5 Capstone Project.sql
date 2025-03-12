--10 Analytical Questions and Queries.


--Question 1. Calculate the average revenue generated per month? 
SELECT to_char(occurred_at, 'month') AS month_name, 
       ROUND(AVG(total_amt_usd), 2) AS average_revenue_usd
FROM orders
GROUP BY month_name
ORDER BY average_revenue_usd DESC;

--Question 2. How many customers placed an order per year in Parch and Posey 
SELECT DATE_PART('year', occurred_at) AS year,
       COUNT(DISTINCT account_id) AS number_of_customers
FROM orders
GROUP BY year
ORDER BY year DESC;

--Question 3. What did each sales rep generate in revenue in the 2016 year
SELECT sales_reps.name,
     SUM(orders.total_amt_usd) AS revenue_generated
FROM sales_reps
JOIN accounts
ON sales_reps.id = accounts.sales_rep_id
JOIN orders
ON accounts.id = orders.account_id
WHERE orders.occurred_at::text LIKE '2016%'
GROUP BY sales_reps.name
ORDER BY revenue_generated DESC;

--Question 4. Which customer accounts generate the highest sales revenue
--what are their key attributes, such as industry, location, and purchase history? 
SELECT orders.account_id, accounts.name AS customers_name, region.name AS region,
       SUM(orders.total_amt_usd)AS total_money_spent,
	   MAX(orders.occurred_at) AS transaction_date
FROM orders 
JOIN accounts 
ON orders. account_id = accounts. id
JOIN sales_reps
ON accounts.sales_rep_id = sales_reps.id
JOIN region
ON sales_reps.region_id = region.id
GROUP BY orders.account_id, accounts.name, region.name
ORDER BY total_money_spent DESC;

--Question 5. How does the number of sales representatives in each region correlate with 
--the revenue distribution across different paper types and total revenue?
SELECT region.name AS region,
    COUNT(DISTINCT sales_reps.name) AS total_sales_reps,
    SUM(standard_amt_usd) AS Standard_paper_revenue,
    SUM(gloss_amt_usd) AS gloss_paper_revenue,
    SUM(poster_amt_usd) AS poster_paper_revenue,
    SUM(total_amt_usd) AS total_revenue
FROM orders
JOIN accounts
ON orders.account_id = accounts.id
JOIN sales_reps
ON accounts.sales_rep_id = sales_reps.id
JOIN region
ON sales_reps.region_id = region.id
GROUP BY region.name
ORDER BY total_revenue DESC;

--Question 6. Identify top 20 customers whose orders exceed the average order value. 
SELECT accounts.id AS customer_id,
       accounts.name AS customer_name, 
	   ROUND(AVG(orders.total_amt_usd), 2) AS average_order_value
FROM orders
JOIN accounts
ON orders.account_id = accounts.id
GROUP BY customer_id, customer_name
ORDER BY average_order_value DESC
LIMIT 20;

--Question. 7 How many responses were gotten from each channel
SELECT channel, COUNT(channel) AS total_channel_responses
FROM web_events
GROUP BY channel
ORDER BY total_channel_responses DESC;

--Question 8. What is the yearly trend in revenue growth or decline over time, 
--by paper type?
SELECT DATE_PART('year', orders.occurred_at) AS year,
	   SUM(orders.standard_amt_usd) AS standard_paper_revenue,
	   SUM(orders.gloss_amt_usd) AS gloss_paper_revenue,
	   SUM(orders.poster_amt_usd) AS poster_paper_revenue
FROM orders
GROUP BY year
ORDER BY year;

--Question 9. What percentage of total revenue comes from each paper type?
SELECT CONCAT(ROUND(SUM(standard_amt_usd) / 
       SUM(total_amt_usd) * 100, 5), '%') AS standard_revenue_pct,
       CONCAT(ROUND(SUM(gloss_amt_usd) / 
	   SUM(total_amt_usd) * 100, 5), '%') AS gloss_revenue_pct,
	   CONCAT(ROUND(SUM(poster_amt_usd) / 
	   SUM(total_amt_usd) * 100, 5), '%') AS poster_revenue_pct
FROM orders;
 
--Question 10. What is the total revenue generated from each channel?
SELECT web_events.channel AS communication_channels,
	SUM(orders.total_amt_usd) AS total_revenue
FROM orders
JOIN web_events 
ON orders.account_id = web_events.account_id
GROUP BY web_events.channel
ORDER BY total_revenue DESC;








