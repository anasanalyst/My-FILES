CREATE DATABASE project2;
USE project2;


----------  Using the Select statement INORDER to get the VAlUES---------

SELECT * FROM walmart_sales;
----------- Creating a new table on which we will perform our function inorder to start the work ---------------

CREATE TABLE walmart_sales2

LIKE walmart_sales;
------- putting all the values from walmart_sales to walmart_sales2---------------------

INSERT INTO walmart_sales2
SELECT * FROM walmart_sales;

--------- Successfully created the new table and now we will look for duplicates-----------------------

SELECT * FROM walmart_sales2;
------------ USING ROW_NUMBER in order to know the duplicates and than we will make a CTE after --------

SELECT*,
ROW_NUMBER() OVER(PARTITION BY Store, `Date`, Weekly_sales, Holiday_Flag,
Temperature, Fuel_Price, CPI, Unemployment) AS row_num
FROM walmart_sales2;


--------------- using cte with row_number to know do we have any duplicates or not --------------------

WITH CTE_walmart AS (
SELECT*,
ROW_NUMBER() OVER(PARTITION BY Store, `Date`, Weekly_sales, Holiday_Flag,
Temperature, Fuel_Price, CPI, Unemployment) AS row_num
FROM walmart_sales2

)
SELECT * FROM
CTE_walmart
WHERE row_num>1;

-------------- USing the CTE function we found no duplicates, which states that the table have no duplicates values --------------------
 
------ Now we will standardize the data------------------------

SELECT * FROM walmart_sales2
ORDER BY Weekly_sales DESC;

SELECT DISTINCT `Temperature`
FROM walmart_sales2;
------------ The Data is in standard Form --------------

----- Now I will perfrom some random function to check the highes sales, tempratures etc---------------



--------- Checking the 2nd Highest weekly sales ---------
SELECT Distinct Weekly_sales
FROM walmart_sales2
ORDER BY Weekly_sales DESC
LIMIT 1, 1;


------- Checking the Average of the weekly sales by Using  the Store --------
SELECT * FROM walmart_sales2;
SELECT Store, Avg(Weekly_sales)as Average_Weeksale
FROM walmart_sales2
GROUP BY Store;

-------- Checking the MAXIMUM Temprature by the store --------------
SELECT Store, MAX(Temperature) AS MAX_TEMP
FROM walmart_sales2
Group BY Store
;

-------- Checking the MINIMUM Temprature by the store --------------
SELECT Store, MIN(Temperature) AS MIN_TEMP
FROM walmart_sales2
Group BY Store
;
SELECT * FROM walmart_sales2;
SELECT Store, COUNT(Weekly_sales) AS TOTAL_Sales
FROM walmart_sales2
GROUP BY Store;


