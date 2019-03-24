/* Given code */
libname mydata "/courses/d02bcad5ba27fe300";
run;

/* Given code */
proc print data = mydata.blood;
run;

/* Given code */
proc sgplot data = mydata.blood;
        /*--Scatter plot settings--*/
        scatter x = age y = sbp;
        reg x = age y = sbp;
        /*--X Axis--*/
        xaxis grid label = "Age";
        /*--Y Axis--*/
        yaxis grid label = "Systolic Blood Pressure";
run;

/* Coding challenge 1. Swap x and y axis in the scatter plot */
proc sgplot data = mydata.blood;
        scatter x = sbp y = age;
        reg     x = sbp y = age;
        xaxis grid label = "Systolic Blood Pressure";
        yaxis grid label = "Age";
run;
        
/* Coding challenge 2. Swap regression line and axis labels..?
   I think this was already done above*/
  
/* Coding challenge 3. Produce a plot of Budget vs Audience
   for data set movies in ocurse library */

proc print data = mydata.Movies;
run;
  
proc sgplot data = mydata.Movies;
        scatter x = Budget y = AudienceScore;
        reg     x = Budget y = AudienceScore;
        xaxis grid label = "Budget";
        yaxis grid label = "Audience Score";
run;

/* Given code - back on blood data */
proc reg data = mydata.blood;
        model sbp = age;
run;

/* Notes:
Variance is constant
qq plot - normally distributed - not necessary
look for residuals and leverage shows outlier 
This is when you use cook's distance */

/* Coding challenge 4. Run a regression of Audience Score on Budget
   with the data set movies in course library */
proc reg data = mydata.Movies;
        model AudienceScore = Budget;
run;

/* Given code - back on blood data */
proc reg data = mydata.blood 
plots = (DFFITS RStudentBYPredicted cooksd);
        model sbp = age / r clb cli clm;
run;
