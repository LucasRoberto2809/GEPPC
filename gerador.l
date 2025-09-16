%{
#include "gerador.tab.h"
%}

%%

"i"|"int"|"inteiro" {
	return T_INT;
}

"f"|"float" {
	return T_FLOAT;
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
