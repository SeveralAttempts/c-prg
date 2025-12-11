#include "input.h"

void restore_terminal_settings() {
    endwin();
}

void init_input() {
    initscr(); 
    noecho(); 
    curs_set(0); 
    nodelay(stdscr, TRUE); 
    keypad(stdscr, TRUE);
    timeout(0);
}

int read_key() {
    return getch();
}

