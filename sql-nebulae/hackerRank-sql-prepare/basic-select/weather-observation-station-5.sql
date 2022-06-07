/*
Query the two cities in STATION with the shortest and longest CITY names,
as well as their respective lengths (i.e.: number of characters in the name).
If there is more than one smallest or largest city, choose the one that comes
first when ordered alphabetically.

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

Sample Input

For example, CITY has four entries: DEF, ABC, PQRS and WXY.

Sample Output

ABC 3
PQRS 4

Explanation

When ordered alphabetically, the CITY names are listed as ABC, DEF, PQRS, and 
WXY, with lengths  and . The longest name is PQRS, but there are  options For
shortest named city. Choose ABC, because it comes first alphabetically.

Note

You can write two separate queries to get the desired output. It need not be 
a single query.
*/

SELECT CITY, LENGTH(CITY)
FROM station
WHERE CITY = (SELECT CITY 
	      FROM station 
	      ORDER BY LENGTH(CITY), CITY
	      LIMIT 1)
   OR CITY = (SELECT CITY
	      FROM station 
	      ORDER BY LENGTH(CITY) DESC, CITY 
	      LIMIT 1);

-- Other solutions
SELECT CITY, LENGTH(CITY)
FROM STATION
ORDER BY LENGTH(CITY), CITY
LIMIT 1
UNION ALL	-- UNION removes duplicate records, UNION ALL does not.
SELECT CITY, LENGTH(CITY)
FROM STATION
ORDER BY LENGTH(CITY) DESC, CITY
LIMIT 1;
