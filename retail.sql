CREATE TABLE retail_sales(
		transactions_id	INT PRIMARY KEY,
		sale_date DATE,
		sale_time	TIME,
		customer_id	INT,
		gender	VARCHAR(10),
		age	INT,
		category VARCHAR(50),	
		quantiy	INT,
		price_per_unit	INT,
		cogs	FLOAT,
		total_sale FLOAT

);

SELECT * FROM ret
SELECT COUNT(*) FROM retail_sales;

SELECT * FROM retail_sales
LIMIT 10;

SELECT COUNT(*) FROM retail_sales;

-- Cehck Null Values 

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
	quantiy IS NULL 
	OR 
	price_per_unit IS NULL 
	OR 
	cogs IS NULL 
	OR 
	total_sale IS NULL;

-- DELETE THIS NULL ROWS 

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
	quantiy IS NULL 
	OR 
	price_per_unit IS NULL 
	OR 
	cogs IS NULL 
	OR 
	total_sale IS NULL;

-- DATA EXPLORATION 

-- How many sales we have 

SELECT COUNT(*) as totalsales
FROM retail_sales;

-- How many unique customers we have ?

SELECT COUNT(DISTINCT customer_id)
FROM retail_sales;

-- know how many times each customer purchase something ?

SELECT customer_id , COUNT(customer_id) as PurchaseTotal
FROM retail_sales 
GROUP BY customer_id
ORDER BY PurchaseTotal DESC;

-- How many uniquee categories are there ? 

SELECT category , COUNT(category)
FROM retail_Sales
GROUP BY category;

-- which category sold most ?

SELECT category , count(category) as total
FROM retail_sales 
GROUP BY category
ORDER BY total DESC;

-- How many quantity is sold per category 

SELECT category , SUM(quantiy) as total
FROM retail_sales
GROUP BY category 
ORDER BY total DESC;

-- which customer invested more money in purchasing ?

SELECT customer_id , SUM(total_sale) as Investment
FROM retail_sales
GROUP BY customer_id
ORDER BY Investment DESC;

-- Money Invested in each category 

SELECT category , SUM(total_sale) as Total
FROM retail_sales
GROUP BY category
ORDER BY total DESC;

-- BUSINESS RELATED PROBLEMS 

-- Q1. Write a SQL Query to retrieve all columns for sales made on 2022-11-05

SELECT *
FROM retail_sales
where sale_date = '2022-11-05';

-- Q2. Write a SQL Query to retireve all transactions where the category is 'clothing' and the quantity sold 
-- is more than 4 in the month of NOV - 2022

SELECT *
FROM retail_sales 
WHERE 
	category = 'Clothing'
	AND 
	TO_CHAR(sale_date , 'YYYY-MM') = '2022-11'
	AND quantiy >= 4 ;

-- since the highest quantity is 4 . so for each month how many times a product is purchased from each category 4 times 

SELECT
	EXTRACT(YEAR FROM sale_date) AS year,
    EXTRACT(MONTH FROM sale_date) AS month,
    category,
    COUNT(*) AS times_quantiy_4_sold
FROM retail_sales
WHERE quantiy = 4
GROUP BY 1,2,3
ORDER BY 1,4 DESC;



-- I want to just calculate what is the toal sale in month on november per category

SELECT SUM(total)
FROM(
SELECT category , SUM(total_sale) as total
FROM retail_sales
WHERE TO_CHAR(sale_date , 'YYYY-MM') = '2022-11'
GROUP BY category);

-- Q3. Write  a SQL query to calculate the total sales ( for each category) :

SELECT 
	category , 
	SUM(total_sale) as total_sales,
	COUNT(*) AS total_orders
FROM retail_sales
GROUP BY category
ORDER BY total_sales DESC;

-- Q4. Write a SQL query to find the evrage age of customers who purchased items from the 'Beauty' category

SELECT ROUND(AVG(age),2)  
FROM retail_sales 
WHERE category = 'Beauty' ;

-- Q5. Write a SQL query to find all transactions where the total_sale is greater than 1000.

SELECT *
FROM retail_sales
WHERE total_sale > 1000;

-- Q6. Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.:

SELECT 
		category,
		gender,
		COUNT(transactions_id)
FROM retail_sales 
GROUP BY category , gender;

-- Q7. Write a SQL query to calculate the average sale for each month. Find out best selling month in each year:

SELECT 
	year , 
	month,
	avg_sale
FROM
(
	SELECT 
		EXTRACT(YEAR FROM sale_date) AS year ,
		EXTRACT(MONTH FROM sale_date ) AS month ,
		AVG(total_sale) AS avg_sale,
		RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) as rank
	FROM retail_sales
	
	GROUP BY 
		1 , 2
) AS t1
WHERE rank = 1


-- Q8. Write a SQL query to find the top 5 customers based on the highest total sales 

SELECT 
	customer_id,
	SUM(total_sale) as total_sale
FROM retail_sales 
GROUP BY customer_id
ORDER BY 2 DESC
LIMIT 5;

-- Q9. Write a SQL query to find the number of unique customers who purchased items from each category.

SELECT 
	category,
	COUNT(DISTINCT(customer_id)) cnt_unque_cs
FROM retail_sales
GROUP BY category

-- those customer who bought atleast one thing from each category '

SELECT 
	customer_id
FROM retail_sales
GROUP BY customer_id
HAVING 
	COUNT(DISTINCT category) = 
		(SELECT COUNT(DISTINCT category) 
		FROM retail_sales);

-- Q10. Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17):

WITH hourly_sale
AS
(SELECT * , 
    CASE
        WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
        WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END as shift
FROM retail_sales)

SELECT 
	shift ,
	COUNT(*) As no_of_orders
FROM hourly_sale
GROUP BY shift
ORDER BY no_of_orders DESC