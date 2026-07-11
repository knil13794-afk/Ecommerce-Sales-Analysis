CREATE DATABASE EcommerceDB;

USE EcommerceDB;


CREATE TABLE Customers (
    Customer_ID VARCHAR(10) PRIMARY KEY,
    Customer_Name VARCHAR(100),
    Gender VARCHAR(10),
    Age INT,
    City VARCHAR(50),
    State VARCHAR(50),
    Segment VARCHAR(30)
);


INSERT INTO Customers VALUES
('C101','Rahul Sharma','Male',28,'Pune','Maharashtra','Consumer'),
('C102','Priya Patel','Female',35,'Ahmedabad','Gujarat','Corporate'),
('C103','Amit Kumar','Male',31,'Delhi','Delhi','Consumer'),
('C104','Sneha Joshi','Female',26,'Mumbai','Maharashtra','Home Office'),
('C105','Rohit Singh','Male',42,'Jaipur','Rajasthan','Corporate');


CREATE TABLE Products (
    Product_ID VARCHAR(10) PRIMARY KEY,
    Product_Name VARCHAR(100),
    Category VARCHAR(50),
    Sub_Category VARCHAR(50),
    Unit_Price DECIMAL(10,2)
);


INSERT INTO Products VALUES
('P101','Laptop','Technology','Computers',55000),
('P102','Mobile','Technology','Phones',25000),
('P103','Office Chair','Furniture','Chairs',7000),
('P104','Printer','Technology','Accessories',12000),
('P105','Table','Furniture','Tables',8500);


CREATE TABLE Orders (
    Order_ID VARCHAR(10) PRIMARY KEY,
    Order_Date DATE,
    Customer_ID VARCHAR(10),
    Product_ID VARCHAR(10),
    Quantity INT,
    Sales DECIMAL(10,2),
    Profit DECIMAL(10,2),

    FOREIGN KEY(Customer_ID)
    REFERENCES Customers(Customer_ID),

    FOREIGN KEY(Product_ID)
    REFERENCES Products(Product_ID)
);


INSERT INTO Orders VALUES
('O101','2024-01-10','C101','P101',1,55000,9000),
('O102','2024-01-11','C102','P103',2,14000,2500),
('O103','2024-01-12','C103','P102',1,25000,4500),
('O104','2024-01-15','C104','P105',2,17000,3200),
('O105','2024-01-20','C105','P104',1,12000,1800);


CREATE TABLE Returns (
    Order_ID VARCHAR(10),
    Returned VARCHAR(10),

    FOREIGN KEY(Order_ID)
    REFERENCES Orders(Order_ID)
);


INSERT INTO Returns VALUES
('O101','No'),
('O102','Yes'),
('O103','No'),
('O104','No'),
('O105','Yes');


-- Database Schema
-- Customers
--     │
--     │ Customer_ID
--     │
-- Orders
--     │
--     ├──────── Product_ID ───────► 
-- Products
--     │
--     └──────── Order_ID ─────────► 
-- Returns


SELECT * FROM Customers;
SELECT * FROM Products;
SELECT * FROM Orders;
SELECT * FROM Returns;

SELECT * FROM Orders;

select customer_id,product_id,sales from orders;

select * from orders where sales>20000;

select * from customers where state='Maharashtra';

select * from products where category='technology';

select * from products order by unit_price desc;

select count(*) as total_customers from customers;

select sum(sales) as total_sales from orders;

select avg(sales) as average_sales from orders;

select max(sales) as highest_sales , min(sales) as lowest_sales from orders;

select customer_id,sum(sales) as total_sales from orders group by customer_id;

select customer_id,sum(profit) as total_profit from orders group by customer_id;

select product_id,sum(quantity) as total_quantity from orders group by product_id;

select avg(profit) from orders;

select month(order_date) as month,sum(sales) as total_sales from orders group by month(order_date);

select c.customer_name,o.sales from orders o join customers c on o.customer_id=c.customer_id;

select p.product_name,o.sales from orders o join products p on o.product_id=p.product_id;

select c.customer_name,p.product_name,o.sales from orders o join customers c on o.customer_id=c.customer_id join products p on o.product_id=p.product_id;

select p.category,sum(o.sales) as total_sales from orders o join products p on o.product_id=p.product_id group by p.category;

select p.category,sum(o.profit) as total_profit from orders o join products p on o.product_id=p.product_id group by p.category;

select customer_id,sum(sales) as total_sales from orders group by customer_id order by total_sales desc limit 5;

select product_id,sum(quantity)  total_qty from orders group by product_id order by total_qty desc;

select p.category,sum(o.sales) Revenue from orders o join products p on o.product_id=p.product_id group by p.category order by Revenue desc;

select customer_id ,sum(profit) as Profit from orders group by customer_id order by Profit desc;

select o.order_id,p.product_name from orders o join returns r on o.order_id=r.order_id join products p on o.product_id=p.product_id where Returned='Yes';

