Create database AliNDay2
Alter database AliNDay2 Modify Name = AliN
Drop Database AliNDay1

use AliN
Create Table tblGender (ID int Not Null Primary Key, Gender nvarchar(50))


Select * from tblPerson

Select id, name from tblPerson

Select * from tblPerson where GenderId = 1;

Select * from Price
Select ITEM, WHOLESALE, WHOLESALE + 0.15 as [New Price] FROM Price;

Select ITEM, -WHOLESALE pric2 from Price;

SELECT ITEM, WHOLESALE, WHOLESALE+0.15 [RETAIL PRICE] from Price;
SELECT ITEM, WHOLESALE, WHOLESALE/2 [SALE PRICE] from Price;

SELECT * FROM Price WHERE ITEM = 'Bananas';

select * from Price where wholesale > 0.4;

create table alinew (ID int Not Null Primary Key, Gendercode int REFERENCES tblGender(Id));

select * from Price where ITEM	< 'baz';
select * from Price where ITEM	<> 'apples';  --(!=)

select * from Price where ITEM like '%A%';
select * from Price where ITEM like 'APPLES';

select * from Price where ITEM like '_______S';--SEARCHES FOR 6 BLANK SPACES AND S AT END

select * from tblPerson where GenderId IS NOT NULL;
select * from tblPerson where GenderId IS NULL;

Select * from Price where ITEM in('apples', 'bananas');

Select * from Price where Wholesale between 0.3 and 0.5;

Select COUNT(*) [NO OF NEW PRICE] from Price where Wholesale > 0.3;

SELECT COUNT(*) FROM Price;

SELECT SUM(WHOLESALE) AS [TOTAL PRICES] FROM Price;

SELECT MAX(ITEM) FROM PRICE;

SELECT AVG(WHOLESALE) AS [AVG PRICES] FROM Price;

SELECT var(WHOLESALE) AS VARIANCE FROM Price;

SELECT stdev(WHOLESALE) AS [standard deviantion] FROM Price;

INSERT INTO Price VALUES ('TT',0.5);

Select * from Price;
INSERT INTO Price VALUES ('RR',0.9);

select * from tblPerson ;
INSERT INTO tblPerson values (6, 'Ali', 'a@a.com', 1);

select getdate()
select DATEPART(DAY, '2017/08/25');
select abs(-10)
select floor(1.2)

select CHAR(10)
select CHARINDEX('e','tareq',2)
select lower('Tareq')
select replace('tar eqt', ' ','');
select rtrim ('tareq jaber   ') + 'abc';
select ltrim('   tareq jaber')

select space(20) + 'tareq';
select stuff('tareqjaber', 4, 2, 'ik');

select soundex('juice'), soundex('Juicy');
select soundex('Ali');
select difference('tareq', 'Ali')

select UNICODE('A')

select SUBSTRING('abcdefg', 3,2);

select distinct item from Price
select all item from Price

select COUNT(distinct item) [no of unique items] from Price

select * from tblPerson

insert into tblPerson values(7, 'Ali', 'a@a.com', NULL)

select count(GenderId) from tblPerson --ignores null values


--to alter columns in a table
Select * from Price;

Alter table price add number int 

Alter table price drop column number

-----class exercies pg 47 
CREATE TABLE EMPLOYEELEAVE (LASTNAME nvarchar(50), EMPLOYEENUM int, YEARS int, LEAVETAKEN int)
INSERT INTO EMPLOYEELEAVE VALUES ('ABLE', 101, 2, 4)
INSERT INTO EMPLOYEELEAVE VALUES ('BAKER', 104, 5, 23)
INSERT INTO EMPLOYEELEAVE VALUES ('BLEDSOE', 107, 8, 45)
INSERT INTO EMPLOYEELEAVE VALUES ('BOLIVAR', 233, 4, 80)
INSERT INTO EMPLOYEELEAVE VALUES ('BOLD', 210, 15, 100)
INSERT INTO EMPLOYEELEAVE VALUES ('COSTALES', 211, 10, 78)
--exercise 1
SELECT * FROM EMPLOYEELEAVE WHERE LASTNAME LIKE 'B%' AND LEAVETAKEN > 50;
--exercise 2
SELECT REPLACE(LASTNAME,'ST','**') FROM EMPLOYEELEAVE WHERE LASTNAME LIKE '%ST%'

