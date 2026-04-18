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