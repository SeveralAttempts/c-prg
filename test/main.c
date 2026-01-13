#include <stdio.h>
#include <stdlib.h>

void difference_between_two_arrays() {
    int f_l, s_l = 0;
    char len_buf[14];
    fgets(len_buf, sizeof(len_buf), stdin);
    sscanf(len_buf, "%d %d", &f_l, &s_l);
    const int f = f_l * 2;
    const int s = s_l * 2;
    char f_buf[f];
    char s_buf[s];
    fgets(f_buf, sizeof(f_buf), stdin);
    fgets(s_buf, sizeof(s_buf), stdin);
    
}

int main(int argc, char *argv[]) {
    
    return EXIT_SUCCESS;
}
