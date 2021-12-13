#include <stdio.h>
#include <stdlib.h>
#include <math.h>

int main() {
    int array[] = {0, 1, 2, 3, 4, 23, 41, 23, 23, 2,3, 23, 32};

    printf("The lenght of the array is: %I64d\n\n", sizeof(array) / sizeof(array[0]));
    printf("%d\n", (int)pow(2, 10));
    printf("%f\n", sqrt(2));
    printf("%d\n\n\n", (int)fabs(-5464));

    inputBufferHacking();

    return 0;
}

void inputBufferHacking(){
    char c;
    do {
        printf("\nAdj meg egy karaktert: ");
        scanf("%c", &c); /* j� megold�s: scanf(" %c", &c); */
        printf("%c", c);
    } while (c!='z');
}

void myInputBufferHacking(){
    int a, b, c, d;
    scanf("%d %d", &a, &b);
    printf("a: %d, b: %d\n", a, b);

        char ch;
        while((c = getchar()) != '\n') {
            printf("%c", c);
        }

    char clearBuff;
    printf("Do you want to clear buffer before go on?(y/n): ");
    scanf("%c", &clearBuff);

    if (clearBuff == 'y') {
        char ch;
        while((ch = getchar()) != '\n') {
            printf("%c", ch);
        }
    }

    scanf("%d %d", &c, &d);
    printf("c: %d, d: %d", c, d);
}
