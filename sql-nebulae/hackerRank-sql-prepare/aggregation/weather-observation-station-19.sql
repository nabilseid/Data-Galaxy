/*
Consider P1(a,b) and P2(b,d) to be two points on a 2D plane where  are the 
respective minimum and maximum values of Northern Latitude (LAT_N) and  are the 
respective minimum and maximum values of Western Longitude (LONG_W) in STATION.

Query the Euclidean Distance between points P1 and P2 and format your answer to 
display 4 decimal digits.

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
SELECT
    TRUNCATE(
        SQRT(
            POWER(MAX(LAT_N) - MIN(LAT_N), 2) +
            POWER(MAX(LONG_W) - MIN(LONG_W), 2)
        ),
        4
    )
FROM STATION;
