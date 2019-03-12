library(nlme)
data(Rail)
class(Rail)
class(Rail)
# [1] "nffGroupedData" "nfGroupedData"  "groupedData"    "data.frame"    
head(Rail)
# Grouped Data: travel ~ 1 | Rail
# Rail travel
# 1    1     55
# 2    1     53
# 3    1     54
# 4    2     26
# 5    2     37
# 6    2     32
levels(Rail$Rail)

library(ggplot2)
ggplot(Rail, aes(x=Rail, y=travel, color=Rail))+geom_point(size=2)

table(Rail$Rail)
# 
# 2 5 1 6 3 4 
# 3 3 3 3 3 3
LMIntercept<-lm(travel~1, data=Rail)
summary(LMIntercept)
# 
# Call:
#     lm(formula = travel ~ 1, data = Rail)
# 
# Residuals:
#     Min     1Q Median     3Q    Max 
# -40.50 -16.25   0.00  18.50  33.50 
# 
# Coefficients:
#     Estimate Std. Error t value Pr(>|t|)    
# (Intercept)   66.500      5.573   11.93  1.1e-09 ***
#     ---
#     Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
# 
# Residual standard error: 23.65 on 17 degrees of freedom

df<-data.frame(residuals=rstandard(LMIntercept), rail=Rail$Rail)
g1<-ggplot(df, aes(sample=rstandard(LMIntercept)))+stat_qq(distribution = qnorm)+ stat_qq_line()
g2<-ggplot(df, aes(x=rail, y=residuals, color=rail))+geom_point()
library(cowplot)
plot_grid(g1, g2, nrow=1, labels=c("A)", "B)"), rel_widths = c(0.8,1))
       
LMEffect<-lm(travel~Rail-1, data=Rail)
summary(LMEffect)
# Call:
#     lm(formula = travel ~ Rail - 1, data = Rail)
# 
# Residuals:
#     Min      1Q  Median      3Q     Max 
# -6.6667 -1.0000  0.1667  1.0000  6.3333 
# 
# Coefficients:
#     Estimate Std. Error t value Pr(>|t|)    
# Rail2   31.667      2.321   13.64 1.15e-08 ***
#     Rail5   50.000      2.321   21.54 5.86e-11 ***
#     Rail1   54.000      2.321   23.26 2.37e-11 ***
#     Rail6   82.667      2.321   35.61 1.54e-13 ***
#     Rail3   84.667      2.321   36.47 1.16e-13 ***
#     Rail4   96.000      2.321   41.35 2.59e-14 ***
#     ---
#     Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
# 
# Residual standard error: 4.021 on 12 degrees of freedom
# Multiple R-squared:  0.9978,	Adjusted R-squared:  0.9967 
# F-statistic: 916.6 on 6 and 12 DF,  p-value: 2.971e-15

library(nlme)
randomModel <- lme(travel~1,random=~1|Rail,data=Rail)
randomModel
summary(randomModel)

VarCorr(randomModel)
# Rail = pdLogChol(1) 
# Variance  StdDev   
# (Intercept) 615.31111 24.805465
# Residual     16.16667  4.020779

ICC<-615.31111/(615.31111+16.16667)

library(lme4)
rail.lmer <- lmer(travel ~1+(1|Rail),data=Rail)
summary(rail.lmer)
# Linear mixed model fit by REML ['lmerMod']
# Formula: travel ~ 1 + (1 | Rail)
# Data: Rail
# 
# REML criterion at convergence: 122.2
# 
# Scaled residuals: 
#     Min       1Q   Median       3Q      Max 
# -1.61883 -0.28218  0.03569  0.21956  1.61438 
# 
# Random effects:
#     Groups   Name        Variance Std.Dev.
# Rail     (Intercept) 615.31   24.805  
# Residual              16.17    4.021  
# Number of obs: 18, groups:  Rail, 6
# 
# Fixed effects:
#     Estimate Std. Error t value
# (Intercept)    66.50      10.17   6.538

data(RatPupWeight, package="nlme")
library(nlme)
head(RatPupWeight)
RatPupWeight$Treatment<-factor(as.character(RatPupWeight$Treatment), levels=c("Control", "Low", "High"))
RatPupWeight$Litter<-factor(as.character(RatPupWeight$Litter), levels=unique(as.character(RatPupWeight$Litter)))

ggplot(RatPupWeight, aes(x=sex, y=weight, fill=Treatment))+geom_boxplot()

g1<-ggplot(RatPupWeight)+geom_jitter(aes(x=Treatment, y=weight, color=Litter))+facet_wrap(~sex)+theme(legend.position="none")

g2<-ggplot(RatPupWeight, aes(x=Litter, y=weight, fill=Litter))+geom_boxplot()+facet_wrap(sex~Treatment, nrow = 2, scales="free_x")+theme(legend.position = "bottom", legend.justification = "center", legend.direction = "horizontal")

p<-plot_grid(g1,g2, labels=c("A)", "B)"), nrow=2, rel_heights = c(0.65,1))

ggplot2::ggsave(p, file="../Dropbox/CursoPG/github/RCourse/imagenes/ratPupsExplo.png", height = 14, width=14, dpi=350)

#### Modelo maximal fixed effects

FEModel<-lme(weight~Treatment+sex+Lsize+Treatment:sex, random=~1|Litter, data=RatPupWeight)
summary(FEModel)

LMModelGLS<-gls(weight~Treatment+sex+Lsize+Treatment:sex, data=RatPupWeight)

stat<- (-2*logLik(LMModelGLS, REML=TRUE)+2*logLik(FEModel, REML=TRUE))[1]
pval<- mean(pchisq(stat,df=c(0,1),lower.tail=FALSE))
pval

