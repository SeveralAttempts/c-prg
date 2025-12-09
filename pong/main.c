#include <stdlib.h>
#include <stdbool.h>
#include "./game_engine/engine.h"

int main(int argc, char *argv[])
{
    // Court setup
    court court;
    court.width = 150;
    court.height = 35;
    court.player_bars_length = 1;
    court.left_player_pos = court.height / 2;
    court.right_player_pos = court.height / 2;
    court.ball_pos.x = court.width / 2;
    court.ball_pos.y = court.height / 2;
    court.ball_pos.is_left = true;
    court_field_create(&court);

    update(&court);   
    return EXIT_SUCCESS;
}

