data(prostate, package="faraway")

head(prostate)
# lcavol lweight age      lbph svi      lcp gleason pgg45     lpsa
# 1 -0.5798185  2.7695  50 -1.386294   0 -1.38629       6     0 -0.43078
# 2 -0.9942523  3.3196  58 -1.386294   0 -1.38629       6     0 -0.16252
# 3 -0.5108256  2.6912  74 -1.386294   0 -1.38629       7    20 -0.16252
# 4 -1.2039728  3.2828  58 -1.386294   0 -1.38629       6     0 -0.16252
# 5  0.7514161  3.4324  62 -1.386294   0 -1.38629       6     0  0.37156
# 6 -1.0498221  3.2288  50 -1.386294   0 -1.38629       6     0  0.76547
summary(prostate)
# lcavol           lweight           age             lbph              svi        
# Min.   :-1.3471   Min.   :2.375   Min.   :41.00   Min.   :-1.3863   Min.   :0.0000  
# 1st Qu.: 0.5128   1st Qu.:3.376   1st Qu.:60.00   1st Qu.:-1.3863   1st Qu.:0.0000  
# Median : 1.4469   Median :3.623   Median :65.00   Median : 0.3001   Median :0.0000  
# Mean   : 1.3500   Mean   :3.653   Mean   :63.87   Mean   : 0.1004   Mean   :0.2165  
# 3rd Qu.: 2.1270   3rd Qu.:3.878   3rd Qu.:68.00   3rd Qu.: 1.5581   3rd Qu.:0.0000  
# Max.   : 3.8210   Max.   :6.108   Max.   :79.00   Max.   : 2.3263   Max.   :1.0000  
# lcp             gleason          pgg45             lpsa        
# Min.   :-1.3863   Min.   :6.000   Min.   :  0.00   Min.   :-0.4308  
# 1st Qu.:-1.3863   1st Qu.:6.000   1st Qu.:  0.00   1st Qu.: 1.7317  
# Median :-0.7985   Median :7.000   Median : 15.00   Median : 2.5915  
# Mean   :-0.1794   Mean   :6.753   Mean   : 24.38   Mean   : 2.4784  
# 3rd Qu.: 1.1786   3rd Qu.:7.000   3rd Qu.: 40.00   3rd Qu.: 3.0564  
# Max.   : 2.9042   Max.   :9.000   Max.   :100.00   Max.   : 5.5829  

prostate$svi<-factor(prostate$svi)
levels(prostate$svi)<-c("No", "Yes")    
prostate$gleason<-factor(prostate$gleason)
levels(prostate$gleason)

library(ggplot2);library(cowplot)
df<-data.frame(psa=exp(prostate$lpsa), lpsa=prostate$lpsa)
g1<-ggplot(df, aes(x=1, y=psa))+geom_violin(fill="blue", color="blue", alpha=0.2, draw_quantiles =  c(0.25, 0.5, 0.75))+labs(x="")
g2<-ggplot(df, aes(x=1, y=lpsa))+geom_violin(fill="red", color="red", alpha=0.2, draw_quantiles  = c(0.25, 0.5, 0.75))+labs(x="")
p<-plot_grid(g1,g2, labels=c("A", "B"),nrow=1)
p

cor(prostate[,-c(5,7)])
# lcavol   lweight       age        lbph         lcp     pgg45      lpsa
# lcavol  1.00000000 0.1941284 0.2249999  0.02734971  0.67531058 0.4336522 0.7344603
# lweight 0.19412839 1.0000000 0.3075247  0.43493174  0.10023889 0.0508462 0.3541218
# age     0.22499988 0.3075247 1.0000000  0.35018592  0.12766778 0.2761124 0.1695929
# lbph    0.02734971 0.4349317 0.3501859  1.00000000 -0.00699944 0.0784600 0.1798095
# lcp     0.67531058 0.1002389 0.1276678 -0.00699944  1.00000000 0.6315281 0.5488132
# pgg45   0.43365224 0.0508462 0.2761124  0.07846000  0.63152807 1.0000000 0.4223157
# lpsa    0.73446028 0.3541218 0.1695929  0.17980950  0.54881316 0.4223157 1.0000000
# 

