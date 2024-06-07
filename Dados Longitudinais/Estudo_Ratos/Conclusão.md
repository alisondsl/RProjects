# Conclusão

Esta pesquisa teve como finalidade verificar o ganho de peso em ratos quando medicados com aditivos destinados ao aumento de peso. O ensaio foi realizado com 30 ratos, divididos igualmente em três grupos de medicamentos: controle (1), tiouracil (2) e tiroxina (3), ao longo de cinco semanas. Durante a pesquisa, três animais do grupo (3) foram perdidos (a causa não foi identificada), resultando na conclusão da pesquisa com apenas 27 ratos.

Durante o estudo, verificamos por meio dos gráficos que todos os grupos apresentaram aumento de peso a cada semana; isto é, o peso inicial dos ratos na semana inicial foi inferior ao peso deles ao final do estudo.

Para propor nosso modelo de regressão mista, utilizamos o vetor de efeitos aleatórios associado ao rato (j) e ao tratamento (k). Posteriormente, identificamos o melhor modelo e realizamos seu diagnóstico, no qual encontramos que o rato *#19* não se ajustava bem ao nosso modelo proposto. No entanto, ao analisar a influência, verificamos que essa observação não afetava nosso modelo proposto.

![](https://raw.githubusercontent.com/alisondsl/RProjects/main/Dados%20Longitudinais/Estudo_Ratos/plot_ajuste_x_observado.png)

Como demonstrado acima, nosso modelo se ajustou bem aos dados, com os valores previstos sendo quase semelhantes aos observados no estudo.

Por fim, podemos concluir que, independentemente do tratamento realizado, todos os grupos causaram aumento de peso corporal nos animais que participaram do estudo.
