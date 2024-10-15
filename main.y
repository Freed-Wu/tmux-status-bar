%{

#include <stdio.h>
#include <stdlib.h>

extern int yylex();
extern int yyparse();
extern FILE* yyin;

void yyerror(const char* s);
%}

%token T_LEFT T_RIGHT T_COLON T_SEMICOLON T_COMMA T_IDENTIFY

%start mainulation

%%

mainulation:
	   | mainulation line
;

line: "#{status-left:" sections "}" {}
;

sections: section ";" sections | section;

section: 

%%

int main() {
	yyin = stdin;

	do {
		yyparse();
	} while(!feof(yyin));

	return 0;
}

void yyerror(const char* s) {
	fprintf(stderr, "Parse error: %s\n", s);
	exit(1);
}
