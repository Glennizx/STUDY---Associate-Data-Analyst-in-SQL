/* Exercise 1
1.Use NOW() to select the current timestamp with timezone.
2.Select the current date without any time value.
3.Now, let's use the CAST() function to eliminate the timezone from the current timestamp.
4. Finally, let's select the current date.
Use CAST() to retrieve the same result from the NOW() function.
*/

SELECT 
	-- Select the current date
	CURRENT_DATE,
    -- CAST the result of the NOW() function to a date
    CAST( NOW() AS date )


--Exercise 2: Select the current timestamp without timezone and alias it as right_now.

SELECT CURRENT_TIMESTAMP::timestamp AS right_now;

-- Exercise 3: Now select a timestamp five days from now and alias it as five_days_from_now.

SELECT
	CURRENT_TIMESTAMP::timestamp AS right_now,
    interval '5 days' + CURRENT_TIMESTAMP AS five_days_from_now;

-- Exercise 4: Finally, let's use a second-level precision with no fractional digits for both the right_now and five_days_from_now fields.
SELECT
	CURRENT_TIMESTAMP(0)::timestamp AS right_now,
    interval '5 days' + CURRENT_TIMESTAMP(0) AS five_days_from_now;


-- Exercise 5: Get the day of the week from the rental_date column.

SELECT 
  -- Extract day of week from rental_date
  EXTRACT(dow FROM rental_date) AS dayofweek 
FROM rental 
LIMIT 100;


-- Exercise 6: Count the total number of rentals by day of the week.
-- Extract day of week from rental_date
SELECT 
  EXTRACT(dow FROM rental_date) AS dayofweek, 
  -- Count the number of rentals
  COUNT(rental_id) as rentals 
FROM rental 
GROUP BY 1;


-- Exercise 7: Truncate the rental_date field by year.
SELECT DATE_TRUNC('year', rental_date) AS rental_year
FROM rental;


-- Exercise 8: Now modify the previous query to truncate the rental_date by month.
SELECT DATE_TRUNC('month', rental_date) AS rental_month
FROM rental;

-- Exercie 9: Let's see what happens when we truncate by day of the month.
SELECT DATE_TRUNC('day', rental_date) AS rental_day 
FROM rental;


-- Exercise 10: Count the total number of rentals by rental_day and alias it as rentals

SELECT 
  DATE_TRUNC('day', rental_date) AS rental_day,
  -- Count total number of rentals 
  COUNT(rental_day) AS rentals 
FROM rental
GROUP BY 1;

-- Exercise 11: Extract the day of the week from the rental_date column using the alias dayofweek.
-- Use an INTERVAL in the WHERE clause to select records for the 90 day period starting on 5/1/2005.
SELECT 
  -- Extract the day of week date part from the rental_date
  EXTRACT(dow FROM rental_date) AS dayofweek,
  AGE(return_date, rental_date) AS rental_days
FROM rental AS r 
WHERE 
  -- Use an INTERVAL for the upper bound of the rental_date 
  rental_date BETWEEN CAST('2005-05-01' AS DATE)
   AND CAST('2005-05-01' AS DATE) + INTERVAL '90 day';



-- Exercise 12:  Finally, use a CASE statement and DATE_TRUNC() to create a
--  new column called past_due which will be TRUE if the rental_days is greater than the rental_duration otherwise, it will be FALSE
SELECT 
  c.first_name || ' ' || c.last_name AS customer_name,
  f.title,
  r.rental_date,
  EXTRACT(dow FROM r.rental_date) AS dayofweek,
  AGE(r.return_date, r.rental_date) AS rental_days,
  CASE WHEN DATE_TRUNC('day', AGE(r.return_date, r.rental_date)) > 
    f.rental_duration * INTERVAL '1' day 
  THEN TRUE 
  ELSE FALSE END AS past_due 
FROM 
  film AS f 
  INNER JOIN inventory AS i 
  	ON f.film_id = i.film_id 
  INNER JOIN rental AS r 
  	ON i.inventory_id = r.inventory_id 
  INNER JOIN customer AS c 
  	ON c.customer_id = r.customer_id 
WHERE 
  r.rental_date BETWEEN CAST('2005-05-01' AS DATE) 
  AND CAST('2005-05-01' AS DATE) + INTERVAL '90 day';


