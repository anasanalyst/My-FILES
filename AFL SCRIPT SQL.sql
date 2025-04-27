CREATE DATABASE PR;
USE PR;
SELECT * FROM games;

-------------- In order to get started we will make a new table from the game table so we can start writting the queries---------------------------
 CREATE TABLE games2
 LIKE games;
 ------ Table created, now we will pull all the values from games to games2 in order to get started------
 INSERT INTO games2
 SELECT * FROM games;
 ----- Values added succesfully-------
 SELECT * FROM games2;
 
SELECT*,
ROW_NUMBER() OVER(PARTITION BY GameId, `YEAR`, Round, `Date`,MaxTemp, MinTemp, Rainfall, Venue, StartTime,
Attendance, HomeTeam, HomeTeamScoreQt, HomeTeamScoreHt,HomeTeamScore3QT,HomeTeamScoreFt,HomeTeamScore,
AwayTeam,AwayTeamScoreQT,AwayTeamScoreHT,AwayTeamScore3QT,AwayTeamScoreFT,AwayTeamScore) as row_num
FROM games2;
 
 
 --------- Creating a CTE inorder to know do we have a duplicate or not------
 WITH nflCTE AS (
 
SELECT*,
ROW_NUMBER() OVER(PARTITION BY GameId, `YEAR`, Round, `Date`,MaxTemp, MinTemp, Rainfall, Venue, StartTime,
Attendance, HomeTeam, HomeTeamScoreQt, HomeTeamScoreHt,HomeTeamScore3QT,HomeTeamScoreFt,HomeTeamScore,
AwayTeam,AwayTeamScoreQT,AwayTeamScoreHT,AwayTeamScore3QT,AwayTeamScoreFT,AwayTeamScore) as row_num
FROM games2
 
 )
 SELECT * FROM
 nflCTE WHERE row_num >1;
 ------------------ by the help of CTE Funtion it is clear that we do not have any Duplicates in our Data and we can proceed to data normilization------
 Select *
 From games2;
 
 
 Select DISTINCT GameId, TRIM(GameId)games2
 FROM games2;
 ----- Checking if the data got any nulls or na, apart from this looking for any un-necassry sybols or spaces--------
 
 SELECT * FROM
 games2
 WHERE Year IS NULL OR `Date`= '' ;
------- There are No Nulls and missing values in this Dataset, apart from this we need to make the Datatypes correct of Year and Date Column------


------------ USING the Alter function to change the data type of the Date Column----
ALTER TABLE games2
MODIFY Date Date;
 
 ALTER TABLE games2
MODIFY Year YEAR;

SELECT * FROM
games2;
--------- NOW We WIll IMPORT THIS AS A CSV AND WORK IN PANDAS TO FIND THE TRENDS AND apply some visualization libraries as well---------
