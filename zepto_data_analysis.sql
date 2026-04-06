drop table if exists zepto;

create table zepto (
sku_id SERIAL PRIMARY KEY,
category VARCHAR(120),
name VARCHAR(150) NOT NULL,
mrp NUMERIC(8,2),
discountPercent NUMERIC(5,2),
availableQuantity INTEGER,
discountedSellingPrice NUMERIC(8,2),
weightInGms INTEGER,
outOfStock BOOLEAN,	
quantity INTEGER
);

--data exploration

SELECT COUNT(*) FROM zepto

-- sample data
SELECT * FROM zepto
LIMIT 10;

-- checking null values
SELECT * FROM zepto
WHERE name IS NULL
OR
category IS NULL
OR
mrp IS NULL
OR
discountpercent IS NULL
OR
availablequantity IS NULL
OR
discountedsellingprice IS NULL
OR
weightingms IS NULL
OR
outofstock IS NULL
OR
quantity is NULL


-- different  product categories
SELECT DISTINCT category
from zepto
ORDER BY category;

-- products in stock and out of stock 
SELECT outofstock , COUNT(sku_id) 
from zepto
GROUP BY outofstock

-- product names present multiple times
select name , count(name)
from zepto
group by name
having count(name) > 1
order by count(name) desc;

-- another way
select name , count(sku_id) as "Number of SKUs"
from zepto
GROUP BY name
HAVING count(sku_id) > 1
ORDER BY count(sku_id) DESC;

-- DATA cleaning
--products with price = 0

SELECT * 
FROM zepto
WHERE mrp = 0 OR discountedsellingprice = 0;

-- deleting row which has mrp = 0
DELETE FROM zepto
WHERE mrp = 0;

-- convert paise to rupees
UPDATE zepto
SET mrp = mrp/100.0,
discountedsellingprice = discountedsellingprice/100.0;

SELECT mrp , discountedsellingprice FROM zepto;

--data analysis

-- Q1. Find the top 10 best-value products based on the discount percentage.

SELECT name,mrp,discountpercent 
FROM zepto
order by discountpercent desc
LIMIT 10;

--Q2.What are the Products with High MRP but Out of Stock
select DISTINCT name , mrp
from zepto 
where mrp > 300 and outofstock = 'True'
ORDER BY mrp DESC;

--Q3.Calculate Estimated Revenue for each category

select DISTINCT(category) , 
sum(discountedsellingprice * availablequantity) as total_revenue
from zepto
group by category
order by total_revenue;

-- Q4. Find all products where MRP is greater than ₹500 and discount is less than 10%.

SELECT DISTINCT name , mrp , discountpercent
FROM zepto 
WHERE mrp > 500 and discountpercent < 10
ORDER BY mrp DESC , discountpercent DESC;

-- Q5. Identify the top 5 categories offering the highest average discount percentage.

select DISTINCT category , avg(discountpercent) as avg_discount
FROM zepto
GROUP by category
ORDER by avg_discount desc
LIMIT 5;

-- Q6. Find the price per gram for products above 100g and sort by best value.
SELECT DISTINCT name , weightingms , discountedsellingprice ,
ROUND(discountedsellingprice/weightingms,2) AS price_per_grams
FROM zepto
WHERE weightingms >= 100
ORDER BY price_per_grams;

--Q7.Group the products into categories like Low, Medium, Bulk.
SELECT DISTINCT name ,category,weightingms , 
CASE WHEN weightingms < 1000 THEN 'Low'
     WHEN weightingms < 5000 THEN 'Medium'
	 ELSE 'Bulk'
	 END AS weight_category
from zepto

--Q8.What is the Total Inventory Weight Per Category 

SELECT category , SUM(weightingms * availablequantity) as total_weights
from zepto
GROUP BY category
order by total_weights desc;