CREATE DATABASE IF NOT EXISTS sql2_miniproj ;

use sql2_miniproj;

-- Tasks to be performed:

-- 1.	Import the csv file to a table in the database.

# CSV File Imported Into the DataBase

SELECT * FROM icc_test_batting_figures;

-- 2.	Remove the column 'Player Profile' from the table.

ALTER TABLE icc_test_batting_figures DROP COLUMN `Player Profile`; 

SELECT * FROM icc_test_batting_figures;

-- 3.	Extract the country name and player names from the given data and store it in seperate columns for further usage.

select substr(Player,1,instr(Player,'(')-1) from icc_test_batting_figures;

ALTER TABLE icc_test_batting_figures
  ADD COLUMN Player_Name varchar(50) NOT NULL,
  ADD COLUMN Country varchar(20) NOT NULL;
  
UPDATE  icc_test_batting_figures set Player_Name = substr(Player,1,instr(Player,'(')-1);

UPDATE icc_test_batting_figures set Country = substr(Player,instr(Player,'('),instr(Player,')'));

select * from icc_test_batting_figures;

-- 4.	From the column 'Span' extract the start_year and end_year and store them in seperate columns for further usage.

ALTER TABLE icc_test_batting_figures
  ADD COLUMN start_year varchar(10) NOT NULL after Player,
  ADD COLUMN endd_year varchar(10) NOT NULL after start_year;
  
-- select substr(span,1,instr(span,'-')-1) from icc_test_batting_figures;
  
UPDATE  icc_test_batting_figures set start_year = substr(span,1,instr(span,'-')-1);

-- select substr(span,instr(span,'-')+1) from icc_test_batting_figures;

UPDATE  icc_test_batting_figures set endd_year = substr(span,instr(span,'-')+1);

-- 5.	The column 'HS' has the highest score scored by the player so far in any given match. The column also has details 
-- if the player had completed the match in a NOT OUT status. Extract the data and store the highest runs and the NOT OUT status
--  in different columns.

desc icc_test_batting_figures;

ALTER TABLE icc_test_batting_figures
   ADD COLUMN NOT_OUT_STATUS varchar(3) NOT NULL;
   
-- select if(substr(HS,1,instr(HS,'*')-1) = 0,0,1) from icc_test_batting_figures;

UPDATE  icc_test_batting_figures set NOT_OUT_STATUS = (CASE WHEN substr(HS,1,instr(HS,'*')-1) = 0  then 0 ELSE 1 END);
 
-- select (CASE WHEN substr(HS,1,instr(HS,'*')-1) = 0  then HS ELSE substr(HS,1,instr(HS,'*')-1) END) name from icc_test_batting_figures;
 
 ALTER TABLE icc_test_batting_figures
   ADD COLUMN HS_Score varchar(3) NOT NULL;
   
UPDATE  icc_test_batting_figures set 
	HS_Score = (CASE WHEN substr(HS,1,instr(HS,'*')-1) = 0  then HS ELSE substr(HS,1,instr(HS,'*')-1) END);

 
-- 6.	Using the data given, considering the players who were active in the year of 2019, create a set of batting order of 
-- best 6 players using the selection criteria of those who have a good average score across all matches for India.

ALTER TABLE icc_test_batting_figures 
   modify start_year int(11) NOT NULL,
   modify endd_year int(11) NOT NULL;
   
select Player_Name,Country,start_year,endd_year,Avg,dense_rank() over(order by Avg DESC ) Top_6_best_avg_rank
from icc_test_batting_figures
where endd_year > 2018 and (Country = '(INDIA)' or Country = '(ICC/INDIA)') limit 6;

desc icc_test_batting_figures;

-- 7.	Using the data given, considering the players who were active in the year of 2019, create a set of batting order 
-- of best 6 players using the selection criteria of those who have highest number of 100s across all matches for India.

select Player_Name,Country,start_year,endd_year,`100`,dense_rank() over(ORDER BY `100` DESC) top_6_highest_100
from icc_test_batting_figures
where endd_year > 2018 and (Country = '(INDIA)' or Country = '(ICC/INDIA)') limit 6;

-- 8.Using the data given, considering the players who were active in the year of 2019, create a set of batting order of 
-- best 6 players using 2 selection criterias of your own for India.

select * from icc_test_batting_figures;

select *,dense_rank() over(ORDER BY Avg DESC),dense_rank() over(ORDER BY `100` DESC) top_6_highest_100
from icc_test_batting_figures
where Country = '(INDIA)' or Country = '(ICC/INDIA)';

-- 9.	Create a View named ‘Batting_Order_GoodAvgScorers_SA’ using the data given, considering the players who were active
--  in the year of 2019, create a set of batting order of best 6 players using the selection criteria of those who have 
-- a good average score across all matches for South Africa.

CREATE OR REPLACE VIEW Batting_Order_GoodAvgScores_SA
as (select *,dense_rank() over(ORDER BY Avg DESC) from icc_test_batting_figures
where endd_year > 2018 and (Country = '(SA)' or Country = '(ICC/SA)')) limit 6;

select * from Batting_Order_GoodAvgScores_SA;

-- 10.	Create a View named ‘Batting_Order_HighestCenturyScorers_SA’ Using the data given, considering the players 
-- who were active in the year of 2019, create a set of batting order of best 6 players using the selection criteria of 
-- those who have highest number of 100s across all matches for South Africa.

CREATE OR REPLACE VIEW Batting_Order_HighestCenturyScorers_SA
as (select *,dense_rank() over(ORDER BY `100` DESC) from icc_test_batting_figures
where endd_year > 2018 and (Country = '(SA)' or Country = '(ICC/SA)')) limit 6;

select * from Batting_Order_HighestCenturyScorers_SA;
