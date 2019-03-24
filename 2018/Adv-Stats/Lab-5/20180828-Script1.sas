/* Given code */
/* Note: gage = gestational age in weeks
         bwght is dummy variable indicating north birth weight */
libname mydata "/courses/d02bcad5ba27fe300";
run;
proc print data = mydata.bwght;
run;

/* Given code
   Check using proc logistic to see if 
   gestational age has impact on probability of normal birth */
proc logistic data = mydata.bwght descending;
     model bwght = gage;
run;

/* Given code */
proc logistic data = mydata.bwght descending;
     model bwght = gage / lackfit;
     output out = Out p = pred_prob RESCHI = Pearson_res;
run;

/* Given code */
proc univariate data = Out;
     var Pearson_res;
run;

/* Given code for ROC */
proc logistic data = mydata.bwght descending plots(only) = roc;
     model bwght = gage;
run;

/* Given code for health dataset */
proc freq data = mydata.health;
     tables gender car age marstat;
run;

/* Given code for
   Adding dummy variable and fixing car var */
data health2;
     set mydata.health;
     if gender = 2 then female = 1;
        else if gender = 1 then female = 0;
     if car = 1 then acc_car = 1;
        else if car = 2 then acc_car = 0;
        else acc_car = '.';
run;

/* Given code for for checking data added is correct*/
proc freq data = health2;
     tables gender gender*female car car*acc_car;
run;

/* Given code for checking relationship, using crosstab */
proc freq data = health2;
     tables female*acc_Car / chisq;
run;

/* logistic model for car and female variables */
proc logistic data = health2 descending;
     model acc_car = female;
run;
