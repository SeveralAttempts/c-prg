#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>

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
} court;

typedef struct
{
    int fps;
} game_settings;

void DrawCourt(int height, int width);

int main(int argc, char *argv[])
{
    // Court setup
    court court;
    court.width = 150;
    court.height = 35;
    court.player_bars_length = 5;
    court.left_player_pos = 4;
    court.right_player_pos = 47;
    court.ball_pos.x = court.width / 2;
    court.ball_pos.y = court.height / 2;
    court.ball_pos.is_left = true;

    DrawCourt(court.height, court.width);
    return EXIT_SUCCESS;
}

void DrawCourt(int height, int width)
{
    for (int i = 0; i < height; ++i) 
    {
        for (int j = 0; j < width; ++j) 
        {
            if (i == 0)
            {
                printf("\u2588");             
            }
            else if (i == height - 1)
            {
                printf("\u2588");
            }
            else 
            {
                if (j == 0)
                    printf("\u2588");
                else if (j == width - 1)
                    printf("\u2588");
                else
                    printf(" ");
            }
        }
        printf("\n");
    }
}

