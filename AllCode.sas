/******************************************************************/
/* Import data */
filename expd url "http://www.stat.unm.edu/~erike/exams/UNM_Stat_Exam_Qual_takehome_201301_pr1-DATA_experiment.csv";

data pr1;
   infile expd dlm=',' firstobs=2;
   input VENDOR $ TREAT : $char11. FORMMETHOD $ ANTIBIOTIC $ ABSORBTIME;
   VENDOR=compress(VENDOR, '"');
   TREAT=compress(TREAT, '"');
   FORMMETHOD=compress(FORMMETHOD, '"'); 
   ANTIBIOTIC=compress(ANTIBIOTIC, '"');
run;
/******************************************************************/

/******************************************************************/
/* Create Table A5 */
ods output "Type I Model ANOVA"=anova1f;
ods output "Type III Tests with Error = Type III VENDOR*TREAT SS"=v_tr_f;
ods output "Type III Tests with Error = Type III VENDOR*TREAT*FORMMET SS"=v_tr_form_f;
proc glm data=pr1;
   class VENDOR TREAT FORMMETHOD ANTIBIOTIC;
   model ABSORBTIME=VENDOR      TREAT             VENDOR*TREAT
                    FORMMETHOD  TREAT*FORMMETHOD  VENDOR*TREAT*FORMMETHOD
                    ANTIBIOTIC  TREAT*ANTIBIOTIC  FORMMETHOD*ANTIBIOTIC
                    TREAT*FORMMETHOD*ANTIBIOTIC
                    TREAT*FORMMETHOD*ANTIBIOTIC;
   output out=outs
          residual=residuals
          predicted=fitted
          rstudent=studentized_resid
          student=student;
   test h=TREAT            e=VENDOR*TREAT; /* Uses appropriate error term, so F-test is now correct. */
   test h=FORMMETHOD       e=VENDOR*TREAT*FORMMETHOD; /* Uses appropriate error term, so F-test is now correct. */
   test h=TREAT*FORMMETHOD e=VENDOR*TREAT*FORMMETHOD; /* Uses appropriate error term, so F-test is now correct. */
   *contrast "Alright" TREAT  1 -1 / e=VENDOR*TREAT;
   *means FORMMETHOD / lsd e=VENDOR*TREAT*FORMMETHOD; /* Can't do this since TREAT*FORM are significant. */
   *means ANTIBIOTIC / lsd; /* No need for e= here, it's just the residual error. */
 run; quit;
 ods output close;
/******************************************************************/

/******************************************************************/
 /* Join the output */
data anova1f_;
   set anova1f v_tr_f v_tr_form_f;
   if trim(left(source))="TREAT" and error="" or
      trim(left(source))="FORMMETHOD" and error="" or
      trim(left(source))="TREAT*FORMMETHOD" and error="" then delete;
run;
proc export
   data=anova1f_
   outfile=".\ANOVA_FULL.csv"
   dbms=csv;
run;
data outs_; set outs; obs=_N_; run;
/******************************************************************/

/******************************************************************/
/* RESIDUAL PLOTS */
/* Create Plot A2 */
symbol1 value=circle;
proc gplot data=outs_;
   title "Residuals vs Fitted Values";
   plot residuals*fitted / vref=0;
run; quit; title;

proc gplot data=outs_;
   title "Studentized Residuals vs Fitted Values";
   plot studentized_resid*obs;
run; quit; title;
/******************************************************************/

/******************************************************************/
/* NORMAL PLOT */
/* Create Plot A3 */
/* Macro code available at:
   https://math.la.asu.edu/~young/stp530/SASRef04/info.html */
%normplt(data=outs_, var=studentized_resid, title=Residual from ANOVA)
proc univariate data=outs_;
   histogram residuals;
run;
/******************************************************************/

/******************************************************************/
/* OUTLIERS */
/* Create Plot A4 */
proc gplot data=outs_;
   title "Studentized Residuals";
   plot student*obs / vref=3 2 -2 3;
run; quit; title;

proc boxplot data=pr1_;
   plot ABSORBTIME*TREAT;
