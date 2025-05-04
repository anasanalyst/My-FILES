CREATE DATABASE salespractise;
USE salespractise;
SELECT * FROM retail;

-------- CREATING 2 TABLE TO PERFROM QUERIES --------
CREATE TABLE retail2
LIKE retail;
--------- Puting all values from reatils to retail2------
INSERT INTO retail2
SELECT * FROM retail;

------ TABLE CREATED AND ALL VALUES ADDED -------
SELECT * FROM retail2;
----- changing the name of the 1 columnn since its a bit difficult to read
ALTER TABLE retail2
CHANGE ï»¿InvoiceNo INVOICE_No INT;

------- Lets check for duplicates -----

SELECT*,
ROW_NUMBER() OVER(PARTITION BY INVOICE_No, InvoiceDate, InvoiceTime, StockCode, `Description`,
 Quantity, UnitPrice, Totalsale, CustomerID, Country) AS row_num
 FROM retail2;
 ------- From the above we can easily find the duplicates by putting the query in CTE and if row_num() is >1 than it means there are duplicates which need to be removed-------
 
 ---- CREATING CTE TO IDENTIFY Duplicates------
 
 WITH CTE_retail2 AS (
SELECT*,
ROW_NUMBER() OVER(PARTITION BY INVOICE_No, InvoiceDate, InvoiceTime, StockCode, `Description`,
 Quantity, UnitPrice, Totalsale, CustomerID, Country) AS row_num
 FROM retail2 
 )
 SELECT * FROM CTE_retail2 
 WHERE row_num >1;
 
 ----- Duplicates Have been marked and to remove them we need to make a new table with row_num Column becuase remove/delete statement is same as updating the table------
 ----- Using create statement from the table -----
 
 
 CREATE TABLE `retail3` (
  `INVOICE_No` int DEFAULT NULL,
  `InvoiceDate` text,
  `InvoiceTime` text,
  `StockCode` text,
  `Description` text,
  `Quantity` int DEFAULT NULL,
  `UnitPrice` double DEFAULT NULL,
  `Totalsale` double DEFAULT NULL,
  `CustomerID` int DEFAULT NULL,
  `Country` text,
  `row_num` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

---- Inserting values from retail2 using the row_num ------

 INSERT INTO retail3
 SELECT*,
ROW_NUMBER() OVER(PARTITION BY INVOICE_No, InvoiceDate, InvoiceTime, StockCode, `Description`,
 Quantity, UnitPrice, Totalsale, CustomerID, Country) AS row_num
 FROM retail2;
 
 SELECT * FROM retail3;
 ----- NOW I WILL USE THE DELETE STATEMENT WITH WHERE TO DELETE row-num greater than 1 ----------
 DELETE FROM retail3
 WHERE row_num>1;
 
 SELECT * FROM retail3;
 

---- Performing some Business Intelligence queries ----------
 
--------- Top 10 Most sold Product by Quantity -------- 
 SELECT Description, SUM(Quantity) AS TotalQuantity
FROM retail3
GROUP BY Description
ORDER BY TotalQuantity DESC
LIMIT 10;
---------------------------------------------------------

-------- Top countires with the most revenue exluding UK -------
SELECT * FROM retail3;

SELECT Country, SUM(Quantity * UnitPrice) AS Revenue
FROM retail3
WHERE Country != 'United Kingdom'
GROUP BY Country
ORDER BY Revenue DESC
LIMIT 5;

----- Finding the Total Revenue----

SELECT SUM(Quantity * UnitPrice) AS Totla_Revenue
FROM retail3;

-------- Changing the Data Type of the InvoiceDate to Date From text --------
SELECT `InvoiceDate`,
STR_TO_DATE(InvoiceDate, '%d-%m-%Y')
FROM retail3; 
 UPDATE retail3
 SET InvoiceDate=STR_TO_DATE(InvoiceDate, '%d-%m-%Y');
 ALTER TABLE retail3
 MODIFY COLUMN `InvoiceDate`  DATE;
 
 -------- Finding the Monthly Revenue Generated--------
 
 SELECT DATE_FORMAT(InvoiceDate, '%Y-%m') AS Month, 
       SUM(Quantity * UnitPrice) AS Revenue
FROM retail3
GROUP BY Month
ORDER BY Month;

------------------------------------------------------------
----- Differentiating Customer segmentation depending on Revenue----

SELECT * FROM retail3;
SELECT CustomerID,
	SUM(Quantity * UnitPrice) AS Revenue,
    CASE 
    WHEN SUM(Quantity * UnitPrice) > 1000 THEN "High Value"
    WHEN SUM(Quantity * UnitPrice) Between 500 AND 1000 THEN "MEDIUM VALUE"
    ELSE 'LOW VALUE'
    END AS REVENUE_SEGMENT
    
FROM retail3
GROUP BY CustomerID
ORDER BY REVENUE_SEGMENT;

----------- END OF Business Intelligence Queries -------

