#include <stdio.h>
#include <stdlib.h>

int main()
{
    FILE *fileptr = fopen("hello.txt", "wp");
    fprintf(fileptr, "%s", "Hello world!\n");
    int i = fclose(fileptr);
    printf("%d", i);

    return 0;
}
