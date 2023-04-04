
# Replicando exemplo 4.1 do Livro "MLG em Experimentação Agrícola" da Profa. Clarice Demétrio --------------------------------------

#Amostras de 20 insetos, Heliothis virescens (praga do algodão), resistentes a cypermethrin, 
#foram expostas a doses crescentes do inseticida, dois dias depois da emergência da pupa. 
#Após 72h foram contados os números de insetos mortos

#Objetivo: Dose Letal 50 para machos e femeas.


# Recriando o database ----------------------------------------------------

machos <- c(1,4,9,13,18,20)
femeas <- c(0,2,6,10,12,16)
doses <- c(1,2,4,8,16,32)

cbind(doses,machos,femeas)

m = 20 #insetos por amostra

d <- log(doses, base = 2)

pm <- machos/m #proporção de insetos machos mortos
pf <- femeas/m #proporção de insetos femeas mortos

df <- data.frame(doses,d,machos,pm,femeas,pf)


# Visualizando a proporção em relação ao sexo  ----------------------------------------------

plot(pm~d, ylim = c(0,1), pch = 19, col = "blue", xlab = "Log(Doses)", ylab = "Proporção de mortos",
     main = 'Relação dose (transformada) com porporção de insetos machos e fêmeas mortos')
points(pf~d, pch=17, col = "red")
legend(x = "topleft", legend = c("Macho", "Fêmea"), col = c("blue", "red"), pch = c(19,17),bty = "n")


# Modelo de acordo com o sexo ---------------------------------------------

## Macho
respm <- cbind(machos, m-machos);respm #animais mortos e vivos pós testagem

mod_macho <- glm(respm ~ d, family = binomial(link = "logit")) #Modelo Binomial com ligação natural
anova(mod_macho, test = "Chisq")
summary(mod_macho)


## Fêmea

respf <- cbind(femeas, m-femeas);respf #animais mortos e vivos pós testagem

mod_femea <- glm(respf ~ d, family = binomial(link = "logit")) #Modelo Binomial com ligação natural
anova(mod_femea, test = "Chisq")
summary(mod_femea)


# Colocando a curva ajustada no plot --------------------------------------
lines(spline(d, fitted(mod_femea)), col = "red")
lines(spline(d, fitted(mod_macho)), col = "blue")

###Assim, nosso modelo seria escrito por:
## Mod_femea = -2.9935 + 0.9060*d
## Mod_macho = -2.8186 + 1.2589*d



# Dose Letal para matar 50% -----------------------------------------------
require(MASS)

a = dose.p(mod_macho, cf = c(1,2), p = 1/2); a
exp(a)

b = dose.p(mod_femea, cf = c(1:2), p = 1/2); b
exp(b)


