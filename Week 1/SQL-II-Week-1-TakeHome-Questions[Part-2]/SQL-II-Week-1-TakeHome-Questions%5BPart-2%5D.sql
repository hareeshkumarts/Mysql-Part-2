-- CREATE SCHEMA IF NOT EXISTS Video_Games;
USE Take_Home;
SELECT * FROM Video_Games_Sales;

# 1. Display the names of the Games, platform and total sales in North America for respective platforms.

select Name,platform,sum(NA_Sales) over(partition by platform)
from Video_Games_Sales;

desc Video_Games_Sales;


# 2. Display the name of the game, platform , Genre and total sales in North America for corresponding Genre as Genre_Sales,total sales for the given platform as Platformm_Sales and also display the global sales as total sales .
# Also arrange the results in descending order according to the Total Sales.

select name,platform,Genre,
sum(NA_Sales) over(partition by Genre) Genre_Sales,sum(NA_Sales) over(partition by platform) as Platform_Sales,
sum(Global_Sales) over() as Global_Sales
from video_games_sales;

# 3. Use nonaggregate window functions to produce the row number for each row 
# within its partition (Platform) ordered by release year.

select *,row_number() over(partition by platform order by Year_of_Release) 
from Video_Games_Sales;

# 4. Use aggregate window functions to produce the average global sales of each row within its partition (Year of release). 
-- Also arrange the result in the descending order by year of release.

select *,avg(Global_Sales) over(partition by Year_of_Release) as Avg_Sales
from video_games_sales
order by Year_of_Release desc;

# 5. Display the name of the top 5 Games with highest Critic Score For Each Publisher. 

with top_5_rnk as (select *,dense_rank() over(partition by publisher order by Critic_Score desc) rnks
from video_games_sales) 

select * from top_5_rnk where rnks<=5;

------------------------------------------------------------------------------------
# Dataset Used: website_stats.csv and web.csv
------------------------------------------------------------------------------------

select * from web;
# 6. Write a query that displays the opening date two rows forward i.e. the 1st row should display the 3rd website launch date

desc web;

update web set launch_date = str_to_date(launch_date,'%d-%m-%Y');
alter table web modify launch_date date;

select *,lead(launch_date,2) over() 
from web;
# 7. Write a query that displays the statistics for website_id = 1 
# i.e. for each row, show the day, the income and the income on the first day.
select * from website_stats;

desc website_stats;

update website_stats set day = str_to_date(day,'%d-%m-%Y');
alter table website_stats modify day date;

-- Query
select day,income,first_value(income) over(order by day) first_day_income 
from website_stats
where website_id = 1;

-----------------------------------------------------------------
# Dataset Used: play_store.csv 
-----------------------------------------------------------------
# 8. For each game, show its name, genre and date of release. In the next three columns, show RANK(), DENSE_RANK() and ROW_NUMBER() sorted by the date of release.

select * from play_store;
update play_store set released = str_to_date(released,'%d-%m-%Y');
alter table play_store modify released date;
desc play_store;

-- Query
select distinct(name),genre,released,rank() over(order by released asc) as rnk,dense_rank() over(order by released asc) as dense_rnk,row_number() over(order by released asc) as row_num
from play_store;

