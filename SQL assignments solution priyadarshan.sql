-- MySQL assignments solution 

-- Day 3 
-- 1)	Show customer number, customer name, state and credit limit from customers table for below conditions. Sort the results by highest to lowest values of creditLimit.
--      a)State should not contain null values
--      b)Credit limit should be between 50000 and 100000
select customerNumber,customerName,state,creditLimit
from customers
where state is not null and creditLimit between 50000 and 100000
order by creditLimit desc;

-- 2)	Show the unique productline values containing the word cars at the end from products table.
select distinct productLine
from productlines
where productLine like "%Cars";

-- Day 4
-- 1)	Show the orderNumber, status and comments from orders table for shipped status only. If some comments are having null values then show them as “-“.
select orderNumber,status,comments,
ifnull(comments, "-") as "Comments"
from orders
where status= "Shipped";

-- 2)	Select employee number, first name, job title and job title abbreviation from employees table based on following conditions.
-- If job title is one among the below conditions, then job title abbreviation column should show below forms.
-- ●	President then “P”
-- ●	Sales Manager / Sale Manager then “SM”
-- ●	Sales Rep then “SR”
-- ●	Containing VP word then “VP”
select employeeNumber,firstName,jobTitle,
Case
When jobTitle="President" then "P"
When jobTitle like "Sales Manager%" or jobTitle like "Sale Manager%" then "SM"
When jobTitle="Sales Rep" then "SR"
When jobTitle like "%VP%" then "VP"
end as jobTitle_abbreviation
from employees
order by jobTitle_abbreviation;

-- Day 5
-- 1) For every year, find the minimum amount value from payments table.
select year(paymentDate) as "Year", min(amount) as "Min Amount"
from payments
group by Year
order by Year;

-- 2)	For every year and every quarter, find the unique customers and total orders from orders table. Make sure to show the quarter as Q1,Q2 etc.
select year(orderDate) as "Year",concat('Q', quarter(orderDate)) as "Quarter", count(distinct customerNumber) as "Unique Customers",
count(orderNumber) as "Total Orders"
from orders
group by Year, Quarter;


-- 3)Show the formatted amount in thousands unit (e.g. 500K, 465K etc.) for every month (e.g. Jan, Feb etc.) with filter on total amount as 500000 to 1000000. Sort the output by total amount in descending mode. [ Refer. Payments Table]
select DATE_FORMAT(paymentDate, '%b') as Month, Concat(Format(sum(amount)/1000,0),'K') as "formatted amount"
from payments
group by Month
having sum(amount) between 500000 and 1000000
order by sum(amount) desc;

-- Day 6
-- 1)	Create a journey table with following fields and constraints.
-- ●	Bus_ID (No null values)
-- ●	Bus_Name (No null values)
-- ●	Source_Station (No null values)
-- ●	Destination (No null values)
-- ●	Email (must not contain any duplicates)

create table journey(
Bus_ID int primary key,
Bus_Name varchar(50)  not null,
Source_Station varchar(50)  not null,
Destination varchar(50)  not null,
Email varchar(100) unique
);

insert into journey(Bus_ID,Bus_Name,Source_Station,Destination,Email)
values(1,"AB123","Gandhi Nagar","L.Tilak Terminus","ab123@bus.gov.in");

insert into journey(Bus_ID,Bus_Name,Source_Station,Destination,Email)
values(2,"DE421","Flora Fountain","C.S.T","de421@bus.gov.in");

-- 2)	Create vendor table with following fields and constraints.
-- ●	Vendor_ID (Should not contain any duplicates and should not be null)
-- ●	Name (No null values)
-- ●	Email (must not contain any duplicates)
-- ●	Country (If no data is available then it should be shown as “N/A”)

drop table vendor;
create table vendor(
Vendor_ID int primary key,
Vendor_Name varchar(50)  not null,
Email varchar(100) unique,
Country varchar(50)  default "N/A"
);

insert into vendor(Vendor_ID,Vendor_Name ,Email,Country)
values(1,"Rajat Singh","rajatsingh11@gmail.com","India");

insert into vendor(Vendor_ID,Vendor_Name ,Email)
values(2,"Vidya Reddy","vidzyeah23@gmail.com");

-- 3)	Create movies table with following fields and constraints.

