/*
Query the difference between the maximum and minimum populations in CITY.

Input Format

The CITY table is described as follows:

+--------------------------+
|Field       |TYPE         |
+--------------------------+
|ID          |NUMBER       |
|NAME        |VARCHAR2(17) |
|COUNTRYCODE |VARCHAR2(3)  |
|DISTRICT    |VARCHAR2(20) |
|POPULATION  |NUMBER       |
+--------------------------+
*/

-- solution
SELECT MAX(POPULATION) - MIN(POPULATION)
FROM CITY;
