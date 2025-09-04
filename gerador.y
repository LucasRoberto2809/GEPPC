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
}

%token T_INT T_COMMA
%token <int_val> T_NUMBER

// Regras e Lógica de Execução

%%

regra_inteiro: T_INT T_COMMA T_NUMBER T_COMMA T_NUMBER {
    int min = $3;
    int max = $5;
    int random_num = (random() % (max - min + 1)) + min;
    printf("%d\n", random_num);
};

%%

// Build-in Error Handler
int yyerror(char *s) {
    fprintf(stderr, "Erro de sintaxe: %s\n", s);
    return 0;
}

int main(int argc, char *argv[]) {
    srand(time(NULL));
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
