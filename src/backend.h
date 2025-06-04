#ifndef BACKEND_H
#define BACKEND_H 1
#include <sys/cdefs.h>

#include "main.h"
__BEGIN_DECLS

#define BUFFER_SIZE 1024
#define STACK_NUMBER 32
#define STACK_DEPTH 32
#define LEFT_SEP  ""
#define RIGHT_SEP ""
#define FORMAT    " %s "

typedef enum {
  other,
  window_status_current_format_left,
  status_left,
  window_status_current_format_right,
  status_right
} func_type_t;

void cat(unsigned int id, YYSTYPE arg);
void push(unsigned int id, YYSTYPE arg);
void call();

__END_DECLS
#endif /* backend.h */
