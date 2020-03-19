libname AN "F:\DSP SAS Project Class\Retail Sales Analysis Project";
libname AN "C:\Users\alina\Documents\DSP SAS Project Class\Retail Sales Analysis Project";
libname AN "C:\Users\anathani\Desktop\DSP SAS Project class\Retail Sales Analysis Project";
libname AN "F:\DSP SAS Project Class\Retail Sales Analysis Project";
libname AN "E:\DSP SAS Project Class\Retail Sales Analysis Project";
libname AN "C:\Users\alina\Documents\DSP SAS Project Class\Retail Sales Analysis Project";

/*STEP 1*/
*import data to SAS;


PROC IMPORT OUT= AN.RSA1 
     DATAFILE= "C:\Users\alina\Documents\DSP SAS Project Class\Retail Sales Analysis Project\transactionhistoryforcurrentcustomers.csv" 
     DBMS=CSV REPLACE;
     GETNAMES=YES;
     DATAROW=2; 

RUN;
*import the 2nd dataset;
PROC IMPORT OUT= AN.RSA2
            DATAFILE= "C:\Users\alina\Documents\DSP SAS Project Class\Retail Sales Analysis Project\ec90_data.csv" 
            DBMS=CSV REPLACE;
     GETNAMES=YES;
     DATAROW=2; 
	
RUN;

/*---------------------------------------------------------------------*/
*RSA 1 - TRANSACTIONAL DATA SET WITH VARIOUS DIFFERENT PRODUCTS;

/*STEP 2----------------------------------------------------------------*/
*DATA PREPARATION;
*DATA VALUE;
PROC PRINT DATA = AN.RSA1 (OBS = 20);
TITLE "RSA1";
RUN;


*DUPLICATES;
*COUNT COLS;
TITLE "Count of Distinct Customer IDs in RSA1";
	PROC SQL;
	SELECT COUNT(Customer_ID)AS TOTAL_COUNT, COUNT(DISTINCT Customer_ID) AS UNIQUE_COUNT
	FROM AN.RSA1
	;
	QUIT;


*REMOVE DUPLICATE OBSERVATIONS and check count again;
PROC SORT DATA = AN.RSA1 OUT = AN.RSA1_S dupout=AN.RSA1aDup NODUPRECS;
	BY _ALL_;
RUN;

*list the duplicate records - STEP NOT REQUIRED;
/*PROC SQL;*/
/*SELECT * FROM AN.RSA1aDup;*/
/*QUIT;*/
/*PROC PRINT; RUN;*/

*COUNT AGAIN;

TITLE 'Count of Customer IDs RSA1_S';
PROC SQL;
	SELECT COUNT(Customer_ID)AS TOTAL_COUNT, COUNT(DISTINCT Customer_ID) AS UNIQUE_COUNT
	FROM AN.RSA1_s
	;
	QUIT;




*UNDERSTAND YOUR DATA AND ITS PROPERTIES;
TITLE "Contents RSA1_s";
PROC CONTENTS DATA = AN.RSA1_S;
RUN;

TITLE "Univariate Analysis RSA1_S";
PROC UNIVARIATE DATA = AN.RSA1_S;

RUN;

 *checking records for quantity = 0;
title 'Missing Quantity Record count';
PROC SQL;
SELECT count(*) FROM AN.RSA1_S
WHERE Quantity = 0;
quit;
PROC SQL;
SELECT * FROM AN.RSA1_S
WHERE Quantity = 0;
quit;

/*LEAVING THE ABOVE QUANTITY RECORDS AS THEY ARE ONLY 6 AND WILL NOT AFFECT THE ANALYSIS*/

*checking records for price = .;
title 'Missing Price Record count';
PROC SQL;
SELECT count(*) FROM AN.RSA1_S
WHERE Price = .;
quit;
PROC SQL OUTOBS=10;
SELECT * FROM AN.RSA1_S
WHERE Price = .;
quit;


/*LEAVING THE ABOVE RECORDS AS IT WILL BE A SEPARATE CATEGORY FOR FREE OR PROMOTIONAL PRODUCTS*/

*checking records for missing category ;
title 'Missing Category Record count';
PROC SQL;
SELECT count(*) FROM AN.RSA1_S
WHERE Category = " ";
quit;


*count missing values for all categorical variables;
*create format for missing;
proc format ;
	value $ missfmt ' '="Missing" other="Not Missing";
	value nmissfmt .="Missing" other="Not Missing";
run;

*Proc freq to count missing/non missing;
ods table onewayfreqs=temp;
proc freq data=AN.RSA1_S;
	table _all_ / missing;
	format _numeric_ nmissfmt. _character_ $missfmt.;
