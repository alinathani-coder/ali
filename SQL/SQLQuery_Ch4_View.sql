
use Sample4
------------------------------------------
Grant create table to tareq1;

create role tareqrole;
Grant create table to tareqrole;

ALTER ROLE tareqrole ADD MEMBER tareq1;
alter role tareqrole drop member tareq1;

drop role tareqrole;
-----------------------------------------------
---index
Select* from tblEmployee

Select * from tblEmployee where Salary > 5000 and Salary < 7000

CREATE Index IX_tblEmployee_Salary 
ON tblEmployee (SALARY ASC)

sp_helpindex tblEmployee

--------------
CREATE TABLE [tblEmployee_2]
(
 [Id] int Primary Key, [Name] nvarchar(50), [Salary] int, [Gender] nvarchar(10), [City] nvarchar(50)
)

sp_helpindex tblEmployee_2


Insert into tblEmployee_2 Values(3,'John',4500,'Male','New York')
Insert into tblEmployee_2 Values(1,'Sam',2500,'Male','London')
Insert into tblEmployee_2 Values(4,'Sara',5500,'Female','Tokyo')
Insert into tblEmployee_2 Values(5,'Todd',3100,'Male','Toronto')
Insert into tblEmployee_2 Values(2,'Pam',6500,'Female','Sydney')

Select * from tblEmployee_2--ordered

Create Clustered Index IX_tblEmployee_Name ON tblEmployee(Name)--error/only one clustered index allowed

Drop index tblEmployee_2.PK__tblEmplo__3214EC07F42C395C--error/ so delete it manually 

Create Clustered Index IX_tblEmployee_Gender_Salary --composite clustered index
ON tblEmployee_2(Gender DESC, Salary ASC)

Select * from tblEmployee_2--re-arranged!!

--non-clustered index

Create NonClustered Index IX_tblEmployee_Name --stored separately--does not affect the order of rows
ON tblEmployee_2(Name)
--------------

create clustered index index1 on price (wholesale);
create nonclustered index index2 on price (item);

create unique nonclustered index index3 on price (item);

insert into Price values ('orange', 2)

SELECT * FROM price WHERE Wholesale = 2.3

select* from price;
drop index price.index2
drop index price.index1

sp_helpindex price

sp_helpindex tblperson
------------------------------------------------

IF EXISTS (SELECT * FROM price WHERE Wholesale = 0.25)
BEGIN--do what needs to be done if exists
print 'yes'
END
ELSE
BEGIN--do what needs to be done if not
print 'no'
END
-----------------------------------
Delete tblGender

select * from tblGender

Drop table tblGender
drop table tblPerson
------------------------------------
select* from tareqnew
update tareqnew
set gendercode = (1)


------------------------------

select* from price where not item = 'Orange'
select wholesale, count(wholesale) as ccc from price group by wholesale
select* from price where item not like null
select* from price where item <> ''

delete from price where item = 'Apple'
select * from price where wholesale between 1.2 and 2

alter table price add number int
select item, max(wholesale) from price group by item




---views

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

--Insert data into tblEmployee table
Insert into tblEmployee values (1,'John', 5000, 'Male', 3)
Insert into tblEmployee values (2,'Mike', 3400, 'Male', 2)
Insert into tblEmployee values (3,'Pam', 6000, 'Female', 1)
Insert into tblEmployee values (4,'Todd', 4800, 'Male', 4)
Insert into tblEmployee values (5,'Sara', 3200, 'Female', 1)
Insert into tblEmployee values (6,'Ben', 4800, 'Male', 3)

select* from tblDepartment
select* from tblEmployee

Select Id, Name, Salary, Gender, DeptName
from tblEmployee
join tblDepartment
on tblEmployee.DepartmentId = tblDepartment.DeptId

Create View firstview
as
Select Id, Name, Salary, Gender, DeptName
from tblEmployee
join tblDepartment
on tblEmployee.DepartmentId = tblDepartment.DeptId

select* from firstview --virtual table/doesnot store any data by default.

drop view firstview

--View that returns only IT department employees:
Create View IT_view
as
Select Id, Name, Salary, Gender, DeptName
from tblEmployee
join tblDepartment
on tblEmployee.DepartmentId = tblDepartment.DeptId
where tblDepartment.DeptName = 'IT'

select* from IT_view

----
--Total number of employees by Department.
Create View CountByDepartment
as
Select DeptName, COUNT(Id) as TotalEmployees
from tblEmployee
join tblDepartment
on tblEmployee.DepartmentId = tblDepartment.DeptId
Group By DeptName

select* from CountByDepartment
------

--Updateable Views

--view, which returns all the columns from the tblEmployees table, except Salary column.
Create view view_ExceptSalary
as
Select Id, Name, Gender, DepartmentId
from tblEmployee

Select * from view_ExceptSalary--virtual/does not save data

Update view_ExceptSalary 
Set Name = 'Mikey' Where Id = 2

select* from tblEmployee--the original table updated

Delete from view_ExceptSalary where Id = 2
Insert into view_ExceptSalary values (2, 'Mikey', 'Male', 2)
---------




