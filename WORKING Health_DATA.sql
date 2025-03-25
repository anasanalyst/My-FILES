CREATE DATABASE health;
USE health;

SELECT *
 FROM Health_Data;
 
----------------- Creating a new table on which we will perform our funtion ---------------------
Create Table Health_Data2
LIKE Health_Data;
-------------- Inserting values from other Table -----------
INSERT INTO Health_Data2
SELECT * FROM Health_Data; 
 
 
 -------------- Using Row_NUMBER() and window function to check the duplicates ------------------
 SELECT *,
 ROW_NUMBER() OVER(PARTITION BY `Name`,	Age,	Gender,	`Blood Type`,	`Medical Condition`,	`Date of Admission`	,`Doctor`, `Hospital`,
 `Insurance Provider`,	`Billing Amount`,	`Room Number`,	`Admission Type`,	`Discharge Date`,	`Medication`,	`Test Results`) AS row_num
FROM Health_Data2;
----------------- There are sum duplicated so we will make a CTE and through which we will make a new table and go to Data cleaning--------------------------------

--------------- Creating CTE --------------------
WITH HEALTH_DUP AS (
 SELECT *,
 ROW_NUMBER() OVER(PARTITION BY `Name`,	Age,	Gender,	`Blood Type`,	`Medical Condition`,	`Date of Admission`	,`Doctor`, `Hospital`,
 `Insurance Provider`,	`Billing Amount`,	`Room Number`,	`Admission Type`,	`Discharge Date`,	`Medication`,	`Test Results`) AS row_num
FROM Health_Data

)
SELECT* FROM HEALTH_DUP
WHERE row_num >1;

/*
	AS WE HAVE ALREADY GOT THE DUPLICATES SO TO DELETE THEM WE NEED TO MAKE A NEW TABLE 
    BUT THIS TIME WE WILL NEED TO MAKE THE TABLE WITH THE row_num COLUMN AS WELL IN-ORDER TO 
    DELETE THE DUPLICATED VALUES. WE ARE MAKING A NEW TABLE AGAIN BECAUSE DELETE QUERY ITSELF IS A UPDATE QUERY.
    THE NEW TABLE WILL BE MADE FROM THE CTE AND I'M GOING TO SHOW YOU HOW. WE WILL USE THE CREATE STATEMENT FROM TABLE DATA_HEALTH2
*/

CREATE TABLE `health_data3` (
  `Name` text,
  `Age` int DEFAULT NULL,
  `Gender` text,
  `Blood Type` text,
  `Medical Condition` text,
  `Date of Admission` text,
  `Doctor` text,
  `Hospital` text,
  `Insurance Provider` text,
  `Billing Amount` double DEFAULT NULL,
  `Room Number` int DEFAULT NULL,
  `Admission Type` text,
  `Discharge Date` text,
  `Medication` text,
  `Test Results` text,
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

SELECT *
FROM Health_data3;
/*
inserting values from CTE TO Health_Data3
*/
INSERT INTO Health_Data3
 SELECT *,
 ROW_NUMBER() OVER(PARTITION BY `Name`,	Age,	Gender,	`Blood Type`,	`Medical Condition`,	`Date of Admission`	,`Doctor`, `Hospital`,
 `Insurance Provider`,	`Billing Amount`,	`Room Number`,	`Admission Type`,	`Discharge Date`,	`Medication`,	`Test Results`) AS row_num
FROM Health_Data2;

SELECT * FROM Health_Data3
WHERE row_num >1;
------- DELETE FROM THE TABLE WHERE row_num >1 ------------
DELETE FROM Health_Data3
WHERE row_num>1;
SELECT* FROM Health_Data3
WHERE row_num>1;

/*
We have gotten rid of the dupliucates now it's time to standardize the data
*/

Select Distinct `Name`,  TRIM(Name)
FROM Health_Data3;
Select Distinct `Name`,  Lower(Name)
FROM Health_Data3;

UPDATE Health_Data3
SET `Name`=TRIM(Name);

---- Since the names are in upper and lower cases we will use the concat with the Lower and Upper string function to make them readabale ------
SELECT Name, CONCAT(UPPER(SUBSTRING(Name, 1, 1)), LOWER(SUBSTRING(Name, 2))) AS normal_case_name
FROM Health_Data;

Update Health_Data3
Set Name=CONCAT(UPPER(SUBSTRING(Name, 1, 1)), LOWER(SUBSTRING(Name, 2)));
SELECT DISTINCT Name
FROM Health_Data3
WHERE NAME LIKE "Aaron%"
;
SELECT Name, REPLACE(Name, ".", '') as Cleaned_name
FROM Health_Data3;

UPDATE Health_Data3
SET Name= REPLACE(Name, ".", '');
SELECT  DISTINCT *
FROM Health_Data3;

SELECT DISTINCT *
FROM Health_Data3
Order By Name;


SELECT *,
CASE
	When Gender = 'Male' THEN "MALE PATIENTS"
    ELSE "FEMALE PATIENTS"
END AS "PATIENTS CATEGORY"
FROM Health_Data3
ORDER BY Gender;

SELECT DISTINCT `Billing Amount`
FROM Health_Data3;
SELECT Floor(`Billing Amount`) AS Billing
FROM Health_Data3;
UPDATE Health_Data3
SET `Billing Amount` =  Floor(`Billing Amount`);
SELECT * 
FROM Health_Data3
ORDER By Gender ;

SELECT DISTINCT `Insurance Provider`
FROM Health_Data3;

Update Health_Data3
Set `Insurance Provider`= "United Health Care"
Where `Insurance Provider` = "UnitedHealthcare";


SELECT DISTINCT Hospital
FROM Health_Data3
Where Hospital LIKE 'and%%%' ;

SELECT * FROM 
Health_Data3;



AlTER TABLE Health_Data3
DROP COLUMN row_num;
SELECT * FROM Health_Data3;

SELECT DISTINCT NAME
FROM Health_Data3;
UPDATE Health_Data3
SET Name = CONCAT(UPPER(LEFT(Name, 1)), LOWER(SUBSTRING(Name, 2)));

UPDATE Health_Data3
SET Name = CONCAT(
    LEFT(Name, LOCATE(' ', Name)),  -- Extract the first name
    UPPER(LEFT(SUBSTRING_INDEX(Name, ' ', -1), 1)),  -- Uppercase first letter of last name
    LOWER(SUBSTRING(SUBSTRING_INDEX(Name, ' ', -1), 2))  -- Lowercase remaining letters of last name
);

Update Health_Data3
SET Name = CONCAT(
    LEFT(Name, LOCATE(' ', Name)),  -- Extract the first name
    UPPER(LEFT(SUBSTRING_INDEX(Name, ' ', -1), 1)),  -- Uppercase first letter of last name
    LOWER(SUBSTRING(SUBSTRING_INDEX(Name, ' ', -1), 2))  -- Lowercase remaining letters of last name
);


SELECT * FROM Health_Data3
;