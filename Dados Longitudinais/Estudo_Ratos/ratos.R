library(readxl)
library(tidyverse)
#install.packages("GGally")
library(GGally)
#install.packages("joineR")
library(joineR)
#install.packages("nlme")
library(nlme)

ratos <- read_excel("C:/Users/aliso/OneDrive/Documentos/ratos.xlsx")
head(ratos)
summary(ratos)

data_long <- gather(ratos, semana, peso, y1:y5, factor_key=TRUE)

data_long <- mutate(data_long[,-3], semana = as.numeric(data_long$semana))

#gráfico de correlação
ggpairs(ratos, columns = c(3:7), aes(color = factor(tto)),
        diag = list(continuous = wrap("densityDiag", alpha = .5)))

#perfis individuais por grupo 
ggplot(data_long, aes(x=semana,y=peso))+
  geom_line(aes(group=id))+
  geom_point()+
  facet_wrap(~tto)+
  labs(x="Semanas de tratamento", y="Peso (gramas)")+
  theme_bw()

#perfil médio por grupo 
ggplot(data_long, aes(x=semana,y=peso))+
  geom_line(aes(group=id))+
  geom_point()+
  stat_summary(fun.y=mean,geom="line",color = "red", size = 1.2)+
  geom_point()+
  facet_wrap(~tto)+
  labs(x="Semanas de tratamento", y="Peso (gramas)", 
       title = " Perfis individuais e médio para cada grupo (1 = Controle, 2 = Tiouracil, 3 = Tiroxina).")+
  theme_bw()

#perfil médio geral 
ggplot(data_long, aes(x=semana,y=peso))+
  stat_summary(fun.y=mean,geom="line",color = "red", size = 1.2)+
  labs(x="Semanas de tratamento", y="Peso (gramas)",
       title = 'Perfil médio geral')+
  theme_bw()

#boxplot
ggplot(data_long, aes(x=semana,y=peso,fill = as.factor(tto)))+
  geom_boxplot(aes(group = semana))+
  facet_wrap(~tto)+
  labs(fill = "Grupo", x = "Semanas de tratamento", y="Peso (gramas)",
       title= "Boxplot para cada grupo de tratamento semanalmente (1 = Controle, 2 = Tiouracil, 3 =
Tiroxina).")+
  theme_bw()

ggplot(data_long, aes(x=tto,y=peso,fill = as.factor(tto)))+
  geom_boxplot(aes(group = tto))+
  labs(fill = "Grupo", x = "Grupo", y="Peso (gramas)",
       title= "Boxplot para cada grupo de tratamento (1 = Controle, 2 = Tiouracil, 3 =
Tiroxina).")+
  theme_bw()

#algumas medidas
estatisticas <- data_long %>% # dados
  group_by(tto,semana) %>% # variável categórica, escala
  summarise(n = n(), # tamanho de cada grupo
            media = mean(peso), # média
            variancia = var(peso,na.rm = T), # variância
            desvio = sd(peso,na.rm = T), # desvio-padrão
            ep = desvio/sqrt(n), # erro-padrão
            mu.lower = media - ep*qt(0.975,n-1), # limites média
            mu.upper = media + ep*qt(0.975,n-1),
            var.lower = variancia*(n-1)/qchisq(.975,n-1), # limites variância
            var.upper = variancia*(n-1)/qchisq(.025,n-1))
estatisticas

#perfil medio com IC
ggplot(estatisticas,aes(x=semana,y=media,colour=as.factor(tto))) +
  geom_line(size=1) +
  geom_point(size=2.5) +
  geom_errorbar(aes(ymin = mu.lower, ymax = mu.upper),width =.2,size=1) +
  facet_wrap(~tto)+
  labs(colour="Grupo",x="Semanas de tratamento", y = "Peso (gramas)",
       title= "Intervalo de confiança para a média com 95% de confiança (1 = Controle, 2 = Tiouracil, 3 =
Tiroxina).")+
  theme_bw()

#variancia com IC
ggplot(estatisticas,aes(x=semana,y=variancia,colour=as.factor(tto))) +
  geom_line(size=1) +
  geom_point(size=2.5) +
  geom_errorbar(aes(ymin = var.lower, ymax = var.upper),width =.2,size=1) +
  facet_wrap(~tto)+
  labs(colour="Grupo",x="Semanas de tratamento", y = "Peso (gramas)",
       title = "Intervalo de confiança para a variância com 95% de confiança (1 = Controle, 2 = Tiouracil, 3 =
Tiroxina).")+
  theme_bw()

#variograma
attach(data_long)
var=variogram(id,semana,peso)
plot(var)

#Pelo variograma podemos adotar um modelo com correlação não-estruturada, AR ou ARMA

