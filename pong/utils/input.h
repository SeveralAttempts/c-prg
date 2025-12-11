#ifndef INPUT_H
#define INPUT_H

#include <ncurses.h>
#include <stdlib.h>

void init_input();
int read_key();
void restore_terminal_settings();

#endif // INPUT_H
