/* Given code for DB location */
libname mydata '/courses/dad220adba27fe300';
run;
proc print data = mydata.heart;
run;

data heartdata;
     set mydata.heart;
run;

/* What proportion of records is related to success */
proc summary data = heartdata;
var Disease_binary;
output out = totals sum = Disease_binary;
run;
/* 139 / 303 */

/* 0 predictor logistic regression on Disease_binary */
proc logistic data = heartdata descending;
     model Disease_binary = ;
run;

/* Question 2 */
/* Relationship between sex and propensity to have heart disease */
/* Create a crosstab between the two variables including a chi-squared test */


/* Q2. a), b), c) d) e) f?) g?)
 * Chi sq */
proc freq data = heartdata;
     tables Sex*Disease_binary / chisq;
run;

/* Q3.
   Fit a logistic regression of disease status on sex,
   using women as the reference category */
proc logistic data = heartdata descending;
     class Sex (ref = '0')/ param = ref;
     model Disease_binary = Sex;
run;

/* e) rerun the model with men as the reference category */
proc logistic data = heartdata descending;
     class Sex (ref = '1') / param = ref;
     model Disease_binary = Sex;
run;

/* Q4.
   FIt a logistic regression of disease status 
   on age, sex, cp(ref cat1, trest bps, chol, oldpeak and slope (ref cat1) */
proc logistic data = heartdata descending;
     class Cp (ref = '1') / param = ref;
     class Slope (ref = '1') / param = ref;
     model Disease_binary = Age
                            Sex
                            Cp
                            Trestbps
                            Chol
                            Oldpeak
                            Slope;
run;

/* Q4. c) Drop chol from model and rerun reg
   The dummy var for type 2 and type 3 chest pain are not significant
   however the dummy var for type 4.
   Should we keep the cp variable in the model? */
proc logistic data = heartdata descending;
     class Cp (ref = '1') / param = ref;
     class Slope (ref = '1') / param = ref;
     model Disease_binary = Age
                            Sex
                            Cp
                            Trestbps
                            Oldpeak
                            Slope;
run;

/* ROC Curve */
proc logistic data = heartdata descending plots(only) = roc;
     class Cp (ref = '1') / param = ref;
     class Slope (ref = '1') / param = ref;
     model Disease_binary = Age
                            Sex
                            Cp
                            Trestbps
                            Oldpeak
                            Slope;
run; 

/* Effects curve sex = 1 */
proc logistic data = heartdata descending plots(only) = effect;
     class Cp (ref = '1') / param = ref;
     class Slope (ref = '1') / param = ref;
     class Sex (ref = '1') / param = ref;
     model Disease_binary = Age
                            Sex
                            Cp
                            Trestbps
                            Oldpeak
                            Slope;
run; 

/* Effects curve sex = 0 */
proc logistic data = heartdata descending plots(only) = effect;
     class Cp (ref = '1') / param = ref;
     class Slope (ref = '1') / param = ref;
     class Sex (ref = '0') / param = ref;
     model Disease_binary = Age
                            Sex
                            Cp
                            Trestbps
                            Oldpeak
                            Slope;
run; 
/* Goodness of fit test */
proc logistic data = heartdata descending;
     class Cp (ref = '1') / param = ref;
     class Slope (ref = '1') / param = ref;
     model Disease_binary = Age
                            Sex
                            Cp
                            Trestbps
                            Oldpeak
                            Slope / lackfit;
     output out = Out p = pred_prob RESCHI = Pearson_res;
run;

/* Predicted probability */
proc logistic data = heartdata descending plots(only) = roc;
class cp(ref='1') slope(ref='1')/ param=ref;
model disease_binary = age sex cp trestbps oldpeak slope /lackfit;
output out=Out p=pred_prob;
run;

proc print data=Out;
run;