# ajuste  -----------------------------------------------------------------
#install.packages("nlme")
#library(nlme)
library(lme4)
model <- lmer(peso~semana+(1|id)+(1|tto), data=data_long)
summary(model)
######################################################################
#ajuste do modelo linear misto homocedastico
m0_lmHO <- lme(peso~semana,random=~1|id,
               correlation = corSymm(form = ~ 1 | id))
m1_lmHO <- lme(peso~semana,random=~1|id,
               correlation = corAR1(form = ~ 1 | id))
m2_lmHO <- lme(peso~semana,random=~1|id,
               correlation = corARMA(form = ~ 1 | id,p=1,q=1))

#ajuste do modelo linear misto heterocedastico
m0_lmHE <- lme(peso~semana,random=~1|id,
               correlation = corSymm(form = ~ 1 | id),
               weights = varIdent(form = ~semana))
m1_lmHE <- lme(peso~semana,random=~1|id,
               correlation = corAR1(form = ~ 1 | id),
               weights = varPower(form = ~semana))
m2_lmHE <- lme(peso~semana*tto,random=~1|id,
               correlation = corARMA(form = ~ 1 | id,p=1,q=1),
               weights = varPower(form = ~semana))

fit0_HO <- summary(m0_lmHO)
fit1_HO <- summary(m1_lmHO)
fit2_HO <- summary(m2_lmHO)

fit0_HE <- summary(m0_lmHE)
fit1_HE <- summary(m1_lmHE)
fit2_HE <- summary(m2_lmHE)

AIC <- c(fit0_HO$AIC,fit1_HO$AIC,fit2_HO$AIC,
         fit0_HE$AIC,fit1_HE$AIC,fit2_HE$AIC)
BIC <- c(fit0_HO$BIC,fit1_HO$BIC,fit2_HO$BIC,
         fit0_HE$BIC,fit1_HE$BIC,fit2_HE$BIC)

require(xtable)
(cbind(AIC,BIC))

################################################################

#Valores Preditos 

predito = fitted(model)
dados_preditos = data.frame(cbind(data_long[,-3],predito))
colnames(dados_preditos) = c("id","tto","semana","predito")


media <- dados_preditos %>% 
  group_by(semana) %>% 
  summarise(predito = mean(predito))
media

media1 <- data_long %>% 
  group_by(semana) %>% 
  summarise(peso = mean(peso))
media1

cbind(media1,media$predito)

ggplot(data_long, aes(x=semana,y=peso))+
  stat_summary(fun.y=mean,geom="line",color = "red", size = 1.2)+
  labs(x="Semanas de tratamento", y="Peso (gramas)", title = "Reta Ajustada (azul) vs Reta Observada (vermelho)")+
  geom_line(data = media, aes(x=semana,y=predito), colour = 'blue', size = 1.2,
            show.legend = FALSE)+
  theme_bw()
#Diagnostico

model <- lmer(peso~semana*tto+(1|id), data=data_long)

fit <- model
subject <- data_long$id


y<-as.vector(fit@resp$y)
X<-as.matrix(fit@pp$X)
Z<-t(as.matrix(fit@pp$Zt))
q<-length(ranef(fit))
n<-length(y)    # Number of cases
k<-length(as.numeric(names(table(subject)))) ## Number of subjects
ni<-(table (subject)) # vector with number of observation by subject
p<-ncol(X)    # Number of location parameters

## Estimate of sigma_e^2
se<-(attr(VarCorr(fit), "sc"))^2

## Estimate of the covariance matrix of conditional errors
sigma<- diag(n) # Homoskedastic conditional independence model.


## Estimate of the D matrix
d<-as.matrix(VarCorr(model)$id) # estimate to each subject
D<-as.matrix(kronecker(diag(k),d))


### Covariance matrix of Y
V<-Z%*%D%*%t(Z)+se*sigma
iv<-solve(V) # inverse of V

### Q matrix 

M<-solve(Z%*%D%*%t(Z)/se+sigma) 
Q<-M-M%*%X%*%solve(t(X)%*%M%*%X)%*%t(X)%*%M      

## EBLUE and EBLUP

eblue<-as.vector(fixef(fit))
eblup<-D%*%t(Z)%*%iv%*%(y-X%*%eblue) 



### Definir o vetor x_i (label of each subject)


### Residual analysis


predm<-X%*%eblue                   # predicted values for mean
predi<-X%*%eblue+Z%*%eblup         # predicted values by subject
resm<-(y-predm)                    # Marginal residual
resc<-(y-predi)                    # Conditional residuals

# Standardized conditional residuals

diaq<-diag(Q)
rescp<-resc/sqrt(se*diaq)           
l<-max(-min(rescp),max(rescp))