anova(LMModelGLS, FEModel)


FEModelHetVar<-lme(weight~Treatment+sex+Lsize+Treatment:sex, random=~1|Litter,
                   weights = varIdent(form = ~1 | Treatment), data=RatPupWeight)
summary(FEModelHetVar)


anova(FEModel, FEModelHetVar)

stat<- (-2*logLik(FEModel, REML=TRUE)+2*logLik(FEModelHetVar, REML=TRUE))[1]
pval<- pchisq(stat,df=2,lower.tail=FALSE)
pval
# [1] 1.120134e-09

RatPupWeight$trtGroup[RatPupWeight$Treatment=="Control"]<-"C"
RatPupWeight$trtGroup[RatPupWeight$Treatment!="Control"]<-"T"

FEModelHetVar2<-lme(weight~Treatment+sex+Lsize+Treatment:sex, random=~1|Litter,
                   weights = varIdent(form = ~1 | trtGroup), data=RatPupWeight)
summary(FEModelHetVar2)

anova( FEModelHetVar2, FEModelHetVar)

stat<- (-2*logLik(FEModelHetVar2, REML=TRUE)+2*logLik(FEModelHetVar, REML=TRUE))[1]
pval<- pchisq(stat,df=1,lower.tail=FALSE)
pval
# [1] 0.2741121

anova( FEModel, FEModelHetVar2)
# Model df      AIC      BIC    logLik   Test  L.Ratio p-value
# FEModel            1  9 419.1043 452.8775 -200.5522                        
# FEModelHetVar2     2 10 381.0807 418.6065 -180.5404 1 vs 2 40.02358  <.0001

stat<- (-2*logLik(FEModel, REML=TRUE)+2*logLik(FEModelHetVar2, REML=TRUE))[1]
pval<- pchisq(stat,df=1,lower.tail=FALSE)
pval
# [1] 2.509153e-10

anova(FEModelHetVar2)
# numDF denDF  F-value p-value
# (Intercept)       1   292 9027.740  <.0001
# Treatment         2    23    4.241  0.0271
# sex               1   292   61.568  <.0001
# Lsize             1    23   49.577  <.0001
# Treatment:sex     2   292    0.317  0.7288
FEModelHetVar3LM<-lme(weight~Treatment+sex+Lsize, random=~1|Litter, 
                    weights = varIdent(form = ~1 | trtGroup), data=RatPupWeight, method = "ML")
FEModelHetVar2LM<-lme(weight~Treatment+sex+Lsize+Treatment:sex, random=~1|Litter, 
                    weights = varIdent(form = ~1 | trtGroup), data=RatPupWeight, method = "ML")


anova(FEModelHetVar3LM,FEModelHetVar2LM)

stat<- (-2*logLik(FEModelHetVar3, REML=FALSE)+2*logLik(FEModelHetVar2, REML=FALSE))[1]
pval<- pchisq(stat,df=2,lower.tail=FALSE)
pval
anova(FEModelHetVar2)

FEModelHetVar4LM<-lme(weight~sex+Lsize, random=~1|Litter, weights = varIdent(form = ~1 | trtGroup), data=RatPupWeight, method = "ML")
anova(FEModelHetVar4LM,FEModelHetVar3LM)

SelectedModel<-lme(weight~Treatment+sex+Lsize, random=~1|Litter, weights = varIdent(form = ~1 | trtGroup), data=RatPupWeight)
summary(SelectedModel)
# Linear mixed-effects model fit by REML
# Data: RatPupWeight 
# AIC      BIC    logLik
# 372.2784 402.3497 -178.1392
# 
# Random effects:
#     Formula: ~1 | Litter
# (Intercept)  Residual
# StdDev:   0.3146374 0.5144324
# 
# Variance function:
#     Structure: Different standard deviations per stratum
# Formula: ~1 | trtGroup 
# Parameter estimates:
#     C         T 
# 1.0000000 0.5889108 
# Fixed effects: weight ~ Treatment + sex + Lsize 
# Value  Std.Error  DF   t-value p-value
# (Intercept)    8.327633 0.27406956 294 30.385107  0.0000
# TreatmentLow  -0.433663 0.15226167  23 -2.848140  0.0091
# TreatmentHigh -0.862268 0.18293359  23 -4.713556  0.0001
# sexFemale     -0.343431 0.04204323 294 -8.168531  0.0000
# Lsize         -0.130681 0.01855194  23 -7.044036  0.0000
# Correlation: 
#     (Intr) TrtmnL TrtmnH sexFml
# TreatmentLow  -0.348                     
# TreatmentHigh -0.610  0.464              
# sexFemale     -0.103 -0.035 -0.006       
# Lsize         -0.913  0.064  0.403  0.043
# 
# Standardized Within-Group Residuals:
#     Min          Q1         Med          Q3         Max 
# -5.97351495 -0.53695365  0.01508652  0.54234475  2.58286992 
# 
# Number of Observations: 322
# Number of Groups: 27 

grps<-factor(c("MC", "FC", "MH","FH","ML","FL"))
grpMean<-c(fixef(SelectedModel)[1], fixef(SelectedModel)[1]+fixef(SelectedModel)[4],
           fixef(SelectedModel)[1]+fixef(SelectedModel)[3],
           fixef(SelectedModel)[1]+fixef(SelectedModel)[3]+fixef(SelectedModel)[4],
           fixef(SelectedModel)[1]+fixef(SelectedModel)[2],
           fixef(SelectedModel)[1]+fixef(SelectedModel)[2]+fixef(SelectedModel)[4])

