/*
Query the list of CITY names from STATION that either do not start with vowels 
or do not end with vowels. Your result cannot contain duplicates.

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
WHERE CITY REGEXP '^[^aeiou].*|.*[^aeiou]$';

-- '^[^aeiou].*|^.*[^aeiou]$' works also
