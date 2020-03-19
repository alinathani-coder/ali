libname AN "F:\DSP SAS Project Class\Retail Sales Analysis Project";
libname AN "C:\Users\alina\Documents\Retail Sales Analysis Project";
libname AN "C:\Users\anathani\Desktop\DSP SAS Project class\Retail Sales Analysis Project";
libname AN "F:\DSP SAS Project Class\Retail Sales Analysis Project";
libname AN "E:\DSP SAS Project Class\Retail Sales Analysis Project";

*import data to SAS;

PROC IMPORT OUT= AN.RSA1 
            DATAFILE= "E:\DSP SAS Project Class\Retail Sales Analysis Pr
oject\transactionhistoryforcurrentcustomers.csv" 
            DBMS=CSV REPLACE;
     GETNAMES=YES;
     DATAROW=2; 
RUN;

PROC IMPORT OUT= AN.RSA2
            DATAFILE= "E:\DSP SAS Project Class\Retail Sales Analysis Pr
oject\ec90_data.csv" 
            DBMS=CSV REPLACE;
     GETNAMES=YES;
     DATAROW=2; 
RUN;

*UNDERSTAND YOUR DATA AND ITS PROPERTIES;
TITLE "RSA1a";
PROC CONTENTS DATA = AN.RSA1;
RUN;

TITLE "RSA2a";
PROC CONTENTS DATA = AN.RSA2;
RUN;

*DATA VALUE;
PROC PRINT DATA = AN.RSA1 (OBS = 20);
TITLE "RSA1";
RUN;
PROC PRINT DATA = AN.RSA2 (OBS = 20);
TITLE "RSA2";
RUN;

*CHECK FOR MISSING VALUES;
PROC MEANS DATA = AN.RSA1 N NMISS;
RUN;
PROC MEANS DATA = AN.RSA2 N NMISS;
RUN;

DATA AN.RSA1a;
	set AN.RSA1;
	if cmiss(of _all_) then delete;
run;
DATA AN.RSA2a;
	set AN.RSA2;
	if cmiss(of _all_) then delete;
run;

*CHECK FOR MISSING VALUES AGAIN;
PROC MEANS DATA = AN.RSA1a N NMISS;
TITLE 'RSA1a';
RUN;
PROC MEANS DATA = AN.RSA2a N NMISS;
TITLE 'RSA2a';
RUN;


*DUPLICATES;
*COUNT COLS;
TITLE "Count of Distinct Customer IDs in RSA1a";
	PROC SQL;
	SELECT COUNT(Customer_ID)AS TOTAL_COUNT, COUNT(DISTINCT Customer_ID) AS UNIQUE_COUNT
	FROM AN.RSA1a
	;
	QUIT;

TITLE "Count of Distinct Customer Numbers in RSA2a";
PROC SQL;
	SELECT COUNT(Customer_Number)AS TOTAL_COUNT, COUNT(DISTINCT Customer_Number) AS UNIQUE_COUNT
	FROM AN.RSA2a
	;
	QUIT;

*REMOVE DUPLICATE OBSERVATIONS and check count again;
PROC SORT DATA = AN.RSA1a OUT = AN.RSA1a_S dupout=AN.RSA1aDup NODUPKEY;
	BY _ALL_;
RUN;
PROC SORT DATA = AN.RSA2a OUT = AN.RSA2a_S dupout=AN.RSA2aDup NODUPKEY;
	BY _ALL_;
RUN;
*COUNT AGAIN;

TITLE 'Count of Customer IDs RSA1_S';
PROC SQL;
	SELECT COUNT(Customer_ID)AS TOTAL_COUNT, COUNT(DISTINCT Customer_ID) AS UNIQUE_COUNT
	FROM AN.RSA1a_s
	;
	QUIT;

TITLE 'Count of Customer IDs RSA2_S';
PROC SQL;
	SELECT COUNT(Customer_Number)AS TOTAL_COUNT, COUNT(DISTINCT Customer_Number) AS UNIQUE_COUNT
	FROM AN.RSA2a_s
	;
	QUIT;


*BEFORE MERGING THE DATA, MIGHT HAVE TO CREATE A SALES COLUMN FOR RSA1 and a Price column for RSA2;

