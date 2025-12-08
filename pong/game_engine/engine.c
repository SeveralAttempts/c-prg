#include <stdio.h>
#include <stdlib.h>
#include "engine.h"

void draw_court(court *court) {
    for (int i = 0; i < court->height; ++i) 
    {
        for (int j = 0; j < court->width; ++j) 
        {
            printf("%c", court->court_field[i][j]);
        }
        printf("\n");
    }
}

result draw_left_player(court *court) {
    result res;
    res.code = ERROR;

    res.code = OK;
    return res;
}
result draw_right_player(court *court) {
    result res;
    res.code = ERROR;

    res.code = OK;
    return res;
}

result court_field_create(court *court) {
    result res;
    res.code = ERROR;

    char** field = malloc(court->height * sizeof(char*));

    for (int i = 0; i < court->width; ++i) {
        field[i] = malloc(court->width * sizeof(char));
    }

    for(int i = 0; i < court->height; ++i) {
        for (int j = 0; j < court-> width; ++j) {
            field[i][j] = i == 0 || i == court->height - 1 ? '#' : ' '; 
            if (j == 0 || j == court->width - 1 && i != 0 && i != court->height - 1) {
                field[i][j] = '#';
            }
        }
    }

    court->court_field = field;
    res.code = OK;
    return res;
}

void update(court *court) {
    while (true) {
        system("clear");
        draw_court(court);
    }
}