RatPupWeight$FG[RatPupWeight$sex=="Male" & RatPupWeight$Treatment=="Control"]<-"MC"
RatPupWeight$FG[RatPupWeight$sex=="Female" & RatPupWeight$Treatment=="Control"]<-"FC"
RatPupWeight$FG[RatPupWeight$sex=="Male" & RatPupWeight$Treatment=="High"]<-"MH"
RatPupWeight$FG[RatPupWeight$sex=="Female" & RatPupWeight$Treatment=="High"]<-"FH"
RatPupWeight$FG[RatPupWeight$sex=="Male" & RatPupWeight$Treatment=="Low"]<-"ML"
RatPupWeight$FG[RatPupWeight$sex=="Female" & RatPupWeight$Treatment=="Low"]<-"FL"

ggplot(RatPupWeight, aes(x=Lsize, y=weight, color=FG))+geom_point(size=3, alpha=0.5)+geom_abline(intercept = grpMean, slope = slope, color=c("MC"="blue", "FC"="skyblue", "MH"="red", "FH"="orange", "ML"="green4", "FL"="green"))+
    scale_color_manual(values=c("MC"="blue", "FC"="skyblue", "MH"="red", "FH"="orange", "ML"="green4", "FL"="green"))

data(SIIdata, package="nlmeU")
head(SIIdata)
summary(SIIdata)

library(ggplot2)
ggplot(SIIdata, aes(x=mathkind,y=mathknow, color=minority))+geom_line()
ggplot(SIIdata, aes(x=mathkind,y=mathknow))+geom_line()+facet_wrap(~schoolid)

library(nlme)
varCompModel<-lme(mathgain~1, random=~1|schoolid/classid, data=SIIdata, method="REML")
summary(varCompModel)

VarCorr(varCompModel)
ICC_s<-73.40192/(73.40192+116.92384+1020.97926)
ICC_c<-(116.92384+73.40192)/(73.40192+116.92384+1020.97926)
ICC_s
ICC_c

varCompModelSRE<-lme(mathgain~1, random=~1|schoolid,data=SIIdata, method="REML")
stat<- (-2*logLik(varCompModelSRE, REML=TRUE)+2*logLik(varCompModel, REML=TRUE))[1]
pval<- mean(pchisq(stat,df=c(0,1),lower.tail=FALSE))
pval
# [1] 0.002465241

FEL1Model<-lme(mathgain~sex+minority+ses+mathkind, random=~1|schoolid/classid, data=SIIdata, method="REML", na.action = "na.omit")
summary(FEL1Model)
# Linear mixed-effects model fit by REML
# Data: SIIdata 
# AIC      BIC    logLik
# 10334.53 10374.38 -5159.267
# 
# Random effects:
#     Formula: ~1 | schoolid
# (Intercept)
# StdDev:    8.137653
# 
# Formula: ~1 | classid %in% schoolid
# (Intercept) Residual
# StdDev:    9.589501 26.73725
# 
# Fixed effects: mathgain ~ sex + minority + ses + mathkind 
# Value Std.Error  DF    t-value p-value
# (Intercept)      286.66229 11.080434 792  25.871034  0.0000
# sexF              -1.36021  1.719783 792  -0.790922  0.4292
# minorityMnrt=Yes  -8.50743  2.374568 792  -3.582728  0.0004
# ses                5.39986  1.274105 792   4.238157  0.0000
# mathkind          -0.47687  0.022699 792 -21.008488  0.0000
# Correlation: 
#     (Intr) sexF   mnrM=Y ses   
# sexF             -0.070                     
# minorityMnrt=Yes -0.304 -0.018              
# ses               0.137  0.021  0.166       
# mathkind         -0.979 -0.005  0.164 -0.166
# 
# Standardized Within-Group Residuals:
#     Min         Q1        Med         Q3        Max 
# -3.4565766 -0.6218058 -0.0375118  0.5607274  4.3174874 

# Number of Observations: 1081
# Number of Groups: 
#     schoolid classid %in% schoolid 
# 105   285 
stat<- (-2*logLik(varCompModel, REML=FALSE)+2*logLik(FEL1Model, REML=FALSE))[1]
pval<- pchisq(stat,df=4,lower.tail=FALSE)
pval
# [1] 4.855231e-81

FEL1ModelA<-lme(mathgain~minority+ses+mathkind+sex+minority:mathkind+minority:ses, random=~1|schoolid/classid, data=SIIdata, method="REML", na.action="na.omit")
stat<- (-2*logLik(FEL1Model, REML=FALSE)+2*logLik(FEL1ModelA, REML=FALSE))[1]
pval<- pchisq(stat,df=2,lower.tail=FALSE)
pval
FEL1ModelB<-lme(mathgain~minority+ses+mathkind+sex+minority:mathkind+minority:ses+minority:mathkind:ses, random=~1|schoolid/classid, data=SIIdata, method="REML", na.action="na.omit")
stat<- (-2*logLik(FEL1ModelA, REML=FALSE)+2*logLik(FEL1ModelB, REML=FALSE))[1]
pval<- pchisq(stat,df=2,lower.tail=FALSE)
pval

FEL12Model<-lme(mathgain~minority+ses+mathkind+sex+yearstea+mathprep+mathknow, random=~1|schoolid/classid, data=SIIdata, na.action="na.omit", method="REML")
summary(FEL12Model)


SIIdataComplete <- subset(SIIdata, !is.na(mathknow))
FEL1ModelC<-lme(mathgain~sex+minority+ses+mathkind, random=~1|schoolid/classid, data=SIIdataComplete, method="REML")
FEL12ModelC<-lme(mathgain~sex+minority+ses+mathkind+mathknow+mathprep, random=~1|schoolid/classid, data=SIIdataComplete, method="REML")