g<-ggplot(prostate, aes(x=lcavol, y=lpsa))+geom_point(color="red")+labs(x="log(volumen tumoral)", y="log(concentración psa)")
modelo<-lm(lpsa~lcavol, data=prostate)
summary(modelo)
# Call:
#     lm(formula = lpsa ~ lcavol, data = prostate)
# 
# Residuals:
#     Min       1Q   Median       3Q      Max 
# -1.67625 -0.41648  0.09859  0.50709  1.89673 
# 
# Coefficients:
#     Estimate Std. Error t value Pr(>|t|)    
# (Intercept)  1.50730    0.12194   12.36   <2e-16 ***
#     lcavol       0.71932    0.06819   10.55   <2e-16 ***
#     ---
#     Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
# 
# Residual standard error: 0.7875 on 95 degrees of freedom
# Multiple R-squared:  0.5394,	Adjusted R-squared:  0.5346 
# F-statistic: 111.3 on 1 and 95 DF,  p-value: < 2.2e-16

summary(modelo$residuals)
# Min.  1st Qu.   Median     Mean  3rd Qu.     Max. 
# -1.67625 -0.41648  0.09859  0.00000  0.50709  1.89673

coeficientes<-coefficients(modelo)
coeficientes
# (Intercept)      lcavol 
# 1.5072979   0.7193201 

ggplot(prostate, aes(x=lcavol, y=lpsa))+geom_point(color="red")+geom_abline(intercept=1.507, slope=0.7193, color="blue")
ggplot(prostate, aes(x=lcavol, y=lpsa))+geom_point(color="red")+geom_smooth(method="lm")

X<-model.matrix(modelo)
RSS<-sum(residuals(modelo)^2)
sigma2Hat<-RSS/(modelo$df.residual)
EEB<-sqrt(diag(solve(t(X)%*%X))*sigma2Hat)
desvio<-sqrt(diag(X%*%diag(EEB^2)%*%t(X)))

t_alp<-qt(0.975, df=modelo$df.residual)
supCB<-predict(modelo)+desvio*t_alp
infCB<-predict(modelo)-desvio*t_alp

ggplot(prostate)+geom_point(aes(x=lcavol, y=lpsa),color="red")+geom_abline(intercept=1.507, slope=0.7193, color="blue")+geom_line(aes(x=lcavol,y=supCB), color="green4")+geom_line(aes(x=lcavol,y=infCB), color="green4")+geom_smooth(method="lm",aes(x=lcavol, y=lpsa))

predict(modelo, newdata=data.frame(lcavol=2), interval = "confidence")

## diagnostic plot
X<-model.matrix(modelo)
RSS<-sum(residuals(modelo)^2)
sigma2Hat<-RSS/(modelo$df.residual)
hatXX<-X%*%solve(t(X)%*%X)%*%t(X)
dfResiduals<-residuals(modelo)/sqrt(sigma2Hat*(1-diag(hatXX)))
ggplot(data.frame(residuals=dfResiduals), aes(sample=residuals))+stat_qq(distribution = qnorm)+ stat_qq_line()
shapiro.test(residuals(modelo))

# Shapiro-Wilk normality test
# 
# data:  residuals(modelo)
# W = 0.97985, p-value = 0.1419
ggplot(data.frame(residuals=dfResiduals, predicted=fitted(modelo)), aes(x=predicted, y=residuals))+geom_point(color="blue")+labs(y="Residuos estandarizados", x="Valores predichos")

# beta tests

EEB<-sqrt(diag(solve(t(X)%*%X))*sigma2Hat)
tB<-coeficientes/EEB
pB<-2*pt(abs(tB), modelo$df.residual,lower.tail=FALSE)

tB;pB

Yobs<-matrix(prostate$lpsa, ncol=1)
TSS<-t(Yobs-mean(Yobs))%*%(Yobs-mean(Yobs))

R2<-1-RSS/TSS
R2

n<-nrow(prostate)
R_adj<-1-(1-R2)*(n-1)/(modelo$df.residual)
R_adj

