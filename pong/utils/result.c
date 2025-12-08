#include "result.h"
#include <stdlib.h>
#include <string.h>

result result_create(result_code code, const char* message) {
    result result;
    result.code = code;
    
    if (message != NULL) {
        result.message = malloc(strlen(message) + 1);
        if (result.message != NULL) {
            strcpy(result.message, message);    
        } else {
            result.message = "";
        }
    } else {
        result.message = "";
    }

    return result;
}

void result_clean(result *result) {
    if (result == NULL) {
         return;
    }
    
    if (result->message != NULL && result->message[0] != '\0') {
        free(result->message);
        result->message = NULL;
    }
}

bool result_is_ok(const result *result) {
    return result->code == OK ? true : false;
}

bool result_is_error(const result *result) {
    return result->code == ERROR ? true : false;
}

const char* result_get_message(const result *result) {
    return result != NULL && result->message != NULL ? result->message : "";
}
