# Conclusão

Esta análise é baseada no exemplo do livro da professora Clarice Demétrio, "Modelos Lineares Generalizados para Experimentação Agrícola".

O objetivo do trabalho é determinar a mortalidade de insetos quando expostos a inseticidas. Os grupos foram divididos em machos e fêmeas, com uma amostra de tamanho 20 para cada dosagem (1, 2, 4, 8, 16, 32). Diferentemente do que é ilustrado no livro, realizei a predição com base em um modelo específico para cada gênero do animal.

Nosso modelo se ajustou bem aos dados, demonstrando uma boa adaptação aos valores observados da proporção dos animais mortos.

![](https://raw.githubusercontent.com/alisondsl/RProjects/main/Regress%C3%A3o/MLG/Dose%20Letal/plot_binomialglm.png)

Por fim, o objetivo do estudo era identificar qual seria a dose letal para matar 50% dos insetos machos e fêmeas. Assim, determinamos que os valores da dosagem de inseticida seriam 9.38 para machos e 27.22 para fêmeas. Isso indica que, embora uma dosagem menor tenha sido suficiente para matar metade dos insetos fêmeas, há fatores que podem ter influenciado nisso, e o mais apropriado seria a dosagem de 27.22 do inseticida.
