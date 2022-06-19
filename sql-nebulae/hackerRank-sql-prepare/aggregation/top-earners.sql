/*
TODO add description
*/

-- solution
SELECT months * salary, COUNT(*) AS freq
FROM Employee
GROUP BY months * salary
ORDER BY freq DESC
LIMIT 1;

-- other solution from internet
SELECT MAX(salary*months), COUNT(*)
FROM Employee
WHERE (salary*months) = (SELECT MAX(salary*months)
                         FROM Employee);
