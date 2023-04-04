# Conclusão

Esta análise faz parte do exemplo do livro da professora Clarice Demétrio, Modelos Lineares Generalizados para Experimentação Agrícola.

O objetivo do trabalho trata-se em saber a mortalidade de insetos quando expostos a inseticidas. Os grupos foram dvididos em macho e fêmea com amostra de tamanho 20 para cada dosagem (1, 2, 4, 8, 16, 32). Diferentemente do ilustrado no livro, realizei a predição baseada em um modelo específico para cada gênero do animal.

Nosso modelo se adequou bem aos dados, ajustando-se interessatemente aos valores observados da proporção dos animais mortos. 

!
[](https://raw.githubusercontent.com/alisondsl/RProjects/main/Regress%C3%A3o/MLG/Dose%20Letal/plot_glmbinomial.png)

Por fim, o interesse do estudo era identificar qual seria a dose letal para matar 50% dos insetos machos e fêmeas. Assim, identificamos que os valores da dosagem de inseticida seria 9.38 para machos e 27.22 para fêmeas. Isso indica que apesar de uma dosagem menor ter matado metade dos insetos fêmeas temos fatores que podem ter influenciado nisto, e o adequado seria a dosagem de 27.22 do inseticida. 
