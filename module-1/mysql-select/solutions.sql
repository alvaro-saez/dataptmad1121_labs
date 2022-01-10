-- Challenge 1 - Who Have Published What At Where?
--        Authors → au
--        Discounts → dc
--        Employee → ep
--        Jobs → jb
--        Pub_info → pbi
--        Publishers → pbs
--        Roysched → ry
--        Sales → sls
--        Stores → sts
--        Titleauthor → ttau
--        Title → tt
SELECT au.au_id AS "AUTHOR ID", au.au_lname AS [LAST NAME], au.au_Fname AS "FIRST NAME", tt.title AS [TITLE], pbs.pub_name AS "PUBLISHER"
FROM authors AS au
    INNER JOIN titleauthor AS ttau ON ttau.au_id = au.au_id
    INNER JOIN titles AS tt ON tt.title_id = ttau.title_id
    INNER JOIN publishers AS pbs ON pbs.pub_id = tt.pub_id


-- Challenge 2 - Who Have Published How Many At Where?
--        we will make a count but we have not to add title as a column because we would increase granularity and the count would be always 1
SELECT au.au_id AS "AUTHOR ID", au.au_lname AS [LAST NAME], au.au_Fname AS "FIRST NAME", pbs.pub_name AS "PUBLISHER", COUNT(DISTINCT tt.title) AS "TITLE COUNT", SUM(COUNT(DISTINCT tt.title)) OVER() AS "SUM TITLE COUNT"
FROM authors AS au
    INNER JOIN titleauthor AS ttau ON ttau.au_id = au.au_id
    INNER JOIN titles AS tt ON tt.title_id = ttau.title_id
    INNER JOIN publishers AS pbs ON pbs.pub_id = tt.pub_id
GROUP BY au.au_id, au.au_lname, au.au_Fname, pbs.pub_name
ORDER BY 1 DESC

-- Challenge 3 - Best Selling Authors
 
SELECT TOP 3 au.au_id AS "AUTHOR ID", au.au_lname AS [LAST NAME], au.au_Fname AS "FIRST NAME", SUM(sls.qty) AS [TOTAL]
FROM authors AS au
    INNER JOIN titleauthor AS ttau ON ttau.au_id = au.au_id
    INNER JOIN sales AS sls ON sls.title_id = ttau.title_id
GROUP BY au.au_id, au.au_lname, au.au_Fname
ORDER BY 4 DESC

-- Challenge 4 - Best Selling Authors Ranking

SELECT au.au_id AS "AUTHOR ID", au.au_lname AS [LAST NAME], au.au_Fname AS "FIRST NAME", ISNULL(SUM(sls.qty), 0) AS [TOTAL]
FROM authors AS au
    FULL JOIN titleauthor AS ttau ON ttau.au_id = au.au_id
    FULL JOIN sales AS sls ON sls.title_id = ttau.title_id
GROUP BY au.au_id, au.au_lname, au.au_Fname
ORDER BY 4 DESC