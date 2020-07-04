Create database MyDatabase

Alter database MyDatabase Modify Name = MYDatabase2

Drop Database MyDatabase2

select * from tblPerson
select * from tblGender


Create Table tblGender(ID int Not Null Primary Key,Gender nvarchar(50))

--assigning FK to a table
Alter table tblPerson 
add constraint tblPerson_GenderId_FK FOREIGN KEY (GenderId) references tblGender(ID)

insert into tblPerson values (5,'Jenny','jj@',2)

select * from tblperson 

--Creating table and assigning FK
create table tareqnew (ID int Not Null Primary Key,
Gendercode int REFERENCES tblGender(Id));

--Adding column
select * from tblGender
ALTER TABLE tblGender
ADD TTT int NULL; 


ALTER TABLE tblGender
drop column TTT; --removing column

--***
Delete Price -- removes the data from the table

Drop table price -- deletes the whole table
--***
--changing order in the column
select name, id, email from tblperson



--Price example
use MyDatabase

Create Table Price(Item varchar(20) Not Null,Wholesale float)

insert into price values ('Apple',2.2)
insert into price values ('Orange',1.3)
insert into price values ('Grape',3.3)
insert into price values ('Banana',1.1)

select* from price

SELECT ITEM, WHOLESALE, WHOLESALE + 0.15 as NewWholesale FROM PRICE;

SELECT ITEM, -WHOLESALE minus_wholesale, WHOLESALE + 0.15 as NewWholesale FROM PRICE;

SELECT ITEM, WHOLESALE, (WHOLESALE/2) SALEPRICE FROM PRICE;

SELECT ITEM, WHOLESALE, (WHOLESALE*2) SALEPRICE FROM PRICE;


select * from price where Item = 'apple'

select * from price where wholesale < 1 

select * from price where item < 'Orange' 

select * from price where item != 'Orange' --or '<>'

select * from price where item like '%a%' 

select * from price where item like 'a%' 

select * from price where item liKE '%a' 

select * from price where item not liKE '%a%' 


select * from price where wholesale > 1 and item < 'n'


SELECT * FROM PRICE WHERE WHOLESALE IS NOT NULL;

insert into price values ('xx',NULL)
insert into price values ('yy',NULL)

SELECT * FROM PRICE WHERE WHOLESALE IS NOT NULL;

SELECT * FROM PRICE WHERE WHOLESALE in (1.1,2.2,3);

SELECT * FROM PRICE WHERE WHOLESALE BETWEEN 0.25 AND 2.3;

--Aggregate Functions
select * from price

select count(item) from price
select count(item) Total from price
select count(Wholesale) from price
select count(distinct Wholesale) from price
select count(All Wholesale) from price
select count(item) from price where wholesale >

select sum(wholesale) sum_of_prices from price--sum works only for numeric data

select avg(wholesale) avg_of_prices from price

select max(item) from price

select min(Wholesale) from price

select var(wholesale) var_of_prices from price

select stdev(wholesale) std_of_prices from price


select getdate()
select datEPART(year, '2017/08/25');
select datEPART(month, '2017/08/25');
select datEPART(day, '2017/08/25');

select abs(-10)
select floor(1.2)

select power(2,3)

update price 
set Wholesale = 1.1 where item = 'xx';

--Chapter2

select * from Price where item!= 'Apple';
select count (*) Numberofitem from Price;
select max (wholesale) from Price;
select NCHAR (197);
select CHAR (200);
select CHARINDEX('e','tareq',2)
select LOWER('TAreq')
select upper('TAreq')
select REPLACE ('tareq', 't', 'f');
select REPLICATE('tareq ', 5);
select RTRIM ('tareq jaber  ') + 'abc';
select '  tareq jaber'
select LTRIM ('  tareq jaber')
SELECT SOUNDEX('Juice'), SOUNDEX('Jucy'); 
SELECT SOUNDEX('Juice'), SOUNDEX('Banana'); 
select soundex('tareq'), soundex('terek');
select DIFFERENCE('tareq', 'banana');
select SPACE(20) + 'tareq';
select STUFF('tareqjaber', 4, 2, 'ik');
select unicode('A')
select substring('abcdefg', 3,2);
-----------------------------------
--Groupby and Having
select * from price
select wholesale, count(wholesale) as ccc from price group by wholesale

select item, max(wholesale) from price group by item

------------------------------------
--Conversion
SELECT convert( varchar(30), 56)
SELECT 56 + 'tareq';--??!!
SELECT convert( varchar(30), 56) + 'tareq';

Select item, item + ' - ' + CAST(wholesale AS NVARCHAR) AS [item-wholesale] FROM Price
Select item, item + wholesale AS itemwholesale FROM Price

SELECT convert( nvarchar(30), now(), 102)
SELECT convert( nvarchar(30), getdate(), 100);--102,100
select CONVERT(decimal(6,4), 9.5)

select CAST(9.5 AS int)
select CAST(9.5 AS decimal(6,4))
-------------------------------------















