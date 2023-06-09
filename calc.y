/*
	Paku
*/

%{

#define YYSTYPE double
#include <stdio.h>
#include "hash.h"

extern FILE* yyin;
extern char *yytext;
extern int yyleng;

//int yyerror(char *s, int linha, char *mensagem );
//int yyerror(char *msg, int error_line_number, char *error_msg);

void yyerror(char *s);
int yylex(void);
int yyparse();
char name[100];

//int errors = 0;
//char *teste;

%}

%token NUMBER EOL
%token PLUS MINUS DIVIDE TIMES
%token P_LEFT P_RIGHT

%left PLUS MINUS
%left TIMES DIVIDE
%left P_LEFT P_RIGHT ATRIBUTION
%left VAR PRINT_FUNCTION

//%locations
//%error-verbose

%%

STATEMENT:
	//STATEMENT EXPRESSION EOL {$$ = $2; printf("Resultado: %f\n", $2);}
	STATEMENT EXPRESSION EOL {$$ = $2;}
	|
	;

EXPRESSION:
	NUMBER {$$ = $1;}
	|	EXPRESSION PLUS EXPRESSION {$$ = $1 + $3;}
	|	EXPRESSION MINUS EXPRESSION {$$ = $1 - $3;}
	|	EXPRESSION TIMES EXPRESSION {$$ = $1 * $3;}
	|	EXPRESSION DIVIDE EXPRESSION {$$ = $1 / $3;}
	|	P_LEFT EXPRESSION P_RIGHT {$$ = $2;}
    |   ATRIBUTION EXPRESSION {$$ = $2; store_value();}
	|   VAR { define_variable();}
	|   PRINT_FUNCTION {print_value();}
	;


%%


int main(int argc, char *argv[])
{
	hash_table = (nodo_table*) malloc(max * sizeof(nodo_table));
    hash_initialize();

	if (argc == 1)
    {
		yyparse();
    }

	if (argc == 2)
	{
    	yyin = fopen(argv[1], "r");
		
		yyparse();
	}

	return 0;
}


void yyerror(char *s)
{
	printf("Error: %s\n", s);
}

void define_variable()
{
    int i, start, end = 0;
	char nome[100]= "";
	int e = 0;
	for (i = 0; i < yyleng; i++) {
		if (yytext[i] == ' ') start = i + 1;
			if (yytext[i] == ':') 
			{   
				end = i;
				break;
			}
	}
	for (i = start; i < yyleng; i++) {
		if (yytext[i] == "\n")
		  break;
		nome[e] = yytext[i];
		e++;
	}
	hash_insert(nome, "int", 0);
	e = 0;
}

void store_value()
{
	int i;
	char valor[100] = "";
	char variable_original[100] = "";
	int e = 0, int_char;
	for (i = -5; i < yyleng; i = i - 1) {
            int_char = yytext[i];
			if ((int_char >= 48) || (int_char == 95) || (int_char >= 65) || (int_char >= 97))
            {
              valor[e] = yytext[i];
			  e++;
			}
			else
			  break;

	for (int x = 0; x < strlen(valor); x++)
	{
		variable_original[x] = valor[strlen(valor) - 1 - x];
	}

}
	char value[8] = "";
	e = 0;
	for (i = 0; i < yyleng; i++) {
		{
			value[e] = yytext[i];
			e++;
		}
}

  hash_update(variable_original, atoi(value));
}

void print_value(){

	int y = 6, z = 0, data;
	char letter = yytext[y];
	char var[100] = "";

	while (letter != ')')
	{  
       var[z] = letter;
	   z++;
	   y++;
	   letter = yytext[y];
	}

    data = hash_get(var);
	printf("%d\n", data);
}

/*
int yyerror(char *s, int linha, char *mensagem ) 
{ 

	if ( s != NULL ) 
		if ( mensagem != NULL )
			if ( linha < 10000)
				printf ("Linha: %d ---------> ERRO: %s %s \n", linha, s );
	
	return 0;
}
*/