W<-tB[2]^2
pW<-1-pf(W, 1, modelo$df.residual)
W;pW

RMS<-t(Yobs-mean(Yobs))%*%hatXX%*%(Yobs-mean(Yobs))
W<-modelo$df.residual/length(coeficientes-1)*RMS/RSS

anova(lm(lpsa ~ 1, data = prostate), lm(lpsa~lcavol, data=prostate))


multipleReg<-lm(lpsa~lcavol+lweight+age+lbph+lcp+pgg45, data=prostate)
summary(multipleReg)

multipleRegSimpl<-lm(lpsa~lcavol+lweight, data=prostate)
summary(multipleRegSimpl)

X<-model.matrix(multipleRegSimpl)
P<-X%*%solve(t(X)%*%X)%*%t(X)
leverage<-diag(P)
plot(leverage)
sum(leverage)
# [1] 3
2*mean(leverage) # punto de corte
# [1] 0.06185567
plot(leverage)
abline(h=0.06185567, col="violet", lwd=3)

idx<-which(leverage >0.1)


multipleRegSimpl2<-lm(lpsa~lcavol+lweight, data=prostate[-idx,])
summary(multipleRegSimpl2)

X<-model.matrix(multipleRegSimpl2)
P<-X%*%solve(t(X)%*%X)%*%t(X)
leverage<-diag(P)
plot(leverage)
sum(leverage)
# [1] 3
2*mean(leverage) # punto de corte
#[1] 0.06741573
plot(leverage)
abline(h=0.06741573, col="violet", lwd=3)


null_model = lm(lpsa ~ 1, data = prostate)
full_model = lm(lpsa ~lcavol+lweight, data = prostate)
anova(null_model, full_model)
# Analysis of Variance Table
# 
# Model 1: lpsa ~ 1
# Model 2: lpsa ~ lcavol + lweight
# Res.Df     RSS Df Sum of Sq      F    Pr(>F)    
# 1     96 127.918                                  
# 2     94  52.966  2    74.951 66.509 < 2.2e-16 ***
#     ---
#     Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

RMS<-sum((fitted(full_model)-fitted(null_model))^2)
RMS
# [1] 74.95133
RSS<-sum(residuals(full_model)^2)
RSS 
# [1] 52.96626
total<-sum(residuals(null_model)^2) 
total
# [1] 127.9176
GDL_regresion<-length(coef(full_model))-length(coef(null_model))
GDL_regresion
# [1] 2
GDL_error<-length(residuals(full_model))-length(coef(full_model))
GDL_error
# [1] 94
GDL_total<-length(residuals(null_model))-length(coef(null_model))
GDL_total
# [1] 96
F_stat<-(RMS/GDL_regresion)/(RSS/GDL_error) 
F_stat
# [1] 66.50861
p_val<-1-pf(F_stat, GDL_regresion, GDL_error)
p_val
# [1] 0

anova(multipleRegSimpl, multipleReg)
# Analysis of Variance Table
# 
# Model 1: lpsa ~ lcavol + lweight
# Model 2: lpsa ~ lcavol + lweight + age + lbph + lcp + pgg45
# Res.Df    RSS Df Sum of Sq      F Pr(>F)
# 1     94 52.966                           
# 2     90 49.103  4    3.8635 1.7704 0.1417

SSD<-sum((fitted(multipleReg)-fitted(multipleRegSimpl))^2)
SSD
# [1] 3.863546
SSE<-sum(residuals(multipleReg)^2)
SSE 
# [1] 49.10271
nulo<-sum(residuals(multipleRegSimpl)^2) 
nulo
# [1] 52.96626
GDL_diff<-length(coef(multipleReg))-length(coef(multipleRegSimpl))
GDL_diff
# [1] 4
GDL_completo<-length(residuals(multipleReg))-length(coef(multipleReg))
GDL_completo
# [1] 90
GDL_nulo<-length(residuals(multipleRegSimpl))-length(coef(multipleRegSimpl))
GDL_nulo
# [1] 94
F_stat<-(SSD/GDL_diff)/(SSE/GDL_completo) 
F_stat
# [1] 1.770366
p_val<-1-pf(F_stat, GDL_diff, GDL_completo)
p_val
# 0.1417332

