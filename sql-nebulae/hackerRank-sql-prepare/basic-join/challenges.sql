/*
TODO fill description
*/

-- solution
WITH Challenge_Count AS (
    SELECT
        Hackers.hacker_id,
        Hackers.name,
        COUNT(Hackers.hacker_id) AS challenges_created
    FROM Hackers, Challenges
    WHERE Hackers.hacker_id = Challenges.hacker_id
    GROUP BY Hackers.hacker_id, Hackers.name
)

SELECT
    hacker_id,
    name,
    challenges_created
FROM Challenge_Count
WHERE hacker_id IN (SELECT MIN(hacker_id)
                    FROM Challenge_Count
                    GROUP BY challenges_created
                    HAVING COUNT(challenges_created) = 1) OR
      challenges_created = (SELECT MAX(challenges_created)
                            FROM Challenge_Count)
ORDER BY challenges_created DESC, hacker_id;
