/*
TODO fill description
*/

-- solution
SELECT
    COUNTRY.Continent,
    FLOOR(AVG(CITY.Population))
FROM CITY
INNER JOIN COUNTRY
    ON CITY.CountryCode = COUNTRY.Code
GROUP BY COUNTRY.Continent;
