libname AN "F:\DSP SAS Project Class\Retail Sales Analysis Project";
libname AN "C:\Users\alina\Documents\DSP SAS Project Class\Retail Sales Analysis Project";
libname AN "C:\Users\anathani\Desktop\DSP SAS Project class\Retail Sales Analysis Project";
libname AN "F:\DSP SAS Project Class\Retail Sales Analysis Project";
libname AN "E:\DSP SAS Project Class\Retail Sales Analysis Project";

*import data to SAS;

PROC IMPORT OUT= AN.RSA1 
            DATAFILE= "C:\Users\alina\Documents\DSP SAS Project Class\Retail Sales Analysis Project\transactionhistoryforcurrentcustomers.csv" 
            DBMS=CSV REPLACE;
     GETNAMES=YES;
     DATAROW=2; 
RUN;

PROC IMPORT OUT= AN.RSA2
            DATAFILE= "C:\Users\alina\Documents\DSP SAS Project Class\Retail Sales Analysis Project\ec90_data.csv" 
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

TITLE "RSA1a";
PROC UNIVARIATE DATA = AN.RSA1;

RUN;

TITLE "RSA2a";
PROC UNIVARIATE DATA = AN.RSA2;
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

*Total Sales;

TITLE ' Total Sales for RSA1b';
PROC SQL;
	SELECT sum(Sales)as TOTAL_Sales format=comma20.2
	FROM AN.RSA1b
		;
	QUIT;

	TITLE ' Total Sales for RSA2b';
PROC SQL;
	SELECT sum(Sales)as TOTAL_Sales format=comma20.2
	FROM AN.RSA2b
		;
	QUIT;


*Sales by Item Code and by Category;

/*each group*/

/* 'Sales by Category';*/

PROC SQL;
CREATE TABLE AN.RSA1Category AS
SELECT Category, COUNT(Customer_ID) format=comma20.2 AS Total_Orders, sum(Sales) format=comma20.2 AS Total_Sales, sum(Quantity) format=comma20.2 AS Total_Quantity
FROM AN.RSA1b
GROUP BY Category
ORDER BY Category;
QUIT;
proc print data = AN.RSA1Category; 
TITLE 'Total Order, Total Sales & Total Quantity by Category'; run;
TITLE "Number of Orders, Total Sales & Total Quantity per Category";
PROC GCHART DATA = AN.RSA1b;
format sales dollar20.;
	PIE Category 	
;
RUN;

pie3d Category / sumvar=Sales
explode="F";
run;

pie3d Category / sumvar=Quantity
explode="F";
run;
quit;

/*title 'in Category C, which products have most orders';*/

PROC SQL;
CREATE TABLE AN.RSA1MostOrderItem AS
SELECT *, COUNT(Item_Code) AS Total_Items, sum(Sales) format=comma20.2 AS Total_Sales, sum(Quantity) format=comma20.2 AS Total_Quantity
FROM AN.RSA1b
Where Category = 'C' 
GROUP BY Item_Code
ORDER BY Total_Items DESC
;
QUIT;



proc sgplot data = AN.RSA1MostOrderItem;
	vbox Total_Items;
		
	title 'Distibution of Quantity by Item_Code';
run;


/*Distribution of orders & sales across Source*/
title "Orders Frequency by Source";
proc freq data =AN.RSA1b;
table Source;
run;

TITLE "Percentage of Sales and Quantity per Source";
PROC GCHART DATA = AN.RSA1b;
format sales dollar20.;
	PIE Source 	
;
RUN;

pie3d Source / sumvar=Sales
explode="WEB";
run;

pie3d Source / sumvar=Quantity
explode="REGULAR";
run;
quit;

*BIVARIATE ANALYSIS
*chi square analysis;

PROC FREQ DATA = AN.RSA1b; 
TITLE 'Source vs Category Chi Square Analysis';
	TABLE Source* Category/CHISQ NOROW NOCOL ; *CAN KEEP PERCENT, DO NOT INCLUDE NOPERCENT OR USE NOFREQ FOR ONLY PERCENT;
RUN;
*STACKED BAR CHART;
PROC SGPLOT DATA = AN.RSA1b;
TITLE 'Source vs Category ';
	VBAR CATEGORY/GROUP=SOURCE;
RUN;
