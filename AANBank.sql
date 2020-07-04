/*METRO COLLEGE OF TECHNOLOGY
SQL PROGRAMMING
PROJECT PHASE 1
BY ALI NATHANI
*/
Create DATABASE BankOfAli;
WAITFOR DELAY '00:00:05';  
GO
Use BankOfAli;
--Creating Tables With Only Primary Key
--UserLogins
Create Table UserLogins(UserLoginID int NOT NULL Primary Key, UserName nvarchar(50), UserPassword varchar(20))
--Inserting Values into table (UserLoginID, UserName, UserPassword)
INSERT INTO UserLogins Values (1001, 'jeffbezos', 'password123')
INSERT INTO UserLogins Values (1002, 'billgates', 'password456')
INSERT INTO UserLogins Values (1003, 'warrenbuffett', 'password789')
INSERT INTO UserLogins Values (1004, 'bernardarnault', 'password101')

--Use BankOfAli;
--UserSecurityQuestions
Create Table UserSecurityQuestions (UserSecurityQuestionID int NOT NULL Primary Key, UserSecurityQuestion varchar(50))
--Inserting Values into table (UserSecurityQuestionID, UserSecurityQuestion)
INSERT INTO UserSecurityQuestions Values (101, 'Which company am I a founder of?')
INSERT INTO UserSecurityQuestions Values (102, 'First name of my spouse?')
INSERT INTO UserSecurityQuestions Values (103, 'I first filed taxes at what age?')
INSERT INTO UserSecurityQuestions Values (104, 'The name of my Daughter?')

--AccountType
Create Table AccountType (AccountTypeID int NOT NULL Primary Key, AccountTypeDescription varchar(30))
--Inserting Values into table (AccountTypeID, AccountTypeDescription)
INSERT INTO AccountType Values (01, 'Checking') 
INSERT INTO AccountType Values (02, 'Savings') 
INSERT INTO AccountType Values (03, 'Market Saver') 
INSERT INTO AccountType Values (04, 'Super Saver') 

--SavingsInterestRates
Create Table SavingsInterestRates (InterestSavingsRateID int NOT NULL Primary Key, InterestRateValue numeric(9,9), InterestRateDescription varchar(20))
--Inserting Values into table (InterestSavingsRateID, InterestRateValue, InterestRateDescription)
INSERT INTO SavingsInterestRates Values(901, 0.000, 'No Interest')
INSERT INTO SavingsInterestRates Values(902, 0.009, 'High Interest')
INSERT INTO SavingsInterestRates Values(903, 0.015, 'Market Interest')
INSERT INTO SavingsInterestRates Values(904, 0.025, 'Super Saver Interest')

--AccountStatusType
Create Table AccountStatusType (AccountStatusTypeID int NOT NULL Primary Key, AccountStatusDescription varchar(30))
--Inserting Values into table (AccountStatusID, AccountStatusDescription)
INSERT INTO AccountStatusType Values(501, 'Active')
INSERT INTO AccountStatusType Values(502, 'Dormant')
INSERT INTO AccountStatusType Values(503, 'Closed')
INSERT INTO AccountStatusType Values(504, 'On Hold')

--Employee
Create Table Employee (EmployeeID int NOT NULL Primary Key, EmployeeFirstName varchar(25), EmployeeMiddleInitial char(1), EmployeeLastName varchar(25), EmployeeIsManager bit)
--Inserting Values into table (EmployeeID, EmployeeFirstName, EmployeeMiddleInitial, EmployeeLastName)
INSERT INTO Employee Values(3111, 'Ali', 'A', 'Nathani', 1)
INSERT INTO Employee Values(3112, 'Matt', 'C', 'Rogowski', 0)
INSERT INTO Employee Values(3113, 'John', 'B', 'Schmale', 0)
INSERT INTO Employee Values(3114, 'Pavel', 'K', 'Razdan', 0)

--TransactionType
Create Table TransactionType (TransactionTypeID int NOT NULL Primary Key, TransactionTypeName char(10), TransactionTypeDescription varchar(50), TransactionFeeAmount smallmoney)
--Inserting Values into table (TransactionTypeID, TransactionTypeName, TransactionTypeDescription, TransactionFeeAmount)
INSERT INTO TransactionType Values(401, 'Deposit', 'Deposits to Account', 0.20)
INSERT INTO TransactionType Values(402, 'Withdrawl', 'Cash/Cheque Withdrawls from Account', 0.25)
INSERT INTO TransactionType Values(403, 'Transfer', 'Inter Bank Transfer to Another account', 0.00)
INSERT INTO TransactionType Values(404, 'IWTransfer', 'International Wire Transfer', 45.00)

