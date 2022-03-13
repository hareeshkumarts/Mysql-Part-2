# Datasets used: employee.csv and membership.csv

-- ---------------------------------------------------------------------------------------------------------------------------------------------------
-- Schema EmpMemb
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS EmpMemb;
USE EmpMemb;


-- 1. Create a table Employee by refering the data file given. 

-- Follow the instructions given below: 
-- -- Q1. Values in the columns Emp_id and Members_Exclusive_Offers should not be null.
-- -- Q2. Column Age should contain values greater than or equal to 18.
-- -- Q3. When inserting values in Employee table, if the value of salary column is left null, then a value 20000 should be assigned at that position. 
-- -- Q4. Assign primary key to Emp_ID
-- -- Q5. All the email ids should not be same.

CREATE TABLE  IF NOT EXISTS Employee(
Emp_Id varchar(50) PRIMARY KEY,
Name varchar(50),
Age int Check (Age >=18),
Email varchar(20) UNIQUE,
Salary float DEFAULT 20000,
`Members Exclusive Offers` varchar(5) NOT NULL
);


-- 2. Create a table Membership by refering the data file given. 

-- Follow the instructions given below: 
-- -- Q6. Values in the columns Prime_Membership_Active_Status and Employee_Emp_ID should not be null.
-- -- Q7. Assign a foreign key constraint on Employee_Emp_ID.
-- -- Q8. If any row from employee table is deleted, then the corresponding row from the Membership table should also get deleted.

CREATE TABLE IF NOT EXISTS Membership
(
Employee_Emp_Id varchar(50) NOT NULL,
Prime_Membership_Active_Status varchar(5) NOT NULL,
Enrollment_Date varchar(50),
End_Date varchar(50),
FOREIGN KEY(Employee_Emp_Id) REFERENCES Employee(Emp_Id) ON DELETE CASCADE
);