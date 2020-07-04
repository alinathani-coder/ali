

select* from price

begin transaction
insert into price (item, wholesale) values('fff', 1.2), ('rrr', 1.6)
commit
         
rollback tran
select* from price

------Isolation\Lock
CREATE TABLE ValueTable (id int);  
BEGIN TRANSACTION;  
--CREATE TABLE ValueTable (id int);
       INSERT INTO ValueTable VALUES(1);  
       INSERT INTO ValueTable VALUES(2);
	   INSERT INTO ValueTable VALUES(3); 
commit tran
select* from valuetable	    
ROLLBACK; 

drop table ValueTable

-----------Savepoint
BEGIN TRANSACTION
CREATE TABLE ValueTable (id int);
       INSERT INTO ValueTable VALUES(1);  
       INSERT INTO ValueTable VALUES(2);
	   SAVE TRAN Savepoint1
	   INSERT INTO ValueTable VALUES(3); 
ROLLBACK tran Savepoint1
commit tran
select* from valuetable	    
-----------------------------

Create Table tblMailingAddress
(
   AddressId int NOT NULL primary key,
   EmployeeNumber int,
   HouseNumber nvarchar(50),
   StreetAddress nvarchar(50),
   City nvarchar(50),
   PostalCode nvarchar(50)
)

Insert into tblMailingAddress values (1, 101, '#10', 'King Street', 'Londoon', 'CR27DW') 


Create Table tblPhysicalAddress
(
 AddressId int NOT NULL primary key,
 EmployeeNumber int,
 HouseNumber nvarchar(50),
 StreetAddress nvarchar(50),
 City nvarchar(50),
 PostalCode nvarchar(50)
)

Insert into tblPhysicalAddress values (1, 101, '#10', 'King Street', 'Londoon', 'CR27DW')

select * from tblMailingAddress
select * from tblPhysicalAddress

--procedure/no input/no output
Create Procedure spUpdateAddress
as
Begin
 Begin Try
  Begin Transaction
   Update tblMailingAddress set City = 'LONDON' 
   where AddressId = 1 and EmployeeNumber = 101
   
   Update tblPhysicalAddress set City = 'LONDON' 
   where AddressId = 1 and EmployeeNumber = 101
  Commit Transaction
 End Try
 Begin Catch
  Rollback Transaction
 End Catch
End 

execute spUpdateAddress

select* from tblMailingAddress
select* from tblPhysicalAddress

Alter Procedure spUpdateAddress
as
Begin
 Begin Try
  Begin Transaction
   Update tblMailingAddress set City = 'LONDON12' 
   where AddressId = 1 and EmployeeNumber = 101
   
   Update tblPhysicalAddress set City = 'LONDON14' 
   where AddressId = 1 and EmployeeNumber = 101
  Commit Transaction
 End Try
 Begin Catch
  Rollback Transaction
 End Catch
End

execute spUpdateAddress

select* from tblMailingAddress
select* from tblPhysicalAddress

sp_helptext spUpdateAddress

--------------------------------
Select* from tblEmployee

Create Procedure spGetEmployees
as
Begin
  Select Name, Gender from tblEmployee
End

execute spGetEmployees

---procedure with input
Create Procedure spGetEmployeesByGenderAndDepartment 
@Gender nvarchar(10)
as
Begin
  Select Name, Gender, DepartmentId from tblEmployee Where Gender = @Gender
End

execute spGetEmployeesByGenderAndDepartment 'Male'
----------------------------
Create Procedure spGetTotalCountOfEmployees2
as
Begin
 return (Select COUNT(ID) from tblEmployee)
End

--execute spGetTotalCountOfEmployees2

Declare @TotalEmployees int;
Execute @TotalEmployees = spGetTotalCountOfEmployees2
Select @TotalEmployees;
-----------------------

--With output 
Create Procedure spGetEmployeeCountByGender
@Gender nvarchar(20),
@EmployeeCount int Output
as
Begin
 Select @EmployeeCount = COUNT(Id) 
 from tblEmployee 
 where Gender = @Gender
End 
--------------
Declare @EmployeeTotal int
Execute spGetEmployeeCountByGender 'Female', @EmployeeTotal output
print @EmployeeTotal;
------------
Declare @EmployeeTotal int
Execute spGetEmployeeCountByGender 'Female', @EmployeeTotal
if(@EmployeeTotal is null)
 Print '@EmployeeTotal is null'
else
 Print '@EmployeeTotal is not null'
--------------

--Return vs Output

Create Procedure spGetNameById1
@Id int,
@Name nvarchar(20) Output
as
Begin
 Select @Name = Name from tblEmployee Where Id = @Id
End

Declare @EmployeeName nvarchar(20)
Execute spGetNameById1 3, @EmployeeName out
Print 'Name of the Employee = ' + @EmployeeName


Create Procedure spGetNameById2
@Id int
as
Begin
 Return (Select Name from tblEmployee Where Id = @Id)
End

Declare @EmployeeName nvarchar(20)
Execute @EmployeeName = spGetNameById2 1
Print 'Name of the Employee = ' + @EmployeeName

--So, using return values, we can only return integers!!!



----------------------------
BEGIN TRAN
UPDATE price SET item = 'grape' WHERE wholesale = 2;
SAVE TRAN Savepoint1
DELETE FROM price WHERE item = 'apple';
ROLLBACK TRAN Savepoint1
ROLLBACK
SELECT * FROM price;
-------------------------------



CREATE FUNCTION StripWWWandCom (@input VARCHAR(250))
RETURNS VARCHAR(250)
AS BEGIN
    DECLARE @Work VARCHAR(250)
 
    SET @Work = @Input
 
    SET @Work = REPLACE(@Work, 'www.', '')
    SET @Work = REPLACE(@Work, '.com', '')
 
    RETURN @work
END

Select dbo.StripWWWandCom('www.amazon.com')

----------------
CREATE FUNCTION AveragePi (@price float = 0.0) 
RETURNS table
AS 
	RETURN ( SELECT *
		           FROM price
		           WHERE Wholesale  >  @price)
				   
select* from AveragePi(2)

--------------
CREATE FUNCTION AveragePricebyItems2 (@price float = 0.0) 
RETURNS @table table (Description varchar(50) null, Price float null) AS
	   begin 
	      insert @table SELECT item, wholesale
		           	      FROM price
		                    WHERE wholesale  >  @price 
	      return 
	end 

select * from AveragePricebyItems2(1)



Select Name, DateOfBirth, dbo.Age(DateOfBirth) as Age 
from tblEmployees
Where dbo.Age(DateOfBirth) > 30