--HOMEWORK EXERCISE PG 48
CREATE TABLE BODYPARTS (NAME nvarchar(50), LOCATION nvarchar(50), PARTNUMBER int)
INSERT INTO BODYPARTS VALUES ('APPENDIX', 'MID-STOMACH', 1)
INSERT INTO BODYPARTS VALUES ('ADAMS APPLE', 'THROAT', 2)
INSERT INTO BODYPARTS VALUES ('HEART', 'CHEST', 3)
INSERT INTO BODYPARTS VALUES ('SPINE', 'BACK', 4)
INSERT INTO BODYPARTS VALUES ('ANVIL', 'EAR', 5)
INSERT INTO BODYPARTS VALUES ('KIDNEY', 'MID-BACK', 6)

--PROBLEM 1
SELECT * FROM BODYPARTS WHERE LOCATION LIKE 'BACK%'

--PROBLEM 2
-- SELECT * FROM FRIENDS WHERE AREACODE = 100 OR AREACODE = 381 OR AREACODE = 204

--HOMEWORK EXERCISE PG 49 PROBLEM 3  , table on pg 33
CREATE TABLE TEAMSTATS (NAME nvarchar(50), POS nvarchar(2), AB int, HITS int, WALKS int, SINGLES int, DOUBLES int, TRIPLES int, HR int, SO int)
INSERT INTO TEAMSTATS VALUES ('JONES', '1B', 145, 45, 34, 31, 8, 1, 5, 10)
 
INSERT INTO TEAMSTATS VALUES ('DONKNOW', '3B', 175, 65, 23, 50, 10, 1, 4, 15)
INSERT INTO TEAMSTATS VALUES ('WORLEY', 'LF', 157, 49, 15, 35, 8, 3, 3, 16)
INSERT INTO TEAMSTATS VALUES ('DAVID', 'OF', 187, 70, 24, 48, 4, 0, 17, 42)
INSERT INTO TEAMSTATS VALUES ('HAMHOCKER', '3B', 50, 12, 10, 10, 2, 0, 0, 13)
INSERT INTO TEAMSTATS VALUES ('CASEY', 'DH', 1, 0, 0, 0, 0, 0, 0, 1)
--PROBLEM 3
--could not figure out meaning of with average greater than 300

SELECT * FROM TEAMSTATS 
SELECT SUM(SINGLES) TOTALSINGLES FROM TEAMSTATS
SELECT SUM(DOUBLES) TOTALDOUBLES FROM TEAMSTATS
SELECT SUM(TRIPLES) TOTALTRIPLES FROM TEAMSTATS
SELECT SUM(HR) TOTALHR FROM TEAMSTATS



--PROBLEM 4
SELECT (SUM(HITS)*100/SUM(AB)) FROM TEAMSTATS

--------DAY 7

--PG 13 FUNCTIONS GROUP BY
CREATE TABLE STAFF (sno nvarchar(5), bno nvarchar(2), fname nvarchar(50), lname nvarchar(50), salary int, position nvarchar(50))
INSERT INTO STAFF VALUES ('SL100', 'B3', 'JOHN', 'WHITE', 30000, 'MANAGER')
INSERT INTO STAFF VALUES ('SL101', 'B5', 'SUSAN', 'BRAND', 24000, 'MANAGER')
INSERT INTO STAFF VALUES ('SL102', 'B3', 'DAVID', 'FORD', 12000, 'PROJECT MANAGER')
INSERT INTO STAFF VALUES ('SL103', 'B5', 'ANN', 'BEECH', 12000, 'PROJECT MANAGER')
INSERT INTO STAFF VALUES ('SL104', 'B7', 'MARY', 'HOWE', 9000, 'PROJECT MANAGER')

