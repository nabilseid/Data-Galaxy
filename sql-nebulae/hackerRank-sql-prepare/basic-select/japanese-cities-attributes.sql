/*
Query all attributes of every Japanese city in the CITY table.
The COUNTRYCODE for Japan is JPN.

The CITY table is described as follows:
__________________________
|Field       |TYPE         |
 --------------------------
|ID          |NUMBER       |
|NAME        |VARCHAR2(17) |
|COUNTRYCODE |VARCHAR2(3)  |
|DISTRICT    |VARCHAR2(20) |
|POPULATION  |NUMBER       |
 --------------------------
*/

SELECT *
FROM city
WHERE COUNTRYCODE = 'JPN';
