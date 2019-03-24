/* Setting up path to library */
libname mydata '/courses/dad220adba27fe300';
run;
proc print data = mydata.health;
run;

/* Code from previous weeks for dummy var, female and acc_car */
data health;
     set mydata.health;
     if gender = 2 then female = 1;
        else if gender = 1 then female = 0;
     if car = 1 then acc_car = 1;
        else if car = 2 then acc_car = 0;
        else acc_car = '.';
run;

/* Use proc logistic statement to model probability of having access to a car 
   female as predictor variable */
proc logistic data = health descending;
     model acc_car = female;
run;

/* Use proc logistic statement to model probability of having access to a car 
   female and age and predictor variables */
proc logistic data = health descending;
     model acc_car = female age;
run;

/* Add martial status as a categorical variable. We first need to recode marstat
   so SAS knows which observations are missing */
data health2;
     set health;
     if marstat = 9 then marstat_new = .;
     else marstat_new = marstat;
run;

/* logistic regression for acc_car against
   female age and marital stat with missing data known to SAS */
proc logistic data = health2 descending;
     class marstat_new / param = reference;
     model acc_car = female age marstat_new;
run;

/* Combining categories */
data health3;
     set health2;
     if marstat_new = 6 then marstat_new2 = -1;
     else if marstat_new = 5 then marstat_new2 = -1;
     else if marstat_new = 4 then marstat_new2 = -1;
     else if marstat_new = 3 then marstat_new2 = -1;
        else marstat_new2 = marstat_new;
run;

/* logistic regression for acc_car against
   female age and marital stat with multiple marital stats combined */
proc logistic data = health3 descending;
     class marstat_new2(ref = '-1') / param = reference;
     model acc_car = female age marstat_new2;
run;

/* Interaction variable for age and female */
data health4;
     set health3;
     age_female = age * female;
run;

/* Refit model from Q6 using interaction */
proc logistic data = health4 descending;
     class marstat_new2(ref = '-1') / param = reference;
     model acc_car = female age marstat_new2 age_female;
run;

/* generate an efect plot for age */
proc logistic data = health4 descendig plots(only) = effect;
     class marstat_new2(ref = '-1') female(ref = '0') / param = reference;
     model acc_car = female age marstat_new2;
run;

/* female not included as class this time */
proc logistic data = health4 descendig plots(only) = effect;
     class marstat_new2(ref = '-1') / param = reference;
     model acc_car = female age marstat_new2;
run;

/* order changed for model */
proc logistic data = health4 descendig plots(only) = effect;
     class marstat_new2(ref = '-1') / param = reference;
     model acc_car = age female marstat_new2;
run;
