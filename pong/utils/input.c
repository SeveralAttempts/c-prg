#include "input.h"

struct termios original_termios;

void save_terminal_settings() {
    tcgetattr(STDIN_FILENO, &original_termios);
}

void restore_terminal_settings() {
    tcsetattr(STDIN_FILENO, TCSANOW, &original_termios);
}

void init_input() {
    save_terminal_settings();

    struct termios t = original_termios;
    tcgetattr(STDIN_FILENO, &t);
    t.c_lflag &= ~(ICANON | ECHO);    
    tcsetattr(STDIN_FILENO, TCSANOW, &t);

    fcntl(STDIN_FILENO, F_SETFL, O_NONBLOCK);
}

int read_key() {
    return getchar();
}
