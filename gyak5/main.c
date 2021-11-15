#include <stdio.h>
#include <stdlib.h>
#include <time.h>

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
    printf("Start: %d, End: %d\n", start, end);

    int array[10];
    srand(time(NULL));
    for (int i = 0; i < 10; i++){
        array[i] = rand() % (end - start) + start;
        printf("%d ", array[i]);
    }

    printf("\n");

    // Count
    printf("Type a number! Elements will be counted below that number!");
    int upper_bound;
    scanf("%d", &upper_bound);
    int numbers_below = 0;
    for (int i = 0; i < 10; i++){
        if (array[i] < upper_bound){
            numbers_below++;
        }
    }
    printf("\nNumbers below: %d\n", numbers_below);

    // Min
    int min_result = array[0];
    for (int i = 1; i < 10; i++){
        if (array[i] < min_result){
            min_result = array[i];
        }
    }
    printf("\nMin: %d\n", min_result);


    // Array inverted
    int array_inverted[10];
    for (int i = 0; i < 10; i++){
        array_inverted[9 - i] = array[i];
    }

    printf("Inverted array: ");
    for (int i = 0; i < 10; i++){
        printf("%d ", array_inverted[i]);
    }

    // SUM
    // Multiply
    // MIN
    // MAX

    //Primszamszamlalos
    printf("Primek\n");
    int counter = 0, isPrime;
    for (int num = start; num < end; num++){
            isPrime = 1;
        for (int devider = 2; devider <= sqrt(num); devider++){
            if (num % devider == 0 || num == 1){
                isPrime = 0;
                break;
            }
        }
        if (isPrime){
            counter++;
            printf("%d ", num);
        }
    }
    return 0;

}