run;

*Format output;
data want;
	length variable $32. variable_value $50.;
	set temp;
	Variable=scan(table, 2);
	Variable_Value=strip(trim(vvaluex(variable)));
	keep variable variable_value frequency percent cum:;
	label variable='Variable' variable_value='Variable Value';
run;
proc print data = want;
run;

data AN.RSA1_NoMiss;
 set AN.RSA1_S;
 
 if Category = ' ' then delete;
 if Item_Description = ' ' then delete;
run;

*COUNT MISSING AGAIN;
ods table onewayfreqs=temp;
proc freq data=AN.RSA1_NoMiss;
	table _all_ / missing;
	format _numeric_ nmissfmt. _character_ $missfmt.;
run;

*Format output;
data want2;
	length variable $32. variable_value $50.;
	set temp;
	Variable=scan(table, 2);
	Variable_Value=strip(trim(vvaluex(variable)));
	keep variable variable_value frequency percent cum:;
	label variable='Variable' variable_value='Variable Value';
run;
proc print data = want2;
run;


/*STEP 3----------------------------------------------------------------*/
*FEATURE GENERATION/ENGINEERING;

*JOIN LOCATION DATA FROM EC90 into a MASTER DATASET;


proc sql;
create table AN.rsa2_some as
select distinct city, customer_number, postal_code, prov
from AN.rsa2;
quit;


proc sql;
  create table master as
  select x.*, y.City, y.Prov, y.Postal_Code, x.Quantity * x.Price AS Sales
  from AN.RSA1_NoMiss x left join AN.rsa2_some y
  on x.customer_id=y.customer_number
  where x.Quantity NE 0;
;  
quit;

TITLE "Master Dataset Univariate Analysis";
PROC UNIVARIATE DATA = Master;

RUN;


/*STEP 4----------------------------------------------------------------*/
*UNIVARIATE ANALYSIS OR DESCRIPTIVE / EXPLORATORY DATA ANALYSIS;

*Distribution of Quantity;
proc sgplot data = Master;
	vbox Quantity ;
	title 'Distibution of Quantity by Customer_ID';
run;

proc sgplot data = Master;
	vbox Quantity ;
	title 'Distibution of Quantity <20 by Customer_ID';
	Where Quantity <20;

run;


*Distribution of Sales ;
proc sgplot data = Master;
	hbox Sales;
	title 'Distibution of Sales ';
	
run;

proc sgplot data = Master;
	hbox Sales;
	title 'Distibution of Sales ';
	Where sales <1000;
run;


*distribution of price;
proc sgplot data = Master;
	vbox Price ;
	title 'Distibution of Price';
run;



*checking frequency of mode of CUSTOMER ID, Sum of the Quantity;
TITLE 'Most Frequent Purchaser ID no 6990246';
PROC SQL;
create table MOST_FREQ_CUST_ID AS
SELECT COUNT(Customer_ID) AS Count_of_MostFreq_Cust_ID, SUM(Quantity) AS Sum_of_Quantity_MostFreq_Cust_ID, Sum(Price*Quantity) format=dollar13.2 AS Tot_Sales_MostFreq_Cust_ID
FROM Master
WHERE Customer_ID = 6990246
;
QUIT;
PROC PRINT; RUN;






/*STEP 5----------------------------------------------------------------*/

*BIVARIATE ANALYSIS;

*orders per customer by Province;

proc sql;
create table totalcount_cust_id as
select count(customer_ID) AS TOTAL_ORDERS_PER_CUSTOMER, Prov
FROM Master
group by Prov 
order by TOTAL_ORDERS_PER_CUSTOMER DESC
;

quit;

title 'Total Orders per Province';
proc sgplot data=totalcount_cust_id ;
  hbar Prov / response=TOTAL_ORDERS_PER_CUSTOMER dataskin=gloss datalabel
       categoryorder=respdesc nostatlabel;
  xaxis grid display=(nolabel);
  yaxis grid discreteorder=data display=(nolabel);
  run;
quit;
*orders per customer by city in Ontario;
proc sql OUTOBS = 10;
create table totalcount_ontariocity as
select count(customer_ID) AS TOTAL_ORDERS_PER_CUSTOMER, City
FROM Master
where Prov = 'ON' 
group by City 
order by TOTAL_ORDERS_PER_CUSTOMER DESC
;

quit;

title 'Top 10 Total Orders per City in Ontario';
proc sgplot data=totalcount_ontariocity  ;
  hbar City / response=TOTAL_ORDERS_PER_CUSTOMER dataskin=matt datalabel
       categoryorder=respdesc nostatlabel;
  xaxis grid display=(nolabel);
  yaxis grid discreteorder=data display=(nolabel);
  run;
