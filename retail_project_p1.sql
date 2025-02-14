
--create retail table

CREATE TABLE retail_sales(
        transactions_id	INT PRIMARY KEY,
        sale_date	Date,
        sale_time	time,
        customer_id	INT,
        gender	varchar(15),
        age	     INT,
        category	varchar(15),
        quantiy	INT,
        price_per_unit	float,
        cogs	float,
        total_sale float
) ;


SELECT * 
FROM retail_sales;


-- Insert data into our table

COPY  retail_sales
FROM 'C:\Users\sigma\Downloads\Retail-Sales-Analysis-SQL-Project--P1-main\SQL - Retail Sales Analysis_utf .csv'
DELIMITER ',' CSV HEADER;

SELECT *
FROM retail_sales
WHERE 
    transactions_id IS NULL
    OR sale_date IS NULL
    OR sale_time IS NULL
    OR customer_id IS NULL
    OR gender IS NULL 
    OR category IS NULL
    OR quantiy IS NULL
    OR price_per_unit is NULL
    OR cogs is NULL
    OR total_sale IS NULL;


DELETE FROM retail_sales
WHERE 
    transactions_id IS NULL
    OR sale_date IS NULL
    OR sale_time IS NULL
    OR customer_id IS NULL
    OR gender IS NULL 
    OR category IS NULL
    OR quantiy IS NULL
    OR price_per_unit is NULL
    OR cogs is NULL
    OR total_sale IS NULL;



--How many sales do we have?

SELECT 
        count(*) As total_sales
FROM retail_sales;

-- How many customers do we have?
SELECT 
        count(customer_id) As customers_count
FROM retail_sales;


-- How many unique customers do we have?

SELECT 
        count(DISTINCT(customer_id)) As customers_count
FROM retail_sales;

--Number of categories

SELECT 
        count(DISTINCT(category)) As customers_count
FROM retail_sales;

-- What are the unique categories 

SELECT 
        DISTINCT(category) As customers_count
FROM retail_sales;



-- **Write a SQL query to retrieve all columns for sales made on '2022-11-05**


SELECT *
FROM retail_sales 
WHERE sale_date = '2022-11-05'

-- **Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022**

SELECT *
FROM
        retail_sales
WHERE 
        category = 'Clothing' AND 
        To_CHAR (sale_date, 'YYYY-MM') ='2022-11' AND
        quantiy >= 4;


-- **Write a SQL query to calculate the total sales (total_sale) for each category.**

SELECT 
        category,
        sum(total_sale) net_sales,
        count(*) no_of_orders
FROM retail_sales
GROUP BY 
        category
ORDER BY 
        net_sales desc


--  **Write a SQL query to find the average age of customers who purchased items from the 'Beauty' 

SELECT 
        round(avg(age), 0)
from
        retail_sales
where category = 'Beauty'



-- **Write a SQL query to find all transactions where the total_sale is greater than 1000.**


SELECT *
from
        retail_sales
where total_sale > 1000



-- **Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.**

SELECT 
        category,
        gender,
        count(transactions_id) sum_of_trans
FROM
        retail_sales
GROUP BY gender,
         category
ORDER BY category ,
        gender desc


-- **Write a SQL query to calculate the average sale for each month. Find out best selling month in each year**

SELECT 
        year,
        month,
        avg_sales
FROM (
        SELECT 
                EXTRACT(year from sale_date) as year,
                EXTRACT(month from sale_date) as month,
                avg(total_sale) as avg_sales,
                rank() Over( PARTITION BY EXTRACT(year from sale_date) ORDER BY avg(total_sale) desc)
        FROM 
                retail_sales
        GROUP BY year, month
) As t1
where rank = 1



-- Write a SQL query to find the top 5 customers based on the highest total sales


SELECT 
       customer_id,
       sum(total_sale) as total_sales
FROM    retail_sales
GROUP BY customer_id
ORDER BY total_sales desc
LIMIT 5



--  **Write a SQL query to find the number of unique customers who purchased items from each category.**

SELECT  
        category,
        count(DISTINCT customer_id)  unique_customer
FROM 
        retail_sales
GROUP BY category




-- **Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)**:


With hourly_sales
AS(
        SELECT  *,
                case 
                when EXTRACT (hour from sale_time) < 12  then 'Morning'
                when EXTRACT (hour from sale_time) Between 12 and 17  then 'Afternoon'
                else 'Evining'
        end    as shift

        FROM
                retail_sales
)
SELECT count(transactions_id) no_of_orders,
        shift
FROM hourly_sales
GROUP BY shift
ORDER BY no_of_orders desc

-- End of project