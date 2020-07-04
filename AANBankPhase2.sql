/*METRO COLLEGE OF TECHNOLOGY
SQL PROGRAMMING
PROJECT PHASE 2
BY ALI NATHANI
*/


Use BankOfAli
----------------------------
--QUESTION/PROBLEM 1.	Create a view to get all customers with checking account from ON province. 
CREATE VIEW OntarioChecking AS

SELECT Customer.CustomerID, CustomerFirstName, CustomerLastName, [State], AccountTypeDescription 
FROM Customer JOIN Account ON Customer.AccountID = Account.AccountID JOIN AccountType ON Account.AccountTypeID = AccountType.AccountTypeID 
WHERE [State] = 'ON' AND [AccountTypeDescription] LIKE '%Checking%';
	

--CHECK RESULT USING THIS STATEMENT
SELECT * FROM OntarioChecking

--QUESTION/PROBLEM 2.	Create a view to get all customers with total account balance (including interest rate) greater than 5000. 
CREATE VIEW CustGreaterFiveK AS 
SELECT CustomerFirstName, CustomerLastName, CurrentBalance, InterestRateValue 
FROM ACCOUNT
JOIN Customer ON Account.AccountID = Customer.AccountID JOIN SavingsInterestRates ON Account.InterestSavingsRateID = SavingsInterestRates.InterestSavingsRateID
WHERE CurrentBalance > 5000

--CHECK RESULT USING THIS STATEMENT
SELECT * FROM CustGreaterFiveK


--QUESTION/PROBLEM 3.	Create a view to get counts of checking and savings accounts by customer. 

CREATE VIEW CHECKSAVGCOUNT (CUSTOMERNAME, TOTALACCOUNTS_PER_CUSTOMER) as
-- - COUNTS HOW MANY ACCOUNTS FOR EACH CUSTOMER THAT ARE EITHER CHECKING OR SAVINGS
select CustomerFirstName+' '+CustomerLastName, count(AccountTypeDescription) 
FROM Customer JOIN Account ON Customer.AccountID = Account.AccountID JOIN AccountType ON Account.AccountTypeID = AccountType.AccountTypeID
WHERE AccountTypeDescription = 'Checking' OR AccountTypeDescription = 'Savings'
GROUP BY CustomerFirstName+' '+CustomerLastName

--CHECK RESULT USING THIS STATEMENT
Select * from CHECKSAVGCOUNT

--QUESTION/PROBLEM 4.	Create a view to get any particular user’s login and password using AccountId. 

CREATE VIEW GETLOGINDETAILS AS 

SELECT CustomerFirstName, CustomerLastName, UserName, UserPassword 
FROM UserLogins JOIN Customer ON Customer.UserLoginID = UserLogins.UserLoginID
WHERE Customer.AccountID = 71001

--CHECK RESULT USING THIS STATEMENT
Select * from GETLOGINDETAILS

--QUESTION/PROBLEM 5.	Create a view to get all customers’ overdraft amount. 
CREATE VIEW GETOVERDRAFTAMOUNTS AS

SELECT CustomerFirstName, CustomerLastName, OverDraftAmount
FROM Customer JOIN OverDraftLog ON Customer.AccountID = OverDraftLog.AccountID

--CHECK RESULT USING THIS STATEMENT
Select * from GETOVERDRAFTAMOUNTS

--QUESTION/PROBLEM 6. Create a Stored Procedure to add "User_" as a prefix to everyone's login (username)
Create Procedure spUpdateLogin
@newloginname varchar(50) 
AS
BEGIN
 BEGIN TRANSACTION
  UPDATE UserLogins set UserLogins.UserName = (@newloginname + UserLogins.UserName)
  WHERE UserName NOT LIKE 'User_%'
  COMMIT TRANSACTION
END

EXECUTE spUpdateLogin 'User_'

--QUESTION/PROBLEM 7. 
CREATE PROCEDURE spAccountIDtoCUSTNAME
@InputAccountID INT
AS

 SELECT CustomerFirstName, CustomerLastName, AccountID
 FROM Customer
 WHERE AccountID = @InputAccountID
GO

EXECUTE spAccountIDtoCUSTNAME '71002'

--QUESTION 8 

CREATE PROCEDURE spUpdateBalance
@InputAccountID INT, @DepositAmount INT
AS
	UPDATE Account Set Account.CurrentBalance = (CurrentBalance + @DepositAmount)
	WHERE Account.AccountID = @InputAccountID
GO

Execute spUpdateBalance '71002', 1000

