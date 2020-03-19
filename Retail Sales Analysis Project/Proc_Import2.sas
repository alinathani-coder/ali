PROC IMPORT OUT= AN.RSA2 
            DATAFILE= "C:\Users\anathani\Desktop\DSP SAS Project class\R
etail Sales Analysis Project\ec90_data.csv" 
            DBMS=CSV REPLACE;
     GETNAMES=YES;
     DATAROW=2; 
RUN;
