PROC IMPORT OUT= AN.RSA1 
            DATAFILE= "F:\DSP SAS Project Class\Retail Sales Analysis Pr
oject\transactionhistoryforcurrentcustomers.csv" 
            DBMS=CSV REPLACE;
     GETNAMES=YES;
     DATAROW=2; 
RUN;
