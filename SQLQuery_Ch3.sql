use Sample4
--SQL Script to create tblEmployee table:
CREATE TABLE tblEmployee
(
  Id int Primary Key,
  Name nvarchar(30),
  Salary int,
  Gender nvarchar(10),
  DepartmentId int
)

--SQL Script to create tblDepartment table: 
CREATE TABLE tblDepartment
(
 DeptId int Primary Key,
 DeptName nvarchar(20)
)

--Insert data into tblDepartment table
Insert into tblDepartment values (1,'IT')
Insert into tblDepartment values (2,'Payroll')
Insert into tblDepartment values (3,'HR')
Insert into tblDepartment values (4,'Admin')
Insert into tblDepartment values (5,'Marketing')

--Insert data into tblEmployee table
Insert into tblEmployee values (1,'John', 5000, 'Male', 3)
Insert into tblEmployee values (2,'Mike', 3400, 'Male', 2)
Insert into tblEmployee values (3,'Pam', 6000, 'Female', 1)
Insert into tblEmployee values (4,'Todd', 4800, 'Male', 4)
Insert into tblEmployee values (5,'Sara', 3200, 'Female', 1)
Insert into tblEmployee values (6,'Ben', 4800, 'Male', 3)
Insert into tblEmployee values (7,'James', 4800, 'Male', Null)
Insert into tblEmployee values (8,'Tom', 4800, 'Male', Null)



select* from tblDepartment
select* from tblEmployee

--inner join
Select Id, Name, Salary, Gender, DeptName
from tblEmployee
join tblDepartment
on tblEmployee.DepartmentId = tblDepartment.DeptId

--left join
Select Id, Name, Salary, Gender, DeptName
from tblEmployee
left join tblDepartment
on tblEmployee.DepartmentId = tblDepartment.DeptId

--WHERE tblEmployee.DepartmentId IS NULL

--right join
Select Id, Name, Salary, Gender, DeptName
from tblEmployee
right join tblDepartment
on tblEmployee.DepartmentId = tblDepartment.DeptId

--full outer join
Select Id, Name, Salary, Gender, DeptName
from tblEmployee
full join tblDepartment
on tblEmployee.DepartmentId = tblDepartment.DeptId


--cross join...??!!
SELECT Name, Gender, Salary, DeptName
FROM tblEmployee
CROSS JOIN tblDepartment

select* from tblEmployee, tblDepartment;
/*
Consider you have Car table which holds model information Car(Make, Model) and AvaliableColorOption(Color)
All available car options can be achieved by cross join..
Car table:
1. Benz C-Class
2. Benz S-Class

AvaliableColorOption:
1. Red
2. Green

Cartesian Product of the tables will yield:
1. Benz C-Class Red
2. Benz S-Class Red
3. Benz C-Class Green
4. Benz S-Class Green*/


--subqueries
Create Table tblProducts
(
 Id int identity primary key,
 Name nvarchar(50),
 Description nvarchar(250)
)

Create Table tblProductSales
(
 Id int primary key identity,
 ProductId int foreign key references tblProducts(Id),
 UnitPrice int,
 QuantitySold int
) 

select* from tblProducts

Insert into tblProducts values ('TV', '52 inch black color LCD TV')
Insert into tblProducts values ('Laptop', 'Very thin black color acer laptop')
Insert into tblProducts values ('Desktop', 'HP high performance desktop')

Insert into tblProductSales values(3, 450, 5)
Insert into tblProductSales values(2, 250, 7)
Insert into tblProductSales values(3, 450, 4)
Insert into tblProductSales values(3, 450, 9)

--retrieve products that are not at all sold?
Select Id, Name, Description
from tblProducts
where Id not in (Select Distinct ProductId from tblProductSales)


--All, any, some
CREATE TABLE T1_YourName (ID int);
INSERT into T1_YourName VALUES (1) ; 
INSERT into T1_YourName VALUES (2) ; 
INSERT into T1_YourName VALUES (3) ; 
INSERT into T1_YourName VALUES (4) ;

select* from T1_YourName

IF 3 < SOME (SELECT ID FROM T1_YourName) 
		PRINT 'TRUE' 
	ELSE 
		PRINT 'FALSE' ;

IF 3 < Any (SELECT ID FROM T1_YourName) 
		PRINT 'TRUE' 
	ELSE 
		PRINT 'FALSE' ;

IF 3 < ALL (SELECT ID FROM T1_YourName) 
		PRINT 'TRUE' 
	ELSE 
		PRINT 'FALSE' ;








