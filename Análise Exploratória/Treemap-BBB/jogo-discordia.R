##install.packages("tidyverse")
install.packages("treemapify")

library(tidyverse)
library(treemapify)

setwd("C:/Users/aliso/OneDrive/Documentos/Projetos R/BBB")

jogo_discordia <- readxl::read_excel("C:/Users/aliso/OneDrive/Documentos/Projetos R/BBB/bbb_jogo_da_discordia.xlsx")

#Analisando frequência do dados
new_table <- jogo_discordia %>%
  select(Indicados, Plaquinha) 

sort(table(new_table$Indicados), decreasing = TRUE) #participantes mais citados
sort(table(new_table$Plaquinha), decreasing = TRUE) #plaquinhas mais usadas

#Iniciando a construção do 'treemap'

tab_treemap <- jogo_discordia %>%
  select(Indicados, Plaquinha) %>%
  table() %>%
  data.frame()

tab_treemap <- tab_treemap %>%
  filter(Freq >= 1) #excluindo variáveis que possuem frequência igual a zero


tab_treemap %>%
  ggplot(aes(area = Freq, fill = Plaquinha, label = Indicados, subgroup = Plaquinha)) + 
  geom_treemap()+
  geom_treemap_subgroup_text(place = "centre", grow = T, alpha = 0.5) +
  geom_treemap_text(colour = "white", place = "center", reflow = T) +
  labs(title = "Treemap do Jogo da Discórdia BBB 22") + 
  labs(subtitle ="Jogo da Discórdia do dia 07/02/2022") +
  theme(legend.position = "bottom")
  
