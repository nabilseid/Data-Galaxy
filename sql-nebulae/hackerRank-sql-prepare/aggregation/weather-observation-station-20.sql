/*
A median is defined as a number separating the higher half of a data set from 
the lower half. Query the median of the Northern Latitudes (LAT_N) from STATION 
and round your answer to 4 decimal places.

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

-- solution
WITH POSITIONED AS (
    SELECT
        ROW_NUMBER() OVER (ORDER BY LAT_N ASC) AS ROW_NUM,
        LAT_N
    FROM STATION
)

SELECT ROUND(AVG(LAT_N), 4)
FROM POSITIONED
WHERE ROW_NUM = CEIL((SELECT COUNT(*) FROM STATION) / 2) OR
      ROW_NUM = CEIL((SELECT COUNT(*) FROM STATION) / 2 + 0.1);
