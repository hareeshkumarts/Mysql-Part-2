use inclass;

-- windows functions - analytical functions , applicable on group of records
-- apply this function on a window - apply on every row
-- First row , decide the window , apply the aggregator and get the result
-- input and output rows remians same
-- for each row window is getting expanded
-- order of execeution - partition by,order by,each row expands
-- Functions --> rownumber(),rank(),dense_rank(),first_value - first value in the window
-- last_value - last value in the window, nth_value - nth(2th) value) (select * ,nth_value(sales_vol,2)in the window,
-- ntile(3) - bring sales in three categories
-- range between unbounded preceding and unbounded following - to consider group by , then one window
-- range between unbounded preceding and current row - consider each row as one window

-- --------------------------------------------------------------
# Dataset Used: wine.csv
-- --------------------------------------------------------------

SELECT * FROM wine;

# Q1. Rank the winery according to the quality of the wine (points).-- Should use dense rank

select winery,points,dense_rank() over(order by points desc) as rnk from wine;

# Q2. Give a dense rank to the wine varities on the basis of the price.

select winery,price,dense_rank() over(order by price desc) rnk from wine;

# Q3. Use aggregate window functions to find the average of points for each row within its partition (country). 
-- -- Also arrange the result in the descending order by country.

SELECT country, province, winery, variety, AVG(points) OVER(PARTITION BY country) AS AvgPoints_CountryWise
FROM wine
ORDER BY country DESC;

-----------------------------------------------------------------
# Dataset Used: students.csv
-- --------------------------------------------------------------

# Q4. Rank the students on the basis of their marks subjectwise.

select student_id,subject,name,marks,dense_rank() over(partition by subject order by marks desc) as 'rank' from students;

# Q5. Provide the new roll numbers to the students on the basis of their names alphabetically.

select distinct(name),row_number()  over(order by name asc) as new_rollnum 
from students;

# Q6. Use the aggregate window functions to display the sum of marks in each row within its partition (Subject).

select *,sum(marks) over(partition by subject) as 'total_marks' from students;

# Q7. Display the records from the students table where partition should be done 
-- on subjects and use sum as a window function on marks, 
-- -- arrange the rows in unbounded preceding manner.

select *,sum(marks) over(partition by subject order by marks rows between unbounded preceding and unbounded following) 
as 'total_marks' from students;


# Q8. Find the dense rank of the students on the basis of their marks subjectwise. Store the result in a new table 'Students_Ranked'

create table Students_Ranked as (
select student_id,subject,name,marks,dense_rank() over(partition by subject order by marks desc) 
as 'rank' from students);


-----------------------------------------------------------------
# Dataset Used: website_stats.csv and web.csv
-----------------------------------------------------------------
# Q9. Show day, number of users and the number of users the next day (for all days when the website was used)

select day ,no_users,lead(no_users) over(order by day) no_user_next_day from website_stats;

# Q10. Display the difference in ad_clicks between the current day and the next day for the website 'Olympus'

select day ,ad_clicks,lead(ad_clicks) over(order by day) diff_clicks from website_stats where website_id= 1;
-- (select id from web where id ='olympus');


# Q11. Write a query that displays the statistics for website_id = 3 such that for each row, show the day, the number of users and the smallest number of users ever.

SELECT day, no_users,
	FIRST_VALUE(no_users) OVER(ORDER BY no_users) smallest_num_of_users
FROM website_stats
WHERE website_id = 3;

# Q12. Write a query that displays name of the website and it's launch date. The query should also display the date of recently launched website in the third column.

update web set launch_date = str_to_date(launch_date,'%d-%m-%y');
alter table web modify launch_date date;
select name,launch_date,last_value(launch_date) 
over(order by launch_date rows between unbounded preceding and unbounded following) from web;
-----------------------------------------------------------------

# Dataset Used: play_store.csv and sale.csv
-----------------------------------------------------------------
# Q13. Write a query thats orders games in the play store into three buckets as per editor ratings received  #ntile

SELECT day, no_users,
	FIRST_VALUE(no_users) OVER(ORDER BY no_users) smallest_num_of_users
FROM website_stats
WHERE website_id = 3;

# Q14. Write a query that displays the name of the game, the price, the sale date and the 4th column should display 
# the sales consecutive number i.e. ranking of game as per the sale took place, so that the latest game sold gets number 1. Order the result by editor's rating of the game
select distinct(name),row_number()  over(order by name asc) as new_rollnum 
from students;

# Q15. Write a query to display games which were both recently released and recently updated. For each game, show name, 
#date of release and last update date, as well as their rank
#Hint: use ROW_NUMBER(), sort by release date and then by update date, both in the descending order

select distinct(name),row_number()  over(order by name asc) as new_rollnum 
from students;

-----------------------------------------------------------------
# Dataset Used: movies.csv, customers.csv, ratings.csv, rent.csv
-----------------------------------------------------------------
# Q16. Write a query that displays basic movie informations as well as the previous rating provided by customer for that same movie 
# make sure that the list is sorted by the id of the reviews.

select r.id, title, rating, lag(rating) over (partition by m.id ) from ratings r join movies m 
where r.movie_id = m.id;

# Q17. For each movie, show the following information: title, genre, average user rating for that movie 
# and its rank in the respective genre based on that average rating in descending order (so that the best movies will be shown first).

with avg_table as (
select r.movie_id , title, avg(rating) as avg_rating from ratings r join movies m 
where r.movie_id = m.id group by r.movie_id) 

select * , dense_rank () over (order by avg_rating desc) from avg_table;


# Q18. For each rental date, show the rental_date, the sum of payment amounts (column name payment_amounts) from rent 
#on that day, the sum of payment_amounts on the previous day and the difference between these two values.

## convert rental_date column  to date format 
with t1 as(
 SELECT rental_date, SUM(payment_amount) AS payment_amounts
    FROM rent
    GROUP BY rental_date)
    
select * ,lag(payment_amounts) over (order by rental_date) as previous_amount,  payment_amounts - lag(payment_amounts) over (order by rental_date) as diff from t1;

