#include "engine.h"

void draw_court(court *court) {
    for (int i = 0; i < court->height; ++i) 
    {
        printf("%s\n", court->court_field[i]);
    }
}

result draw_left_player(court *court) {
    result res;
    res.code = ERROR;
    
    for (int i = 0; i < court->height; ++i) {
        court->court_field[i][0] = '#';
    }

    for (int i = 0; i < court->player_bars_length; ++i) {
        court->court_field[court->left_player_pos + i][0] = '|';
    }
    
    res.code = OK;
    return res;
}

result draw_right_player(court *court) {
    result res;
    res.code = ERROR;
    
    for (int i = 0; i < court->height; ++i) {
        court->court_field[i][court->width - 1] = '#';
    }

    for (int i = 0; i < court->player_bars_length; ++i) {
        court->court_field[court->right_player_pos + i][court->width - 1] = '|';
    }

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
            if ((j == 0 || j == court->width - 1) && i != 0 && i != court->height - 1) {
                field[i][j] = '#';
            }
        }
    }

    court->court_field = field;
    res.code = OK;
    return res;
}

void update(court *court) {
    init_input();
    printf("\033[2J");
    printf("\033[?25l");
    while (true) {
        printf("\033[H"); // \033[2J <- cause blinking in WSL if add to the printf
        char key = read_key();
        move_bat(key, court);
        draw_court(court);
        usleep(40000);
    }
}

void move_bat(char key, court *court) {
    if (key == 'w') {
        court->left_player_pos = court->left_player_pos - 1 > 0 ? 
            court->left_player_pos - 1 : court->left_player_pos;
    } else if (key == 's') {
        court->left_player_pos = court->left_player_pos + 1 < court->height - court->player_bars_length ? 
            court->left_player_pos + 1 : court->left_player_pos;
    }

    if (key == 'o') {
        court->right_player_pos = court->right_player_pos - 1 > 0 ?
            court->right_player_pos - 1 : court->right_player_pos;
    } else if (key == 'l') {
        court->right_player_pos = court->right_player_pos + 1 < court->height - court->player_bars_length ?
            court->right_player_pos + 1 : court->right_player_pos;
    }

    draw_left_player(court);
    draw_right_player(court);
}