SELECT bno, COUNT(sno) AS COUNT, SUM(SALARY) AS SUM FROM STAFF GROUP BY BNO ORDER BY BNO;


SELECT * FROM PRICE
--INSERT INTO Price VALUES ('APPLES', 2.3)
SELECT ITEM, MAX(WHOLESALE) FROM PRICE GROUP BY ITEM --GIVES EACH ITEM WITH MAX PRICE FOR EACH
SELECT ITEM, AVG(WHOLESALE) FROM PRICE GROUP BY ITEM --GIVES EACH ITEM WITH AVG PRICE FOR EACH
SELECT ITEM, COUNT(*) FROM PRICE GROUP BY ITEM  --GIVES EACH ITEM WITH COUNT OF EACH ITEM

--GIVES COUNT OF EACH WHOLESALE PRICE IN DESCENDING ORDER
SELECT WHOLESALE, COUNT(WHOLESALE) AS CCC FROM PRICE GROUP BY WHOLESALE ORDER BY WHOLESALE DESC

select bno, count(sno) as count, sum(salary) as sum from STAFF group by bno having count(sno)>1 order by bno;

--to update a record with change in data
select * from price
update Price
set WHOLESALE = 5 where item = 'bananas'

-- for deleting records
delete from Price where item = 'RR'

--Delete all records
--'delete price'

-- delete full table
--'drop table price'

---convert & cast - pg 16

select convert(varchar(30), 56)
select 56 + 'tareq'; --??!! - this doesn't work
select 'abc' + 'edf' -- works for 2 strings
select convert(varchar(30), 56) + 'tareq'; --this works

--allows to concatenate string with values
select item + ' is priced at $' + convert(varchar(30), wholesale) as [newoutput] from price

select item, 'price of ' + item + ' is $' + CAST(wholesale as nvarchar) as [item-wholesale] from price
select item, item + wholesale as itemwholesale from price -- gives error by itself

-- convert date to characters
select getdate()
select convert(nvarchar(30), getdate(), 103); -- 103, 102, or 100 are formats inbuilt

--provides 4 digits after decimal points, AND 2 digits before decimal = 6 digits TOTAL before and after decimal
select convert(decimal(6,4), 99.55557)

select cast(9.5 as int)
select cast(9.5 as decimal (6,4)) -- same as convert above

select * from price
select cast(wholesale as int) from price
select item, cast(wholesale as decimal (3, 1)) [rounded price] from price

select item, wholesale from Price order by wholesale

--order by allows data to be ordered as per columns in ascending or descending order for multiple columns 
select * from price order by item, wholesale desc

--edit structure for table after it is created to add relationship
Alter table tblPerson
add constraint tblPerson_GenderId_FK Foreign key (GenderId) references tblGender (ID)


-- CHAPTER 3 SQL JOINS

create table CustomerNames (CustomerId nvarchar(1) Primary key, FirstName nvarchar(30), LastName nvarchar(30), Email nvarchar(30), DOB date, Phone nvarchar(50))
Insert into CustomerNames Values(1, 'John', 'Smith', 'John.Smith@yahoo.com', '02-04-1968', '626 222-2222')
Insert into CustomerNames Values(2, 'Steven', 'Goldfish', 'goldfish@fishhere.net', '04-04-1974', '323 455-4545')
Insert into CustomerNames Values(3, 'Paula', 'Brown', 'pb@herowndomain.org', '05-24-1978', '416 323-3232')
Insert into CustomerNames Values(4, 'James', 'Brown', 'jim@superguy.net', '10-20-1974', '111 222-3333')

