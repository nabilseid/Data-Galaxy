/*
TODO fill description
*/

-- solution
WITH Max_Score AS (
    SELECT
        Submissions.hacker_id,
        Hackers.name,
        Submissions.challenge_id,
        MAX(Submissions.score) as score
    FROM Hackers
    INNER JOIN Submissions
        ON Hackers.hacker_id = Submissions.hacker_id
    GROUP BY Submissions.hacker_id, Hackers.name, Submissions.challenge_id
)

SELECT 
    hacker_id,
    name,
    SUM(score)
FROM Max_Score
GROUP BY hacker_id, name
HAVING SUM(score) > 0
ORDER BY SUM(score) DESC, hacker_id;
