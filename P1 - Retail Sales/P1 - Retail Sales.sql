SELECT * FROM retail_sales LIMIT 10;

--
SELECT COUNT(*) FROM retail_sales;

--
SELECT * FROM retail_sales 
WHERE
	transactions_id IS NULL
	OR 
	sale_date IS NULL
	OR
	sale_time IS NULL
	OR
	customer_id IS NULL
	OR
	gender IS NULL
	OR
	age IS NULL
	OR 
	category IS NULL
	OR
	quantity IS NULL
	OR 
	price_per_unit IS NULL
	OR
	cogs IS NULL
	OR
	total_sale IS NULL;
	
-- 
SELECT * FROM retail_sales WHERE gender='Female' and age > (SELECT AVG(age) FROM retail_sales WHERE gender='Female');

--
UPDATE retail_sales SET age = (SELECT AVG(age) FROM retail_sales WHERE gender='Male') WHERE gender='Male' AND age is NULL;

--
SELECT * FROM retail_sales WHERE gender='Male' and age IS NULL;
	
--
DELETE FROM retail_sales 
WHERE
	transactions_id IS NULL
	OR 
	sale_date IS NULL
	OR
	sale_time IS NULL
	OR
	customer_id IS NULL
	OR
	gender IS NULL
	OR
	age IS NULL
	OR 
	category IS NULL
	OR
	quantity IS NULL
	OR 
	price_per_unit IS NULL
	OR
	cogs IS NULL
	OR
	total_sale IS NULL;
	
	
	
-- Data Explorations

-- How many transactions?
SELECT COUNT(*) AS total_sales FROM retail_sales;

-- No of unique customers
SELECT COUNT(DISTINCT customer_id) FROM retail_sales;

-- Unique Category
SELECT DISTINCT category FROM retail_sales;



-- Data Analysis & Findings

-- Write a SQL query to retrieve all columns for sales made on '2022-11-05
SELECT * FROM retail_sales WHERE sale_date='2022-11-05';


-- Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022
SELECT * 
FROM retail_sales
WHERE TO_CHAR(sale_date, 'YYYY-MM')='2022-11' AND category='Clothing' AND quantity >= 3;


-- Write a SQL query to calculate the total sales (total_sale) for each category.
SELECT category, COUNT(*) AS total_orders, SUM(total_sale) AS net_sale
FROM retail_sales 
GROUP BY category;

-- Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
SELECT ROUND(AVG(age), 2) AS avg_age
FROM retail_sales
WHERE category='Beauty';

-- Write a SQL query to find all transactions where the total_sale is greater than 1000
SELECT * 
FROM retail_sales
WHERE total_sale > 1000;


-- Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category
SELECT gender, category, COUNT(transactions_id) AS total_transaction
FROM retail_sales
GROUP BY gender, category;


-- Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
SELECT year, month, avg_sale
FROM 
	(SELECT 
		EXTRACT(YEAR FROM sale_date) AS year,
		EXTRACT(MONTH FROM sale_date) as month,
		ROUND(AVG(total_sale), 2) AS avg_sale,
		RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY ROUND(AVG(total_sale), 2) DESC) as rank 
	FROM retail_sales
	GROUP BY 1, 2
	ORDER BY 1, 3 DESC) AS t
WHERE rank=1;


-- Write a SQL query to find the top 5 customers based on the highest total sales 
SELECT customer_id, SUM(total_sale) AS total_sale
FROM retail_sales
GROUP BY customer_id
ORDER BY customer_id DESC
LIMIT 5;


-- Write a SQL query to find the customers who purchased from each category
SELECT customer_id, COUNT(DISTINCT category) AS cat_count
FROM retail_sales
GROUP BY customer_id
having COUNT(DISTINCT category) = 3
ORDER BY customer_id;


-- Write a SQL query to find the number of unique customers who purchased items from each category
SELECT category, COUNT(DISTINCT customer_id)
FROM retail_sales
GROUP BY category;


-- Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)
WITH hourly_sale
AS
(SELECT *, 
	CASE
		WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
		WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
		ELSE 'Evening'
	END AS shift
FROM retail_sales)
SELECT shift, COUNT(transactions_id) as total_orders
FROM hourly_sale
GROUP BY shift




















