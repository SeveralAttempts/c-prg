#include "engine.h"

void draw_court(court *court) {
    for (int i = 0; i < court->height; ++i) 
    {
        mvprintw(i, 0, "%s\n", court->court_field[i]);
    }

    refresh();
}

result set_ball(court *court) {
    court->court_field[court->ball_pos.y][court->ball_pos.x] = 'O';
    return (result){OK};
}

result set_left_player(court *court) {
    for (int i = 0; i < court->height; ++i) {
        court->court_field[i][0] = '#';
    }

    for (int i = 0; i < court->player_bars_length; ++i) {
        court->court_field[court->left_player_pos + i][0] = '|';
    }
    
    return (result){OK};
}

result set_right_player(court *court) {
    for (int i = 0; i < court->height; ++i) {
        court->court_field[i][court->width - 1] = '#';
    }

    for (int i = 0; i < court->player_bars_length; ++i) {
        court->court_field[court->right_player_pos + i][court->width - 1] = '|';
    }

    return (result){OK};
}

result court_field_create(court *court) {
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
    return (result){OK};
}

void update(court *court) {
    init_input();
    const int HOLD_DURATION = 200;
    while (true) {
        int key = read_key();
        if (key == '1') { 
            break;
        }

        move_bat(court, key);
        move_ball(court);
        draw_court(court);
        napms(16);
    }
    restore_terminal_settings();
}

void move_bat(court *court, int key) {
    int chunk = court->player_bars_length;

    if (key == 'q') {
        court->left_player_pos = 1;
    } 

    if (key == 'w') {
        court->left_player_pos = chunk + 1; // TODO: finish the function
    }

    if (key == 'e') {
        court->left_player_pos = chunk * 2 + 1;
    } 

    if (key == 'r') {
        court->left_player_pos = chunk * 3 + 1;
    }

    if (key == 'u') {
        court->right_player_pos = 1;
    } 

    if (key == 'i') {
        court->right_player_pos = chunk + 1;
    }

    if (key == 'o') {
        court->right_player_pos = chunk * 2 + 1;
    } 

    if (key == 'p') {
        court->right_player_pos = chunk * 3 + 1;
    }

    set_left_player(court);
    set_right_player(court);
}

void move_ball(court *court) {
    set_ball(court);   
}