stat<- (-2*logLik(FEL1ModelC, REML=TRUE)+2*logLik(FEL12ModelC, REML=TRUE))[1]
pval<- pchisq(stat,df=2,lower.tail=FALSE)
pval
# [1] 0.1365077

FEL13Model<-lme(mathgain~sex+minority+ses+mathkind+housepov, random=~1|schoolid/classid, data=SIIdata, method="REML", na.action = "na.omit")
summary(FEL13Model)
stat<- (-2*logLik(FEL1Model, REML=FALSE)+2*logLik(FEL13Model, REML=FALSE))[1]
pval<- pchisq(stat,df=1,lower.tail=FALSE)
pval
# [1] 0.005386144

FEL1ModelLM<-lme(mathgain~sex+minority+ses+mathkind, random=~1|schoolid/classid,data=SIIdata, method="ML")
FEL13ModelLM<-lme(mathgain~sex+minority+ses+mathkind+housepov,random=~1|schoolid/classid, data=SIIdata, method="ML")
anova(FEL13ModelLM, FEL1ModelLM)
#  Model df      AIC      BIC    logLik   Test  L.Ratio p-value
# FEL13ModelLM     1  9 11407.64 11453.38 -5694.822                        
# FEL1ModelLM      2  8 11406.96 11447.62 -5695.481 1 vs 2 1.318652  0.2508

## QQplot de los residuos

PearsonRes<-resid(FEL1Model, type="pearson")
fittedValues<-fitted(FEL1Model)
df<-data.frame(PearsonRes, fittedValues, SII)

a<-ggplot(df, aes(sample=PearsonRes))+geom_qq(color="blue", alpha=0.7)+geom_abline(slope=1, intercept=0)+labs(y="Residuos de Pearson", x="Valores te?ricos")

b<-ggplot(df, aes(x=fittedValues,y=PearsonRes))+geom_point(color="blue", alpha=0.7)+geom_hline(yintercept = 0)+labs(y="Residuos de Pearson", x="Valores ajustados")

library(cowplot)
p<-plot_grid(a,b, nrow=1, labels=c("A", "B"), rel_widths = c(0.8, 1.2))
ggplot2::ggsave(p, file="../Dropbox/CursoPG/github/RCourse/imagenes/ClassResidPlots.png", dpi=400, height = 6, width = 9)

ggplot(SIIdata, aes(x=ses*mathkind, y=mathgain))+geom_point()

ggplot(df, aes(x=minority,y=PearsonRes))+geom_boxplot()


SIIdata$pearsonRes<-abs(PearsonRes)>=2.3
FEL1ModelLM<-lme(mathgain~sex+minority+ses+mathkind,weights = varExp(1, ~mathkind),
 random=~1|schoolid/classid,data=SIIdata, 
                 method="REML")

stat<- (-2*logLik(FEL1Model, REML=TRUE)+2*logLik(FEL1ModelLM, REML=TRUE))[1]
pval<- pchisq(stat,df=1,lower.tail=FALSE)
pval
# [1] 0.002311152

ggplot(SIIdata, aes(x=ses, y=mathgain, color=sex))+geom_point()+geom_smooth()
ggplot(SIIdata, aes(x=ses, y=mathgain, color=minority))+geom_point()+geom_smooth()
ggplot(SIIdata, aes(x=mathkind, y=mathgain, color=sex))+geom_point()+geom_smooth()
ggplot(SIIdata, aes(x=mathkind, y=mathgain, color=minority))+geom_point()+geom_smooth()



EBLUPs<-ranef(FEL1Model)
shapiro.test(EBLUPs[[1]][,1])

# Shapiro-Wilk normality test
# 
# data:  EBLUPs[[1]][, 1]
# W = 0.99357, p-value = 0.9004

shapiro.test(EBLUPs[[2]][,1])

# Shapiro-Wilk normality test
# 
# data:  EBLUPs[[2]][, 1]
# W = 0.99596, p-value = 0.6076
df<-data.frame(EBLUPSchool=EBLUPs[[1]][,1])
escuelas<-levels(SIIdata$schoolid)
cursos<-levels(SIIdata$classid)

df$escuelas<-escuelas
df2<-data.frame(EBLUPclass=EBLUPs[[2]][,1],cursos)
aux<-merge(SIIdata, df, by.x = "schoolid", by.y="escuelas")
aux<-merge(aux, df2, by.x="classid", by.y="cursos")
aux$pearsonRes<-PearsonRes
aux$fittedValues<-fittedValues
a<-ggplot(aux, aes(x=PearsonRes, y=EBLUPSchool))+geom_point()
b<-ggplot(aux, aes(x=PearsonRes, y=EBLUPclass))+geom_point()
c<-ggplot(aux, aes(x=fittedValues,y=EBLUPSchool))+geom_point()
d<-ggplot(aux, aes(x=fittedValues,y=EBLUPclass))+geom_point()

plot_grid(a,b, nrow=1, labels=c("A", "B"), rel_widths = c(0.8, 1.2))

data("rat.brain", package="WWGbook")
library(nlme)

head(rat.brain)
summary(rat.brain)

rat.brain$treatment<-as.factor(rat.brain$treatment)
levels(rat.brain$treatment)<-c("Basal", "Carb")
rat.brain$region<-as.factor(rat.brain$region)
levels(rat.brain$region)<-c("BST", "LS", "VDB")
summary(rat.brain)
# animal  treatment  region      activate    
# R100797:6   Basal:15   BST:10   Min.   :179.4  
# R100997:6   Carb :15   LS :10   1st Qu.:261.4  
# R110597:6              VDB:10   Median :406.6  
# R111097:6                       Mean   :402.1  
# R111397:6                       3rd Qu.:493.6  
# Max.   :727.0 
library(dplyr)
rat.brain %>% 
    group_by(treatment, region) %>%  summarise(avgActiv=mean(activate), sdActiv=sd(activate))

