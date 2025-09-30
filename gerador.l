%{
#include "gerador.tab.h"
%}

%%

"int" {
	return T_INT;
}

"float" {
	return T_FLOAT;
}

"array" {
	return T_ARRAY;
}

[-| ][0-9]+ {
	yylval.int_val = atoi(yytext);
	return T_NUMBER;
}

"," {
	return T_COMMA; 
}

[ \t]+ {
	/* ignora espaços e tabs */
}

.|\n {
	/* ignora qualquer outro caractere, incluindo quebra de linhas */
}

%%

int yywrap(void) {
	return 1;
}
