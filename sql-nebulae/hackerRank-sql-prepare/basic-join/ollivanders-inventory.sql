/*
TODO fill description
*/

-- solution MS SQL Server
WITH Ranked_Wands AS (
    SELECT
        Wands.id,
        Wands_Property.age,
        Wands.coins_needed,
        Wands.power,
        ROW_NUMBER() OVER(PARTITION BY Wands_Property.age, Wands.power
                                 ORDER BY Wands.coins_needed) AS rank
    FROM Wands
    INNER JOIN WANDS_Property
        ON Wands.code = Wands_Property.code
    WHERE Wands_Property.is_evil = 0
)

SELECT
    id,
    age,
    coins_needed,
    power
FROM Ranked_Wands
WHERE rank = 1
ORDER BY power DESC, age DESC;
