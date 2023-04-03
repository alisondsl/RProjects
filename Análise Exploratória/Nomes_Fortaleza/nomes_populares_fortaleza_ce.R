library(tidyverse)
library(readxl)

setwd("C:/Users/aliso/OneDrive/Documentos/Projetos R/Nomes-Populares")

nomes_br <- read_csv("C:/Users/aliso/OneDrive/Documentos/Projetos R/Nomes-Populares/quantidade_municipio_nome_2010.csv")

getmode <- function(v) {
  uniqv <- unique(v)
  uniqv[which.max(tabulate(match(v, uniqv)))]
}

nomes_fortaleza <- nomes_br %>%
  filter(id_municipio %in% c("2304400")) %>%
  mutate(
    id_municipio = ifelse(2304400, "FORTALEZA-CE")
  ) %>%
  arrange(desc(quantidade_nascimentos_ate_2010)) %>%
  filter(quantidade_nascimentos_ate_2010 >= 20000) %>%
  arrange(desc(quantidade_nascimentos_ate_2010)) %>%
  mutate(quantidade_nascimentos_ate_2010 = quantidade_nascimentos_ate_2010/1000)%>%
  mutate(nome = forcats::fct_reorder(nome, quantidade_nascimentos_ate_2010))


nomes_fortaleza %>%
  ggplot(aes(x=quantidade_nascimentos_ate_2010, y=nome))+
  geom_col(fill= "deepskyblue4", show.legend = FALSE)+
  labs(x="Quantidade de Registros (1000)", y="Nomes", 
       title ="Nomes mais populares em Fortaleza-CE até 2010", caption = "Fonte: Censo Demográfico IBGE 2010")+
  theme_light()






   


