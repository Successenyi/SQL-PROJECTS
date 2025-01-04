--sql Retail Sales Analysis 
create database sql_projects

--create table
CREATE TABLE  retail_sales
(
	transactions_id INT PRIMARY KEY,
	sale_date DATE,
	sale_time TIME,
	customer_id INT,
	gender VARCHAR(15),
	age	INT,
	category VARCHAR(20),
	quantiy INT,
	price_per_unit FLOAT,
	cogs FLOAT,
	total_sale FLOAT
)

ALTER TABLE retail_sales
RENAME COLUMN quantiy TO quantity;

SELECT * FROM retail_sales
LIMIT 10

SELECT
	COUNT(*) 
FROM retail_sales

SELECT * FROM retail_sales
WHERE transactions_id IS NULL

SELECT * FROM retail_sales
WHERE sale_date IS NULL


--Data cleaning
SELECT * FROM retail_sales
	WHERE 
	transactions_id IS NULL
	OR
	sale_date IS NULL
	OR
	sale_time IS NULL
	OR
	gender IS NULL
	OR
	age IS NULL
	OR
	category IS NULL
	OR
	quantity IS NULL
	OR
	cogs IS NULL
	OR
	total_sale IS NULL

DELETE FROM retail_sales
	WHERE 
		transactions_id IS NULL
		OR
		sale_date IS NULL
		OR
		sale_time IS NULL
		OR
		gender IS NULL
		OR
		age IS NULL
		OR
		category IS NULL
		OR
		quantity IS NULL
		OR
		cogs IS NULL
		OR
		total_sale IS NULL
		
---Data Exploration
--what's the no of total sales

SELECT 
	COUNT(*) AS total_sales
FROM retail_sales;

--How many unique customers do we have
SELECT 
	COUNT(DISTINCT customer_id) AS total_customer
FROM retail_sales;


--Business key problems

--Write an SQL query to retrieve all columns for sales on "2022-11-05" 
SELECT *
FROM retail_sales
WHERE sale_date = '2022-11-05';

SELECT *
FROM retail_sales
WHERE customer_id ='102';

--Write a sql query to retrieve all transactions where the category is 'clothing' and 
--the quantity sold is more than 4 in the month of nov-2022

SELECT *
FROM retail_sales 
	WHERE category ='Clothing'
	AND TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
	AND quantity >= 4; 

--Write an sql query to find the total sales and total orders for each category

SELECT category,
	SUM(total_sale) AS total_sales,
	COUNT(*) AS total_orders
FROM retail_sales
GROUP BY category;

--Write a sql query to find the
--average age of customers who purchased items from the 'beauty' category

SELECT 
	ROUND(AVG(age), 1) AS Average_age
FROM retail_sales
WHERE category = 'Beauty'
GROUP BY category;

--Write a sql query to find all transactions where 
--the total_sale is greater than 1000

SELECT transactions_id, total_sale
FROM retail_sales
WHERE total_sale >= 1000;

--Write a sql query to find the total number of transactions
--(transaction_id) made by each gender in each category

SELECT
	 category AS category,
	 gender,
	 COUNT(*) AS total_sales
FROM retail_sales
 
GROUP 
	BY 
	category,
	gender
ORDER BY category;	

--Write a sql to calculate the average sale for each month. 
--find out the best selling month in each year
 SELECT 
 	YEAR,
	MONTH,
	total_sale
 FROM
(
	SELECT 
	    EXTRACT(YEAR FROM sale_date) AS year,
	    EXTRACT(MONTH FROM sale_date) AS month,
		AVG(total_sale) AS total_sale,
		RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC)
	FROM retail_sales
	GROUP BY 1,2	
) AS TABLE1
WHERE RANK = 1


-- write a sql query to find the
--top 5 cutomers based on the highest total sales

SELECT 
	customer_id,
	SUM(total_sale) AS total_sales
FROM retail_sales
GROUP BY customer_id
ORDER BY 2 DESC
LIMIT 5;

--write a sql query to find the number of unique 
--customers who purchased items from each category

SELECT 
	category,
	COUNT( DISTINCT customer_id) AS UNIQUE_CUSTOMERS
FROM retail_sales
GROUP BY 1;

--Write a sql query to create each shift and number
--of orders(example Morning < 12, Afernoon between 12 and 17, Evening > 17)

WITH Hourly_sales
AS
(
SELECT *,
	CASE
		WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
		WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
		ELSE 'Evening'
	END AS shift
FROM retail_sales
)
SELECT 
	shift,
	COUNT(*) AS total_orders
FROM hourly_sales
GROUP BY shift;






