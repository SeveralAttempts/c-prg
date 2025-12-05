#include <stdio.h>
#include <stdlib.h>

int main(int argc, char *argv[])
{
    if (argc == 2)
    {
        printf("What is %s?\n", argv[1]);
    }
    printf("%d\n", EXIT_SUCCESS);
    return EXIT_SUCCESS;
}