select customer_id,sum(sales) as total_sales,rank()over(order by sum(sales) desc)as sales_rank from orders group by customer_id;

with customer_sales as (select customer_id,sum(sales) as total_sales,rank()over(order by sum(sales) desc)as sales_rank from orders group by customer_id) select * from customer_sales where sales_rank<=3;

select product_id,sum(sales) as total_sales from orders group by product_id order by total_sales desc limit 1;

select order_id,order_date,sales,sum(sales) over(order by order_date) as running_total from orders;

select customer_id,order_date,sales,lag(sales) over(partition by customer_id order by Order_date)as previous_sale from orders;

select customer_id,order_date,sales,lead(sales) over(partition by customer_id order by Order_date)as next_sale from orders;

select order_id,sales,case when sales>=50000 then 'High' when sales>=20000 then 'Medium' else 'Low' end as sales_category from orders;

select customer_id,sum(sales) as total_sales from orders group by customer_id having total_sales>(select avg(sales) from orders);

select order_id,sales,profit,round((profit/sales)*100,2) as profit_percentage from orders;

select distinct sales from orders order by sales desc limit 1 offset 1;

select max(sales) from orders where sales < (select max(sales) from orders);

select p.category,sum(o.profit) as total_profit from orders o join products p on o.product_id=p.product_id group by p.category order by total_profit desc;

select customer_id,sum(sales) as total_sales from orders group by customer_id having sum(sales)>(select avg(total_sales) from (select sum(sales)as total_sales from orders group by customer_id)a);

select * from orders o1 where sales>(select avg(sales) from orders o2 where o1.customer_id=o2.customer_id);


-- 1. Subquery
-- Q1. Find customers whose total sales are above the average customer sales.
SELECT Customer_ID, SUM(Sales) AS TotalSales
FROM Orders
GROUP BY Customer_ID
HAVING SUM(Sales) >
(
SELECT AVG(TotalSales)
FROM
(
SELECT SUM(Sales) AS TotalSales
FROM Orders
GROUP BY Customer_ID
) A
);
###
SELECT Customer_ID, SUM(Sales) AS TotalSales
FROM Orders
GROUP BY Customer_ID
HAVING SUM(Sales) >
(
SELECT AVG(sales)
FROM orders);
-- Interview Question
-- What is a Subquery?
-- Answer: A Subquery is a query written inside another SQL query. It is used to filter, compare, or calculate values before the main query executes.

-- 2. Correlated Subquery
-- Q2. Find customers whose sales are greater than their own average sales.
SELECT *
FROM Orders O1
WHERE Sales >
(
SELECT AVG(Sales)
FROM Orders O2
WHERE O1.Customer_ID=O2.Customer_ID
);

-- 3. Common Table Expression (CTE)
-- Q3. Find Top 5 Customers
WITH CustomerSales AS
(
SELECT Customer_ID,
SUM(Sales) TotalSales
FROM Orders
GROUP BY Customer_ID
)
SELECT *
FROM CustomerSales
ORDER BY TotalSales DESC
LIMIT 5;

-- 4. Multiple CTE
WITH SalesData AS
(
SELECT Customer_ID,
SUM(Sales) Sales
FROM Orders
GROUP BY Customer_ID
),
ProfitData AS
(
SELECT Customer_ID,
SUM(Profit) Profit
FROM Orders
GROUP BY Customer_ID
)
SELECT
s.Customer_ID,
s.Sales,
p.Profit
FROM SalesData s
JOIN ProfitData p
ON s.Customer_ID=p.Customer_ID;

-- 5. ROW_NUMBER()
-- Assign a unique number to every order.
SELECT
Order_ID,
Sales,
ROW_NUMBER() OVER
(
ORDER BY Sales DESC
) RowNum
FROM Orders;

-- 6. RANK()
SELECT
Customer_ID,
SUM(Sales) TotalSales,
RANK() OVER
(
ORDER BY SUM(Sales) DESC
) Ranking
FROM Orders
GROUP BY Customer_ID;
-- If two customers have the same sales, they get the same rank, and the next rank is skipped.

-- 7. DENSE_RANK()
SELECT
Customer_ID,
SUM(Sales) TotalSales,
DENSE_RANK() OVER
(
ORDER BY SUM(Sales) DESC
) Ranking
FROM Orders
GROUP BY Customer_ID;
-- Unlike RANK(), there are no gaps in the ranking.

-- 8. Difference Between ROW_NUMBER(), RANK(), and DENSE_RANK()
-- Suppose sales are:
-- Customer
-- Sales
-- A
-- 1000
-- B
-- 900
-- C
-- 900
-- D
-- 800
-- Customer
-- ROW_NUMBER
-- RANK
-- DENSE_RANK
-- A
-- 1
-- 1
-- 1
-- B
-- 2
-- 2
-- 2
-- C
-- 3
-- 2
-- 2
-- D
-- 4
-- 4
-- 3