quit;
*sales per province;
proc sql OUTOBS = 10;
create table totalsales_PROV as
select sum(Sales) format dollar13.2 AS TOTAL_SALES_PER_PROV, Prov
FROM Master
group by Prov 
order by TOTAL_SALES_PER_PROV DESC
;

quit;

title 'Top 10 Total Sales per Province';
proc sgplot data=totalsales_PROV ;
  hbar Prov / response=TOTAL_SALES_PER_PROV dataskin=gloss datalabel
       categoryorder=respdesc nostatlabel;
  xaxis grid display=(nolabel);
  yaxis grid discreteorder=data display=(nolabel);
  run;
quit;
*sales by city in Ontario;
proc sql OUTOBS=10;
create table totalsales_ontariocity as
select sum(Sales) format dollar13.2 AS TOTAL_SALES_PER_CITY, City
FROM Master
where Prov = 'ON' 
group by City 
order by TOTAL_SALES_PER_CITY DESC
;

quit;

title 'Top 10 Total Sales per City in Ontario';
proc sgplot data=totalsales_ontariocity  ;
  hbar City / response=TOTAL_SALES_PER_CITY dataskin=gloss datalabel
       categoryorder=respdesc nostatlabel;
  xaxis grid display=(nolabel);
  yaxis grid discreteorder=data display=(nolabel);
  run;
quit;

*sales by channel in Ontario;
proc sql OUTOBS=10;
create table totalsales_channel as
select sum(Sales) format dollar13.2 AS TOTAL_SALES_PER_CHANNEL, Source
FROM Master
group by Source 
order by TOTAL_SALES_PER_CHANNEL DESC
;

quit;

title 'Top 10 Total Sales per Source/Channel';
proc sgplot data=totalsales_channel  ;
  hbar Source / response=TOTAL_SALES_PER_CHANNEL dataskin=gloss datalabel
       categoryorder=respdesc nostatlabel;
  xaxis grid display=(nolabel);
  yaxis grid discreteorder=data display=(nolabel);
  run;
quit;

TITLE "Percentage of Sales and Quantity per Source/Channel";
PROC GCHART DATA = Master;
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



*order date;
proc sql ;
create table Master2 as 
select *, month(datepart(Order_Date)) as OrderMonth, year(datepart(Order_Date)) as OrderYear
from Master
;
quit;




Proc Format;
	Value YearT 2007 = "2007"
                2008 = "2008"
;
Run;

proc sql;
create table totalsales_year as

select sum(Sales) format dollar13.2 AS TOTAL_SALES_PER_YEAR, OrderYear 
FROM Master2
group by OrderYear 
order by TOTAL_SALES_PER_YEAR DESC
;

quit;



/**pie chart;*/
TITLE "Total sales per year";
PROC GCHART DATA = totalsales_year;
format OrderYear YearT.;
pie3d OrderYear / sumvar=TOTAL_SALES_PER_YEAR
;
run;
quit;



title 'Total Sales Per Year';
proc sgplot data=totalsales_year  ;
  vbar OrderYear / response=TOTAL_SALES_PER_YEAR dataskin=gloss datalabel
       categoryorder=respdesc nostatlabel;
  xaxis grid display=(nolabel);
  yaxis grid discreteorder=data display=(nolabel);
  run;
quit;


*sales by Month in 2007;
proc format;
	value monthlabel 1 = "Jan"
					 2 = "Feb"
					 3 = "Mar"
					 4 = "Apr"
					 5 = "May"
					 6 = "Jun"
					 7 = "Jul"
					 8 = "Aug"
					 9 = "Sep"
					10 = "Oct"
					11 = "Nov"
					12 = "Dec"
;
run;



proc sql;
create table totalsales_month2007 as
select sum(Sales) format dollar13.2 AS TOTAL_SALES_PER_MONTH, OrderMonth format monthlabel. as OrderMonth
FROM Master2
where OrderYear = 2007 
group by OrderMonth 
order by TOTAL_SALES_PER_MONTH DESC
;

quit;




title 'Total Sales per month in 2007';
proc sgplot data=totalsales_month2007 ;
  hbar OrderMonth / response=TOTAL_SALES_PER_MONTH dataskin=gloss datalabel
       categoryorder=respdesc nostatlabel;
  xaxis grid display=(nolabel);
  yaxis grid discreteorder=data display=(nolabel);
  run;
quit;

*sales by Month in 2008;


