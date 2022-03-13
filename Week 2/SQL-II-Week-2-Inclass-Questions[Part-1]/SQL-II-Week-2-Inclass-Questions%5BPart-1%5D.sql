CREATE DATABASE inClass_Week2;

use inClass_Week2;
# Datasets used: AirlineDetails.csv, passengers.csv and senior_citizen.csv
-- -----------------------------------------------------
-- Schema Airlines
-- -----------------------------------------------------
-- ---------------------------------------------------------------------------------------------------------------------------------------------------
-- 1. Create a table Airline_Details. Follow the instructions given below: 
-- -- Q1. Values in the columns Flight_ID should not be null.
-- -- Q2. Each name of the airline should be unique.
-- -- Q3. No country other than United Kingdom, USA, India, Canada and Singapore should be accepted
-- -- Q4. Assign primary key to Flight_ID
-- ---------------------------------------------------------------------------------------------------------------------------------------------------

CREATE TABLE Airline_Details (
Flight_ID int PRIMARY KEY,
Airline varchar(50) UNIQUE,
Country varchar(50) CHECK(Country IN ('United Kingdom','USA','India','Canada','Singapore')),
Punctuality float ,
Service_Quality float,
AirHelp_Score float
);
-- 2. Create a table Passengers. Follow the instructions given below: 
-- -- Q1. Values in the columns Traveller_ID and PNR should not be null.
-- -- Q2. Only passengers having age greater than 18 are allowed.
-- -- Q3. Assign primary key to Traveller_ID

CREATE TABLE Passengers(
Traveller_ID varchar(50) PRIMARY KEY,
Name varchar(50),
PNR varchar(50) NOT NULL,
Flight_ID int,
Age int Check (Age > 18),
Ticket_Price float
);

-- Questions for table Passengers:  
-- -- Q3. PNR status should be unique and should not be null.

-- Alter Table Passengers Add constraint pk_pnr primary key(PNR);

Alter Table Passengers modify PNR varchar(50) UNIQUE NOT NULL;


-- -- Q4. Flight Id should not be null.

Alter Table Passengers modify Flight_ID int NOT NULL;

desc passengers;
-- ---------------------------------------------------------------------------------------------------------------------------------------------------

-- ---------------------------------------------------------------------------------------------------------------------------------------------------
-- 5. Create a table Senior_Citizen_Details. Follow the instructions given below: 
-- -- Q1. Column Traveller_ID should not contain any null value.
-- -- Q2. Assign primary key to Traveller_ID
-- -- Q3. Assign foreign key constraint on Traveller_ID such that if any row from passenger table is updated, then the Senior_Citizen_Details table should also get updated.
-- -- --  Also deletion of any row from passenger table should not be allowed.
-- ---------------------------------------------------------------------------------------------------------------------------------------------------

CREATE TABLE Senior_Citizen_Details (
    Traveller_ID VARCHAR(50) PRIMARY KEY,
    Senior_Citizen BOOLEAN,
    Discounted_Price FLOAT,
    FOREIGN KEY (Traveller_ID)
        REFERENCES Passengers (Traveller_ID)
        ON UPDATE CASCADE ON DELETE RESTRICT
);

desc Senior_Citizen_Details;
-- -----------------------------------------------------
-- Table Senior_Citizen_Details
-- -- Q6. Create a new column Age in Passengers table that takes values greater than 18. 

ALTER TABLE Senior_Citizen_Details
  ADD COLUMN AGE int CHECK (AGE > 18);
 
-- ---------------------------------------------------------------------------------------------------------------------------------------------------
-- 7. Create a table books. Follow the instructions given below: 
-- -- Columns: books_no, description, author_name, cost
-- -- Qa. The cost should not be less than or equal to 0.
-- -- Qb. The cost column should not be null.
-- -- Qc. Assign a primary key to the column books_no.
-- ---------------------------------------------------------------------------------------------------------------------------------------------------

CREATE TABLE BOOKS(
book_no int PRIMARY KEY,
description varchar(100),
author_name varchar(50),
cost float NOT NULL CHECK(cost > 0)
);
# Q8. Update the table 'books' such that the values in the columns 'description' and author' must be unique.

Alter Table BOOKS 
modify description varchar(50) UNIQUE,
modify author_name varchar(50) UNIQUE;

desc books;

-- ---------------------------------------------------------------------------------------------------------------------------------------------------
-- 9. Create a table bike_sales. Follow the instructions given below: 
-- -- Columns: id, product, quantity, release_year, release_month
-- -- Q1. Assign a primary key to ID. Also the id should auto increment.
-- -- Q2. None of the columns should be left null.
-- -- Q3. The release_month should be between 1 and 12 (including the boundries i.e. 1 and 12).
-- -- Q4. The release_year should be between 2000 and 2010.
-- -- Q5. The quantity should be greater than 0.
-- --------------------------------------------------------------------------

CREATE TABLE bike_sales (
id int PRIMARY KEY AUTO_INCREMENT,
product varchar(50) NOT NULL,
quantity int NOT NULL,
release_year varchar(50) NOT NULL,
release_month varchar(50) NOT NULL
CHECK (release_month BETWEEN 1 and 12),
CHECK (release_year BETWEEN 2000 and 2010),
CHECK (quantity >0)
);
-- Use the following comands to insert the values in the table bike_sales
insert into bike_sales  values
('1','Pulsar','1','2001','7'),
('2','yamaha','3','2002','3'),
('3','Splender','2','2004','5'),
('4','KTM','2','2003','1'),
('5','Hero','1','2005','9'),
('6','Royal Enfield','2','2001','3'),
('7','Bullet','1','2005','7'),
('8','Revolt RV400','2','2010','7');
-- ('9','Jawa 42','1','2011','5');
-- --------------------------------------------------------------------------



