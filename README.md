# Retail Sales Analysis SQL Project

## Project Overview

**Project Title**: Retail Sales Analysis  
**Level**: Beginner  
**Database**: `p1_retail_db`

This project is designed to demonstrate SQL skills and techniques typically used by data analysts to explore, clean, and analyze retail sales data. The project involves setting up a retail sales database, performing exploratory data analysis (EDA), and answering specific business questions through SQL queries. This project is ideal for those who are starting their journey in data analysis and want to build a solid foundation in SQL.

## Objectives

1. **Set up a retail sales database**: Create and populate a retail sales database with the provided sales data.
2. **Data Cleaning**: Identify and remove any records with missing or null values.
3. **Exploratory Data Analysis (EDA)**: Perform basic exploratory data analysis to understand the dataset.
4. **Business Analysis**: Use SQL to answer specific business questions and derive insights from the sales data.

## Project Structure

### 1. Database Setup

- **Database Creation**: The project starts by creating a database named `p1_retail_db`.
- **Table Creation**: A table named `retail_sales` is created to store the sales data. The table structure includes columns for transaction ID, sale date, sale time, customer ID, gender, age, product category, quantity sold, price per unit, cost of goods sold (COGS), and total sale amount.

```sql
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
```

### 2. Data Exploration & Cleaning

- **Record Count**: Determine the total number of records in the dataset.
- **Customer Count**: Find out how many unique customers are in the dataset.
- **Category Count**: Identify all unique product categories in the dataset.
- **Null Value Check**: Check for any null values in the dataset and delete records with missing data.

```sql
SELECT COUNT(*) FROM retail_sales;
SELECT COUNT(DISTINCT customer_id) FROM retail_sales;
SELECT DISTINCT category FROM retail_sales;

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

```

### 3. Data Analysis & Findings

The following SQL queries were developed to answer specific business questions:

1. **know how many times each customer purchase something ?**
```sql
SELECT customer_id , COUNT(customer_id) as PurchaseTotal
FROM retail_sales 
GROUP BY customer_id
ORDER BY PurchaseTotal DESC;
```
2. **which category sold most ?**
```sql
SELECT category , count(category) as total
FROM retail_sales 
GROUP BY category
ORDER BY total DESC;
```
3. **How many quantity is sold per category ?**
```sql
SELECT category , SUM(quantiy) as total
FROM retail_sales
GROUP BY category 
ORDER BY total DESC;
```
4. **which customer invested more money in purchasing ?**
```sql
SELECT customer_id , SUM(total_sale) as Investment
FROM retail_sales
GROUP BY customer_id
ORDER BY Investment DESC;
```
5. **Money gained from each category**
```sql
SELECT category , SUM(total_sale) as Total
FROM retail_sales
GROUP BY category
ORDER BY total DESC;
```

6. **Write a SQL query to retrieve all columns for sales made on '2022-11-05**:
```sql
SELECT *
FROM retail_sales
WHERE sale_date = '2022-11-05';
```

7. **Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022**:
```sql
SELECT 
  *
FROM retail_sales
WHERE 
    category = 'Clothing'
    AND 
    TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
    AND
    quantity >= 4
```
8. **For each month how many times a product is purchased from each category 4 times ?**
```sql
SELECT
	EXTRACT(YEAR FROM sale_date) AS year,
    EXTRACT(MONTH FROM sale_date) AS month,
    category,
    COUNT(*) AS times_quantiy_4_sold
FROM retail_sales
WHERE quantiy = 4
GROUP BY 1,2,3
ORDER BY 1,4 DESC;
```
9. **what is the toal sale in month of november in each category ?**
```sql
SELECT SUM(total)
FROM(
SELECT category , SUM(total_sale) as total
FROM retail_sales
WHERE TO_CHAR(sale_date , 'YYYY-MM') = '2022-11'
GROUP BY category);
```

10. **Write a SQL query to calculate the total sales (total_sale) for each category.**:
```sql
SELECT 
	category , 
	SUM(total_sale) as total_sales,
	COUNT(*) AS total_orders
FROM retail_sales
GROUP BY category
ORDER BY total_sales DESC;
```

