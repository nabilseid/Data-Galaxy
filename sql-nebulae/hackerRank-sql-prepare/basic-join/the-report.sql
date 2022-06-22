/*
TODO fill description
*/

-- solution
SELECT
    CASE -- for shorter syntax -> IF(Grades.Grade < 8, NULL, Students.Name)
        WHEN Grades.Grade < 8 THEN NULL
        ELSE Students.Name
    END,
    Grades.Grade,
    Students.Marks
FROM Students, Grades
WHERE Students.Marks BETWEEN Grades.Min_Mark AND Grades.Max_Mark
ORDER BY Grades.Grade DESC, Students.Name, Students.Marks;
