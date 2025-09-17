#!/bin/bash

# Compila o arquivo .y usando o bison e gera o parser e o arquivo de cabeçalho (.h)
bison -d gerador.y

# Compila o arquivo .l usando o flex e gera o analisador léxico
flex gerador.l

# Compila os arquivos C gerados pelo bison e flex e cria o executável
gcc gerador.tab.c lex.yy.c utilitarios.c -o gerador -lm

# Exibe uma mensagem de sucesso ou falha
if [ $? -eq 0 ]; then
	echo "Compilação concluída! O executável 'gerador' foi criado."
else
	echo "Erro: Falha na compilação. Verifique os erros do GCC acima."
	exit 1
fi