11. **Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.**:
```sql
SELECT ROUND(AVG(age),2)  
FROM retail_sales 
WHERE category = 'Beauty' ;
```

12. **Write a SQL query to find all transactions where the total_sale is greater than 1000.**:
```sql
SELECT *
FROM retail_sales
WHERE total_sale > 1000;

```

13. **Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.**:
```sql
SELECT 
		category,
		gender,
		COUNT(transactions_id)
FROM retail_sales 
GROUP BY
        category ,
        gender;
```

14. **Write a SQL query to calculate the average sale for each month. Find out best selling month in each year**:
```sql
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
```

15. **Write a SQL query to find the top 5 customers based on the highest total sales **:
```sql
SELECT 
	customer_id,
	SUM(total_sale) as total_sale
FROM retail_sales 
GROUP BY customer_id
ORDER BY 2 DESC
LIMIT 5;
```

16. **Write a SQL query to find the number of unique customers who purchased items from each category.**:
```sql
SELECT 
	category,
	COUNT(DISTINCT(customer_id)) cnt_unque_cs
FROM retail_sales
GROUP BY category;
```
17. **customer who bought atleast one thing from each category.**
```sql
SELECT 
	customer_id
FROM retail_sales
GROUP BY customer_id
HAVING 
	COUNT(DISTINCT category) = 
		(SELECT COUNT(DISTINCT category) 
		FROM retail_sales);
```

18. **Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)**:
```sql
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
```

## Findings

- **Customer Profile**: Purchases come from a wide age range, with a noticeable concentration in middle-aged customers. Buying behavior varies by category, with Clothing attracting the highest footfall and Beauty appealing to older, higher-spending buyers.

- **High-Value Orders**: Multiple transactions exceed 1000 in total sale value, showing that premium products—especially within the Electronics , Clothing and Beauty category—drive significant revenue spikes.

- **Category Performance**: Clothing leads in total order count and units sold, while Beauty contributes disproportionately to revenue, indicating strong profitability despite lower volume.

- **Seasonal Patterns**: Highest Monthly average sale in 2022 is in July and 2023 is in February but average 

- **Customer Behavior**: Only a small subset of customers purchases across all categories, indicating weak cross-category engagement. Yet, a handful of repeat buyers generate disproportionately higher revenue, identifying them as high-value customers worth retaining.

- **Operational Timing**: Most orders occur during the Evening Shift, making it the busiest period for transactions and a critical window for staffing and operational efficiency.
## Reports

- **Sales Summary**: A detailed report summarizing total sales, customer demographics, and category performance.
- **Trend Analysis**: Insights into sales trends across different months and shifts.
- **Customer Insights**: Reports on top customers and unique customer counts per category.

## Conclusion

This beginner SQL project gives you a basic understanding how to work with EDA , Understanding of How Real World Business problems look like and How they deal with it. 
In this project mainly you learn of finding patterns of customer behaviour , their taste of interest and when majority of them place an order , i.e their demographic . 

## How to Use

1. **Set Up the Database**: Run the SQL scripts provided in the `database_setup.sql` file to create and populate the database.
2. **Run the Queries**: Use the SQL queries provided in the `analysis_queries.sql` file to perform your analysis.
3. **Explore and Modify**: Feel free to modify the queries to explore different aspects of the dataset or answer additional business questions.

## Author - Puskar Ghosal

This project is part of my portfolio, showcasing the SQL skills essential for data analyst roles. If you have any questions, feedback, or would like to collaborate, feel free to get in touch!

### Stay Updated and Join the Community

For more content on SQL, data analysis, and other data-related topics, make sure to follow me on social media and join our community:

- **YouTube**: [Subscribe to my channel](https://www.youtube.com/@theghoalinstitution)
- **Instagram**: [Follow my personal account for fun](https://www.instagram.com/l_o_v_e.quote/)
- **LinkedIn**: [Connect with me professionally](https://www.linkedin.com/in/puskar-ghosal-2565a7254/)

Thank you for your support, and I look forward to connecting with you!
