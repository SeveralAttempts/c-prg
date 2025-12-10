#ifndef ENGINE_H
#define ENGINE_H

#include "../utils/result.h"
#include "../utils/input.h"
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

typedef struct 
{
    int x;
    int y;
    bool is_left;
} ball_position;

typedef struct 
{
    int height;
    int width;
    int player_bars_length;
    int left_player_pos;
    int right_player_pos;
    ball_position ball_pos;
    char **court_field;
} court;

typedef struct
{
    int fps;
} game_settings;

void draw_court(court *court);
result draw_left_player(court *court);
result draw_right_player(court *court);
result draw_ball(court *court);
result court_field_create(court *court);
void update(court *court);
void move_bat(court *court, bool w, bool s, bool o, bool l);

#endif // ENGINE_H 

