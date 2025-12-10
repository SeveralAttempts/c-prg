#ifndef INPUT_H
#define INPUT_H

#include <fcntl.h>
#include <termios.h>
#include <unistd.h>
#include <stdio.h>

void init_input();
int read_key();
void restore_terminal_settings();
void save_terminal_settings();

#endif // INPUT_H