cavol=exp(mean(prostate$lcavol))
    weight=exp(mean(prostate$lweight))
exp(-0.30262)*(cavol^0.67753*weight^0.51095)


# Prediction bands
#  tengo que sumarle al valor esperado la variabilidad suya y la del error, la cov es cero entre ellos, con los residuos NO
X<-model.matrix(multipleRegSimpl)
RSS<-sum(residuals(multipleRegSimpl)^2)
sigma2Hat<-RSS/(multipleRegSimpl$df.residual)
hatXX<-diag(X%*%solve(t(X)%*%X)%*%t(X))
pred<-X%*%matrix(coef(multipleRegSimpl), ncol=1)

EE_pred<-sqrt(sigma2Hat*(1+hatXX))
t_IC<-qt(0.975,multipleRegSimpl$df.residual, lower.tail = TRUE)
IC_upper<-pred+t_IC*EE_pred
IC_lower<-pred-t_IC*EE_pred
predictions<-data.frame(lower=IC_upper, predicted=pred, upper=IC_upper)
head(predictions)
# lower predicted    upper
# 1 -0.8158328 0.7196150 2.255063
# 2 -0.8090749 0.7198989 2.248873
# 3 -0.8117645 0.7263521 2.264469
# 4 -0.9757429 0.5590050 2.093753
# 5  0.4592342 1.9602684 3.461303
# 6 -0.8955677 0.6358548 2.167277


table(prostate$svi)

# 0  1 
# 76 21 
table(prostate$gleason)

# 6  7  8  9 
# 35 56  1  5 

ggplot(prostate, aes(x=lcavol, y=lpsa, color=gleason, shape=svi))+geom_point(size=2, alpha=0.7)+scale_color_manual("Gleason", values = c("6"="red", "7"="blue", "8"="green4", "9"="orange"))


modelo<-lm(lpsa~lcavol, data=prostate)
coefficients(modelo)
# (Intercept)      lcavol 
# 1.5072979   0.7193201 
ggplot(prostate, aes(x=lcavol, y=lpsa, shape=svi))+geom_point(size=2, color="red")+geom_abline(intercept = 1.5072979, slope = 0.7193201, color="blue", lwd=1.5, alpha=0.7)


modeloAditivo<-lm(lpsa~lcavol+svi, data=prostate)
modeloInteraccion<-lm(lpsa~lcavol+svi+lcavol*svi, data=prostate)
summary(modeloAditivo)

## diagnostic plot
dfResiduals<-rstandard(modeloAditivo)
g1<-ggplot(data.frame(residuals=dfResiduals), aes(sample=residuals))+stat_qq(distribution = qnorm)+ stat_qq_line()

g2<-ggplot(data.frame(residuals=dfResiduals, predicted=fitted(modeloAditivo)), aes(x=predicted, y=residuals))+geom_point(color="blue")+labs(y="Residuos estandarizados", x="Valores predichos")

p<-plot_grid(g1,g2, labels=c("A", "B"))

shapiro.test(dfResiduals)

#Shapiro-Wilk normality test
# 
# data:  dfResiduals
# W = 0.97843, p-value = 0.1109

X<-model.matrix(modeloAditivo)
RSS<-sum(residuals(modeloAditivo)^2)
sigma2Hat<-RSS/(modeloAditivo$df.residual)
EEB<-sqrt(diag(solve(t(X)%*%X))*sigma2Hat)
desvio<-sqrt(diag(X%*%diag(EEB^2)%*%t(X)))

t_alp<-qt(0.975, df=modeloAditivo$df.residual)
supCB<-predict(modeloAditivo)+desvio*t_alp
infCB<-predict(modeloAditivo)-desvio*t_alp

