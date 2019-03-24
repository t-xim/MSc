/* Based on weeks 9, 10, 11 */

libname mydata '/courses/dad220adba27fe300';
run;
proc print data = mydata.households;
run;
proc print data = mydata.sti;
run;

/* households contain data on poverty levels in COsta Rican households */
/* The data is used to determine which households are most in need of aid */

/* Localising data */
data household_data;
     set mydata.households;
run;
data sti_data;
     set mydata.sti;
run;

proc print data = household_data;
run;

/* Linear regression */
proc reg data = household_data;
     model poverty_level = num_rooms
                           hhsize
                           prop_men
                           num_children
                           has_toilet
                           has_electricity
                           persons_per_room
                           rural
                           head_male
                           head_edu;
run;

/* Ordinal logistic regression */


/* Multinomial logistic regression */
proc logistic data = household_data;
     model poverty_level = num_rooms
                           hhsize
                           prop_men
                           num_children
                           has_toilet
                           has_electricity
                           persons_per_room
                           rural
                           head_male
                           head_edu;
run;

/* Multinomial logistic regression */
/* taking out the following variables */
/* toilet, electricity, maybe prop_men*/
proc logistic data = household_data;
     model poverty_level = num_rooms
                           hhsize
                           prop_men
                           num_children
                           persons_per_room
                           rural
                           head_male
                           head_edu
     / link = glogit
       aggregate = (num_rooms hhsize prop_men num_children persons_per_room rural head_male head_edu)
       scale = none;
output out = output predprobs = I;                           
run;

/* ASSUMING prop_men is full proportion and not just for adults */
data household_data1;
     set mydata.households;
     bedrooms       = round(hhsize / persons_per_room,1);
     nonbedrooms    = num_rooms - bedrooms;
     adults         = hhsize - num_children;
     males          = round((hhsize / (prop_men + 1)) * prop_men);  
     prop_men_adult = males / adults; /* This is wrong */
run;

/* Model with new variables */
proc logistic data = household_data1;
     model poverty_level = bedrooms
                           nonbedrooms
                           hhsize
                           num_children
                           persons_per_room
                           rural
                           head_male
                           head_edu
     / link = glogit
       aggregate = (num_rooms hhsize prop_men_adult num_children 
                    persons_per_room rural head_male head_edu)
       scale = none;
output out = output predprobs = I;                           
run;

/* Original without prop_men */
proc logistic data = household_data;
     model poverty_level = num_rooms
                           hhsize
                           num_children
                           persons_per_room
                           rural
                           head_male
                           head_edu
     / link = glogit
       aggregate = (num_rooms hhsize num_children persons_per_room rural head_male head_edu)
       scale = none;
output out = output predprobs = I;                           
run;

/* Torris model */
proc logistic data = household_data;
	model poverty_level = num_rooms hhsize prop_men persons_per_room rural head_male head_edu
	/ link = glogit aggregate = (num_rooms hhsize prop_men persons_per_room rural head_male head_edu) scale = none;
	output out = output predprobs = I;
run;