### Checking linearity of effects (Marginal residuals)


#diagresm<-diag(solve(M)%*%Q%*%solve(M)) 
plot(predm,resm,xlab="Valor Predito",ylab="Resíduo Marginal",pch=16)
abline(h=0,lty=2)

### Blup to detect outlying subjects 
q1<-length(eblup)/k ## Number of random effects
B=diag(as.vector(eblup))
aux=se*(D-D%*%t(Z)%*%Q%*%Z%*%D)
dmah=diag(t(B)%*%aux%*%B)
plot(dmah,ylab="Distância de Mahalanobis",xlab="Unidade Experimental",pch=16)
identify(dmah)

### Residuals for within-subjects covariance matrix
resmcov<-rep(0,k) 
auxni=as.vector(ni)
for (t in 1:k){
  li= sum(ni[1:t-1])+1
  ls= sum(ni[1:t])
  auxr1 <- eigen(V[li:ls,li:ls])
  auxr2 <- auxr1$vectors
  Vraiz<-auxr2%*%diag(sqrt(auxr1$values)) # V<-Vraiz%*%t(Vraiz)
  Vres2<-solve(Vraiz)%*%resm[li:ls]
  auxt=diag(ni[t])-Vres2%*%t(Vres2)
  a=as(auxt, "dpoMatrix") 
  resmcov[t]=norm(a,"F")
}
plot(resmcov,ylab="Residuals for covariance matrix structure",xlab="Subject",pch=16)
abline(h=10,lty=2)
for (i in 1:k){
  if (resmcov[i]>2*mean(resmcov)){
    text(i,resmcov[i]-2,i) # 
  }
}




### Standardized conditional residual

plot(rescp,xlab="Unidade Experimental",ylab="Resíduo Condicional Padronizado",pch=16,ylim=c(-l,l))
abline(h=3,lty=2)
abline(h=-3,lty=2)

auxqn<-svd(Q)$d
auxqn<-diag(auxqn[1:(n-p)])## Matriz Pi
mk<-svd(Q)$u[,1:(n-p)] 
resmc<-rep(0,(n-p)) 
identify(rescp)

### Obtaining the least confounded residuals

for (i in 1:(n-p)){
  resmc[i]<-auxqn[i,i]*t(mk[,i])%*%y
}
resmc<-resmc/sqrt(se)



### plot of the least confounded residuals  with 95%


#par(mfrow=c(1,1))

n1<-length(resmc)

epsilon <- matrix(0,n1,100)

e <- matrix(0,n1,100)

e1 <- numeric(n1)

e2 <- numeric(n1)

#

for(i in 1:100){
  epsilon[,i] <- rnorm(n1,0,1)
  
  e[,i] <- epsilon[,i]
  
  e[,i] <- e[,i]
  
  e[,i] <- sort(e[,i]) }

#

for(i in 1:n1){
  
  eo <- sort(e[i,])
  
  e1[i] <- eo[2]
  
  e2[i] <- eo[98] }

#

med <- apply(e,1,mean)

faixa <- range(resmc,e1,e2)

#

par(pty="s")

qqnorm(resmc,xlab="Quantis da N(0,1)",
       
       ylab="Resíduo com confundimento mínimo", ylim=faixa, pch=16)


par(new=T)

qqnorm(e1,axes=F,xlab="",ylab="",type="l",ylim=faixa,lty=1)

par(new=T)

qqnorm(e2,axes=F,xlab="",ylab="", type="l",ylim=faixa,lty=1)

par(new=T)

qqnorm(med,axes=F,xlab="",ylab="",type="l",ylim=faixa,lty=2)

#######################################################


#Excluindo a observação 
(1/27)*100 #influencia esperada 

ratos1 <- ratos[-19,]
attach(ratos1)

data_long1 <- gather(ratos1, semana, peso, y1:y5, factor_key=TRUE)

data_long1 <- mutate(data_long1[,-3], semana = as.numeric(data_long1$semana))

model1 <- lmer(peso~semana+(1|id)+(1|tto), data=data_long1)
summary(model)


#beta0
((31.4572-31.7765)/31.7765)*100
#beta1
((23.4692-23.1593)/23.1593)*100

c_19 <- data_long %>% 
  group_by(semana) %>% 
  filter(id == "19")
c_19

ggplot(data_long, aes(x=semana,y=peso))+
  stat_summary(fun.y=mean,geom="line",color = "red", size = 1.2)+
  labs(x="Semanas de tratamento", y="Peso (gramas)")+
  geom_line(data = c_19, aes(x=semana,y=peso), colour = 'orange', size = 1.2,
            show.legend = FALSE)+
  theme_bw()



