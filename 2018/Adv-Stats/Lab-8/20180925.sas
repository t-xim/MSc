/* Setting up data */
libname mydata '/courses/dad220adba27fe300';
run;

data asthama;
     set mydata.asthma;
run;

proc print data = asthma;
run;

/* Fit a constant model and saving pearson residuals */
proc genmod data = mydata.asthma;
     model Num = / dist = Poisson link = Log;
     output out = output1 reschi = pears;
run;

/* */
proc sgplot data = output1;
     scatter x = Month y = pears;
run;

/* */
proc genmod data = mydata.asthma;
     class Season(ref = 'Winter') / param = ref;
     model Num = Season / dist = Poisson link = Log;
     output out = output1 reschi = pears;
run;

/* */
data asthma;
     set mydata.asthma;
     LogDays = log(days);
run;

/* */
proc genmod data = asthma;
     class Season(ref = 'Winter') / param = ref;
     model Num = Season / dist = Poisson link = Log offset = LogDays;
run;
