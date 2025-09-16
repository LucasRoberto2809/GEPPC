// Bibliotecas e definição de header

%{
#include <stdio.h>
#include <stdlib.h>
#include <time.h>

extern int yylex();
extern int yyerror(char *s);
extern FILE *yyin;
%}

// Declaração de Tokens e União

%union {
		int int_val;
		float float_val;
}

%token T_INT
%token T_FLOAT
%token T_COMMA
%token <int_val> T_NUMBER

// Regras e Lógica de Execução

%%

inicio: regra_inteiro | regra_float;

regra_inteiro: T_INT T_COMMA T_NUMBER T_COMMA T_NUMBER {
						 /* int, -100, 100 */
		int min = $3;
		int max = $5;
		int random_num = (random() % (max - min + 1)) + min;
		printf("%d\n", random_num);
};

regra_float: T_FLOAT T_COMMA T_NUMBER T_COMMA T_NUMBER T_COMMA T_NUMBER {
					 /* float, 10, -100, 100 */
		int len = $3;
		int min = $5;
		int max = $7;
		double random_num = (double)(random() % (max - min + 1)) + min;
		int i=0, div=10.0;
		for (i=0; i<len; i++) {
			random_num += (double)(random() % 9)/ div;
			div *= 10.0;
		}
		printf("%.*f\n", len, random_num);
};

%%

// Build-in Error Handler
int yyerror(char *s) {
		fprintf(stderr, "Erro de sintaxe: %s\n", s);
		return 0;
}

int main(int argc, char *argv[]) {
		srand(time(NULL) + clock());
		if (argc > 1) {
				yyin = fopen(argv[1], "r");
				if (!yyin) {
						perror("Não foi possível abrir o arquivo de entrada");
						return -1;
				}
		}
		yyparse();
		return 0;
}