g<-ggplot(rat.brain, aes(x=region, y=activate, color=animal, group=animal))+geom_point()+geom_line()+facet_wrap(~treatment)+labs(x="Regi?n", y="Activaci?n", color="Animal")+theme(legend.position="bottom")
ggsave(g, file="../Dropbox/CursoPG/github/RCourse/imagenes/exploRat.png", dpi=300, width=5.7, height = 3.5)

maximalModel<-lme(activate~treatment+region+treatment:region, random=~1|animal, method="REML", data=rat.brain)
summary(maximalModel)
# Linear mixed-effects model fit by REML
# Data: rat.brain 
# AIC      BIC    logLik
# 291.2822 300.7066 -137.6411
# 
# Random effects:
#     Formula: ~1 | animal
# (Intercept) Residual
# StdDev:    69.64057 49.50045
# 
# Fixed effects: activate ~ treatment + region + treatment:region 
# Value Std.Error DF   t-value p-value
# (Intercept)              428.506  38.21022 20 11.214435  0.0000
# treatmentCarb             98.204  31.30684 20  3.136823  0.0052
# regionLS                -190.762  31.30684 20 -6.093302  0.0000
# regionVDB               -216.212  31.30684 20 -6.906223  0.0000
# treatmentCarb:regionLS    99.322  44.27455 20  2.243320  0.0364
# treatmentCarb:regionVDB  261.822  44.27455 20  5.913600  0.0000
# Correlation: 
#     (Intr) trtmnC regnLS rgnVDB trC:LS
# treatmentCarb           -0.410                            
# regionLS                -0.410  0.500                     
# regionVDB               -0.410  0.500  0.500              
# treatmentCarb:regionLS   0.290 -0.707 -0.707 -0.354       
# treatmentCarb:regionVDB  0.290 -0.707 -0.354 -0.707  0.500
# 
# Standardized Within-Group Residuals:
#     Min          Q1         Med          Q3         Max 
# -1.46425392 -0.57621824  0.08020306  0.40718428  1.55091562 
# 
# Number of Observations: 30
# Number of Groups: 5 

anova(maximalModel)
# numDF denDF   F-value p-value
# (Intercept)          1    20 153.77636  <.0001
# treatment            1    20 146.24632  <.0001
# region               2    20  20.60935  <.0001
# treatment:region     2    20  17.82470  <.0001

FEModel<-gls(activate~treatment+region+treatment:region,  method="REML", data=rat.brain)

stat<- (-2*logLik(FEModel, REML=TRUE)+2*logLik(maximalModel, REML=TRUE))[1]
pval<- 0.5*pchisq(stat,df=1,lower.tail=FALSE)
pval
# [1] 3.202497e-05

anova(maximalModel, FEModel)
randTreatModel<-lme(activate~treatment+region+treatment:region, random=~treatment|animal, method="REML", data=rat.brain)
summary(randTreatModel)
# Linear mixed-effects model fit by REML

stat<- (-2*logLik(maximalModel, REML=TRUE)+2*logLik(randTreatModel, REML=TRUE))[1]
pval<- mean(pchisq(stat,df=c(1,2),lower.tail=FALSE))
pval
# [1] 1.2423e-06

randTreatCorModel<-lme(activate~treatment+region+treatment:region, random=~treatment|animal, weights = varIdent(form=~1|treatment), method="REML", data=rat.brain)
anova(randTreatModel, randTreatCorModel)
#                   Model df      AIC      BIC    logLik   Test   L.Ratio p-value
# randTreatModel        1 10 269.1904 280.9710 -124.5952                         
# randTreatCorModel     2 11 271.0383 283.9969 -124.5192 1 vs 2 0.1521269  0.6965


randTreatModelRedLM<-lme(activate~treatment+region, random=~treatment|animal, method="REML", data=rat.brain, control=lmeControl(opt='optim'))

stat<- (-2*logLik(randTreatModelRedLM, REML=FALSE)+2*logLik(randTreatModel, REML=FALSE))[1]
pval<- pchisq(stat,df=2,lower.tail=FALSE)
pval

anova(randTreatModel)


PearsonRes<-resid(randTreatModel, type="pearson")
fittedValues<-fitted(randTreatModel)
df<-data.frame(PearsonRes, fittedValues, rat.brain)
levels(df$treatment)[2]<-"Carbacol"
a<-ggplot(df, aes(sample=PearsonRes))+geom_qq(color="blue", alpha=0.7)+geom_abline(slope=1, intercept=0)+labs(y="Residuos de Pearson", x="Valores teóricos")

b<-ggplot(df, aes(x=fittedValues,y=PearsonRes, color=treatment))+geom_point(alpha=0.7)+geom_hline(yintercept = 0)+labs(y="Residuos de Pearson", x="Valores ajustados", color="Tratamiento")

library(cowplot)
p<-plot_grid(a,b, nrow=1, labels=c("A", "B"), rel_widths = c(0.8, 1.2))
ggplot2::ggsave(p, file="../Dropbox/CursoPG/github/RCourse/imagenes/RatThreeResidPlots.png", dpi=400, height = 6, width = 9)

ggplot(df, aes(x=treatment, y=PearsonRes))+geom_boxplot()

shapiro.test(PearsonRes)
# Shapiro-Wilk normality test
# 
# data:  PearsonRes
# W = 0.97081, p-value = 0.5614

