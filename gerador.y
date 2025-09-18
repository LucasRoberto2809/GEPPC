// Bibliotecas e definição de header

%{
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include "utilitarios.h"

extern int yylex();
extern int yyerror(char *s);
extern FILE *yyin;
%}

// Declaração de Tokens e União

%union {
		int int_val;
}

%token <int_val> T_NUMBER
%token T_COMMA
%token T_INT
%token T_FLOAT
%token T_ARRAY

// Regras e Lógica de Execução

%%

inicio: regra_inteiro | regra_float | regra_array;

regra_array: regra_array_int | regra_array_float;

regra_array_int: T_ARRAY T_COMMA T_INT T_COMMA T_NUMBER T_COMMA T_NUMBER T_COMMA T_NUMBER {
					 /* array, int, len, min, max */
		for (int i=0; i<$5; i++) {
			printf("%d ", int_random($7, $9));
		}
		printf("\n");
};

regra_array_float: T_ARRAY T_COMMA T_FLOAT T_COMMA T_NUMBER T_COMMA T_NUMBER T_COMMA T_NUMBER T_COMMA T_NUMBER {
					 /* array, float, len, decimal, min, max */
		for (int i=0; i<$5; i++) {
			printf("%.*f ", $7, float_random($7, $9, $11));
		}
		printf("\n");
};

regra_inteiro: T_INT T_COMMA T_NUMBER T_COMMA T_NUMBER {
						 /* int, min, max */
		printf("%d\n", int_random($3, $5));
};

regra_float: T_FLOAT T_COMMA T_NUMBER T_COMMA T_NUMBER T_COMMA T_NUMBER {
					 /* float, decimal, min, max */
		printf("%.*f\n", $3, float_random($3, $5, $7));
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
