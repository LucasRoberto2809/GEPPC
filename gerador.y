// Bibliotecas e definição de header

%{
#include "utilitarios.h"

extern int yylex();
extern int yyerror(char *s);
extern FILE *yyin;

%}

// Declaração de Tokens e União

%union {
	int int_val;
	struct Parameters *parameters_ptr;
	struct Command *command_ptr;
}

%token <int_val> T_NUMBER
%token T_COMMA
%token T_INT
%token T_FLOAT
%token T_ARRAY

%type <command_ptr> begin
%type <command_ptr> program
%type <command_ptr> command
%type <command_ptr> out_int
%type <command_ptr> out_float
%type <command_ptr> array
%type <command_ptr> int_array
%type <command_ptr> float_array
%type <parameters_ptr> float_type
%type <parameters_ptr> int_type

// Regras e Lógica de Execução

%%

begin: program {
	run_command($1);
	clear_commands($1);
};

program: command {$$ = $1;}
			 | command program {$$ = link_command($1, $2);};

command: out_int {$$ = $1;}
			 | out_float {$$ = $1;}
			 | array {$$ = $1;};

array: int_array {$$ = $1;}
		 | float_array {$$ = $1;};

int_array: T_ARRAY T_COMMA T_NUMBER T_COMMA int_type {
	/* array, collumns, int, min, max */
	$5->rows = 1;
	$5->collumns = $3;
	$$ = make_command_node(NodeArray, *$5);
	free($5);
	}
	| T_ARRAY T_COMMA T_NUMBER T_COMMA T_NUMBER T_COMMA int_type { 
	/* array, lines, collumns, int, min, max */
	$7->rows = $3;
	$7->collumns = $5;
	$$ = make_command_node(NodeArray, *$7);
	free($7);
};

float_array: T_ARRAY T_COMMA T_NUMBER T_COMMA float_type {
	/* array, collumns, int, min, max */
	$5->rows = 1;
	$5->collumns = $3;
	$$ = make_command_node(NodeArray, *$5);
	free($5);
	}
	| T_ARRAY T_COMMA T_NUMBER T_COMMA T_NUMBER T_COMMA float_type { 
	/* array, lines, collumns, int, min, max */
	$7->rows = $3;
	$7->collumns = $5;
	$$ = make_command_node(NodeArray, *$7);
	free($7);
};

out_float: float_type {
	/* float, decimal, min, max */
	$$ = make_command_node(NodeFloat, *$1);
	free($1);
};

out_int: int_type {
	/* int, min, max */
	$$ = make_command_node(NodeInt, *$1);
	free($1);
};

float_type: T_FLOAT T_COMMA T_NUMBER T_COMMA T_NUMBER T_COMMA T_NUMBER {
	$$ = malloc(sizeof(Parameters));
	if ($$ == NULL) {
		yyerror("Failed to allocate memory");
	}
	$$->basic_type = BasicTypeFloat;
	$$->decimal = $3;
	$$->min = $5;
	$$->max = $7;
};

int_type: T_INT T_COMMA T_NUMBER T_COMMA T_NUMBER {
	$$ = malloc(sizeof(Parameters));
	if ($$ == NULL) {
		yyerror("Failed to allocate memory");
	}
	$$->basic_type = BasicTypeInt;
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
