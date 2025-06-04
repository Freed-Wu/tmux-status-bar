%{
#include "backend.h"

extern unsigned int id;
extern int yylex();
%}

%token T_VAR T_ATTR T_CMD T_COLOR T_FUNC T_FUNC_END T_FUNC_SEP T_OTHER

%%

S: /* empty */
 | S T
 ;

T: T_VAR                            { cat(id, $1); }
 | T_ATTR                           { cat(id, $1); }
 | T_CMD                            { cat(id, $1); }
 | T_COLOR                          { cat(id, $1); }
 | T_OTHER                          { cat(id, $1); }
 | F                                {  }
 ;

F: T_FUNC_ TS T_FUNC_END_           {  }
 ;

T_FUNC_: T_FUNC                     { push(++id, $1); push(id, ""); }
       ;

T_FUNC_END_: T_FUNC_END             { push(id, $1); call(); }
           ;

TS: S                               {  }
  | TS T_FUNC_SEP_ S                {  }
  ;

T_FUNC_SEP_: T_FUNC_SEP             { push(id, $1); push(id, ""); }
           ;
