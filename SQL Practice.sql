CREATE TABLE CustomerClaims
(
Customer_ID int,
Claim_date date,
Claim_amount int
);

INSERT INTO CustomerClaims
VALUES
(123456, '2019-05-05', 200),
(654321, '2019-06-20', 399),
(123456, '2019-05-02', 200),
(234567, '2019-04-05', 2910),
(345678, '2019-03-21', 3861),
(123456, '2019-01-20', 289),
(654321, '2018-11-21', 111);

SELECT * FROM CustomerClaims
-- You have a table with customers' claim date and corresponding claim amount:
-- 1.Sum the claim amount for each customer ID by month.




-- 2. Write a SQL query to only show the latest claim record for each customer ID.




CREATE TABLE Purchases
(
Account_ID int,
Merchant_category char(10),
Purchase_amount int
);

INSERT INTO Purchases
VALUES
(123456, 'Online', 100),
(654321, 'Grocery', 199),
(123456, 'Online', 20),
(234567, 'Others', 2910),
(345678, 'Grocery', 1861),
(123456, 'Others', 289),
(654321, 'Online', 111);

SELECT * FROM Purchases

--Write a query to create a table containing the following 4 columns for each Account ID:
	-- Account ID
	-- Sum of total Online purchase amount
	-- Sum of total Grocery purchase amount
	-- Sum of total Other purchase amount
--Make sure your final result has one record per Account ID
