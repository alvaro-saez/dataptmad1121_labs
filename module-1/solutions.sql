-- Challenge 1 - Most Profiting Authors
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

-- Step 1: Calculate the royalty of each sale for each author and the advance for each author and publication

SELECT tt.title_id, 
ttau.au_id, 
tt.advance*ttau.royaltyper/100 AS [advance],
tt.price * sls.qty * tt.royalty / 100 * ttau.royaltyper / 100 AS "sales_royalty"
FROM titles AS tt 
    INNER JOIN titleauthor AS ttau ON tt.title_id = ttau.title_id
    INNER JOIN sales AS sls ON tt.title_id = sls.title_id

-- Step 2: Aggregate the total royalties for each title and author
SELECT tt.title_id, 
ttau.au_id,
sum(tt.price * sls.qty * tt.royalty / 100 * ttau.royaltyper / 100) AS "agregated sales_royalty" -- an option could have been to create another table with the previous query and call this table to make the sum aggregated function
FROM titles AS tt 
    INNER JOIN titleauthor AS ttau ON tt.title_id = ttau.title_id
    INNER JOIN sales AS sls ON tt.title_id = sls.title_id
GROUP BY tt.title_id, ttau.au_id

-- Step 3: Calculate the total profits of each author
SELECT TOP 3
ttau.au_id,
sum(tt.price * sls.qty * tt.royalty / 100 * ttau.royaltyper / 100) AS "agregated sales_royalty", -- an option could have been to create another table with the previous query and call this table to make the sum aggregated function
sum(tt.advance*ttau.royaltyper/100) AS "agregated advanced", -- an option could have been to create another table with the previous query and call this table to make the sum aggregated function
sum(tt.price * sls.qty * tt.royalty / 100 * ttau.royaltyper / 100) + sum(tt.advance*ttau.royaltyper/100) AS [total profits]
FROM titles AS tt 
    INNER JOIN titleauthor AS ttau ON tt.title_id = ttau.title_id
    INNER JOIN sales AS sls ON tt.title_id = sls.title_id
GROUP BY ttau.au_id
ORDER BY "total profits" DESC


-- Challenge 2 - Alternative Solution - TEMPORAL TABLE

SELECT tt.title_id, 
ttau.au_id, 
tt.advance*ttau.royaltyper/100 AS [advance],
tt.price * sls.qty * tt.royalty / 100 * ttau.royaltyper / 100 AS "sales_royalty"
INTO #alternative_profit
FROM titles AS tt 
    INNER JOIN titleauthor AS ttau ON tt.title_id = ttau.title_id
    INNER JOIN sales AS sls ON tt.title_id = sls.title_id

SELECT TOP 3
au_id,
sum(advance) AS "advance",
sum(sales_royalty) AS "sales_royalty",
sum(advance) + sum(sales_royalty) AS [total profit]
FROM #alternative_profit
GROUP BY au_id
ORDER BY "total profit" DESC


-- Challenge 3 - Alternative Solution - PERMANENT TABLE


SELECT tt.title_id, 
ttau.au_id, 
tt.advance*ttau.royaltyper/100 AS [advance],
tt.price * sls.qty * tt.royalty / 100 * ttau.royaltyper / 100 AS "sales_royalty"
INTO alternative_permanent_profit
FROM titles AS tt 
    INNER JOIN titleauthor AS ttau ON tt.title_id = ttau.title_id
    INNER JOIN sales AS sls ON tt.title_id = sls.title_id

SELECT TOP 3
au_id,
sum(advance) AS "advance",
sum(sales_royalty) AS "sales_royalty",
sum(advance) + sum(sales_royalty) AS [total profit]
FROM alternative_permanent_profit
GROUP BY au_id
ORDER BY "total profit" DESC