g<-ggplot(prostate,aes(x=lcavol, y=lpsa, shape=svi, color=svi) )+geom_point(size=2)
g<-g+geom_segment(x=-1.34707, xend=3.246491, y=0.7352078, yend=3.457171, size=2, alpha=0.7, color="red")
g<-g+geom_segment(x=1.214913, xend=3.821004, y=2.923089, yend=4.467354, size=2, alpha=0.7, color="blue")

g+geom_line(aes(x=lcavol,y=supCB), color="black")+geom_line(aes(x=lcavol,y=infCB), color="black")

summary(modeloInteraccion)
dfResiduals<-rstandard(modeloInteraccion)
g1<-ggplot(data.frame(residuals=dfResiduals), aes(sample=residuals))+stat_qq(distribution = qnorm)+ stat_qq_line()

g2<-ggplot(data.frame(residuals=dfResiduals, predicted=fitted(modeloInteraccion)), aes(x=predicted, y=residuals))+geom_point(color="blue")+labs(y="Residuos estandarizados", x="Valores predichos")

p<-plot_grid(g1,g2, labels=c("A", "B"))

shapiro.test(dfResiduals)

anova(modeloAditivo, modeloInteraccion)
# Analysis of Variance Table
# 
# Model 1: lpsa ~ lcavol + svi
# Model 2: lpsa ~ lcavol + svi + lcavol * svi
# Res.Df    RSS Df Sum of Sq      F Pr(>F)
# 1     94 53.677                           
# 2     93 53.643  1  0.034187 0.0593 0.8082

modeloAditivoMultiple<-lm(lpsa~lcavol+svi+gleason, data=prostate)
summary(modeloAditivoMultiple)
anova(modeloAditivo, modeloAditivoMultiple)
modeloAditivoMultiple<-lm(lpsa~lcavol+lweight+svi, data=prostate)
summary(modeloAditivoMultiple)
anova(modeloAditivo, modeloAditivoMultiple)



##### Melatonin #####

melatonin<-data.frame(sleep=c(8.145150,7.522362,6.935754,8.959435,6.985122,8.072651,8.313826,8.086409, 8.922108, 8.124743,8.065844, 10.943974, 4.833367, 7.865453, 6.340014, 8.963140, 6.158896, 5.012253, 3.571440, 9.784136 ), group=factor(rep(c("control", "treatment"),10)))
ggplot(melatonin, aes(x=group, y=sleep, fill=group))+geom_boxplot()+theme(legend.position = "none")+labs(x="Grupo", y="Horas de sueño")+scale_x_discrete(labels=c("control"="Control", "treatment"="Tratados"))

# t.test(melatonin$sleep[melatonin$group=="control"], melatonin$sleep[melatonin$group=="treatment"])
t.test(sleep~group, data=melatonin, var.equal=TRUE)
# Two Sample t-test
# 
# data:  sleep by group
# t = -2.0854, df = 18, p-value = 0.05154
# alternative hypothesis: true difference in means is not equal to 0
# 95 percent confidence interval:
#     -3.02378251  0.01117551
# sample estimates:
#     mean in group control mean in group treatment 
# 6.827152                8.333456 

data(coagulation, package="faraway")
head(coagulation)
# coag diet
# 1   62    A
# 2   60    A
# 3   63    A
# 4   59    A
# 5   63    B
# 6   67    B
table(coagulation$diet)

# A B C D 
# 4 6 6 8 

ggplot(coagulation, aes(x=diet, y=coag, fill=diet))+geom_boxplot()+theme(legend.position = "none")+labs(x="Dieta", y="Tiempo de coagulación")

