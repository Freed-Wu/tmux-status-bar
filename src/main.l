%{
#include "main.h"

#include "main.tab.h"
%}

%option noyywrap
%x COMMENT

%%

"# "                      BEGIN(COMMENT);
<COMMENT>[^\n]            {  }
<COMMENT>"\n"             BEGIN(0);
"\\\n"                    {  }
"#"[A-Z]                  { yylval = strdup(yytext); return T_VAR; } // #S, #W
"#["[^]]+"]"              { yylval = strdup(yytext); return T_ATTR; } // #[noreverse], #[fg=white,bg=red]
"#("[^)]+")"              { yylval = strdup(yytext); return T_CMD; } // #(ls)
"#{"[a-z0-9_-]+"}"        { yylval = strdup(yytext); return T_VAR; } // #{host}
"#"[a-f0-9]{6}            { yylval = strdup(yytext); return T_COLOR; } // #fffafa
"#{?"                     { yylval = strdup(yytext); return T_FUNC; }
"#{"[^?:}]+":"            { yylval = strdup(yytext); return T_FUNC; } // #{||:,}
"}"                       { yylval = strdup(yytext); return T_FUNC_END; }
","                       { yylval = strdup(yytext); return T_FUNC_SEP; }
";"                       { yylval = strdup(yytext); return T_FUNC_SEP; }
[^,;}#]                   { yylval = strdup(yytext); return T_OTHER; } /* catch-all for other characters */
