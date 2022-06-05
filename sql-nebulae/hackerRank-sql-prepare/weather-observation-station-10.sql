/*
Query the list of CITY names from STATION that do not end with vowels. 
Your result cannot contain duplicates.

Input Format

The STATION table is described as follows:

+--------------------------+
|Field       |TYPE         |
+--------------------------+
|ID          |NUMBER       |
|CITY        |VARCHAR2(21) |
|STATE       |VARCHAR2(2)  |
|LAT_N       |NUMBER       |
|LONG_W      |NUMBER       |
+--------------------------+

where LAT_N is the northern latitude and LONG_W is the western longitude.
*/

-- MySQL solution
SELECT DISTINCT CITY FROM STATION
WHERE CITY REGEXP '.*[^aeiou]$'; -- '^.*[^aeiou]$' also works

-- `^` in regex indicates beginning character of a string

-- MS SQL Server
SELECT DISTINCT CITY
FROM STATION
WHERE LOWER(CITY) Like '%[^aeiou]'; -- [^...] -> not any of characters in `[]`
