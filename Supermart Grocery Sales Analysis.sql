use supermart_grocery;

select * from sales;

# convert Order_Date data type to date data type
SELECT Order_Date
FROM sales
WHERE Order_Date LIKE '%/%';

UPDATE sales
SET Order_Date =
CASE
    WHEN Order_Date LIKE '%-%' THEN STR_TO_DATE(Order_Date, '%d-%m-%Y')
    WHEN Order_Date LIKE '%/%' THEN STR_TO_DATE(Order_Date, '%m/%d/%Y')
END;

ALTER TABLE sales
MODIFY Order_Date DATE;

select Order_Date from sales;


# Total sales & Profit
SELECT 
    SUM(Sales) AS total_sales,
    ROUND(SUM(Profit), 0) AS total_profit
FROM
    sales;
    
# Top 5 Best-Selling Categories
SELECT 
    Category, SUM(Sales) AS total_sales
FROM
    sales
GROUP BY Category
ORDER BY total_sales DESC
LIMIT 5;

# Most Profitable Sub-Categories
SELECT 
    SubCategory, ROUND(SUM(Profit), 2) AS total_profit
FROM
    sales
GROUP BY SubCategory
ORDER BY total_profit DESC;

# Region-wise Sales Performance
SELECT 
    Region,
    SUM(Sales) AS total_sales,
    ROUND(SUM(Profit), 0) AS total_profit
FROM
    sales
GROUP BY Region;

# Top 10 Customers by Sales
SELECT 
    CustomerName, SUM(Sales) AS total_sales
FROM
    sales
GROUP BY CustomerName
ORDER BY total_sales DESC
LIMIT 10;

# Year wise Monthly Sales Trend
SELECT 
    DATE_FORMAT(Order_Date, '%Y-%m') AS month,
    SUM(Sales) AS total_sales
FROM sales
GROUP BY month
ORDER BY month;

# Loss-Making Transactions
SELECT 
    *
FROM
    sales
WHERE
    Profit < 0;
    
# Impact of Discount on Profit
SELECT 
    Discount, ROUND(AVG(Profit), 2) AS avg_profit
FROM
    sales
GROUP BY Discount
ORDER BY Discount;

# Orders per Customer
SELECT 
    CustomerName, COUNT(DISTINCT Order_ID) AS num_of_order
FROM
    sales
GROUP BY CustomerName
ORDER BY num_of_order;

# Which categories have high sales but low profit margins? 
WITH category_metrics AS (
    SELECT 
        Category,
        SUM(Sales) AS total_sales,
        round(SUM(Profit),2) AS total_profit,
        round((SUM(Profit) / SUM(Sales)) * 100,2) AS profit_margin
    FROM sales
    GROUP BY Category
)
SELECT *
FROM category_metrics
WHERE total_sales > (SELECT AVG(total_sales) FROM category_metrics)
  AND profit_margin < (SELECT AVG(profit_margin) FROM category_metrics)
ORDER BY total_sales DESC;

# Rank Customers by Sales
SELECT CustomerName , sum(Sales) AS total_sales ,  RANK() OVER (ORDER BY SUM(Sales) DESC) AS sales_rank 
FROM sales GROUP BY  CustomerName;

# Category Contribution Percentage
SELECT 
    Category,
    SUM(Sales) * 100 / (SELECT 
            SUM(Sales)
        FROM
            sales) AS percentage_contribution
FROM
    sales
GROUP BY Category;

# Identify Discount Levels with Negative Profit
SELECT 
    Discount, SUM(Profit) AS total_profit
FROM
    sales
GROUP BY Discount
HAVING total_profit < 0
ORDER BY Discount;