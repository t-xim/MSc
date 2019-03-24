libname mydata '/courses/dad220adba27fe300';
run;

data sti_data;
     set mydata.sti;
run;

proc print data = sti_data;
run;


proc genmod data = sti_data;
     model count = 
     / dist = Poisson link = Log;
     output out = output1 reschi = pears;
run;

data sti_data1;
     set sti_data;
     prop_sti = count / population;
run;

/* Changing sex to 1 or 0 */
data sti_data1;
     set sti_data1;
     if sex = "Male" then male = 1;
     else male = 0;
run;


proc genmod data = sti_data1;
     class disease county;
     model count = disease
                   county
                   male
                   time
                   population
     / dist = Poisson link = Log;
     output out = output1 reschi = pears;
run;










/* Torris working */
data log_sti;
	set sti_data;
	LogPopulation = Log(Population);
run;

proc genmod data = log_sti;
	class disease sex;
	model count = disease * sex * time / dist = Poisson Link = Log offset = LogPopulation;
	output out = output1 reschi = pears;
run;
