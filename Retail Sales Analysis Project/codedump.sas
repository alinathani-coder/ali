/*delete below code*/
/*proc sql noprint;*/
/*  create table master as*/
/*  select x.Customer_ID, x.Item_Code, x.Source, x.Order_Date, x.Item_Description, x.Category, x.price,x.quantity, x.price*x.quantity AS Sales, y.city, y.prov, y.postal_code from*/
/*  AN.rsa1 x left join AN.rsa2 y*/
/*on x.Customer_ID = y.Customer_Number  ;*/
/*quit;*/

/*data AN.RSA2Patient(keep = Customer_ID Item_Code Source Order_Date Item_Description Category Price Quantity City Prov Postal_Code);*/
/*set AN.RSA2;*/
/*Item_Code = put(Item_Num, 6.);*/
/*rename Customer_number = Customer_ID Category_code = Category;*/
/*run;*/
/**/
/*data keymerge( keep = Customer_ID Item_Code Source Order_Date Item_Description Category price Quantity City Prov Postal_Code);*/
/* set AN.RSA1; *Master data;*/
/* set AN.RSA2Patient(keep=Customer_ID City Prov Postal_Code);*/
/* if (not _iorc_ = %sysrc(_sok)) then do;*/
/* * clear variables from the indexed data set;*/
/* 	City = ' ';*/
/* 	Prov = ' ';*/
/* 	Postal_code = ' ';*/
/*	_error_ = 0;*/
/* end;*/
/*run;*/


/*ods listing style=htmlblue;*/
/*ods graphics / reset width=5in height=3in imagename='Lollipop_Vert_Group_2';*/
/*title 'Total Sales per Month in 2008';*/
/*proc sgplot data=totalsales_month2008   noborder;*/
/*  styleattrs datacolors=(cxefafaf cxafafef) datacontrastcolors=(red blue);*/
/*  needle x=OrderMonth y=TOTAL_SALES_PER_MONTH / clusterwidth=0.34 lineattrs=(thickness=2) */
/*         baselineattrs=(thickness=0);*/
/*  scatter x=OrderMonth  y=TOTAL_SALES_PER_MONTH  / */
/*          markerattrs=(symbol=circlefilled size=32) filledoutlinedmarkers*/
/*          datalabel datalabelpos=center name='a' dataskin=sheen;*/
/*  xaxis display=(nolabel noticks);*/
/*  yaxis offsetmin=0 display=(nolabel noticks noline) grid;*/
/*  keylegend 'a' / type=markercolor;*/
/*run;*/

/**STACKED BAR CHART;*/
/*PROC SGPLOT DATA = data=sales_month2008;*/
/*TITLE 'Month vs Source ';*/
/*	VBAR OrderMonth/GROUP=Source;*/
/*RUN;*/



/**CHECK FOR MISSING VALUES;*/
/*PROC MEANS DATA = AN.RSA1 N NMISS;*/
/*RUN;*/
/**/
/*DATA AN.RSA1a;*/
/*	set AN.RSA1;*/
/*	if cmiss(of _all_) then delete;*/
/*run;*/
/**/
/**CHECK FOR MISSING VALUES AGAIN;*/
/*PROC MEANS DATA = AN.RSA1a N NMISS;*/
/*TITLE 'RSA1a';*/
/*RUN;*/

TITLE 'RSA2b';
PROC CONTENTS data = AN.RSA2b; run;


*FEB 17 11:27PM-----------------------------------------------------;


*FEATURE GENERATION FOR ;
*create sales columns in RSA1 ;
PROC SQL ;
	CREATE TABLE AN.RSA1b AS
	SELECT *, PRICE*QUANTITY AS SALES
	FROM AN.RSA1a_s
	;
	QUIT;


TITLE 'RSA1b';
PROC CONTENTS data = AN.RSA1b; run;


*SELECT VARIABLES IDENTIFIED IN YOUR STUDY FRAMEWORK;

*Total Sales;

TITLE ' Total Sales for RSA1b';
PROC SQL;
	SELECT sum(Sales)as TOTAL_Sales format=comma20.2
	FROM AN.RSA1b
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



* RSA 2 - EC90 DATA SET WITH PURCHASES OF AN ELECTRONIC ITEM, ACER ASPIRE 16" MULTIMEDIA NOTEBOOK COMPUTER;
*UNDERSTAND YOUR DATA AND ITS PROPERTIES;
TITLE "RSA2";
PROC CONTENTS DATA = AN.RSA2;
RUN;

TITLE "RSA2";
PROC UNIVARIATE DATA = AN.RSA2;

RUN;