run;
proc boxplot data=pr1__;
   plot ABSORBTIME*FORMMETHOD;
run;
proc boxplot data=pr1___;
   plot ABSORBTIME*ANTIBIOTIC;
run;
/******************************************************************/

/******************************************************************/
/* PROFILE PLOTS */
symbol;
proc gplot data=outs;
   title "Absorption Time vs Vendor";
   plot ABSORBTIME*VENDOR;
run; quit; title;
proc gplot data=outs;
   title "Absorption Time vs Treatment";
   plot ABSORBTIME*TREAT;
run; quit; title;
proc gplot data=outs;
   title "Absorption Time vs Formation Method";
   plot ABSORBTIME*FORMMETHOD;
run; quit; title;
proc gplot data=outs;
   title "Absorption Time vs Antibiotic";
   plot ABSORBTIME*ANTIBIOTIC;
run; quit; title;
/******************************************************************/

/******************************************************************/
/* To compare subplot levels within a common mainplot */
proc sort data=pr1 out=pr1_treat; by TREAT; run;
proc sort data=pr1 out=pr1_form; by FORMMETHOD; run;
proc sort data=pr1 out=pr1_anti; by ANTIBIOTIC; run;

/* Create Tables A6 and A7 */
proc glm data=pr1_treat;
   class VENDOR TREAT FORMMETHOD ANTIBIOTIC;
   model ABSORBTIME=VENDOR      TREAT             VENDOR*TREAT
                    FORMMETHOD  TREAT*FORMMETHOD  VENDOR*TREAT*FORMMETHOD
                    ANTIBIOTIC  TREAT*ANTIBIOTIC  FORMMETHOD*ANTIBIOTIC
                    TREAT*FORMMETHOD*ANTIBIOTIC
                    TREAT*FORMMETHOD*ANTIBIOTIC;
   /* COMPARE LEVELS WITHIN MAINPLOT (TREAT) SINCE INTERACTIONS WERE SIGNIFICANT. */
   means ANTIBIOTIC / lsd; by TREAT; /* CORRECT! */
   means FORMMETHOD / lsd e=VENDOR*TREAT*FORMMETHOD; by TREAT; /* CORRECT! */
run; quit;

/* Create Table A8 */
proc glm data=pr1_form;
   class VENDOR TREAT FORMMETHOD ANTIBIOTIC;
   model ABSORBTIME=VENDOR      TREAT             VENDOR*TREAT
                    FORMMETHOD  TREAT*FORMMETHOD  VENDOR*TREAT*FORMMETHOD
                    ANTIBIOTIC  TREAT*ANTIBIOTIC  FORMMETHOD*ANTIBIOTIC
                    TREAT*FORMMETHOD*ANTIBIOTIC
                    TREAT*FORMMETHOD*ANTIBIOTIC;
   /* COMPARE LEVELS AMONG MAINPLOT (TREAT) W/I FORMMETHOD SINCE INTERACTIONS WERE SIGNIFICANT. */
   means TREAT / lsd e=VENDOR*TREAT; by FORMMETHOD; /* CORRECT! */
run; quit;

/* Create Table A9 */
proc glm data=pr1_anti;
   class VENDOR TREAT FORMMETHOD ANTIBIOTIC;
   model ABSORBTIME=VENDOR      TREAT             VENDOR*TREAT
                    FORMMETHOD  TREAT*FORMMETHOD  VENDOR*TREAT*FORMMETHOD
                    ANTIBIOTIC  TREAT*ANTIBIOTIC  FORMMETHOD*ANTIBIOTIC
                    TREAT*FORMMETHOD*ANTIBIOTIC
                    TREAT*FORMMETHOD*ANTIBIOTIC;
   /* COMPARE LEVELS AMONG MAINPLOT (TREAT) W/I ANTIBIOTIC SINCE INTERACTIONS WERE SIGNIFICANT. */
   means TREAT / lsd e=VENDOR*TREAT; by ANTIBIOTIC; /* CORRECT! */
run; quit;
/******************************************************************/
