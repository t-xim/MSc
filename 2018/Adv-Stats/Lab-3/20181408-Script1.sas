/* Given code to access Library and data */
libname mydata "/courses/dad220adba27fe300";
run;

/* Given code for creating table */
data auto;
    set mydata.auto (rename = (horsepower = horsepower_char));
    horsepower = input(horsepower_char, best.);
run;

/* Given code for printing */
proc print data = auto;
run;

/* Q1 - create dummy variables for 8 and 6 cylinder */
data auto;
    set auto;
    if cylinders = 8 then Cylinder8 = 1;
    else Cylinder8 = 0;
run;

data auto;
    set auto;
    if cylinders = 6 then Cylinder6 = 1;
    else Cylinder6 = 0;
run;

proc print data = auto;
run;

/* Q2 - why use categorical? Answered outside of SAS */

/* Q3 - Create a multi regression for actual fuel mileage on rest of predictors
        Except for car_name, treat cylinders as categorical.
        Produce diagnostic plots and regression summary and comment on model */

/* Not using cylinder and horsepower_char variables */
proc reg data = auto;
    model mpg = displacement 
                weight 
                acceleration
                model_year 
                horsepower 
                Cylinder8 
                Cylinder6;
run;

/* Q4 - Create a scatterplot of mpg against model_year
        Include the regression line with a quadratic term.
        Describe relationship between model_year and mpg. */
proc sgplot data = auto;
    scatter x = model_year y = mpg;
    reg x = model_year y = mpg / degree = 2;
run;

/* Choosing between degree 2 and 3, the fit looks relatively similar for 2 and 3
   This may not be the case if we had a larger range of year data */
  
/* Adding variables model_year squared and cubic
   cubic added just to test later */
data auto;
    set auto;
    Myear_squared = model_year ** 2;
    Myear_cubic   = model_year ** 3;
run;

/* Q5 - Fit a multiple regression with the variables of six cylinders,
        eight cylinders, weight, model year and model year squared.
        Produce diagonostic plots and compare. */
proc reg data = auto;
    model mpg = Cylinder6
                Cylinder8
                weight
                model_year
                Myear_squared;
run;

/* Q6 - Generate a scatterplot of mpg against weight,
        include colour coding and regression lines for each cylinder types.
        Does weight require non-parallel slopes for six and eight cylinder cars? */
proc sgplot data = auto;
    scatter x = mpg y = weight;
    reg x = mpg y = weight / group = cylinders;
run;

/* Q7 - Add a weight and cylinders interaction term to the previous model.
        Comment on the suitability of the interaction term in the model. */
data auto;
    set auto;
    weight_cylinders = weight * cylinders;
run;

/* Q8 - Generate the diagnostic plots for this model,
        Comment on the model assumptions and potential outliers */
proc reg data = auto;
    model mpg = Cylinder6
                Cylinder8
                weight
                model_year
                Myear_squared
                weight_cylinders;
run;

/* Q9 - Write down the regression equation for this model.
        Is the overall regression significant?
        What is the coefficient of determination? */
/* Not done in SAS */

/* Q10 - Predictions
   A car made in 1970, 6 cylinder, weight of 2700 pounds
   Predict mpg, Find a 95% confidence interval for this value */
data auto_predict;
    input mpg 
          Cylinder6
          Cylinder8
          weight 
          model_year
          Myear_squared 
          weight_cylinders;
    cards;
    0 1 0 2700 70 4900 16200
run;


proc reg data = auto
         outest = RegOut
         noprint;
    model mpg = Cylinder6
                Cylinder8
                weight 
                model_year
                Myear_squared 
                weight_cylinders;
run;

proc score data = auto_predict
           score = RegOut
           out = prediction
           type =  parms nostd predict;
               var mpg
                   Cylinder6
                   Cylinder8
                   weight
                   model_year
                   Myear_squared
                   weight_cylinders;
run;

proc print data = prediction;
run;
