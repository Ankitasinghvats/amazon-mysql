use amazon;
SET SQL_SAFE_UPDATES = 0;
select * from amazon;
/*finding the null values*/
SELECT *
FROM amazon
WHERE `Invoice ID` IS NULL
    OR `Branch` IS NULL
    OR `City` IS NULL
    OR `Customer type` IS NULL
    OR `Gender` IS NULL
    OR `Product line` IS NULL
    OR `Unit price` IS NULL
    OR `Quantity` IS NULL
    OR `Tax 5%` IS NULL
    OR `Total` IS NULL
    OR `Date` IS NULL
    OR `Time` IS NULL
    OR `Payment` IS NULL
    OR `cogs` IS NULL
    OR `gross margin percentage` IS NULL
    OR `gross income` IS NULL
    OR `Rating` IS NULL;


/*feature Engineering: This will help us generate some new columns from existing ones*/

ALTER TABLE amazon
MODIFY `Invoice ID` VARCHAR(30),
MODIFY `Branch` VARCHAR(30),
MODIFY `City` VARCHAR(30),
MODIFY `Customer type` VARCHAR(30),
MODIFY `Gender` VARCHAR(10),
MODIFY `Product line` VARCHAR(150),
MODIFY `Unit price` DECIMAL(10,2),
MODIFY `Quantity` VARCHAR(10),
MODIFY `Tax 5%` DECIMAL(10,2),
MODIFY `Total` DECIMAL(10,2),
MODIFY `Date` DATE,
MODIFY `Time` TIME,
MODIFY `Payment` VARCHAR(30),
MODIFY `cogs` DECIMAL(10,2),
MODIFY `gross margin percentage` DECIMAL(10,2),
MODIFY `gross income` DECIMAL(10,2),
MODIFY `Rating` DECIMAL(3,1);
ALTER TABLE amazon
modify date date;
update amazon
set date=str_to_date(date,"%d-%m-%Y")

ALTER TABLE amazon
add timeofday VARCHAR(10);

-- Update the time_of_day column based on the time column
UPDATE amazon
SET timeofday = 'afternoon'
WHERE time between'12:43:00' AND '18:00:00';

UPDATE amazon
SET timeofday = 'morning'
WHERE time between '06:00:00' AND '12:43:00';

UPDATE amazon
SET timeofday = 'evening'
WHERE time between '18:00:00' AND  '21:00:00';
select * from amazon;

ALTER TABLE amazon
ADD dayname VARCHAR(30);
UPDATE amazon
SET dayname = DAYNAME(Date);


alter table amazon
add month_name varchar(30);
update amazon
set month_name=monthname(date);

ALTER TABLE amazon
modify time_of_day VARCHAR(10);
select * from amazon;

/*What is the count of distinct cities in the dataset?*/
SELECT COUNT(DISTINCT city) AS distinct_cities_count
FROM amazon;

/*For each branch, what is the corresponding city?*/
SELECT branch, city
FROM amazon
GROUP BY branch, city;

/* What is the count of distinct product lines in the dataset? */

SELECT COUNT(DISTINCT  `Product line`) AS distinct_product_lines_count
FROM amazon;

select * from amazon;

/*Which payment method occurs most frequently*/
SELECT payment, COUNT(*) AS frequency
FROM amazon
GROUP BY payment
ORDER BY frequency DESC
LIMIT 1;

/*Which product line has the highest sales*/
SELECT  `Product line`, SUM(Total) AS total_sales
FROM amazon
GROUP BY `Product line`
ORDER BY total_sales DESC
LIMIT 1;

select * from amazon;
/*How much revenue is generated each month?*/
SELECT distinct month_name, SUM(total) AS total_revenue
FROM amazon
GROUP BY month_name
ORDER BY month_name;

/*In which month did the cost of goods sold reach its peak?*/
SELECT distinct month_name ,SUM(cogs) AS total_cogs
FROM amazon
GROUP BY month_name
ORDER BY total_cogs DESC
LIMIT 1;

/*Which product line generated the highest revenue?*/
select distinct  `Product line` , sum(total) as total_sales
from amazon
group by  `Product line`
order by total_sales desc
limit 1;

/*In which city was the highest revenue recorded?*/
select distinct city, sum(total) as total_sales
from amazon
group by city
order by total_sales desc
limit 1;