-- 9. CASE WHEN
-- Classify orders.
SELECT
Order_ID,
Sales,
CASE
WHEN Sales>=50000 THEN 'Excellent'
WHEN Sales>=20000 THEN 'Good'
WHEN Sales>=10000 THEN 'Average'
ELSE 'Poor'
END AS Performance
FROM Orders;

-- 10. CASE WHEN with Profit
SELECT
Order_ID,
Profit,
CASE
WHEN Profit>5000 THEN 'High Profit'
WHEN Profit BETWEEN 2000 AND 5000 THEN 'Medium Profit'
ELSE 'Low Profit'
END AS ProfitCategory
FROM Orders;

-- 11. LAG()
-- Compare each order's sales with the previous order.
SELECT
Order_ID,
Order_Date,
Sales,
LAG(Sales)
OVER
(
ORDER BY Order_Date
)
AS PreviousSales
FROM Orders; 

-- 12. LEAD()
-- Compare with the next order.
SELECT
Order_ID,
Order_Date,
Sales,
LEAD(Sales)
OVER
(
ORDER BY Order_Date
)
AS NextSales
FROM Orders;

-- 13. Running Total
SELECT
Order_Date,
Sales,
SUM(Sales)
OVER
(
ORDER BY Order_Date
)
RunningTotal
FROM Orders;

-- 14. Moving Average
SELECT
Order_Date,
Sales,
AVG(Sales)
OVER
(
ORDER BY Order_Date
ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
)
MovingAverage
FROM Orders;

-- 15. Find Second Highest Salary (Very Common Interview Question)
SELECT MAX(Sales)
FROM Orders
WHERE Sales <
(
SELECT MAX(Sales)
FROM Orders
);


-- Advanced SQL Part 2 (Queries 16–25)
-- Q16. Find the 3rd Highest Sales
SELECT DISTINCT Sales
FROM Orders
ORDER BY Sales DESC
LIMIT 1 OFFSET 2;

-- Q17. Find the Top 3 Products by Total Sales
SELECT
    p.Product_Name,
    SUM(o.Sales) AS Total_Sales
FROM Orders o
JOIN Products p
ON o.Product_ID = p.Product_ID
GROUP BY p.Product_Name
ORDER BY Total_Sales DESC
LIMIT 3;

-- Q18. Find Customers Who Placed More Than One Order
SELECT
    Customer_ID,
    COUNT(Order_ID) AS Total_Orders
FROM Orders
GROUP BY Customer_ID
HAVING COUNT(Order_ID) > 1;

-- Q19. Find the Month with the Highest Sales
SELECT
    MONTH(Order_Date) AS Month,
    SUM(Sales) AS Total_Sales
FROM Orders
GROUP BY MONTH(Order_Date)
ORDER BY Total_Sales DESC
LIMIT 1;

-- Q20. Calculate Profit Margin for Each Order
SELECT
    Order_ID,
    Sales,
    Profit,
    ROUND((Profit / Sales) * 100, 2) AS Profit_Margin
FROM Orders;

-- Q21. Find Products That Were Never Returned
SELECT
    p.Product_Name
FROM Products p
JOIN Orders o
ON p.Product_ID = o.Product_ID
LEFT JOIN Returns r
ON o.Order_ID = r.Order_ID
WHERE r.Returned = 'No';
-- Interview follow-up: A stricter solution should also handle products with no return record at all by checking r.Order_ID IS NULL depending on the dataset.

-- Q22. Find Total Sales by State
SELECT
    c.State,
    SUM(o.Sales) AS Total_Sales
FROM Orders o
JOIN Customers c
ON o.Customer_ID = c.Customer_ID
GROUP BY c.State
ORDER BY Total_Sales DESC;

-- Q23. Find the Best Customer in Each State
WITH CustomerSales AS
(
SELECT
    c.State,
    c.Customer_Name,
    SUM(o.Sales) AS Total_Sales,
    RANK() OVER
    (
        PARTITION BY c.State
        ORDER BY SUM(o.Sales) DESC
    ) AS Rank_No
FROM Orders o
JOIN Customers c
ON o.Customer_ID = c.Customer_ID
GROUP BY c.State,c.Customer_Name
)
SELECT *
FROM CustomerSales
WHERE Rank_No = 1;

-- Q24. Find Category-wise Sales Percentage
SELECT
    p.Category,
    SUM(o.Sales) AS Category_Sales,
    ROUND(
        SUM(o.Sales) * 100 /
        (SELECT SUM(Sales) FROM Orders),
        2
    ) AS Sales_Percentage
FROM Orders o
JOIN Products p
ON o.Product_ID = p.Product_ID
GROUP BY p.Category;

-- Q25. Create a Sales Performance Report
SELECT
    Order_ID,
    Customer_ID,
    Sales,
CASE
WHEN Sales >=50000 THEN 'Excellent'
WHEN Sales >=30000 THEN 'Very Good'
WHEN Sales >=15000 THEN 'Good'
ELSE 'Needs Improvement'
END AS Sales_Status
FROM Orders;
