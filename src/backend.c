#include <libgen.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>

#include "backend.h"

extern FILE *yyin, *yyout;
extern int yyparse();

static YYSTYPE stacks[STACK_NUMBER][STACK_DEPTH];
static unsigned int depths[STACK_NUMBER];
unsigned int id;

void cat(unsigned int id, YYSTYPE arg) {
  YYSTYPE *stack = stacks[id];
  strcat(stack[depths[id] - 1], arg);
}

void push(unsigned int id, YYSTYPE arg) {
  YYSTYPE *stack = stacks[id];
  stack[depths[id]++] = calloc(BUFFER_SIZE, sizeof(char));
  strcat(stack[depths[id] - 1], arg);
}

static YYSTYPE _sprintf(YYSTYPE *p, YYSTYPE format) {
  YYSTYPE text = *p;
  if (strcmp(format, "%s") == 0)
    return text;
  text = malloc(strlen(*p) + strlen(format) - 1);
  sprintf(text, format, *p);
  free(*p);
  *p = text;
  return text;
}

void call() {
  YYSTYPE *last_stack = stacks[id - 1];
  YYSTYPE *stack = stacks[id];
  YYSTYPE func_name = stack[0];
  YYSTYPE last_symbol = last_stack[depths[id - 1] - 1];
  YYSTYPE out = last_symbol + strlen(last_symbol);
  YYSTYPE format = FORMAT;
  YYSTYPE sep = LEFT_SEP;
  YYSTYPE fg, bg, text, last_bg = "";
  // first sep index
  int i = 2;
  func_type_t func_type = other;
  if (strcmp(func_name, "#{status-left:") == 0) {
    func_type = status_left;
  } else if (strcmp(func_name, "#{status-right:") == 0) {
    func_type = status_right;
  } else if (strcmp(func_name, "#{window-status-current-format-left:") == 0) {
    func_type = window_status_current_format_left;
  } else if (strcmp(func_name, "#{window-status-current-format-right:") == 0) {
    func_type = window_status_current_format_right;
  }
  // #{func_name: fg , bg , text }
  if (func_type && depths[id] < 7) {
    fprintf(stderr, "usage:  %sfg,bg,text}", func_name);
    func_type = other;
  }

  switch (func_type) {
  case other:
    for (int i = 0; i < depths[id]; ++i) {
      strcat(out, stack[i]);
      free(stack[i]);
    }
    depths[id--] = 0;
    return;
  case status_left:
    while (i < depths[id]) {
      fg = stack[i - 1];
      switch (stack[i][0]) {
      case ',':
        if (stack[i + 3] == NULL) {
          fprintf(stderr, "usage:  %sfg,bg,text}", func_name);
          exit(EXIT_FAILURE);
        }
        bg = stack[i + 1];
        text = _sprintf(&stack[i + 3], format);
#ifndef NDEBUG
        fprintf(stderr, "fg: %s, bg: %s, text: %s\n", fg, bg, text);
#endif
        if (last_bg[0])
          sprintf(out, "#[fg=%s,bg=%s]%s#[fg=%s]%s", last_bg, bg, sep, fg,
                  text);
        else
          sprintf(out, "#[fg=%s,bg=%s]%s", fg, bg, text);
        out += strlen(out);
        last_bg = bg;
        i += 6;
        break;
        // ';' or '}'
      default:
        if (strstr(fg, "%s"))
          format = fg;
        else
          sep = fg;
        i += 2;
      }
    }
    sprintf(out, "#[fg=%s,bg=default]%s", bg, sep);
  case window_status_current_format_left:
    while (i < depths[id]) {
      fg = stack[i - 1];
      switch (stack[i][0]) {
      case ',':
        if (stack[i + 3] == NULL) {
          fprintf(stderr, "usage:  %sfg,bg,text}", func_name);
          exit(EXIT_FAILURE);
        }
        bg = stack[i + 1];
        text = _sprintf(&stack[i + 3], format);
#ifndef NDEBUG
        fprintf(stderr, "fg: %s, bg: %s, text: %s\n", fg, bg, text);
#endif
        sprintf(out, "#[reverse,fg=%s]%s#[noreverse,fg=%s,bg=%s]%s", bg, sep,
                fg, bg, text);
        out += strlen(out);
        i += 6;
        break;
        // ';' or '}'
      default:
        if (strstr(fg, "%s"))
          format = fg;
        else
          sep = fg;
        i += 2;
      }
    }
    sprintf(out, "#[fg=%s,bg=default]%s", bg, sep);
  default:
    sep = RIGHT_SEP;
    while (i < depths[id]) {
      fg = stack[i - 1];
      switch (stack[i][0]) {
      case ',':
        if (stack[i + 3] == NULL) {
          fprintf(stderr, "usage:  %sfg,bg,text}", func_name);
          exit(EXIT_FAILURE);
        }
        bg = stack[i + 1];
        text = _sprintf(&stack[i + 3], format);
#ifndef NDEBUG
        fprintf(stderr, "fg: %s, bg: %s, text: %s\n", fg, bg, text);
#endif
        sprintf(out, "#[fg=%s]%s#[fg=%s]#[bg=%s]%s", bg, sep, fg, bg, text);
        out += strlen(out);
        i += 6;
        break;
        // ';' or '}'
      default:
        if (strstr(fg, "%s"))
          format = fg;
        else
          sep = fg;
        i += 2;
      }
    }
    if (func_type == window_status_current_format_right)
      sprintf(out, "#[fg=default]%s", sep);
  }

  for (int i = 0; i < depths[id]; ++i)
    free(stack[i]);
  depths[id--] = 0;
}

int main(int argc, char *argv[]) {
  switch (argc) {
  case 3:
    if (strcmp(argv[2], "-")) {
      yyout = fopen(argv[2], "w");
      if (yyout == NULL)
        err(2, "%s cannot be write", argv[2]);
    }
  case 2:
    if (strcmp(argv[1], "-")) {
      char *name = dirname(strdup(argv[1]));
      mkdir(name, 0644);
      yyin = fopen(argv[1], "r");
      if (yyin == NULL)
        err(3, "%s cannot be read", argv[1]);
    }
  case 1:
    break;
  default:
    fprintf(stderr, "usage: %s [input] [output]\n", argv[0]);
  }

  push(0, "");
  yyparse();
  for (int i = 0; i < depths[0]; i++)
    fprintf(yyout, "%s", stacks[0][i]);

  fclose(yyin);
  fclose(yyout);
  return EXIT_SUCCESS;
}
