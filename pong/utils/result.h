#ifndef RESULT_H
#define RESULT_H

#include <stdbool.h>

typedef enum {
    OK,
    ERROR
} result_code;

typedef struct 
{
    result_code code;
    char* message;
} result;

result result_create(result_code code, const char* message);
void result_clean(result *result);
bool result_is_ok(const result *result);
bool result_is_error(const result *result);
const char* result_get_message(const result *result);

#endif // RESULT_H