modelo<-lm(coag~diet, data=coagulation)
summary(modelo)
model.matrix(modelo)
# (Intercept) dietB dietC dietD
# 1            1     0     0     0
# 2            1     0     0     0
# 3            1     0     0     0
# 4            1     0     0     0
# 5            1     1     0     0
# 6            1     1     0     0
# 7            1     1     0     0
# 8            1     1     0     0
# 9            1     1     0     0
# 10           1     1     0     0
# 11           1     0     1     0
# 12           1     0     1     0
# 13           1     0     1     0
# 14           1     0     1     0
# 15           1     0     1     0
# 16           1     0     1     0
# 17           1     0     0     1
# 18           1     0     0     1
# 19           1     0     0     1
# 20           1     0     0     1
# 21           1     0     0     1
# 22           1     0     0     1
# 23           1     0     0     1
# 24           1     0     0     1
# attr(,"assign")
# [1] 0 1 1 1
# attr(,"contrasts")
# attr(,"contrasts")$`diet`
# [1] "contr.treatment"
anova(modelo)
# Analysis of Variance Table
# 
# Response: coag
# Df Sum Sq Mean Sq F value    Pr(>F)    
# diet       3    228    76.0  13.571 4.658e-05 ***
#     Residuals 20    112     5.6                      
# ---
#     Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
aov(coag~diet, data=coagulation)
summary(aov(coag~diet, data=coagulation))


dfResiduals<-rstandard(modelo)
g1<-ggplot(data.frame(residuals=dfResiduals), aes(sample=residuals))+stat_qq(distribution = qnorm, color="blue")+ stat_qq_line()
g2<-ggplot(data.frame(residuals=dfResiduals, predicted=fitted(modelo)), aes(x=predicted, y=residuals))+geom_point(color="blue")+labs(y="Residuos estandarizados", x="Valores predichos")
p<-plot_grid(g1,g2, labels=c("A)", "B)"), nrow=1)
shapiro.test(residuals(modelo))

# Shapiro-Wilk normality test
# 
# data:  residuals(modelo)
# W = 0.97831, p-value = 0.8629
med <- with (coagulation, tapply (coag, diet, median))
ar <- with (coagulation, abs (coag-med[diet] ) )
anova (lm(ar~diet, coagulation))
# Analysis of Variance Table
# 
# Response: ar
# Df Sum Sq Mean Sq F value Pr(>F)
# diet       3  4.333  1.4444  0.6492 0.5926
# Residuals 20 44.500  2.2250 

TukeyHSD(aov(coag~diet, data=coagulation), conf.level = 0.95)
# Tukey multiple comparisons of means
# 95% family-wise confidence level
# 
# Fit: aov(formula = coag ~ diet, data = coagulation)
# 
# $`diet`
# diff         lwr       upr     p adj
# B-A    5   0.7245544  9.275446 0.0183283
# C-A    7   2.7245544 11.275446 0.0009577
# D-A    0  -4.0560438  4.056044 1.0000000
# C-B    2  -1.8240748  5.824075 0.4766005
# D-B   -5  -8.5770944 -1.422906 0.0044114
# D-C   -7 -10.5770944 -3.422906 0.0001268

plot(TukeyHSD(aov(coag~diet, data=coagulation), conf.level = 0.95))


data(rats, package="faraway")
head(rats)
# time poison treat
# 1 0.31      I     A
# 2 0.82      I     B
# 3 0.43      I     C
# 4 0.45      I     D
# 5 0.45      I     A
# 6 1.10      I     B
# 
table(rats[,-1]) 
# treat
# poison A B C D
# I   4 4 4 4
# II  4 4 4 4
# III 4 4 4 4

g1<-ggplot(rats, aes(x = poison, y = time, color =treat, group = treat)) +
    stat_summary(fun.y = mean, geom = "point", size=2) +
    stat_summary(fun.y = mean, geom = "line", size=2)+labs(x="Veneno", y="Tiempo sobrevida", color="Tratamiento")

g2<-ggplot(rats, aes(x = treat, y = time, color =poison, group = poison)) +
    stat_summary(fun.y = mean, geom = "point", size=2) +
    stat_summary(fun.y = mean, geom = "line", size=2)+labs(x="Tratamiento", y="Tiempo sobrevida", color="Veneno")
p<-plot_grid(g1,g2, labels=c("A)", "B)"), nrow=1)
p

interactionModel<-lm(time~poison+treat+poison:treat, data=rats)
additiveModel<-lm(time~poison+treat, data=rats)
poisonModel<-lm(time~poison, data=rats)
treatModel<-lm(time~treat, data=rats)
nullModel<-lm(time~1, data=rats)

