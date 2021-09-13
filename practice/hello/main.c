#include <stdio.h>
#include <stdlib.h>

int main()
{
    int a = 3;
    int b = 2;

    scanf("%d %d", &a, &b);

    printf("B is: %d and A is:%d\n", a, b);
    printf("If we multiply them we get: %d\n", a * b);

    printf("\nBy devision: %d\n", a / b);
    printf("\nAttempt x: %f\n", a / (float )b);
    printf("Attempt two: %f\n", (float) a / (float) b);


    printf("18.f: %f\n", 15);

    printf("THATS A FUNNY LANGUAGE :)");
    return 0;
}