summary(randTreatModel)
intervals(randTreatModel)

EBLUPs<-ranef(randTreatModel)
df<-cbind(df, randBasal=EBLUPs[,1], randCarb=rowSums(EBLUPs))
ggplot(df, aes(x=region, y=activate))+geom_point()

rat.brain$ttms<-factor(paste(as.character(rat.brain$region), as.character(rat.brain$treatment), sep=":"))
randTreatModel2<-lme(activate~ttms-1, random=~treatment|animal, method="REML", data=rat.brain)

anova(randTreatModel2,L=c(1,-1,1,-1,1,-1))

emmReg<-emmeans(randTreatModel, specs="region")

emmTreat<-emmeans(randTreatModel, specs="treatment")
emmRegTreat<-emmeans(randTreatModel, specs=c("region", "treatment"))
emmRegTreat
contrast(emmRegTreat, method = "pairwise", by="region")
contrast(emmRegTreat, method = "pairwise", by="treatment")

getVarCov(randTreatModel)
getVarCov(randTreatModel, type="conditional")
getVarCov(randTreatModel, type="marginal")
Z<-matrix(nrow=6, c(rep(1,6),rep(0,3), rep(1,3)), byrow = F)
G<-Z%*%R%*%t(Z)

# G + getVarCov(randTreatModel, type="conditional") =getVarCov(randTreatModel, type="marginal")

ICCBasal<-1284.3 /(1284.3 + 6371.3+538.9)
ICCBasal
ICCCarb<- (1284.3+ 6371.3) /(1284.3 + 6371.3+538.9)
ICCCarb

data("BtheB", package = "HSAUR2")
head(BtheB)
summary(BtheB)

BtheB$patient <- factor(rownames(BtheB), levels=rownames(BtheB))
nobs <- nrow(BtheB)
BtheB_long <- reshape(BtheB, idvar = "patient", varying = c( "bdi.2m", "bdi.3m", "bdi.5m", "bdi.8m"), direction = "long")
BtheB_long$time <-as.factor(BtheB_long$time )
levels(BtheB_long$time)<-c("2", "3", "5", "8")
BtheB_long$time <-as.numeric(as.character(BtheB_long$time))

head(BtheB_long)

BtheB_long<-na.omit(BtheB_long)
BtheB_long$patient<-factor(as.character(BtheB_long$patient))
library(ggplot2)
g<-ggplot(BtheB_long,aes(x=as.factor(time), y=bdi))+geom_boxplot()+facet_grid(~treatment)+labs(x="Mes", y="BDI")
ggsave(g, file="../Dropbox/CursoPG/github/RCourse/imagenes/boxplotBtB.png", height = 4, width=6,dpi=350)

g<-ggplot(BtheB_long,aes(x=as.factor(time), y=bdi, group=patient, color=patient))+geom_point()+geom_line()+facet_grid(treatment~length+drug)+theme(legend.position = "none")+labs(x="Mes", y="BDI")
ggsave(g, file="../Dropbox/CursoPG/github/RCourse/imagenes/pointsBtB.png", height = 4, width=6,dpi=350)
ggplot(BtheB_long,aes(x=bdi.pre, y=bdi, color=patient))+geom_point()+
    facet_grid(~time)+theme(legend.position = "none")+labs(x="BDI-pre", y="BDI")


g<-ggplot(BtheB_long,aes(x=as.factor(time), y=bdi, fill=treatment))+geom_boxplot()+facet_grid(length~drug)+theme(legend.position = "bottom")+labs(x="Mes", y="BDI", fill="Tratamiento")
ggsave(g, file="../Dropbox/CursoPG/github/RCourse/imagenes/boxplotBtB2.png", 
       height = 5.5, width=7,dpi=450)

g<-ggplot(BtheB_long,aes(x=as.factor(time), y=bdi, fill=treatment))+geom_boxplot()+facet_grid(length~drug)+theme(legend.position = "bottom")+labs(x="Mes", y="DBI", fill="Tratamiento")

library(nlme)
randomIntercept<-lme(bdi~time+length+treatment+drug+bdi.pre+length:treatment+treatment:drug+bdi.pre:length+bdi.pre:drug+bdi.pre:treatment+length:drug:treatment, 
                     random=~1|patient, data=BtheB_long, method = "REML")
randomSlope<-lme(bdi~time+length+treatment+drug+bdi.pre+length:treatment+treatment:drug+bdi.pre:length+bdi.pre:drug+bdi.pre:treatment+length:drug:treatment, 
                 random=~1+time|patient, data=BtheB_long, method = "REML")

stat<- -2*logLik(randomIntercept, REML=T)[1]+2*logLik(randomSlope,REML=T)[1]
mean(pchisq(stat,c(1,2),lower.tail = F))
# [1] 0.581104

summary(randomIntercept)
anova(randomIntercept)

df<-na.omit(BtheB_long)
df$residCond<-resid(randomIntercept, type="pearson")
df$predCond<-predict(randomIntercept)
g1<-ggplot(df, aes(sample=residCond))+geom_qq()+geom_qq_line()+labs(y="Cuantiles de Residuos de Pearson", x="Cuantiles teóricos")
g2<-ggplot(df, aes(x=predCond, y= residCond))+geom_point()+
    labs(x="Valores ajustados de BDI", y="Residuos de Pearson", color="Longitud depresión")+theme(legend.position = "bottom")
p1<-plot_grid(g1,g2, nrow=1, labels=c("A)", "B)"))
ggsave(p1, file="../Dropbox/CursoPG/github/RCourse/imagenes/diagBtB.jpg", height = 5, width=8, dpi=400)

