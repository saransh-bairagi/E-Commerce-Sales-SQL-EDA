-- Creating Database for Sales Data for More Data Use
CREATE DATABASE IF NOT EXISTS ecommerceSales;
USE ecommercesales;
-- Creating Table/Entity for Sales Data
CREATE TABLE IF NOT EXISTS sales(
	invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
    branch  VARCHAR(5) NOT NULL,
    city VARCHAR(30) NOT NULL,
    customer_type VARCHAR(30) NOT NULL,
    gender VARCHAR(30) NOT NULL,
    product_line VARCHAR(100) NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    quantity INT NOT NULL,
    VAT FLOAT(6,4),
    total DECIMAL(12,4) NOT NULL,
    date DATETIME NOT NULL,
    time TIME NOT NULL,
    payment_method VARCHAR(15) NOT NULL,
    -- cost of good sold
    cogs DECIMAL(10,2) NOT NULL,
    gross_margin_pct FLOAT(11,9),
    gross_income DECIMAL (12,4) NOT NULL,
    rating FLOAT(2,1)
);



-- -------------------------
-- Feature Engineering
-- -------------------------
-- time_of_day

SELECT 
	time,
	(CASE 
		WHEN time BETWEEN "00:00:00" AND "12:00:00" THEN "MORNING"
        WHEN time BETWEEN "12:01:00" AND "16:00:00" THEN "MORNING"
        ELSE "Evening"
        END
	) AS time_of_day
FROM sales;
ALTER TABLE sales ADD COLUMN time_of_day VARCHAR(20);

UPDATE sales
SET time_of_day=(
	(CASE 
		WHEN time BETWEEN "00:00:00" AND "12:00:00" THEN "MORNING"
        WHEN time BETWEEN "12:01:00" AND "16:00:00" THEN "AFTERNOON"
        ELSE "Evening"
        END
	)
);
-- day_name

SELECT 
	date,
    DAYNAME(date)
FROM sales;
ALTER TABLE sales ADD COLUMN day_name VARCHAR(10);
UPDATE sales
SET day_name=(
	    DAYNAME(date)
);


-- Month name add 
SELECT 
	date,
    MONTHNAME(date)
FROM sales;

ALTER TABLE sales ADD COLUMN month_name VARCHAR(10);
UPDATE sales
SET month_name=(
	MONTHNAME(date)
);





-- Exploratory Data Analysis (Generic)



-- Q How many Cities does E commerce Operate?
SELECT 
	DISTINCT city
FROM sales;
-- A three 

-- Q Branches and Cities
SELECT 
	DISTINCT city,
    branch
FROM sales;



-- Product Analysis---------------


-- How Many unique product lines does data have 
SELECT
	COUNT(DISTINCT product_line)
FROM sales;
-- A:6

-- Most Common Payment Method

SELECT 
	payment_method,
    COUNT(payment_method) AS cnt
FROM sales
GROUP BY payment_method
ORDER BY cnt DESC;

-- A:Cash



-- Q most selling product

SELECT
	product_line,
    COUNT(product_line) as cnt
FROM sales
GROUP BY product_line
ORDER BY cnt DESC;
-- A:Fashion Accessories folllowed by food and least is Health and Beauty


-- Total Revenue by month

SELECT
	month_name,
    SUM(total) as total_revenue
FROM sales
GROUP BY month_name
ORDER BY total_revenue DESC;
-- A: JAN>MAR>Feb

SELECT
	month_name,
    SUM(cogs) as net_cogs
FROM sales
GROUP BY month_name
ORDER BY net_cogs DESC;
-- A:January

SELECT
	product_line,
    SUM(total )as total_revenue
FROM sales
GROUP BY product_line
ORDER BY total_revenue DESC;

-- Q:City with largest revenue

SELECT 
	branch,	
	city,    
    sum(total) AS total_revenue
FROM sales
GROUP BY city,branch
ORDER BY total_revenue DESC;

-- product line having largest VAT
SELECT 
	product_line,
	AVG(VAT) as VAT
FROM sales
GROUP BY product_line
ORDER BY VAT DESC;

-- Which branch sold more product than avg product sold?
SELECT 
	branch,
    SUM(quantity) AS qt
FROM sales
GROUP BY branch
HAVING qt>(SELECT AVG(quantity) FROM sales);


-- Most Common Product Line by gender
SELECT
	gender,
    product_line,
    COUNT(gender) AS total_cnt
FROM sales
GROUP BY gender,product_line
ORDER BY total_cnt DESC;



-- average rating of each product line?

SELECT 
	product_line,
    ROUND(AVG(rating),2) as avg_rating
FROM sales
GROUP BY product_line
ORDER BY avg_rating DESC;


-- Sales Analysis

-- Q Nubmer of sales made in each time of day per weekday

SELECT
	time_of_day,
    COUNT(*) AS total_sales
FROM sales
WHERE day_name="Sunday"
GROUP BY time_of_day
ORDER BY total_sales DESC;

-- Customers type most revenue
SELECT
	customer_type,
    SUM(total) as total_revenue
FROM sales
GROUP BY customer_type
ORDER BY total_revenue DESC;


-- City with largest vat value
SELECT
	customer_type,
    AVG(vat) as avg_vat
FROM sales
GROUP BY customer_type
ORDER BY avg_vat DESC;

-- UNique customer types data have
SELECT 
	COUNT(DISTINCT customer_type)
FROM sales;

-- Unique Payment Methods data have
SELECT
	COUNT(DISTINCT payment_method)
FROM sales;
SELECT
	customer_type,
	COUNT(*) as cnt
FROM sales
GROUP BY customer_type
ORDER BY cnt DESC;

-- Most common gender type
SELECT 
	gender,
    COUNT(*) AS gender_count
FROM sales
-- WHERE branch="A"
GROUP BY gender
ORDER BY gender_count DESC;


-- what time of day customers give more rating
SELECT
	time_of_day,
	AVG(rating) AS cnt
FROM sales
WHERE branch="A"
GROUP BY time_of_day
ORDER BY cnt DESC;

-- day with best ratings
SELECT	
	day_name,
	AVG(rating) AS cnt
FROM sales
GROUP BY day_name
ORDER BY cnt DESC;