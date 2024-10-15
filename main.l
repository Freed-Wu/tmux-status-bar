%option noyywrap

#include <main.tab.h>

%%

"#{status-left:"                        return T_STATUS_LEFT;
"#{status-right:"                       return T_STATUS_RIGHT;
"#{window-status-current-format-left:"  return T_WINDOW_STATUS_CURRENT_FORMAT_LEFT;
"#{window-status-current-format-right:" return T_WINDOW_STATUS_CURRENT_FORMAT_RIGHT;
"#{"                                    return T_BEGIN;
"}"                                     return T_END;
";"                                     return T_SEMICOLON;
.                                       return T_IDENTIFY;
<<EOF>>                                 return T_EOF;