*FEATURE GENERATION FOR ;
*create sales columns in RSA1 and price col IN RSA2;
PROC SQL ;
	CREATE TABLE AN.RSA1b AS
	SELECT *, PRICE*QUANTITY AS SALES
	FROM AN.RSA1a_s
	;
	QUIT;


*Convert Sales_amount in RSA2_S to numeric and create a Price column;
DATA AN.RSA2b;
	SET AN.RSA2a_s;
	Sales = input(Sales_amount, dollar10.2);
	Price = Sales/Quantity;
	DROP Sales_amount;
run;

TITLE 'RSA1b';
PROC CONTENTS data = AN.RSA1b; run;
TITLE 'RSA2b';
PROC CONTENTS data = AN.RSA2b; run;


*DATA MERGING;

*BELOW CODE IS NOT A GOOD WAY TO MERGE THIS DATASET;
/*PROC SQL;*/
/*	CREATE TABLE PO AS */
/*	SELECT A.*,B.**/
/*	FROM AN.RSA1 AS A LEFT JOIN AN.RSA2 AS B*/
/*	ON A.CUSTOMER_ID = B.CUSTOMER_NUMBER*/
/*	;*/
/*	ALTER TABLE PO*/
/*	DROP CUSTOMER_NUMBER;*/
/*	QUIT;*/
/*PROC PRINT DATA = PO (OBS = 20);*/
/*RUN;*/

*SELECT VARIABLES IDENTIFIED IN YOUR STUDY FRAMEWORK;

*Q1 - 1. Which customers have the lowest average day difference;

PROC SORT DATA = AN.RSA1b OUT = AN.RSA1_RA;
	BY Customer_ID  DESCENDING Order_Date;
RUN;

DATA AN.N_ORDERDATE;
	SET AN.RSA1_RA;
	BY CUSTOMER_ID;
N_ORDERDATE = DATEPART(ORDER_DATE);
RUN;

PROC SORT DATA = AN.N_ORDERDATE OUT = AN.N_ORDERDATE2 dupout=AN.N_ORDERDATEDup NODUPKEY ;
	BY Customer_ID Item_code Order_date ;
RUN;
PROC SORT DATA = AN.N_ORDERDATE2 ;
	BY Customer_ID DESCENDING Order_date ;
RUN;


PROC SQL;
SELECT COUNT(Customer_ID) as total_count
FROM AN.N_ORDERDATE2
;
QUIT;


DATA AN.FSUMMARY;
	SET AN.N_ORDERDATE2;
	BY Customer_ID;
	
	RETAIN TOTAL_ITEMS TOTAL_CAT TOTAL_SOURCE;
	LENGTH TOTAL_SOURCE $700.;
	
	IF FIRST.Customer_ID THEN TOTAL_ITEMS = " ";
		TOTAL_ITEMS = CATX(",",TOTAL_ITEMS, Item_Code);

	IF FIRST.Customer_ID THEN TOTAL_CAT = " ";
	TOTAL_CAT = CATX(",",TOTAL_CAT, Category);

	IF FIRST.Customer_ID THEN TOTAL_SOURCE = " ";
	else if index(TOTAL_SOURCE ,Source)=0 then TOTAL_SOURCE = CATX(",",TOTAL_SOURCE, Source);

	IF FIRST.Customer_ID THEN NUM_ORDERS = 0;
		NUM_ORDERS + 1;

	IF FIRST.Customer_ID THEN TOTAL_SALES = 0;
	TOTAL_SALES + SALES;


	IF FIRST.Customer_ID THEN TOTAL_QUANTITY = 0;
	TOTAL_QUANTITY + Quantity;

	N_DATE = LAG(N_ORDERDATE);
	IF FIRST.Customer_ID THEN N_DATE = .;
	DIFF_DAY = N_DATE - N_ORDERDATE;

	IF FIRST.Customer_ID THEN TOTAL_DIFF_DAY = 0;
	TOTAL_DIFF_DAY + DIFF_DAY;

	IF FIRST.Customer_ID THEN AVG_DIFF_DAY = 0;
	AVG_DIFF_DAY = (TOTAL_DIFF_DAY/NUM_ORDERS);


	IF LAST.Customer_ID;