df$residMarg<-resid(randomIntercept, type="pearson", level=0)
df$predMarg<-predict(randomIntercept, level=0)

g1<-ggplot(df, aes(x=length, y=residMarg, fill=length))+geom_boxplot()+
    labs(x="Longitud episodio depresión", y="Residuos de Pearson")+theme(legend.position="none")
g2<-ggplot(df, aes(x=length, y=residMarg, fill=treatment))+geom_boxplot()+
    labs(x="Longitud episodio depresión", y="Residuos de Pearson", fill="Tratamiento")+scale_x_discrete(labels = c("Yes" = "Sí","No" = "No"))+facet_wrap(~drug)
p<-plot_grid(g1,g2,labels=c("A)", "B)"), rel_widths = c(0.7,1))
ggsave(p, file="../Dropbox/CursoPG/github/RCourse/imagenes/linBtB.jpg", height = 5, width=8, dpi=400)

randomIntercept2<-lme(bdi~time+length+treatment+drug+bdi.pre+length:treatment+treatment:drug+bdi.pre:length+bdi.pre:drug+bdi.pre:treatment+length:drug:treatment, 
                     random=~1|patient, data=BtheB_long, method = "REML", 
                     weights = varIdent(form=~1|length*treatment))
summary(randomIntercept2)
anova(randomIntercept, randomIntercept2)

randomIntercept2A<-lme(bdi~time+length+treatment+drug+bdi.pre+length:treatment+treatment:drug+bdi.pre:length+bdi.pre:drug+bdi.pre:treatment+length:drug:treatment, 
                      random=~1|patient, data=BtheB_long, method = "REML", 
                      weights = varIdent(form=~1|treatment))

randomIntercept2B<-lme(bdi~time+length+treatment+drug+bdi.pre+length:treatment+treatment:drug+bdi.pre:length+bdi.pre:drug+bdi.pre:treatment+length:drug:treatment, 
                      random=~1|patient, data=BtheB_long, method = "REML", 
                      weights = varIdent(form=~1|length))
anova(randomIntercept2A, randomIntercept2)
anova(randomIntercept2B, randomIntercept2)

anova(randomIntercept2B)
# numDF denDF  F-value p-value
# (Intercept)               1   182 399.7588  <.0001
# time                      1   182  25.9702  <.0001
# length                    1    85   5.2283  0.0247
# treatment                 1    85   5.7780  0.0184
# drug                      1    85   0.0724  0.7885
# bdi.pre                   1    85  72.1002  <.0001
# length:treatment          1    85   3.6616  0.0590
# treatment:drug            1    85   1.2315  0.2703
# length:bdi.pre            1    85   2.4492  0.1213
# drug:bdi.pre              1    85   2.4471  0.1215
# treatment:bdi.pre         1    85   0.4931  0.4845
# length:treatment:drug     2    85   0.8083  0.4490
randomIntercept3<-lme(bdi~time+length+treatment+bdi.pre+length:treatment+bdi.pre:length, 
                       random=~1|patient, data=BtheB_long, method = "REML", 
                       weights = varIdent(form=~1|length))
stat<- -2*(logLik(randomIntercept3, REML=FALSE)[1]-logLik(randomIntercept2B, REML=FALSE)[1])
pchisq(stat, 6, lower.tail = FALSE)
# [1] 0.2614501

randomIntercept4<-lme(bdi~time+length+treatment+bdi.pre+length:treatment+bdi.pre:length, 
                      random=~1|patient, data=BtheB_long, method = "REML", 
                      weights = varPower(form=~bdi.pre|length))

anova(randomIntercept3)
# numDF denDF  F-value p-value
# (Intercept)          1   182 390.3914  <.0001
# time                 1   182  25.8843  <.0001
# length               1    91   5.0481  0.0271
# treatment            1    91   5.6174  0.0199
# bdi.pre              1    91  67.8173  <.0001
# length:treatment     1    91   3.2039  0.0768
# length:bdi.pre       1    91   3.9046  0.0512

df<-na.omit(BtheB_long)
df$residCond<-resid(randomIntercept3, type="pearson")
df$fittedCond<-predict(randomIntercept3)
g1<-ggplot(df, aes(sample=residCond, color=length))+geom_qq()+geom_qq_line()+
    labs(y="Cuantiles de Residuos de Pearson", x="Cuantiles teóricos")+facet_wrap(~length)+theme(legend.position="none")

g2<-ggplot(df, aes(x=fittedCond, y= residCond, color=length))+geom_point(size=2)+
    labs(x="Valores ajustados de BDI", y="Residuos de Pearson", color="Duración depresión")+
    theme(legend.position = "bottom")+facet_wrap(~length)
p<-plot_grid(g1,g2, nrow=2,labels=c("A)", "B)"))

ggsave(p, file="../Dropbox/CursoPG/github/RCourse/imagenes/diagBtB2.jpg", height = 9, width=9, dpi=400)


df$residMarg<-resid(randomIntercept3, type="pearson", level=0)
df$fittedMarg<-predict(randomIntercept3, level=0)
g1<-ggplot(df, aes(sample=residMarg, color=length))+geom_qq()+geom_qq_line()+
    labs(y="Cuantiles de Residuos Marginales de Pearson", x="Cuantiles teóricos")+facet_wrap(~length)+theme(legend.position="none")

g2<-ggplot(df, aes(x=fittedMarg, y= residMarg, color=length))+geom_point(size=2)+
    labs(x="Medias marginales de BDI", y="Residuos Marginales de Pearson", color="Duración depresión")+
    theme(legend.position = "bottom")+facet_wrap(~length)
p<-plot_grid(g1,g2, nrow=2,labels=c("A)", "B)"))

