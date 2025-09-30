// Bibliotecas e definição de header

%{
#include "utilitarios.h"
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
	struct FloatParametros *float_p; 
	struct IntParametros *int_p; 
}

%token <int_val> T_NUMBER
%token T_COMMA
%token T_INT
%token T_FLOAT
%token T_ARRAY

%type <float_p> float_type
%type <int_p> int_type

// Regras e Lógica de Execução

%%

begin: out_int | out_float | array;

array: int_array| float_array;

int_array: T_ARRAY T_COMMA T_NUMBER T_COMMA int_type {
	/* array, len, int, min, max */
	int len = $3 - 1;
	int min = $5->min;
	int max = $5->max;
	for (int i=0; i<len; i++) {
		printf("%d ", int_random(min, max));
	}
	// ultimo elemento
	printf("%d\n", int_random(min, max));
};

float_array: T_ARRAY T_COMMA T_NUMBER T_COMMA float_type {
	/* array, len, float, decimal, min, max */
	int len = $3 - 1;
	int decimal = $5->decimal;
	int min = $5->min;
	int max = $5->max;
	for (int i=0; i<len; i++) {
		printf("%.*f ", decimal, float_random(decimal, min, max));
	}
	// ultimo elemento
	printf("%.*f\n", decimal, float_random(decimal, min, max));
};

out_float: float_type {
	/* float, decimal, min, max */
	int decimal = $1->decimal;
	int min = $1->min;
	int max = $1->max;
	printf("%.*f\n", decimal, float_random(decimal, min, max));
}

out_int: int_type {
	/* int, min, max */
	int min = $1->min;
	int max = $1->max;
	printf("%d\n", int_random(min, max));
}

float_type: T_FLOAT T_COMMA T_NUMBER T_COMMA T_NUMBER T_COMMA T_NUMBER {
	$$ = malloc(sizeof(struct FloatParametros));
	if($$ == NULL){ // error handling for malloc
		yyerror("Memory allocation failed\n");
	}
	$$->decimal = $3;
	$$->min = $5;
	$$->max = $7;
};

int_type: T_INT T_COMMA T_NUMBER T_COMMA T_NUMBER {
	$$ = malloc(sizeof(struct IntParametros));
	if($$ == NULL){ // error handling for malloc
		yyerror("Memory allocation failed\n");
	}
	$$->min = $3;
	$$->max = $5;
};

%%

// Build-in Error Handler
int yyerror(char *s) {
		fprintf(stderr, "Error: %s\n", s);
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