rats_table <-expand.grid(poison = unique(rats$poison), treat = unique(rats$treat))
rats_table
get_est_means = function(model, table) {
    mat = matrix(predict(model, table), nrow = 4, ncol = 3, byrow = TRUE)
    colnames(mat) = c("I", "II", "III")
    rownames(mat) = c("A", "B", "C", "D")
    mat
}
get_est_means(model = interactionModel, table = rats_table)
get_est_means(model = additiveModel, table = rats_table)
get_est_means(model = poisonModel, table = rats_table)
get_est_means(model = treatModel, table = rats_table)
get_est_means(model = nullModel, table = rats_table)

anova(additiveModel, interactionModel)
anova(additiveModel)


THSDAddMod<-TukeyHSD(aov(time ~ poison + treat, data = rats))
THSDAddMod

df<-as.data.frame(THSDAddMod[[1]])
df$group<-rownames(df)
g1<-ggplot(df, aes(x=group,y=diff))+geom_errorbar(aes(ymin=lwr, ymax=upr))+coord_flip()+labs(x="Diferencia de medias", y="Grupos", title="Factor Veneno")

df<-as.data.frame(THSDAddMod[[2]])
df$group<-rownames(df)
g2<-ggplot(df, aes(x=group,y=diff))+geom_errorbar(aes(ymin=lwr, ymax=upr))+coord_flip()+labs(x="Diferencia de medias", y="Grupos", title="Factor Tratamiento")
p<-plot_grid(g1,g2, nrow=1, labels=c("A)", "B)"))


rats$ltime<-log(rats$time)
g1<-ggplot(rats, aes(x = poison, y = ltime, color =treat, group = treat)) +
    stat_summary(fun.y = mean, geom = "point", size=2) +
    stat_summary(fun.y = mean, geom = "line", size=2)+labs(x="Veneno", y="log(Tiempo sobrevida)", color="Tratamiento")

g2<-ggplot(rats, aes(x = treat, y = ltime, color =poison, group = poison)) +
    stat_summary(fun.y = mean, geom = "point", size=2) +
    stat_summary(fun.y = mean, geom = "line", size=2)+labs(x="Tratamiento", y="log(Tiempo sobrevida)", color="Veneno")
p<-plot_grid(g1,g2, labels=c("A)", "B)"), nrow=1)
p

interactionModel<-lm(ltime~poison+treat+poison:treat, data=rats)
additiveModel<-lm(ltime~poison+treat, data=rats)
poisonModel<-lm(ltime~poison, data=rats)
treatModel<-lm(ltime~treat, data=rats)
nullModel<-lm(ltime~1, data=rats)

rats_table <-expand.grid(poison = unique(rats$poison), treat = unique(rats$treat))
rats_table
get_est_means = function(model, table) {
    mat = matrix(predict(model, table), nrow = 4, ncol = 3, byrow = TRUE)
    colnames(mat) = c("I", "II", "III")
    rownames(mat) = c("A", "B", "C", "D")
    mat
}
get_est_means(model = interactionModel, table = rats_table)
get_est_means(model = additiveModel, table = rats_table)
get_est_means(model = poisonModel, table = rats_table)
get_est_means(model = treatModel, table = rats_table)
# get_est_means(model = nullModel, table = rats_table)
# 
anova(additiveModel, interactionModel)
anova(additiveModel)


THSDAddMod<-TukeyHSD(aov(ltime ~ poison + treat, data = rats))
THSDAddMod

df<-as.data.frame(THSDAddMod[[1]])
df$group<-rownames(df)
g1<-ggplot(df, aes(x=group,y=diff))+geom_errorbar(aes(ymin=lwr, ymax=upr))+coord_flip()+labs(x="Diferencia de medias", y="Grupos", title="Factor Veneno")

df<-as.data.frame(THSDAddMod[[2]])
df$group<-rownames(df)
g2<-ggplot(df, aes(x=group,y=diff))+geom_errorbar(aes(ymin=lwr, ymax=upr))+coord_flip()+labs(x="Diferencia de medias", y="Grupos", title="Factor Tratamiento")
p<-plot_grid(g1,g2, nrow=1, labels=c("A)", "B)"))