-- ●	Movie_ID (Should not contain any duplicates and should not be null)
-- ●	Name (No null values)
-- ●	Release_Year (If no data is available then it should be shown as “-”)
-- ●	Cast (No null values)
-- ●	Gender (Either Male/Female)
-- ●	No_of_shows (Must be a positive number)


create table movies(
Movie_ID int primary key,
Movie_Name varchar(50)  not null,
Release_Year varchar(20) default "-",
Movie_cast varchar(100) not null,
Gender enum("Male","Female") not null,
No_of_shows int check(No_of_shows>0)
);

insert into movies(Movie_ID,Movie_Name,Release_Year,Movie_cast,Gender,No_of_shows)
values(1,"Oppenheimer",2023,"Cilian Murphy","Male",50);

insert into movies(Movie_ID,Movie_Name,Movie_cast,Gender,No_of_shows)
values(2,"500 days of Summer","Zooey Deschannel","Female",20);


--  4)	Create the following tables. Use auto increment wherever applicable

-- a. Product
-- ✔	product_id - primary key
-- ✔	product_name - cannot be null and only unique values are allowed
-- ✔	description
-- ✔	supplier_id - foreign key of supplier table

-- b. Suppliers
-- ✔	supplier_id - primary key
-- ✔	supplier_name
-- ✔	location

-- c. Stock
-- ✔	id - primary key
-- ✔	product_id - foreign key of product table
-- ✔	balance_stock

create table Suppliers(
supplier_id int auto_increment primary key,
supplier_name varchar(50) not null,
location text
);
create table Product(
product_id int auto_increment primary key,
product_name varchar(50) not null unique,
description text,
supplier_id int,
Foreign key(supplier_id) references Suppliers(supplier_id) 
);
create table Stock(
id int auto_increment primary key,
product_id int,
Foreign key(product_id) references Product(product_id) ,
balance_stock int
);

insert into Suppliers(supplier_id,supplier_name,location)
values(1,"Krunal Khatri","Dombivli");

insert into Product(product_id,product_name,description,supplier_id)
values(31,"iphone_14_pro"," 6.1 inch OLED display,6 GB RAM, Storage 1 TB",1);

insert into Stock(id,product_id,balance_stock)
values(7,31,5);

-- Day 7
-- 1)	Show employee number, Sales Person (combination of first and last names of employees)
-- , unique customers for each employee number and sort the data by highest to lowest unique customers.
-- Tables: Employees, Customers

select e.employeeNumber as employeeNumber, CONCAT(e.firstName, ' ', e.lastName) as "Sales Person", 
Count(distinct c.customerNumber) as UniqueCustomers 
from Employees e left join Customers c on e.employeeNumber = c.salesRepEmployeeNumber 
group by e.employeeNumber, "Sales Person" 
order by UniqueCustomers desc;

-- 2) Show total quantities, total quantities in stock, left over quantities for each product and each customer. Sort the data by customer number.
-- Tables: Customers, Orders, Orderdetails, Products

select customerNumber,customerName,productCode,productName,sum(quantityOrdered) as "Ordered Qty",sum(quantityInStock) as "Total Inventory",sum(quantityInStock)-sum(quantityOrdered) as "Left Qty"
from customers inner join orders using(customerNumber)
inner join orderdetails using(orderNumber)
inner join products using(productCode)
group by customerNumber, productCode
order by customerNumber;

-- 3)	Create below tables and fields. (You can add the data as per your wish)
-- ●	Laptop: (Laptop_Name)
-- ●	Colours: (Colour_Name)
-- Perform cross join between the two tables and find number of rows.

create table Gadgets(
Laptop_Name varchar(20) not null,
Size text,
Price int
);
insert into Gadgets
values
("Dell","Small",25000),
("HP","Medium",35000),
("Acer","Large",45000),
("Lenovo","Large",52000),
("Apple Mcbook","Small",85000);

create table Colour(
Colour_Name varchar(20)
);
insert into Colour
values
("White"),
("Silver"),
("Black");

select *
from Gadgets cross join Colour;

-- 4)	Create table project with below fields.

-- ●	EmployeeID
-- ●	FullName
-- ●	Gender
-- ●	ManagerID
-- Add below data into it.
-- INSERT INTO Project VALUES(1, 'Pranaya', 'Male', 3);
-- INSERT INTO Project VALUES(2, 'Priyanka', 'Female', 1);
-- INSERT INTO Project VALUES(3, 'Preety', 'Female', NULL);
-- INSERT INTO Project VALUES(4, 'Anurag', 'Male', 1);
-- INSERT INTO Project VALUES(5, 'Sambit', 'Male', 1);
-- INSERT INTO Project VALUES(6, 'Rajesh', 'Male', 3);
-- INSERT INTO Project VALUES(7, 'Hina', 'Female', 3);
-- Find out the names of employees and their related managers.