Create table CustomerSales (CustomerId nvarchar(1), Date date, SaleAmount float)
Insert into CustomerSales values (2, '05-06-2004', 100.22)
Insert into CustomerSales values (1, '05-07-2004', 99.95)
Insert into CustomerSales values (3, '05-06-2004', 122.95)
Insert into CustomerSales values (3, '05-13-2004', 100.00)
Insert into CustomerSales values (4, '05-22-2004', 555.55)

select CustomerNames.FirstName, CustomerNames.LastName, Sum(CustomerSales.SaleAmount)
as [Sales Per Customer]
FROM CustomerNames JOIN CustomerSales
ON CustomerNames.CustomerId = CustomerSales.CustomerId
group by CustomerNames.FirstName, CustomerNames.LastName

--ch 3 SELF JOIN

--compares values of 2 different columns in same table
--SYNTAX - SELECT employeeid, lastname, firstname, reportsto FROM employees;
--SYNTAX - SELECT concat(e.firstname, e.lastname) employee, concat(m.firstname, m.lastname) manager FROM employees e INNER JOIN employees m ON m.employeeid = e.reportsto;

create table employeesreportto (employeeid int not null, lastname nvarchar(30), firstname nvarchar(30), reportsto int)
insert into employeesreportto values (1, 'Davolio', 'Nancy', 2)
insert into employeesreportto values (2, 'Fuller', 'Andrew', NULL)
insert into employeesreportto values (3, 'Leverling', 'Janet', 2)
insert into employeesreportto values (4, 'Peacock', 'Margaret', 2)
insert into employeesreportto values (5, 'Buchanan', 'Steven', 2)
insert into employeesreportto values (6, 'Suyama', 'Michael', 5)
insert into employeesreportto values (7, 'King', 'Robert', 5)
insert into employeesreportto values (8, 'Callahan', 'Laura', 2)
insert into employeesreportto values (9, 'Dodsworth', 'Anne', 5)

select * from employeesreportto

SELECT concat(e.firstname, e.lastname) as employee, concat(m.firstname, m.lastname) as manager 
FROM employeesreportto e 
INNER JOIN employeesreportto m ON m.employeeid = e.reportsto;

--embedded select statement - executes the statement only once
--correlated subquery - works on every row or record
-- any, some or all - refer sql ch3 query
/*
--execute query for business rule that no engineer may have an overtime rate lower than another engineer's basic hourly pay
Select EngineerId,
EngineerName, OvertimeRate
FROM 
Engineers
WHERE
 NOT OvertimeRate >= ALL (SELECT HourlyRate FROM Engineers)
 */
 /*
 --execute query to find list of engineers who have an overtime rate that is lower than any other engineer's hourly rate
Select EngineerId,
EngineerName, OvertimeRate
FROM 
Engineers
WHERE
 OvertimeRate < ANY (SELECT HourlyRate FROM Engineers)
 */
 /*
 OvertimeRate < SOME (SELECT HourlyRate FROM Engineers)
 */

--GO statement - refer sql ch3 query

 -- case statement pg 38

 /*
 SELECT OrderID, Quantity,
 CASE
	WHEN Quantity > 30 THEN 'The quantity is greater than 30'
	WHEN Quantity = 30 THEN 'The quantity is 30'
	ELSE 'The quantity is under 30'
END AS QuantityText
FROM OrderDetails;
*/

 --case statement for re-ordering the rows of the dataset
 /*
 SELECT CustomerName, City, Country
 FROM Customers
 ORDER BY
 (CASE
	WHEN City IS NULL THEN Country
	ELSE City
END);
*/
/*
-- https://www.w3schools.com/SQL/sql_case.asp
*/

-- CHAPTER 4
/* views, indexes & transactions
DATA CONTROL LANGUAGE DCL
GRANT & REVOKE priviliges
Roles
SYNTX
GRANT create table to tareq1;
create role tareqrole;
Grant create table to tareqrole;

ALTER ROLE tareqrole ADD MEMBER tareq1;
ALTER ROLE tareqrole DROP MEMBER Tareq1;

drop role tareqrole;
*/

