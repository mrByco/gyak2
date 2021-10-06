#include <stdio.h>
#include <stdlib.h>

int main()
{
    int start, end, numbersOk, num_of_inputs;
    char ch;

    do {
        printf("\n Please enter two numbers for counting\n");

        num_of_inputs = scanf("%d %d", &start, &end);
        printf("Given %d numbers\n", num_of_inputs);

        if (num_of_inputs != 2){
            printf("Error! Two numbers needed.\n");
            while ((ch = getchar()) != '\n');
            continue;
        }
        if(start < 0 || end < 0){
            printf("Error! Positive numbers required!\n");
            continue;
        }
        if(end < start){
            printf("Error! End must be lower than start!\n");
            continue;
        }
        numbersOk = 1;
    } while (!numbersOk);


    printf("Start: %d, End: %d", start, end);
}