proc sql;
create table totalsales_month2008 as
select sum(Sales) format dollar13.2 AS TOTAL_SALES_PER_MONTH, OrderMonth format monthlabel. as OrderMonth 
FROM Master2
where OrderYear = 2008 
group by OrderMonth 
order by TOTAL_SALES_PER_MONTH DESC
;

quit;

title 'Total Sales per Month in 2008';
proc sgplot data=totalsales_month2008 ;
  hbar OrderMonth / response=TOTAL_SALES_PER_MONTH dataskin=gloss datalabel
       categoryorder=respdesc nostatlabel;
  xaxis grid display=(nolabel);
  yaxis grid discreteorder=data display=(nolabel);
  run;


*----------------------------;
*total sales per Source in 2007;
proc sql;
create table sales_month2007 as
select Source, sum(Sales) as TOTAL_SALES_PER_SOURCE format dollar13.2, OrderMonth format monthlabel. as OrderMonth
FROM Master2
where OrderYear = 2007 
group by OrderMonth, Source
;
quit;


title 'Total Sales per month by Source in 2007';
proc sgplot data=sales_month2007 ;
  vbar OrderMonth / response=TOTAL_SALES_PER_SOURCE group=Source seglabel groupdisplay=stack
         dataskin=pressed stat=sum datalabel
       categoryorder=respdesc nostatlabel
       baselineattrs=(thickness=0)
          outlineattrs=(color=cx3f3f3f);;
  xaxis grid display=(nolabel);
  yaxis grid discreteorder=data display=(nolabel);
  run;
quit;
*2008;
proc sql;
create table sales_month2008 as
select Source, sum(Sales) as TOTAL_SALES_PER_SOURCE format dollar13.2, OrderMonth format monthlabel. as OrderMonth
FROM Master2
where OrderYear = 2008 
group by OrderMonth, Source
;
quit;

title 'Total Sales per month by Source in 2008';
proc sgplot data=sales_month2008 ;
  hbar OrderMonth / response=TOTAL_SALES_PER_SOURCE group=Source seglabel groupdisplay=stack
         dataskin=pressed stat=sum datalabel
       categoryorder=respdesc nostatlabel
       baselineattrs=(thickness=0)
          outlineattrs=(color=cx3f3f3f);;
  xaxis grid display=(nolabel);
  yaxis grid discreteorder=data display=(nolabel);
  run;
quit;

/*change variables to bin them*/

*change quantity into categories;
proc format ;
VALUE Quantities
	   0 = 'FREE PROMO'
  	 1-5 = 'SMALL     '
    6-10 = 'MEDIUM    '
10- high = 'HIGH      '
;
RUN;

PROC FREQ DATA = Master order=data;

title 'Frequency Distibution of Quantity ';
	format Quantity Quantities.;
	tables Quantity;
run;
/**/
*change sales into categories;
proc format ;
VALUE SalesDist
	 1-150 = 'LOW   '
   151-300 = 'MEDIUM'
 300- high = 'HIGH  '
;
RUN;

PROC FREQ DATA = Master order=data;
title 'Frequency Distibution of Sales ';
	format Sales SalesDist.;
	tables Sales;
run;

*TOTAL SALES PER CATEGORY OR PRODUCTS AND SALES PER CATEGORY;
proc print data = Master; 
TITLE 'Total Sales & Total Quantity by Category'; run;
TITLE "Total Sales & Total Quantity per Category";
PROC GCHART DATA = AN.RSA1b;
format sales dollar20.;

pie3d Category / sumvar=Sales
explode="F";
run;

pie3d Category / sumvar=Quantity
explode="F";
run;
quit;


PROC FREQ DATA = Master2; 
TITLE 'Order Month by Sourcevs Sales Chi Square Analysis';
	TABLE OrderMonth* Sales/CHISQ NOROW NOCOL ; *CAN KEEP PERCENT, DO NOT INCLUDE NOPERCENT OR USE NOFREQ FOR ONLY PERCENT;
	
	RUN;

*chi square analysis;
proc sql;
create table master3 as
select * from master2
where Source = 'WEB';
run;

PROC FREQ DATA = Master2; 
TITLE 'Source vs Sales Chi Square Analysis';
	TABLE Source* Sales/CHISQ NOROW NOCOL ; *CAN KEEP PERCENT, DO NOT INCLUDE NOPERCENT OR USE NOFREQ FOR ONLY PERCENT;
RUN;



*---------------------;
*RSA 2 - EC90 DATA SET WITH 1 main product;

*STACKED BAR CHART;
PROC SGPLOT DATA = Master2;
TITLE 'OrderMonth vs Sales';
	VBAR OrderMonth/GROUP=SOURCE;
RUN;



PROC CONTENTS DATA = AN.RSA2;
run;
