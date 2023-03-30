/*
	Paku
*/

%{
#define YYSTYPE double
#include "calc.tab.h" 
#include <stdlib.h>

void yyerror(char *s); 

%}

%option case-insensitive
%option yylineno 

%%

[0-9]+("."[0-9]+)? 	{ yylval = atof(yytext); return NUMBER; }
[\n]				{ return EOL; }
[+]					{ return PLUS; }
[-]					{ return MINUS; }
[/]					{ return DIVIDE; }
[*]					{ return TIMES; }
[(]					{ return P_LEFT;}
[)]					{ return P_RIGHT;}
([A-Za-z_][A-Z_0-9a-z]*[ ]("->"))      					{return ATRIBUTION;}
(("int")[ ][A-Za-z_][A-Z_0-9a-z]*)    			{return VAR;}
("print"[(][A-Za-z_][A-Z_0-9a-z]*[)])    			{return PRINT_FUNCTION;}
[[:space:]]			;
.           		{}
%%

int yywrap()
{
	return 1;
}