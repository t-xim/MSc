libname mydata '/courses/dad220adba27fe300';
run;

proc logistic data = mydata.ilea;
     model vrband = esw / link = glogit aggregate = (esw girl) scale = none;
     output out = output predprob = I;
run;

proc logistic data = mydata.ilea;
     model vrband = esw
                    girl
                    / link = glogit aggregate = (esw girl) scale = none;
     output out = output predprob = I;
run;

proc logistic data = mydata.ilea;
     class esw (ref = '0') girl(ref = '0')/param = ref;
     model vrband = esw girl / link = glogit;
     effectplot interaction(plotby = esw)/noobs;
     effectplot interaction(plotby = girl)/noobs;
run;
