/*
TODO fill description
*/

-- solution
SELECT
    Submissions.hacker_id,
    MIN(Hackers.name)
FROM Submissions
INNER JOIN Challenges
    ON Submissions.challenge_id = Challenges.challenge_id
    INNER JOIN Difficulty
        ON Challenges.difficulty_level = Difficulty.difficulty_level
        INNER JOIN Hackers
            ON Submissions.hacker_id = Hackers.hacker_id
WHERE Submissions.score = Difficulty.score
GROUP BY Submissions.hacker_id
HAVING COUNT(Submissions.hacker_id) > 1
ORDER BY COUNT(Submissions.hacker_id) DESC, Submissions.hacker_id
