-- Ecommerce Sales Analysis - Advanced queries (MySQL)

DROP TABLE IF EXISTS orders;
CREATE TABLE orders (
  OrderID BIGINT PRIMARY KEY,
  OrderDate DATE,
  CustomerID VARCHAR(20),
  CustomerName VARCHAR(100),
  ProductID VARCHAR(20),
  ProductName VARCHAR(255),
  Category VARCHAR(100),
  Quantity INT,
  UnitPrice DECIMAL(10,2),
  TotalAmount DECIMAL(12,2),
  Region VARCHAR(50),
  PaymentMethod VARCHAR(50)
);

-- Load from CSV using LOAD DATA INFILE or use INSERTs if small.

-- 1) Total revenue overall
SELECT SUM(TotalAmount) AS total_revenue FROM orders;

-- 2) Revenue by year and month
SELECT YEAR(OrderDate) AS yr, MONTH(OrderDate) AS mth, SUM(TotalAmount) AS revenue
FROM orders
GROUP BY yr, mth
ORDER BY yr, mth;

-- 3) Top 10 products by revenue
SELECT ProductID, ProductName, Category, SUM(TotalAmount) AS revenue, SUM(Quantity) AS units_sold
FROM orders
GROUP BY ProductID, ProductName, Category
ORDER BY revenue DESC
LIMIT 10;

-- 4) Top 10 customers by lifetime value
SELECT CustomerID, CustomerName, SUM(TotalAmount) AS lifetime_value, COUNT(*) AS orders_count
FROM orders
GROUP BY CustomerID, CustomerName
ORDER BY lifetime_value DESC
LIMIT 10;

-- 5) Monthly Average Order Value (AOV)
SELECT YEAR(OrderDate) AS yr, MONTH(OrderDate) AS mth, ROUND(AVG(TotalAmount),2) AS avg_order_value, COUNT(*) AS orders
FROM orders
GROUP BY yr, mth
ORDER BY yr, mth;

-- 6) Repeat customers (customers with >1 orders) and their % contribution
WITH cust AS (
  SELECT CustomerID, COUNT(*) AS orders_count, SUM(TotalAmount) AS spend
  FROM orders
  GROUP BY CustomerID
)
SELECT (SELECT COUNT(*) FROM cust WHERE orders_count>1) AS repeat_customers_count,
       (SELECT ROUND(SUM(spend)/(SELECT SUM(TotalAmount) FROM orders)*100,2) FROM cust WHERE orders_count>1) AS repeat_customers_revenue_pct;

-- 7) Region-wise revenue and share
SELECT Region, SUM(TotalAmount) AS revenue, ROUND(SUM(TotalAmount)/(SELECT SUM(TotalAmount) FROM orders)*100,2) AS revenue_pct
FROM orders
GROUP BY Region
ORDER BY revenue DESC;

-- 8) Payment method trends (count + revenue)
SELECT PaymentMethod, COUNT(*) AS orders, SUM(TotalAmount) AS revenue
FROM orders
GROUP BY PaymentMethod
ORDER BY orders DESC;

-- 9) Year-over-year revenue growth (using window functions)
SELECT yr, revenue, LAG(revenue) OVER (ORDER BY yr) AS prev_year, 
       ROUND((revenue - LAG(revenue) OVER (ORDER BY yr))/LAG(revenue) OVER (ORDER BY yr)*100,2) AS yoy_growth_pct
FROM (
  SELECT YEAR(OrderDate) AS yr, SUM(TotalAmount) AS revenue
  FROM orders
  GROUP BY yr
) t
ORDER BY yr;

-- 10) Top categories by revenue and units sold
SELECT Category, SUM(TotalAmount) AS revenue, SUM(Quantity) AS units_sold
FROM orders
GROUP BY Category
ORDER BY revenue DESC;

-- 11) High-value orders (TotalAmount > 75th percentile)
WITH percentiles AS (
  SELECT TotalAmount FROM orders ORDER BY TotalAmount
)
-- Note: MySQL doesn't have a built-in percentile function in older versions. This is a placeholder; use window functions or client-side to compute exact percentiles.

-- 12) Cohort analysis: first order month and retention (simplified)
WITH first_order AS (
  SELECT CustomerID, MIN(DATE_FORMAT(OrderDate, '%Y-%m-01')) AS cohort_month
  FROM orders GROUP BY CustomerID
)
SELECT f.cohort_month, DATE_FORMAT(o.OrderDate, '%Y-%m-01') AS order_month, COUNT(DISTINCT o.CustomerID) AS customers
FROM orders o JOIN first_order f ON o.CustomerID = f.CustomerID
GROUP BY f.cohort_month, order_month
ORDER BY f.cohort_month, order_month;

-- 13) Top products per region
SELECT Region, ProductID, ProductName, SUM(TotalAmount) AS revenue
FROM orders
GROUP BY Region, ProductID, ProductName
ORDER BY Region, revenue DESC;

-- 14) Correlation check between Quantity and TotalAmount (simple)
SELECT ROUND(CORR(Quantity, TotalAmount),2) AS corr_qty_amount FROM orders;

-- 15) Orders per day of week with revenue
SELECT DAYNAME(OrderDate) AS day_of_week, COUNT(*) AS orders, SUM(TotalAmount) AS revenue
FROM orders
GROUP BY day_of_week
ORDER BY FIELD(day_of_week,'Monday','Tuesday','Wednesday','Thursday','Friday','Saturday','Sunday');

-- 16) Average time between orders per customer (approx)
-- This requires window functions to compute diffs between order dates per customer.

-- End of advanced queries. Use them to generate dashboard KPIs.