--Exercise 13: Concatenate the first_name and last_name columns
-- separated by a single space followed by email surrounded by < and >.
SELECT first_name || ' ' ||  last_name || ' <' || email || '>' AS full_email 
FROM customer

-- Exeercise 14: Now use the CONCAT() function to do the same operation as the previous step.
SELECT CONCAT(first_name, ' ', last_name,  ' <', email, '>') AS full_email 
FROM customer

/* Exercise 14: 
Convert the film category name to uppercase.
Convert the first letter of each word in the film's title to upper case.
Concatenate the converted category name and film title separated by a colon.
Convert the description column to lowercase.
*/
SELECT 
  UPPER(c.name)  || ': ' || INITCAP(f.title) AS film_category, 
  lower(description) AS description
FROM 
  film AS f 
  INNER JOIN film_category AS fc 
  	ON f.film_id = fc.film_id 
  INNER JOIN category AS c 
  	ON fc.category_id = c.category_id;


-- Exercise 15:  Replace all whitespace with an underscore.
SELECT 
  REPLACE(title, ' ', '_') AS title
FROM film; 

/* Exercise 16:
Select the title and description columns from the film table.
Find the number of characters in the description column with the alias desc_len
*/
SELECT 
  title,
  description,
  CHAR_LENGTH(description) AS desc_len
FROM film;

-- Exercise 17: Select the first 50 characters of the description column with the alias short_desc
SELECT 
  LEFT(description, 50) AS short_desc
FROM 
  film AS f; 

/* Exercise 17:
Extract only the street address without the street number from the address column.
Use functions to determine the starting and ending position parameters.
*/
SELECT 
  SUBSTRING(address FROM POSITION(' ' IN address)+1 FOR LENGTH(address))
FROM 
  address;

  /* Exercise 18:
Extract the characters to the left of the @ of the 
email column in the customer table and alias it as username.
Now use SUBSTRING to extract the characters after the @ 
of the email column and alias the new derived field as domain.
*/
SELECT
  LEFT(email, POSITION('@' IN email)-1) AS username,
  SUBSTRING(email FROM POSITION('@' IN email)+1 FOR LENGTH(email)) AS domain
FROM customer;

/* Exercise 19:
Add a single space to the end or right of the first_name column using a padding function.
Use the || operator to concatenate the padded first_name to the last_name column.
*/
SELECT 
	RPAD(first_name, LENGTH(first_name)+1) || last_name AS full_name
FROM customer;

/* Exercise 20:
Now add a single space to the left or beginning of the last_name column using a different padding function than the first step.
Use the || operator to concatenate the first_name column to the padded last_name.
*/
SELECT 
	first_name || LPAD(last_name, LENGTH(last_name)+1) AS full_name
FROM customer; 

/* Exercise 21:
Add a single space to the right or end of the first_name column.
Add the characters < to the right or end of last_name column.
Finally, add the characters > to the right or end of the email column.+
*/
SELECT 
	RPAD(first_name, LENGTH(first_name)+1) 
    || RPAD(last_name, LENGTH(last_name)+2, ' <') 
    || RPAD(email, LENGTH(email)+1, '>') AS full_email
FROM customer; 

/* Exercise 22:
Convert the film category name to uppercase and use the CONCAT() 
concatenate it with the title.
Truncate the description to the first 50 characters and 
make sure there is no leading or trailing whitespace after truncating.
*/
SELECT 
  CONCAT(UPPER(c.name), ': ', f.title) AS film_category, 
  TRIM(LEFT(description, 50)) AS film_desc
FROM 
  film AS f 
  INNER JOIN film_category AS fc 
  	ON f.film_id = fc.film_id 
  INNER JOIN category AS c 
  	ON fc.category_id = c.category_id;

  /* Exercise 23:
Get the first 50 characters of the description column
Determine the position of the last whitespace character 
of the truncated description column and subtract it from 
the number 50 as the second parameter in the first function above.
*/
SELECT 
  UPPER(c.name) || ': ' || f.title AS film_category, 
  LEFT(description, 50 - 
    POSITION(
      ' ' IN REVERSE(LEFT(description, 50))
    )
  ) 
FROM 
  film AS f 
  INNER JOIN film_category AS fc 
  	ON f.film_id = fc.film_id 
  INNER JOIN category AS c 
  	ON fc.category_id = c.category_id;