DROP SALES Category Item_Description Item_Code Quantity Source Price Order_Date;
RUN;

PROC SQL;
	CREATE TABLE AN.P1 AS
	SELECT Customer_ID, AVG_DIFF_DAY, TOTAL_DIFF_DAY, TOTAL_SALES
	FROM AN.FSUMMARY
	WHERE TOTAL_DIFF_DAY > 1
	ORDER BY AVG_DIFF_DAY ASC;
	;
	QUIT;

	
*UNIVARIATE ANALYSIS;

	*ALL CONTINUOUS;
	PROC MEANS DATA = P1;
	RUN;

	*DEMO;
	PROC MEANS DATA = SASHELP.HEART;
	RUN;
   *DEMO WANT TO KNOW MISSING VALUES AS WELL;
	PROC MEANS DATA = SASHELP.HEART N NMISS MIN MEAN MEDIAN MAX STD;
	RUN;
   *using var for continuous;
	PROC MEANS DATA = SASHELP.HEART N NMISS MIN MEAN MEDIAN MAX STD;
	VAR WEIGHT HEIGHT AgeAtStart;
	RUN;

	*FOR CATEGORICAL;
	*putting missing as a category;
	PROC FREQ DATA = SASHELP.HEART;
	TABLE DeathCause/MISSING;
	RUN;

	*putting missing as a category with 3 different categories;
	PROC FREQ DATA = SASHELP.HEART;
	TABLE DeathCause STATUS SEX/MISSING;
	RUN;

*CONTINUOUS DATA :VISUAL METHODS;

PROC SGPLOT DATA = SASHELP.HEART;
	HISTOGRAM WEIGHT;
	DENSITY WEIGHT;
RUN;

TITLE "THIS IS HORIZONTAL BOXPLOT";
PROC SGPLOT DATA = SASHELP.HEART;
	HBOX WEIGHT;
	RUN;
	TITLE "THIS IS VERTICAL BOXPLOT";
PROC SGPLOT DATA = SASHELP.HEART;
	VBOX WEIGHT;
	RUN;

*CATEGORICAL DATA :VISUAL METHODS;
TITLE "THIS IS VERTICAL BARCHART";
TITLE2 "THIS IS TEST";
FOOTNOTE "CREATED BY ARKAR";
FOOTNOTE2 "TEST";
PROC SGPLOT DATA = SASHELP.HEART;
	VBAR STATUS;
RUN;

TITLE "THIS IS HORIZONTAL BARCHART";
PROC SGPLOT DATA = SASHELP.HEART;
	HBAR STATUS;
RUN;

*ODS - PDF, CSV, HTML, RTF;
ODS PDF FILE = "C:\Users\anathani\Desktop\DSP SAS Project class\MY_REPORT.PDF";
TITLE "THIS IS PIE CHART";
PROC GCHART DATA = SASHELP.HEART;
	PIE Smoking_Status;
RUN;
QUIT;

ODS PDF CLOSE;
ODS _ALL_ CLOSE;
ODS HTML BODY = "C:\Users\anathani\Desktop\MY_REPORT.HTML";
TITLE "THIS IS PIE CHART";
ODS GRAPHICS ON;
PROC GCHART DATA = SASHELP.HEART;
	PIE Smoking_Status;
RUN;
QUIT;
ODS HTML CLOSE;

ODS CSV FILE = "C:\Users\anathani\Desktop\DSP SAS Project class\MY_REPORT.CSV";
TITLE "THIS IS PIE CHART";
PROC GCHART DATA = SASHELP.HEART;
	PIE Smoking_Status;
RUN;
QUIT;
ODS CSV CLOSE;

ODS RTF FILE = "C:\Users\anathani\Desktop\DSP SAS Project class\MY_REPORT.RTF";
TITLE "THIS IS PIE CHART";
PROC GCHART DATA = SASHELP.HEART;
	PIE Smoking_Status;
RUN;
QUIT;

ODS RTF CLOSE;


*OUTPUT DELIVERY SYSTEM :ODS;