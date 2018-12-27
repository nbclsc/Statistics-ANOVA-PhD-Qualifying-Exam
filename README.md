# ANOVA Split-Plot Design

## [Problem](http://math.unm.edu/sites/default/files/files/qual-exams/Edit%20Past%20Qualifying%20Exams%20Page%20Past%20Qualifying%20Exams%20-%20Statistics/UNM_Stat_Exam_Qual_takehome_201301.pdf):

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;This experiment involves the absorption time (minutes) of a particular type of antibiotic capsule. Four vendors (`W`, `X`, `Y`, `Z`) provide the capsule material.  From each vendor’s material, equal amounts are either left untreated or treated; and because of the difficulties of treating many small batches the chemical treatment in a single large batch for each vendor’s material. Next, the material batches are divided into three sub-batches and formed into capsule shells by three methods (`D`, `G`, `H`); each method creates many capsule shells in one run. Finally, an antibiotic combination (`A` alone, `B` alone, or `A` and `B` together) is placed in each capsule shell.  The shells are all stored for a period of three weeks under accelerated aging conditions, then measured. Each shell is placed in a mildly acidic solution until a proxy for absorption is indicated, at which point the time elapsed in minutes is recorded.  Analyze the data, where vendors are random and the other factors are fixed, and draw conclusions.

## Solution:
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;

### Materials and Methods
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;The data appears to be a Split-split-plot design where our blocks are the four companies providing materials (`W`, `Y`, `X`, `Z`), the whole-plot treatments are treated/untreated groups, our subplot treatments are capsule shell formation method at three levels (`D`,`G`,`H`), and our sub-subplot treatments are antibiotic combinations at three levels (`A`, `AB`, `B`). Both SAS and R were used to analyze the data.
### Analysis
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Our model looks like:
$$ Y_{ijkl} = \mu_{\cdot\cdot\cdot\cdot} + \alpha_i + \tau_j + d_{ij} + \beta_k + (\alpha \beta)_{ik} + f_{ijk} + \gamma_l + (\alpha \gamma)_{il} + (\beta \gamma)_{kl} + (\alpha \beta \gamma)_{ikl} + \varepsilon_{ijkl} $$

<img src="https://latex.codecogs.com/gif.latex?%5Cinline%20Y_%7Bijkl%7D%20%3D%20%5Cmu_%7B%5Ccdot%5Ccdot%5Ccdot%5Ccdot%7D%20&plus;%20%5Calpha_i%20&plus;%20%5Ctau_j%20&plus;%20d_%7Bij%7D%20&plus;%20%5Cbeta_k%20&plus;%20%28%5Calpha%20%5Cbeta%29_%7Bik%7D%20&plus;%20f_%7Bijk%7D%20&plus;%20%5Cgamma_l%20&plus;%20%28%5Calpha%20%5Cgamma%29_%7Bil%7D%20&plus;%20%28%5Cbeta%20%5Cgamma%29_%7Bkl%7D%20&plus;%20%28%5Calpha%20%5Cbeta%20%5Cgamma%29_%7Bikl%7D%20&plus;%20%5Cvarepsilon_%7Bijkl%7D" border="0" />

