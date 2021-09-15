#include <stdio.h>
#include <stdlib.h>
#include <math.h>


int main()
{
    double input_number, result;
    printf("Please type a number!\n");
    scanf("%lf", &input_number);
    result = sqrt(input_number);

    printf("The result: %lf", result);
    return 0;
}