/*Which product line incurred the highest Value Added Tax?*/
SELECT `Product line`,SUM(`Tax 5%`) AS total_vat
FROM amazon
GROUP BY `Product line`
ORDER BY total_vat DESC
LIMIT 1;


/*For each product line, add a column indicating "Good" if its sales are above average, otherwise "Bad."*/
SELECT `Product line`,SUM(Total) AS total_sales,
CASE WHEN SUM(Total) > (SELECT AVG(Total) FROM amazon) THEN 'Good'
        ELSE 'Bad'
    END AS sales_rating
FROM amazon
GROUP BY `Product line`;

/*Identify the branch that exceeded the average number of products sold.*/
SELECT Branch, SUM(Quantity) AS total_quantity_sold
FROM amazon
GROUP BY Branch
HAVING SUM(Quantity) > (SELECT AVG(total_quantity) FROM (
        SELECT SUM(Quantity) AS total_quantity
        FROM amazon
        GROUP BY Branch
    ) AS subquery);

/*Which product line is most frequently associated with each gender?*/
SELECT Gender,`Product line`,COUNT(*) AS frequency
FROM amazon
GROUP BY Gender, `Product line`
ORDER BY Gender, frequency DESC;

/*Calculate the average rating for each product line.*/
SELECT `Product line`,AVG(Rating) AS average_rating
FROM amazon
GROUP BY `Product line`;
select * from amazon;

/*Count the sales occurrences for each time of day on every weekday.*/
SELECT dayname AS weekday,timeofday,COUNT(*) AS occurrences
FROM amazon
GROUP BY weekday,Timeofday;

/*Identify the customer type contributing the highest revenue*/
SELECT `Customer type`,SUM(Total) AS total_revenue
FROM amazon
GROUP BY `Customer type`
ORDER BY total_revenue DESC
LIMIT 1;


/*Determine the city with the highest VAT percentage.*/
SELECT City,AVG(`Tax 5%`) / AVG(Total) * 100 AS vat_percentage
FROM amazon
GROUP BY City
ORDER BY vat_percentage DESC
LIMIT 1;

/*Identify the customer type with the highest VAT payments.*/
SELECT `Customer type`,SUM(`Tax 5%`) AS total_vat
FROM amazon
GROUP BY `Customer type`
ORDER BY total_vat DESC
LIMIT 1;


/*What is the count of distinct customer types in the dataset?*/
SELECT COUNT(DISTINCT `Customer type`) AS distinct_customer_types_count
FROM amazon;

/*What is the count of distinct payment methods in the dataset?*/
SELECT COUNT(DISTINCT Payment) AS distinct_payment_methods_count
FROM amazon;

/*Which customer type occurs most frequently?*/
SELECT `Customer type`,COUNT(*) AS frequency
FROM amazon
GROUP BY `Customer type`
ORDER BY frequency DESC
LIMIT 1;

/*Identify the customer type with the highest purchase frequency.*/
SELECT `Customer type`,COUNT(*) AS purchase_frequency
FROM amazon
GROUP BY `Customer type`
ORDER BY purchase_frequency DESC
LIMIT 1;

/*Determine the predominant gender among customers.*/
SELECT Gender,COUNT(*) AS gender_count
FROM amazon
GROUP BY Gender
ORDER BY gender_count DESC
LIMIT 1;

/*Examine the distribution of genders within each branch.*/
SELECT Branch,Gender,COUNT(*) AS count
FROM amazon
GROUP BY Branch,Gender;

/*Identify the time of day when customers provide the most ratings.*/
SELECT Timeofday,COUNT(Rating) AS rating_count
FROM amazon
GROUP BY Timeofday
ORDER BY rating_count DESC;

/*Determine the time of day with the highest customer ratings for each branch.*/
SELECT Branch,Timeofday,AVG(Rating) AS average_rating
FROM amazon
GROUP BY Branch,Timeofday
ORDER BY Branch,average_rating DESC;

select * from amazon
#Identify the day of the week with the highest average ratings.
select dayname,AVG(Rating) AS average_rating
FROM amazon
GROUP BY dayname
ORDER BY average_rating DESC
LIMIT 1;
#Determine the day of the week with the highest average ratings for each branch.
SELECT Branch,DAYNAME AS weekday,AVG(Rating) AS average_rating
FROM amazon
GROUP BY Branch,weekday
ORDER BY Branch ,average_rating DESC;