--LoginErrorLog
Create Table LoginErrorLog (ErrorLogID int NOT NULL Primary Key, ErrorTime datetime, FailedTransactionXML xml)
--Inserting Values into table (ErrorLogID, ErrorTime, FailedTransactionXML)
INSERT INTO LoginErrorLog Values(601, '20190101 12:01:00 AM', 'Incorrect Password, You have 2 attempts remaining');
INSERT INTO LoginErrorLog Values(602, '20190203 01:45:05 PM', 'Account Locked, Contact the customer support line')
INSERT INTO LoginErrorLog Values(603, '20190304 04:10:08 AM', 'Username not found')
INSERT INTO LoginErrorLog Values(604, '20190406 10:05:09 AM', 'Signed Out for your safety, due to no activity')

--FailedTransactionErrorType
Create Table FailedTransactionErrorType (FailedTransactionErrorTypeID int NOT NULL Primary Key, FailedTransactionDescription varchar(50))
--Inserting Values into table (FailedTransactionErrorTypeID, FailedTransactionDescription)
INSERT INTO FailedTransactionErrorType Values(2201, 'SWIFT Code is not found')
INSERT INTO FailedTransactionErrorType Values(2202, 'Cash Deposited does not match inputted value')
INSERT INTO FailedTransactionErrorType Values(2203, 'Daily Withdrawl Limit reached')
INSERT INTO FailedTransactionErrorType Values(2204, 'Receiver is not registered to receive E-Transfer')

--Creating Tables with Both Primary Key and Foreign Keys

--FailedTransactionLog
Create Table FailedTransactionLog (FailedTransactionID int NOT NULL Primary Key, FailedTransactionErrorTypeID int REFERENCES FailedTransactionErrorType(FailedTransactionErrorTypeID), FailedTransactionErrorTime datetime, FailedTransactionXML xml)
--Inserting Values into table (FailedTransactionID, FailedTransactionErrorTypeID, FailedTransactionErrorTime, FailedTransactionXML)
INSERT INTO FailedTransactionLog Values(99001, 2202, '20190106 09:07:10 AM', 'ATM Deposit')
INSERT INTO FailedTransactionLog Values(99002, 2204, '20190223 11:45:55 AM', 'ETransfer')
INSERT INTO FailedTransactionLog Values(99003, 2203, '20190310 18:05:07 PM', 'ATM Withdrawl')
INSERT INTO FailedTransactionLog Values(99004, 2201, '20190414 20:22:11 PM', 'International Wire Transfer')

--UserSecurityAnswers
Create Table UserSecurityAnswers(UserLoginID int NOT NULL Primary Key REFERENCES UserLogins(UserLoginID), UserSecurityAnswer varchar(25), UserSecurityQuestionID int REFERENCES UserSecurityQuestions(UserSecurityQuestionID))
--Inserting Values into table (UserLoginID, UserSecurityAnswer, UserSecurityQuestionID)
INSERT INTO UserSecurityAnswers Values (1001, 'Amazon', 101)
INSERT INTO UserSecurityAnswers Values (1002, 'Melinda', 102)
INSERT INTO UserSecurityAnswers Values (1003, 'thirteen', 103)
INSERT INTO UserSecurityAnswers Values (1004, 'Delphine', 104)

--Account
Create Table Account(AccountID int NOT NULL Primary Key, CurrentBalance int, AccountTypeID int REFERENCES AccountType(AccountTypeID), AccountStatusTypeID int REFERENCES AccountStatusType(AccountStatusTypeID), InterestSavingsRateID int REFERENCES SavingsInterestRates(InterestSavingsRateID))
--Inserting Values into table (AccountID, CurrentBalance, AccountTypeID, AccountStatusTypeID, InterestSavingsRateID )
INSERT INTO Account Values (71001, 55000, 01, 504, 901)
INSERT INTO Account Values (71002, 500, 02, 502, 902)
INSERT INTO Account Values (71003, 131000, 02, 501, 902)
INSERT INTO Account Values (71004, 96500, 03, 501, 903)