ggsave(p, file="../Dropbox/CursoPG/github/RCourse/imagenes/diagMargBtB2.jpg", height = 9, width=9, dpi=400)

linearModelCompSym<-gls(bdi~time+length+treatment+bdi.pre+length:treatment+bdi.pre:length, 
                      correlation = corCompSymm(form=~1|patient),
                      data=BtheB_long, method = "REML")
logLik(randomIntercept3, REML=T)
Z=model.matrix(~BtheB_long$patient-1)

logLik(linearModelCompSym, REML=T)

df<-na.omit(BtheB_long)
df$resid<-resid(randomIntercept3, type="pearson")
df$fitted<-predict(randomIntercept3)
df$resid2<-resid(linearModelCompSym, type="pearson")
df$fitted2<-predict(linearModelCompSym)

ggplot(df, aes(x=fitted2, y= resid2))+geom_point()+
    labs(x="Valores ajustados de BDI", y="Residuos de Pearson", color="Longitud depresión")+theme(legend.position = "bottom")

a<-ggplot(df, aes(sample=resid, color=treatLen))+geom_qq()+geom_qq_line()+labs(y="Cuantiles de Residuos de Pearson", x="Cuantiles teóricos")+facet_wrap(~treatLen)
b<-ggplot(df, aes(sample=resid2, color=treatLen))+geom_qq()+geom_qq_line()+labs(y="Cuantiles de Residuos de Pearson", x="Cuantiles teóricos")+facet_wrap(~treatLen)
c<-ggplot(df, aes(x=fitted2, y= resid2, color=length))+geom_point()+
    labs(x="Valores ajustados de BDI", y="Residuos de Pearson", color="Longitud depresión")+theme(legend.position = "bottom")+facet_wrap(~length)
d<-ggplot(df, aes(x=fitted, y= resid, color=length))+geom_point()+
    labs(x="Valores ajustados de BDI", y="Residuos de Pearson", color="Longitud depresión")+theme(legend.position = "bottom")+facet_wrap(~length)
p<-plot_grid(a,b,c,d, nrow=2)
p
ggplot(df, aes(x=fitted, y= resid, color=length))+geom_point()+
    labs(x="Valores ajustados de BDI", y="Residuos de Pearson", color="Longitud depresión")+theme(legend.position = "bottom")

a<-ggplot(df, aes(x=drug, y=resid, fill=length))+geom_boxplot()+
    labs(x="Prescripción fármacos", y="Residuos de Pearson")+
    theme(legend.position = "none")+scale_x_discrete(labels = c("Yes" = "Sí","No" = "No"))

b<-ggplot(df, aes(x=length, y=resid, fill=length))+geom_boxplot()+
    labs(x="Longitud depresión", y="Residuos de Pearson")+
    theme(legend.position = "none")
c<-ggplot(df, aes(x=treatment, y=resid, fill=length))+geom_boxplot()+
    labs(x="Tratamiento", y="Residuos de Pearson")+
    theme(legend.position = "none")
d<-ggplot(df, aes(x=as.factor(time), y=resid, color=length))+geom_boxplot()+
    labs(x="Tiempo", y="Residuos de Pearson")+
    theme(legend.position = "none")
e<-ggplot(df, aes(x=bdi.pre, y=resid, color=length))+geom_point()

library(cowplot)
p<-plot_grid(g,a,b,c,d,e, nrow=3)


compSym<-gls(bdi~time+length+treatment+bdi.pre+length:treatment+bdi.pre:length,
                      correlation=corCompSymm(form=~1|patient), 
             data=BtheB_long, method = "REML",
                      na.action = "na.omit", weights = varComb(varIdent(form=~1|length),
                                                               varPower(form=~bdi.pre)))
compSym2<-gls(bdi~time+length+treatment+bdi.pre+length:treatment+bdi.pre:length,  
             correlation=corCompSymm(form=~1|patient), 
             data=BtheB_long, method = "REML",
             na.action = "na.omit", weights =  varPower(form=~bdi.pre| length))

randomIntercept7<-gls(bdi~time+length+treatment+drug+bdi.pre+length:treatment, 
                      data=BtheB_long, method = "REML",
                      na.action = "na.omit", weights = varComb(varIdent(form=~1|length),
                                                               varPower(form=~bdi.pre)), 
                      correlation= corCompSymm(form=~1|patient))
randomIntercept8<-gls(bdi~time+bdi.pre, 
                      data=BtheB_long, method = "REML",
                      na.action = "na.omit", weights = varComb(varIdent(form=~1|length),
                                                               varPower(form=~bdi.pre)), 
                      correlation= corCompSymm(form=~1|patient))

anova(randomIntercept4, randomIntercept5)
anova(randomIntercept6, randomIntercept5)
anova(randomIntercept7, randomIntercept8)

stat<- -2*logLik(randomIntercept8, REML=F)[1]+2*logLik(randomIntercept7,REML=F)[1]
pchisq(stat,4,lower.tail = F)


shapiro.test(resid(randomIntercept9, type="pearson"))
shapiro.test(resid(randomIntercept7, type="pearson"))
shapiro.test(resid(randomIntercept8, type="pearson"))

qqnorm((resid(randomIntercept9, type="pearson")))
qqnorm((resid(randomIntercept7, type="pearson")))
qqnorm((resid(randomIntercept8, type="pearson")))

plot(fitted(compSym), resid(compSym, type="pearson"))
plot(fitted(randomIntercept7), resid(randomIntercept7, type="pearson"))
plot(fitted(randomIntercept8), resid(randomIntercept8, type="pearson"))
plot(fitted(randomIntercept9), resid(randomIntercept9, type="pearson"))
