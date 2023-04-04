# Conclusão

Esta pesquisa teve-se como finalidade verificar o ganho de peso em ratos quando medicados com aditivos que servem para o aumento de peso. O ensaio foi designado com 30 ratos
divididos igualmente em três grupos de medicamentos, sendo estes: controle (1), tiouracil (2) e tiroxina(3) dentro de cinco semanas. Durante a pesquisa, o grupo (3)
teve a perda de três animais (causa não identificada). Assim, concluiu-se a pesquisa com apenas 27 ratos.

Durante o estudo, conseguimos verificar através dos gráficos realizados que todos os grupos tiveram como resposta o aumento de peso durante cada semana, ou seja, 
o peso inicial do rato na semana inicial foi inferior ao dele mesmo no final do estudo.

Para propor nosso modelo de regressão misto, utilizamos o vetor de efeitos aleatórios associado ao rato (j) e ao tratamento (k). Posteriormente, identificamos o melhor modelo,
e realizamos seu diagnóstico, no qual encontramos que o rato *#19* não se adequava bem ao nosso modelo proposto. Entretanto, ao realizar-se a análise de influência, vimos 
que esta observação não interferia em nosso modelo proposto. 

![](https://raw.githubusercontent.com/alisondsl/RProjects/main/Dados%20Longitudinais/Estudo_Ratos/plot_ajuste_x_observado.png)

Como pode ser visto acima, nosso modelo se adequou bem aos dados, com os valores previsto quase semelhantes ao observados no estudo.

Por fim, podemos concluir, que independente do tratamento a ser realizado, todos os grupos causam aumento de peso corporal nos animais que participaram do estudo.
