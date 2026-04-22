/* #1. 
 Subtract the count of the non-null ticker values from the total 
number of rows in fortune500; alias the difference as missing.
*/
SELECT count(*) - COUNT(ticker) AS missing
  FROM fortune500;

/* #2.  Repeat for the industry column: subtract the count of the 
  non-null industry values from the total number of rows in fortune500; alias the difference as missing.
*/
  SELECT COUNT(*) - COUNT(industry) AS missing
FROM fortune500

/* #3.  Closely inspect the contents of the company and fortune500 
tables to find a column present in both tables that can also be considered 
to uniquely identify each company.
Join the company and fortune500 tables with an INNER JOIN.
*/
SELECT company.name 
  FROM company 
       INNER JOIN fortune500 
       ON company.ticker=fortune500.ticker;


/* #4.
First, using the tag_type table, count the number of tags with each type.
Order the results to find the most common tag type.
*/
SELECT type, count(*) AS count
  FROM tag_type
 GROUP BY type

 ORDER BY count DESC;

 /* #5.
Join the tag_company, company, and tag_type tables, keeping only mutually occurring records.
Select company.name, tag_type.tag, and tag_type.type for tags with the most common type
 from the previous step.
*/
-- Select the 3 columns desired
SELECT name, tag_type.tag, tag_type.type
  FROM company
       INNER JOIN tag_company 
       ON company.id = tag_company.company_id
       INNER JOIN tag_type
       ON tag_company.tag = tag_type.tag
  WHERE type='cloud';

  /* #6.
Use coalesce() to select the first non-NULL value from industry, sector, or 'Unknown' as a fallback value.
Alias the result of the call to coalesce() as industry2.
Count the number of rows with each industry2 value.
Find the most common value of industry2.

  */
SELECT COALESCE(industry, sector, 'Unknown') AS industry2,
       
       COUNT(*) 
  FROM fortune500
 GROUP BY industry2
 ORDER BY count DESC
 LIMIT 1;

 /* #7.
Select profits_change and profits_change cast as integer from fortune500.
Look at how the values were converted.
 */ 
SELECT profits_change, 
       CAST(profits_change AS integer) AS profits_change_int
  FROM fortune500;

/* #8.
Select profits_change and profits_change cast as integer from fortune500.
Look at how the values were converted.
*/ 
SELECT 10/3, 
       10::numeric/3;

/* #9.
Now cast numbers that appear as text as numeric.
Note: 1e3 is scientific notation.
*/ 
SELECT '3.2'::numeric,
       '-123'::numeric,
       '1e3'::numeric,
       '1e-3'::numeric,
       '02314'::numeric,
       '0002'::numeric


/* #10.
Use GROUP BY and count() to examine the values of revenues_change.
Order the results by revenues_change to see the distribution.
*/
SELECT revenues_change, count(*) 
  FROM fortune500
 GROUP BY revenues_change 
 ORDER BY revenues_change;

 /* #11.
Repeat step 1, but this time, cast revenues_change as an integer 
to reduce the number of different values.
*/
SELECT revenues_change::integer, COUNT(*)
  FROM fortune500
 GROUP BY revenues_change::integer
 ORDER BY revenues_change;


  /* #12.
How many of the Fortune 500 companies had revenues increase in 2017 compared to 2016?
To find out, count the rows of fortune500 where revenues_change indicates an increase.
*/
-- Count rows 
SELECT COUNT(*)
  FROM fortune500
 -- Where...
 WHERE revenues_change > 0;

/* #13.
Compute revenue per employee by dividing revenues by employees; casting is used here to produce a numeric result.
Take the average of revenue per employee with avg(); alias this as avg_rev_employee.
Group by sector.
Order by the average revenue per employee.
*/
SELECT sector, 
       AVG(revenues/employees::numeric) AS avg_rev_employee
  FROM fortune500
 GROUP BY sector
 ORDER BY avg_rev_employee;