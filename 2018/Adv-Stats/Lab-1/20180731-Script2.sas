/* Given code */
libname mydata "/courses/d02bcad5ba27fe300";
run;

/* Given code */
proc print data = mydata.blood;
run;

/* Removing data */
data blood_sub;
        set mydata.blood;
        if sbp = 220 then delete;
run;

/* Model and fit */
proc sgplot data = blood_sub;
        scatter x = age y = sbp;
        reg x = age y = sbp;
        xaxis grid label = "Age";
        yaxis grid label = "Systolic Blood Pressure";
run;

proc reg data = blood_sub;
        model sbp = age;
run;


/* Given code - predict for two people 
   Jane = age 60, Bob = Age 30        */
proc reg data = blood_sub outest = RegOut noprint;
        model sbp = age;
run;

data blood_new;
        input sbp age;
        cards;
        0 30
        0 60
        ;
run;
        
proc score data = blood_new  score = RegOut out = NewPred 
type = parms nostd predict;
        var sbp age;
run;

proc print data = NewPred;
run;

/* Now ages 20, 25, 42, 59 */
data blood_new2;
        input sbp age;
        cards;
        0 20
        0 25
        0 42
        0 59
        ;
run;

proc score data = blood_new2 score = RegOut out = NewPred
type = parms nostd predict;
        var sbp age;
run;