create table project(
EmployeeID int,
FullName varchar(50) not null,
Gender varchar(20) not null,
ManagerID int 
);

INSERT INTO Project 
VALUES(1, 'Pranaya', 'Male', 3),
(2, 'Priyanka', 'Female', 1),
(3, 'Preety', 'Female', NULL),
(4, 'Anurag', 'Male', 1),
(5, 'Sambit', 'Male', 1),
(6, 'Rajesh', 'Male', 3),
(7, 'Hina', 'Female', 3);

select e2.FullName as "Manager Name",e1.FullName as "Emp Name"
from project as e1 join project as e2
on(e1.ManagerID=e2.EmployeeID);

-- Day 8
-- Create table facility. Add the below fields into it.
-- ●	Facility_ID
-- ●	Name
-- ●	State
-- ●	Country

-- i) Alter the table by adding the primary key and auto increment to Facility_ID column.
-- ii) Add a new column city after name with data type as varchar which should not accept any null values.

create table facility(
Facility_ID int,
Name varchar(100),
State varchar(100),
Country varchar(100)
);

Alter table facility modify Facility_ID int auto_increment primary key;

Alter table facility add City varchar(100) not null after Name;
describe facility;

-- Day 9
-- Create table university with below fields.
-- ●	ID
-- ●	Name
-- Add the below data into it as it is.
-- INSERT INTO University
-- VALUES (1, "       Pune          University     "), 
--                (2, "  Mumbai          University     "),
--             (3, "     Delhi   University     "),
--              (4, "Madras University"),
--              (5, "Nagpur University");
-- Remove the spaces from everywhere and update the column like Pune University etc.

create table university(
ID int not null primary key,
Name char(50)
);
INSERT INTO University
VALUES (1, "       Pune          University     "), 
               (2, "  Mumbai          University     "),
              (3, "     Delhi   University     "),
              (4, "Madras University"),
              (5, "Nagpur University");

UPDATE University SET Name = TRIM(REGEXP_REPLACE(Name, ' +', ' '));

select *
from university
order by ID;

-- Day 10 
-- Create the view products status. Show year wise total products sold. 
-- Also find the percentage of total value for each year. The output should look as shown in below figure.

drop view products_status;
create view products_status as
select YEAR(o.orderDate) AS Year,
CONCAT(COUNT(od.productCode), 
' (', ROUND(COUNT(od.productCode) / (SELECT COUNT(*) FROM orderdetails) * 100), '%)') AS Value
FROM
orders o JOIN orderdetails od ON o.orderNumber = od.orderNumber
GROUP BY Year;

-- Day 11
-- 1)	Create a stored procedure GetCustomerLevel which takes input as customer number
--  and gives the output as either Platinum, Gold or Silver as per below criteria.

-- Table: Customers

-- ●	Platinum: creditLimit > 100000
-- ●	Gold: creditLimit is between 25000 to 100000
-- ●	Silver: creditLimit < 25000

DROP Procedure GetCustomerLevel;

DELIMITER //
CREATE PROCEDURE GetCustomerLevel(IN customerNumber INT, OUT customerLevel VARCHAR(20))
BEGIN
    DECLARE customerCreditLimit DECIMAL(10, 2);

    SELECT creditLimit INTO customerCreditLimit
    FROM Customers
    WHERE customerNumber = customerNumber
    LIMIT 1;

    IF customerCreditLimit > 100000 THEN
        SET customerLevel = 'Platinum';
    ELSEIF customerCreditLimit >= 25000 THEN
        SET customerLevel = 'Gold';
    ELSE
        SET customerLevel = 'Silver';
    END IF;
END //
DELIMITER ;

CALL GetCustomerLevel(114, @customerLevel);
SELECT @customerLevel AS CustomerLevel;


-- 2) Create a stored procedure Get_country_payments which takes in year and country as inputs and gives year wise,
-- country wise total amount as an output. Format the total amount to nearest thousand unit (K)
-- Tables: Customers, Payments
drop procedure Get_country_payments;
Delimiter //
create procedure Get_country_payments(IN Year_no int,IN country_name varchar(40), OUT Total_payments int)
begin
	select sum(amount) into Total_payments
	from payments
	where year(paymentDate)= Year_no AND customerNumber 
    in (select customerNumber 
	from customers
	where country=country_name);
