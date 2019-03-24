libname mydata "/courses/d02bcad5ba27fe300";
run;

/* Importing salary data */
proc print data = mydata.salary;
run;

/* Scatter plot of salary and experience */
proc sgplot data = mydata.salary;
        scatter x = Experience  y = Salary;
        reg x = Experience y = Salary;
        /*--X Axis--*/
        xaxis grid label = "Experience";
        /*--Y Axis--*/
        yaxis grid label = "Salary";
run;

/* Given code */
/* Scatter plot that differentiates between gender */
proc sgplot data=mydata.salary;
reg x = Experience y = Salary / group = Male;
run;

/* Given code */
/* Creating a new dataset with an interaction variable */
data salaryInt;
    set mydata.salary;
    Experience_Male = Experience*Male;
run;

/* Viewing the data */
proc print data = salaryInt;
run;


/* Given code */
/* Running multiple regression of salary on experience, gender and interaction between */
proc reg data = salaryInt;
        model Salary = Experience Male Experience_Male;
run;

/* Here */


/* Given code */
/* To address the issue of increasing variance in residuals
   Take log transformation of salary */
data salaryIntLog;
    set salaryInt;
    Ln_Salary = log(salary);
run;

/* Run regression on transformed variable */
proc reg data = salaryIntLog;
        model Ln_Salary = Experience Male Experience_Male;
run;

/* Adding new variable that is Experience squared */
data salaryIntLogSq;
    set SalaryIntLog;
    Experience_Sq = Experience**2;
run;

/* Run regression using quadratic term */
proc reg data = salaryIntLogSq;
        model Ln_Salary = Experience Experience_Sq Male Experience_Male;
run;