$$ i=1,2 j=1,2,3,4,k=1,2,3,l=1,2,3 $$
$ Y_ijkl $ ∶ absorption time; <img src="https://latex.codecogs.com/gif.latex?%5Cinline%20%5Cmu_%7B%5Ccdot%5Ccdot%5Ccdot%5Ccdot%7D" border="0" />: general mean; <img src="https://latex.codecogs.com/gif.latex?%5Cinline%20%5Calpha_i" border="0" />, <img src="https://latex.codecogs.com/gif.latex?%5Cinline%20%5Cbeta_k" border="0" />, <img src="https://latex.codecogs.com/gif.latex?%5Cinline%20%5Cgamma_l" border="0" />,:Treatment effects for main plots treated material (TREAT), subplots for formation method (FORMMETHOD), and sub-subplots for antibiotic combination (ANTIBIOTIC), respectively; <img src="https://latex.codecogs.com/gif.latex?%5Cinline%20%5Ctau_j" border="0" />: Vendor block effect; <img src="https://latex.codecogs.com/gif.latex?%5Cinline%20%28%5Calpha%5Cbeta%29_%7Bik%7D" border="0" />, <img src="https://latex.codecogs.com/gif.latex?%5Cinline%20%28%5Calpha%20%5Cgamma%29_%7Bil%7D" border="0" />, <img src="https://latex.codecogs.com/gif.latex?%5Cinline%20%28%5Cbeta%20%5Cgamma%29_%7Bkl%7D" border="0" />,: Two-way interactions; <img src="https://latex.codecogs.com/gif.latex?%5Cinline%20d_%7Bij%7D" border="0" />, <img src="https://latex.codecogs.com/gif.latex?%5Cinline%20f_%7Bijk%7D" border="0" />, <img src="https://latex.codecogs.com/gif.latex?%5Cinline%20%5Cvarepsilon_%7Bijkl%7D" border="0" />: The main plot error, the subplot error, and the sub-subplot error, respectively;  <img src="https://latex.codecogs.com/gif.latex?%5Cinline%20%28%5Calpha%20%5Cbeta%20%5Cgamma%29_%7Bikl%7D" border="0" />: Three-way interaction

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Prior to running the model interaction plots are created to get an idea of how things look. Two-way interaction plots can be seen in [**_Plot A1_**](#Plot-A1). Treat by formation method show lower absorption times for treated materials for all formation method levels. The line for formation method `H` does cross the other formation method levels and suggests interaction. The crossing does cause an issue where we now will not know if the treatment is effective or not without considering the formation method. The interaction plot of treatment by antibiotic shows absorption times for the antibiotic `A` and `AB` appear almost parallel, but antibiotic `B` has a slope much lower, so interaction could be possible. Finally, the interaction plot of formation method by antibiotic show lines roughly parallel, so it’s hopeful that interaction is not present. Next, fitting the full model, we initially examine the model assumptions. A look at the residuals versus the fitted values in [**_Plot A2_**](#Plot-A2) shows no dependence on sign or cone shaped pattern, so the assumption of constant error variance appears to be satisfied. A look at the normal plot of the data in [**_Plot A3_**](#Plot-A3) shows that the data fits the normal line very well without heavy tails. The coefficient of correlation between the ordered residuals and there expected values under normality is 0.9957. Based on the normal plot and correlation it appears that the data is normally distributed. Looking at a plot of the studentized residuals in [**_Plot A4_**](#Plot-A4), there are three observations with absolute studentized residuals greater than two that would be considered outliers. All three cases belong to untreated materials, and two of three belong to antibiotic `B`. However, since it’s assumed there was no measurement error while collecting the data, we cannot remove these cases.
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;The full split-split plot ANOVA table can be seen in [**_Table A5_**](#Table-A5), we can see that the three way interaction term, and the two way interaction term for formation method and antibiotic are not significant. However, the two-way interactions for treatment and formation method, as well as treatment and antibiotic are significant at the 0.05 level. Looking at the main effects, treatments, and antibiotics are significant at the 0.05 level, but the formation method is marginally insignificant with a p-value of 0.0532. Since the interaction term for treatment and formation method was significant we’ll keep the main effects term.
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Since the interaction term for treatments and formation method was significant we move on to comparing the subplots for formation method within the whole plots for treatments averaged over all antibiotic levels using Fisher’s Least Significant Difference (LSD) test at the 0.05 level ([**_Table A6_**](#Table-A6)). We find that for the untreated materials absorption times for formation method `G` are no different than those from method `D`, but lower than those for method `H`. Formation method `G` has the lowest absorption times. For the treated materials there was no significant difference found between any of the three different formation methods. From the ANOVA table the interaction of treatments and antibiotics was also significant so we then compare sub-subplots for antibiotics within main plots for treatments using LSD at the 0.05 level ([**_Table A7_**](#Table-A7)). It is revealed that absorption times for the untreated materials with antibiotics `A` and `AB` are not significantly different from one another, but they are different (higher) then antibiotic `B`. This can be seen in the interaction plot in [**_plot A1_**](#Plot-A1). For the treated materials it was found that there is no significant difference in absorption time between any of the three antibiotic levels.
Looking at main plots (TREAT) within subplot levels (FORMMETHOD) averaged over all antibiotic combinations ([**_Table A8_**](#Table-A8)) we find that for formation level `H` there is a significant difference in absorption times between treated and untreated materials averaged over all sub-subplot antibiotic levels. Means for treated materials have much lower average absorption times. For both the level `G` and `D` there is not a significant difference between treated and untreated materials. For main plots treatment within the three sub-subplot levels for antibiotic averaged over levels of formation method ([**_Table A9_**](#Table-A9)), we find that for the antibiotic level `B` there is no significant difference between the treated and untreated materials absorption times, but for the other two levels of antibiotic (`A` and `AB`), there is a significant difference between treated and untreated absorption times with treated materials again having lower absorption rates.
### Conclusion
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;After analyzing the model it appears that there isn’t a simple description of the data due to interaction with the main plot material treatment. It is interesting that when comparing the means within the untreated main plots group, that both the formation methods and antibiotics had significantly different levels within themselves. It’s also interesting that main plot means being compared with the subplot and sub-subplot levels show that the treated materials always have the lower absorption times when comparisons are significant. Comparing means for the treatment main plots within formation methods found that only formation method `H` resulted in different absorption times between treated and untreated materials averaged over antibiotics. Also, comparing main plot treatments within antibiotic combinations averaged over formation methods showed that antibiotic `B` was the only sub-subplot treatment to have significant differences

### Appendix
#### **_Plot A1_**
#### Interaction Plots
#### **_Plot A2_**
#### Interaction Plots
#### **_Plot A3_**
#### Interaction Plots
#### **_Plot A4_**
#### Interaction Plots
#### **_Table A5_**
#### Interaction Plots
#### **_Table A6_**
#### Interaction Plots
#### **_Table A7_**
#### Interaction Plots
#### **_Table A8_**
#### Interaction Plots
#### **_Table A9_**
#### Interaction Plots