end //
Delimiter ;
call Get_country_payments(2003,"France",@Total_payments);
select concat(format(@Total_payments/1000,0),'K') as "Total Amount";

-- Day 12
-- 1)	Calculate year wise, month name wise count of orders and year over year (YoY) percentage change. 
-- Format the YoY values in no decimals and show in % sign.

-- STEP 1: Calculation for YoY % for count(orderDate)
-- Diff between the current and previous order(i.e. LAG()) is given as:
-- YoY =[Count(orderNumber)-LAG(Count(orderNumber)]/LAG(Count(orderNumber). 

-- STEP 2: Using window function for calculating aggegate over Month and Year
-- YoY =((Count(orderNumber)-LAG(Count(orderNumber)) over (order by Year(orderDate), Month(orderDate)))/LAG(Count(orderNumber)over (order by Year(orderDate), Month(orderDate)) 

-- STEP 3:  Using Format and Imputing Null if the diffrence is zero using Ifnull
-- YoY  = IFNULL(Format((Count(orderNumber)-LAG(Count(orderNumber)) over (order by Year(orderDate), Month(orderDate)))/(LAG(Count(orderNumber))over (order by Year(orderDate), Month(orderDate)))*100,0),"Null") 

-- STEP 4: To append % we concat YoY with % sign
-- (% YoY) = Concat(YoY,"%") as "% YoY change"

-- STEP 5: Writing the final query
select year(orderDate) as Year,date_format(orderDate,"%M") as Month,Count(orderNumber) as "Total Orders",
Concat(IFNULL(Format((Count(orderNumber)-LAG(Count(orderNumber)) over (order by Year(orderDate), date_format(orderDate,"%M")))/
(LAG(Count(orderNumber))over (order by Year(orderDate), date_format(orderDate,"%M")))*100,0),"Null") ,"%")
as "% YoY Change"
from orders
group by Year, Month
order by Year, Month;


-- 2)	Create the table emp_udf with below fields.
-- ●	Emp_ID
-- ●	Name
-- ●	DOB
-- Add the data as shown in below query.
-- INSERT INTO Emp_UDF(Name, DOB)
-- VALUES ("Piyush", "1990-03-30"), ("Aman", "1992-08-15"), ("Meena", "1998-07-28"), ("Ketan", "2000-11-21"), ("Sanjay", "1995-05-21");
-- Create a user defined function calculate_age which returns the age in years and months (e.g. 30 years 5 months) 
-- by accepting DOB column as a parameter.

create table EMP_UDF(
Emp_ID int  auto_increment primary key,
Name varchar(20) not null,
DOB date 
);
INSERT INTO Emp_UDF(Name, DOB)
VALUES ("Piyush", "1990-03-30"), ("Aman", "1992-08-15"), ("Meena", "1998-07-28"),
("Ketan", "2000-11-21"), ("Sanjay", "1995-05-21");

Delimiter //
create function Calculate_age(DOB date)
returns varchar(50)                       -- Specifying the datatype of the o/p          
deterministic                             -- A function that gives the same o/p every time it is called.
										  -- Not deterministic is a function that gives different o/p every time it is called. 
										  -- (E.g Random function Rand())
begin
	declare years int;
    declare months int;
    declare age varchar(50);                                      -- declaring the o/p variable
    SET years= timestampdiff(Year,DOB,Curdate());                 -- Storing the answer in o/p variable
    SET months= timestampdiff(Month,DOB,Curdate())-(years*12);
    SET Age= Concat(years," years ",months," months ");
    return Age;                                                   --  returing the value of o/p variable
end //
Delimiter ;

select Name,DOB, Calculate_age(DOB) as Age
from EMP_UDF;


-- Day 13
-- 1)	Display the customer numbers and customer names from customers table 
-- who have not placed any orders using subquery
--  Table: Customers, Orders

select customerNumber, customerName
from customers
where customerNumber NOT in(select customerNumber
from orders);

-- 2)	Write a full outer join between customers and orders using union and get the customer number, customer name, count of orders for every customer.
-- Table: Customers, Orders

select customerNumber, customerName, count(orderNumber) as "Total Orders"
from customers left join orders using(customerNumber)
group by customerNumber, customerName
Union
select customerNumber, customerName, count(orderNumber) as "Total Orders"
from orders right join customers using(customerNumber)
group by customerNumber, customerName;

-- 3)	Show the second highest quantity ordered value for each order number.
-- Table: Orderdetails

