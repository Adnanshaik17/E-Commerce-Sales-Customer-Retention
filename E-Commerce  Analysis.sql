SELECT * FROM OnlineRetail;


SELECT COUNT(*) AS 'TOTAL RECORDS' FROM OnlineRetail;
 

 --Removing cancelled invoices('C') and NULL customers

CREATE VIEW CleanedRetail AS 
(SELECT * FROM OnlineRetail
WHERE InvoiceNo NOT LIKE 'C%'
AND CustomerID IS NOT NULL
AND Quantity <> 0
AND UnitPrice > 0);

SELECT * FROM CleanedRetail;

--A.KPI's

--1.Total Revenue:

SELECT ROUND(SUM(Quantity * UnitPrice), 2) AS Total_Revenue
FROM CleanedRetail

--2.Total Quantity Sold

SELECT SUM(Quantity) AS Total_Quantity_Sold
FROM CleanedRetail;

--3.Average Unit Price

SELECT ROUND(AVG(UnitPrice),2) AS Average_UnitPrice
FROM CleanedRetail;

--4. Average Basket Size:

SELECT ROUND(AVG(ItemCount), 2) AS Average_Basket_Size
FROM ( SELECT InvoiceNo, SUM(Quantity) AS ItemCount
    FROM CleanedRetail
    GROUP BY InvoiceNo) AS InvoiceSummary;



--5.Average Order Value (AOV)

SELECT ROUND(SUM(Quantity * UnitPrice) * 1.0 / COUNT(DISTINCT InvoiceNo), 2) AS Average_Order_Value
FROM CleanedRetail;


--B Chart Requirement

--1.Top-Selling Products: Identify revenue-driving inventory.

SELECT Top 5 Description, 
SUM(Quantity) AS Units_Sold, 
ROUND(SUM(Quantity * UnitPrice), 2) AS Revenue
FROM CleanedRetail
GROUP BY Description
ORDER BY Revenue DESC;

--2.Monthly Sales Trend: Track seasonality and business growth.

SELECT FORMAT(InvoiceDate, 'yyyy-MM') AS Month,
ROUND(SUM(Quantity * UnitPrice), 2) AS Monthly_Revenue
FROM CleanedRetail
WHERE Quantity > 0
GROUP BY FORMAT(InvoiceDate, 'yyyy-MM')
ORDER BY Month;


--3.Customer Lifetime Value (CLV): Find and prioritize high-value customers.

SELECT	TOP 10 CustomerID,
ROUND(SUM(Quantity * UnitPrice), 2) AS Customer_Lifetime_Value
FROM CleanedRetail
GROUP BY CustomerID
ORDER BY Customer_Lifetime_Value DESC;



--4.Which customers placed the most orders or spent the most?

SELECT TOP 10 CustomerID, description, ROUND(SUM(Quantity * UnitPrice), 2) AS Total_Spent
FROM CleanedRetail 
GROUP BY CustomerID, description
ORDER BY Total_Spent DESC;

--5.Which countries generate the highest sales?

-- Sales
SELECT Country, ROUND(SUM(Quantity * UnitPrice), 2) AS Revenue
FROM CleanedRetail
GROUP BY Country
ORDER BY Revenue DESC;

--6.Top 5 Best Sellers 

SELECT TOP 5 Description, ROUND(SUM(Quantity * UnitPrice), 2) AS TotalRevenue,
SUM(Quantity) AS TotalQuantity
FROM CleanedRetail
GROUP BY Description
ORDER BY TotalRevenue DESC;

--7.Bottom 5 Worst Sellers
SELECT TOP 5 Description, ROUND(SUM(Quantity * UnitPrice), 2) AS TotalRevenue,
SUM(Quantity) AS TotalQuantity
FROM CleanedRetail
GROUP BY Description
ORDER BY TotalRevenue;




SELECT * FROM CleanedRetail;

