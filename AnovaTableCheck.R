abso <- read.csv("http://www.stat.unm.edu/~erike/exams/UNM_Stat_Exam_Qual_takehome_201301_pr1-DATA_experiment.csv", header=T)
attach(abso)
names(abso)
# Generate ANOVA table for split-split plot design
model1 <- aov(absorbtime~treat*formmethod*antibiotic+Error(vendor/treat/formmethod/antibiotic))
summary(model1)

# Interaction plots
par(mfrow=c(2,2)) 
interaction.plot(treat, formmethod, absorbtime, main="Treat by Formmethod") #x=treat, y=absorbtime lines=formmethod
interaction.plot(treat, antibiotic, absorbtime, main="Treat by Antibiotic") #x=treat, y=absorbtime lines=antibiotic
interaction.plot(formmethod, antibiotic, absorbtime, main="Formmethod by Antibiotic") #x=formmethod y=absorbtime lines=antibiotic