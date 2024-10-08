-- SQL Retail Sales Analysis

CREATE DATABASE sql_project_p2;

-- CREATE TABLE

CREATE TABLE retail_sales(
			transactions_id	INT PRIMARY KEY,
			sale_date DATE,
			sale_time TIME,
			customer_id	INT,
			gender VARCHAR(10),
			age	INT,
			category VARCHAR(15),
			quantiy	INT,
			price_per_unit FLOAT,	
			cogs FLOAT,
			total_sale FLOAT
 		);

SELECT * FROM retail_sales
LIMIT 10;

SELECT COUNT(*) 
FROM retail_sales
LIMIT 10;

-- Data Cleaning

SELECT * FROM retail_sales 
WHERE transactions_id IS NULL;

SELECT * FROM retail_sales 
WHERE sale_date IS NULL;

SELECT * FROM retail_sales 
WHERE sale_time IS NULL;

SELECT * FROM retail_sales 
WHERE gender IS NULL;

SELECT * FROM retail_sales
WHERE
	transactions_id IS NULL
	OR sale_date IS NULL
	OR sale_time IS NULL
	OR gender IS NULL
	OR category IS NULL
	OR quantiy IS NULL
	OR price_per_unit IS NULL
	OR cogs IS NULL
	OR total_sale IS NULL;
	
-- 

DELETE FROM retail_sales
WHERE
	transactions_id IS NULL
	OR sale_date IS NULL
	OR sale_time IS NULL
	OR gender IS NULL
	OR category IS NULL
	OR quantiy IS NULL
	OR price_per_unit IS NULL
	OR cogs IS NULL
	OR total_sale IS NULL;

-- Data Exploration

-- How many sales we have?
SELECT COUNT(*) FROM retail_sales;

-- How many unique customers we have?
SELECT COUNT(DISTINCT customer_id) as total_sales FROM retail_sales;

-- How many categories we have?
SELECT COUNT(DISTINCT category) as total_category FROM retail_sales;

ALTER TABLE retail_sales RENAME COLUMN quantiy TO quantity;

-- Data Analysis and Business Key Problems & Answers

-- My Analysis and findings:
-- Q1. Write a SQL Query to retrieve all columns for sales made on '2022-11-05'
-- Q2. Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in 
-- the month of Nov-2022
-- Q3. Write a SQL query to calculate the total sales(total_sale) for each category.
-- Q4. Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
-- Q5. Write a SQL query to find all transactions where the total_sale is greater than 1000.
-- Q6. Write a SQL query to find the total number of transactions(transaction_id) made by each gender in each catefory.
-- Q7. Write a SQL query to calculate the average sale for each month, find out the best selling month in each year.
-- Q8. Write a SQL query to find the top 5 customers based on the highest total sales.
-- Q9. Write a SQL query to find the number of unique customers who purchased items from each category.
-- Q10. Write a SQL query to create each shift and number of orders ( Example: Morning<=12, Afternoon Between 12 & 17, Evening > 17)

-- Q1. Write a SQL Query to retrieve all columns for sales made on '2022-11-05'

SELECT *
FROM retail_sales
WHERE sale_date = '2022-11-05';


-- Q2. Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in 
-- the month of Nov-2022

SELECT *
FROM retail_sales
WHERE category = 'Clothing' 
	AND 
	TO_CHAR(sale_date,'YYYY-MM') = '2022-11'
	AND quantity >= 4;

-- Q3. Write a SQL query to calculate the total sales(total_sale) for each category.

SELECT
		category,
		SUM(total_sale) AS Total_sale,
		COUNT(*) AS Total_Orders
		FROM retail_sales
GROUP BY category;

-- Q4. Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.

SELECT 
	ROUND(avg(age),2) as Average_age
FROM retail_Sales
WHERE category = 'Beauty';

-- Q5. Write a SQL query to find all transactions where the total_sale is greater than 1000.

SELECT *
FROM retail_sales
WHERE total_sale > 1000;

-- Q6. Write a SQL query to find the total number of transactions(transaction_id) made by each gender in each catefory.

SELECT
category,gender,COUNT(*)
FROM retail_sales
GROUP BY category,gender
ORDER BY 1;


-- Q7. Write a SQL query to calculate the average sale for each month, find out the best selling month in each year.

SELECT 
	year, month, avg_sale
FROM (
	SELECT 
		EXTRACT(YEAR FROM sale_date) as year,
		EXTRACT(MONTH FROM sale_date) as month,
		AVG(total_sale) as avg_sale,
		RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) as rank
	FROM retail_sales
	GROUP BY 1, 2
) as t1
WHERE rank = 1
--ORDER BY 1,3 DESC

-- Q8. Write a SQL query to find the top 5 customers based on the highest total sales.

SELECT customer_id, SUM(total_sale) as total_Sales FROM retail_sales
GROUP BY customer_id
ORDER BY 2 DESC
LIMIT 5;

-- Q9. Write a SQL query to find the number of unique customers who purchased items from each category.

SELECT COUNT (DISTINCT customer_id) as Unique_Customer,category 
FROM retail_sales
GROUP BY category;

-- Q10. Write a SQL query to create each shift and number of orders ( Example: Morning<12, Afternoon Between 12 & 17, Evening > 17)

WITH shift_sales AS(
SELECT *,
	CASE
		WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
		WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
		ELSE 'Evening'
	END as shift
FROM retail_sales
)
SELECT shift, 
		COUNT(*)
FROM shift_sales
GROUP BY shift


--Q11. Calculate the profit margin for each category
SELECT 
    category,
    SUM(total_sale) AS total_revenue,
    ROUND(SUM(cogs)::numeric,2) AS total_cost,
    ROUND(SUM(total_sale - cogs)::numeric,2) AS total_profit,
    ROUND((SUM(total_sale - cogs) / SUM(total_sale) * 100)::numeric,2) AS profit_margin_percentage
FROM 
    retail_sales
GROUP BY 
    category
ORDER BY 
    profit_margin_percentage DESC;

-- Q12. Identify the busiest hour of the day in terms of number of transactions, grouped by each day of the week

SELECT 
    TO_CHAR(sale_date, 'Day') AS day_of_week,
    EXTRACT(HOUR FROM sale_time) AS hour_of_day,
    COUNT(*) AS transaction_count
FROM 
    retail_sales
GROUP BY 
    TO_CHAR(sale_date, 'Day'),
    EXTRACT(HOUR FROM sale_time)
ORDER BY 
    transaction_count DESC,
	TO_CHAR(sale_date, 'Day');

--  END OF THE PROJECT

--SELECT EXTRACT(HOUR FROM sale_time)
--FROM retail_sales



