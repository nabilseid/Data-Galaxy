/*
Pivot the Occupation column in OCCUPATIONS so that each Name is sorted 
alphabetically and displayed underneath its corresponding Occupation. The output 
column headers should be Doctor, Professor, Singer, and Actor, respectively.

Note: Print NULL when there are no more names corresponding to an occupation.

Input Format

The OCCUPATIONS table is described as follows:

+-------------+-----------+
| Column      |   Type    |
+-------------+-----------+
| Name        | STRING    |
| Occupation  | STRING    |
+-------------+-----------+

Occupation will only contain one of the following values: Doctor, 
Professor, Singer or Actor.

Sample Input

An OCCUPATIONS table that contains the following records:

+------------------------+
| Name      | Occupation |
+------------------------+
| Samantha  | Doctor     |
| Julia     | Actor      |
| Maria     | Actor      |
| Meera     | Singer     |
| Ashely    | Professor  |
| Ketty     | Professor  |
| Christeen | Professor  |
| Jane      | Actor      |
| Jenny     | Doctor     |
| Priya     | Singer     |
+------------------------+

Sample Output

Jenny    Ashley     Meera  Jane
Samantha Christeen  Priya  Julia
NULL     Ketty      NULL   Maria

Explanation

The first column is an alphabetically ordered list of Doctor names.
The second column is an alphabetically ordered list of Professor names.
The third column is an alphabetically ordered list of Singer names.
The fourth column is an alphabetically ordered list of Actor names.
The empty cell data for columns with less than the maximum number of names 
per occupation (in this case, the Professor and Actor columns) are filled 
with NULL values.
*/

-- MS SQL Server solution
WITH ranked AS ( -- with row position cte 
    SELECT
        a.Occupation,
        a.Name,
        (SELECT COUNT(*)
         FROM Occupations AS b
         WHERE a.occupation = b.occupation AND a.Name > b.Name) AS Pos
    FROM Occupations AS a
),
pivot_table AS ( -- pivot table cte
    SELECT * FROM
    (
        SELECT Occupation, Name, Pos
        FROM ranked
    ) temp_t
    PIVOT(
        Min(Name)
        FOR Occupation IN (Doctor, Professor, Singer, Actor)
    ) AS temp_pivot
)

-- Using select with case and arranging names using pos 
SELECT
    MIN(CASE WHEN Occupation = 'Doctor' THEN Name ELSE NULL END) AS Doctor,
    MIN(CASE WHEN Occupation = 'Professor' THEN Name ELSE NULL END) AS Professor,
    MIN(CASE WHEN Occupation = 'Singer' THEN Name ELSE NULL END) AS Singer,
    MIN(CASE WHEN Occupation = 'Actor' THEN Name ELSE NULL END) AS Actor
FROM ranked
GROUP BY Pos;

-- Using pivot table, PIVOT will do the pivoting 
SELECT Doctor, Professor, Singer, Actor
FROM pivot_table;

-- ref https://linuxhint.com/mysql_pivot/#:~:text=A%20database%20table%20can%20store,a%20table%20into%20column%20values.
-- https://www.databasestar.com/mysql-pivot/