--Customer
Create Table Customer(CustomerID int NOT NULL Primary Key, AccountID int REFERENCES Account(AccountID), CustomerFirstName varchar(30), CustomerMiddleInitial char(1), CustomerLastName varchar(30), CustomerAddress1 varchar(30), CustomerAddress2 varchar(30), City varchar(20), [State] char(2), ZipCode char(10), EmailAddress varchar(40), HomePhone char(10), CellPhone char(10), WorkPhone char(10), SSN char(9), UserLoginID int REFERENCES UserLogins(UserLoginID))
--Inserting Values into table (CustomerID, AccountID, CustomerFirstName, CustomerMiddleInitial, CustomerLastName, CustomerAddress1, CustomerAddress2, City, State, ZipCode, EmailAddress, HomePhone, CellPhone, WorkPhone, SSN, UserLoginID )
INSERT INTO Customer Values (38051, 71002, 'Warren', 'E', 'Buffett', '3555 Farnam Street', '', 'Omaha', 'NE', '68131', 'berkshire@berkshirehathaway.com', '5558166251', '4441264736', '1264733623', '888111222',  1003)
INSERT INTO Customer Values (38052, 71003, 'Jeff', 'P', 'Bezos', '568 Bezos Rd', 'opposite Amazon head office', 'Medina', 'WA', '98039', 'jeff.bezos@amazon.com', '5551234222', '4444151955', '1519559155', '888555777', 1001)
INSERT INTO Customer Values (38053, 71001, 'Bernard', 'J', 'Arnault', '1150 Lakeshore Road East', 'next to the lake', 'Oakville', 'ON', 'L6L1L2', 'bernard.arnault@louisvuitton.com', '2891651747','4161651747', '9051651747', '571651747', 1004)
INSERT INTO Customer Values (38054, 71004, 'William', 'H', '[Gates III]', '1835 73rd Ave NE', '', 'Medina', 'WA', '98039', 'bill.gates@microsoft.com', '5554567333', '4441344317', '1344317275', '888222333',1002)

--Customer_Account
Create Table Customer_Account(AccountID int REFERENCES Account(AccountID), CustomerID int REFERENCES Customer(CustomerID))
--Inserting Values into table (AccountID, CustomerID)
INSERT INTO Customer_Account Values (71001, 38053)
INSERT INTO Customer_Account Values (71002, 38051)
INSERT INTO Customer_Account Values (71003, 38052)
INSERT INTO Customer_Account Values (71004, 38054)

--TransactionLog
Create Table TransactionLog(TransactionID int NOT NULL Primary Key, TransactionDate datetime, TransactionTypeID int REFERENCES TransactionType(TransactionTypeID), TransactionAmount money, NewBalance money, AccountID int REFERENCES Account(AccountID), CustomerID int REFERENCES Customer(CustomerID), EmployeeID int REFERENCES Employee(EmployeeID), UserLoginID int REFERENCES UserLogins(UserLoginID))
--Inserting Values into table (TransactionID, TransactionDate, TransactionTypeID, TransactionAmount, NewBalance, AccountID, CustomerID, EmployeeID, UserLoginID)
INSERT INTO TransactionLog Values (985711, '20190106 09:10:11 AM', 402, 10000, 65000, 71001, 38053, 3112, 1004)
INSERT INTO TransactionLog Values (985712, '20190215 15:05:15 PM', 401, 5000, 91500, 71004, 38054, 3114, 1002)
INSERT INTO TransactionLog Values (985713, '20190307 11:09:30 AM', 404, 30000, 100000, 71003, 38052, 3111, 1001)
INSERT INTO TransactionLog Values (985714, '20190420 12:11:45 PM', 403, 100, 400, 71002, 38051, 3113, 1003)

Create Table OverDraftLog(AccountID int NOT NULL Primary Key REFERENCES Account(AccountID), OverDraftDate datetime, OverDraftAmount money, OverDraftTransactionXML xml)
--Inserting Values into table (AccountID, OverDraftDate, OverDraftAmount, OverDraftTransactionXML)
INSERT INTO OverDraftLog Values (71001, '20190211 10:01:05 AM', 0, 'No Overdraft')
INSERT INTO OverDraftLog Values (71003, '20190305 06:26:07 AM', 100, 'Overdraft')
INSERT INTO OverDraftLog Values (71004, '20190423 15:55:09 PM', 1000, 'Overdraft')
INSERT INTO OverDraftLog Values (71002, '20190519 20:25:44 PM', 100, 'Overdraft')

Create Table Login_Account(UserLoginID int REFERENCES UserLogins(UserLoginID), AccountID int REFERENCES Account(AccountID))
--Inserting Values into table (UserLoginID, AccountID)
INSERT INTO Login_Account Values (1002, 71004)
INSERT INTO Login_Account Values (1003, 71002)
INSERT INTO Login_Account Values (1001, 71003)
INSERT INTO Login_Account Values (1004, 71001)
