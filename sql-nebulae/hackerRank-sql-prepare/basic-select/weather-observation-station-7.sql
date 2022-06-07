/*
Query the list of CITY names ending with vowels (a, e, i, o, u) from STATION.
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

-- MySQL solutions
-- Using regex patters
SELECT DISTINCT CITY FROM STATION
WHERE CITY REGEXP '.*[aeiou]$';

-- https://dev.mysql.com/doc/refman/8.0/en/regexp.html
-- https://www.w3resource.com/mysql/string-functions/mysql-regexp-function.php

-- Using IN(1,2,3) operator
SELECT DISTINCT CITY
FROM station
WHERE LOWER(RIGHT(CITY, 1)) IN('a', 'e', 'i', 'o', 'u');

-- check weather-observation-station-6.sql for reference

-- MS SQL Server solution 
SELECT DISTINCT CITY
FROM STATION
WHERE LOWER(CITY) Like '%[aeiou]';