select orderNumber, quantityOrdered
from 
(select dense_rank() over(partition by orderNumber order by quantityOrdered desc) as RANK_ORDER,
orderNumber, quantityOrdered
from orderdetails) as Rank_table
where RANK_ORDER=2;


-- 4)	For each order number count the number of products and 
-- then find the min and max of the values among count of orders.
-- Table: Orderdetails

select MAX(Total),MIN(Total)
from
(select orderNumber, count(productCode) as Total
from orderdetails
group by orderNumber) as Total;

-- 5)	Find out how many product lines are there for which the buy price value is 
-- greater than the average of buy price value. Show the output as product line and its count.

select productline, count(productLine) as "Total"
from products
where buyPrice > (select avg(buyPrice) from products)
group by productline;


-- Day 14
-- Create the table Emp_EH. Below are its fields.
-- ●	EmpID (Primary Key)
-- ●	EmpName
-- ●	EmailAddress
-- Create a procedure to accept the values for the columns in Emp_EH. 
-- Handle the error using exception handling concept. Show the message as “Error occurred” in case of anything wrong.
drop table Emp_EH;
drop procedure InsertEmpEHDetails;
create table Emp_EH(
EmpID int primary key,
EmpName varchar(40),
EmailAddress varchar(100) 
);
DELIMITER //
CREATE PROCEDURE InsertEmpEHDetails
(
	InputEmpID INT,
    InputEmpName VARCHAR(50),
    InputEmailAddress VARCHAR(100)
    )

BEGIN 
	DECLARE error_occurred BOOLEAN DEFAULT FALSE;
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION,SQLWARNING, NOT FOUND
	BEGIN
        SET error_occurred = TRUE;
    END;
	START TRANSACTION;
	INSERT INTO Emp_EH(EmpID, EmpName, EmailAddress)
	VALUES
	(InputEmpID, InputEmpName, InputEmailAddress);    
    IF error_occurred THEN
	ROLLBACK;
	SELECT 'Error occurred' AS Message;
    ELSE
	COMMIT;
	SELECT 'Data inserted successfully' AS Message;
    END IF;
END // 
DELIMITER ;

select * from Emp_EH; 
CALL InsertEmpEHDetails (1,7,'priyadarshan578@gmail.com');


-- Day 15
-- Create the table Emp_BIT. Add below fields in it.
-- ●	Name
-- ●	Occupation
-- ●	Working_date
-- ●	Working_hours

-- Insert the data as shown in below query.
-- INSERT INTO Emp_BIT VALUES
-- ('Robin', 'Scientist', '2020-10-04', 12),  
-- ('Warner', 'Engineer', '2020-10-04', 10),  
-- ('Peter', 'Actor', '2020-10-04', 13),  
-- ('Marco', 'Doctor', '2020-10-04', 14),  
-- ('Brayden', 'Teacher', '2020-10-04', 12),  
-- ('Antonio', 'Business', '2020-10-04', 11);  
 
-- Create before insert trigger to make sure any new value of Working_hours, 
-- if it is negative, then it should be inserted as positive.

create table Emp_BIT(
Name varchar(20),
Occupation varchar(50),
Working_date Date,
Working_hours int
);
insert into Emp_BIT values
('Robin', 'Scientist', '2020-10-04', 12),  
('Warner', 'Engineer', '2020-10-04', 10),  
('Peter', 'Actor', '2020-10-04', 13),  
('Marco', 'Doctor', '2020-10-04', 14),  
('Brayden', 'Teacher', '2020-10-04', 12),  
('Antonio', 'Business', '2020-10-04', 11);  

DELIMITER //
CREATE TRIGGER Before_Insert_Emp_BIT
BEFORE INSERT ON Emp_BIT
FOR EACH ROW
BEGIN
    IF NEW.Working_hours < 0 THEN
        SET NEW.Working_hours = -NEW.Working_hours;
    END IF;
END //
DELIMITER ;

Show TRIGGERS;
insert into Emp_BIT values
('Priyadarshan', 'AI Scientist', '2019-04-01', -10);