/*
INDEXES - binary search algorithm, used to find data without reading whole table
users cannot see the indexes
- any table with primary key is an index (unique values)
-speeds up search
eg. pg 9
Person (name, age, city)
Select *
FROM Person
WHERE name = "Smith"
Sequential scan of the file Person may take long

CREATE INDEX nameIndex ON Person(name)

--more than one attribute
CREATE INDEX doubleindex ON
			Person(age, city)

above helps in case where both are used in the search, not with just city, for eg.

Index is useful in range queries
DROP INDEX for removing
*/

---------------------------
--index
select * from tblEmployee
Select * from tblEmployee where Salary > 5000 and Salary < 7000

CREATE Index IX_tblEmployee_Salary
ON tblEmployee (SALARY ASC)

sp_helpindex tblEmployee

-- FOR CLUSTERED INDEX
/* DROP CURRENT CLUSTERED INDEX WILL GIVE AN ERROR DUE TO SECURITY, DELETE MANUALLY
*/
-- FOR NON CLUSTERED INDEX
/*
create nonclustered index ix_tblEmployee_Name -- stored separately does not affect primary key
ON tblEmployee_2(Name)
*/

--TRANSACTION IN SQL p13
/*  A sequence of database operations or work accomplished in a logical order
- propogation of one of more changes to the database
eg. - update checking
set balance = balance - 1000
where account = 'Sally'
*/

--exists keyword
/*KEYWORD that checks for existence of a condition

*/
IF EXISTS (SELECT * FROM Price WHERE Wholesale = 2.5)
BEGIN -- do what needs to be done if exists
print 'yes'
END
ELSE
BEGIN -- dow what needs to be done if not
print 'no'
END

/*CHAPTER 4 - VIEWS

VIEW IS A VIRTUAL TABLE

EG. 
CREATE VIEW CUSTOMERS_VIEW AS
SELECT name, age FROM CUSTOMERS
WHERE age IS NOT NULL

see examples in Ch4 query for egs of creating views and dropping views
VIEW with where condition, INNER JOIN on 2 columns
Eg. for COUNT GROUP BY as well AND UPDATEABLE Views
*/

/* CHAPTER 5 - transactions, errors and functions
Transactions must be ACID
Atomicity
Consistency
Isolation
Durability
syntax
BEGIN TRANSACTION;
STATEMENT;
COMMIT;


*/
CREATE TABLE ValueTable (id int);
BEGIN TRANSACTION;
 INSERT INTO ValueTable VALUES(1);
 INSERT INTO ValueTable VALUES(2);
ROLLBACK;

SELECT * FROM Price

begin tran
insert into price (item, wholesale) values('fff', 1.2), ('rrr', 1.6)
commit tran
rollback tran --gives error because it is already committed above

begin tran
insert into price (item, wholesale) values('fffff', 1.2), ('rrrrr', 1.6)
--commit tran
rollback tran --gives error because it is already committed above

select * from Price
--ISOLATION
CREATE TABLE ValueTable (id int);
BEGIN TRANSACTION;
--CREATE TABLE ValueTable (id int);
	INSERT INTO ValueTable VALUES(1);
	INSERT INTO ValueTable VALUES(2);
	INSERT INTO ValueTable VALUES(3);
commit tran
select * from ValueTable
ROLLBACK;
drop table ValueTable

--savepoint
BEGIN TRANSACTION;
--CREATE TABLE ValueTable (id int);
	CREATE TABLE ValueTable (id int);
	INSERT INTO ValueTable VALUES(1);
	INSERT INTO ValueTable VALUES(2);
	SAVE TRAN Savepoint1
	INSERT INTO ValueTable VALUES(3);
ROLLBACK tran Savepoint1;
--commit tran
select * from ValueTable
drop table ValueTable


/* CREATE PROCEDURE
TRY CATCH
BEGIN TRY
END TRY
BEGIN CATCH 
END CATCH


sp_helptext PROCEDURE NAME
*/
/*
ALI NATHANI
HHH
*/

