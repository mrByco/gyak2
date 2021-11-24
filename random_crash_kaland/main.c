#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <math.h>
#define ARRAY_LENGTH 6

void scan_values (int *bottom, int *top)
{
    int ok;
    char ch;
    do
    {
        ok = 1;
        printf("Type two values between 100-1000:");
        if (scanf("%d %d", bottom, top ) !=2 || *bottom < 100 || *top > 1000 || *bottom > *top)
        {
            printf("Wrong value!\n");
            ok = 0;
            while((ch=getchar()) != '\n');
        }
    }
    while(!ok);
    printf("%d - %d", *bottom, *top);
}
void values_of_range (int* array, int from, int to)
{
    for (int i = 0 ; i < ARRAY_LENGTH; i++)
    {
        if (array[i] < to && array[i] > from)
        {
            printf("%d\n", array[i]);
        }
    }
}

void average ();

int main()
{
    int array [ARRAY_LENGTH];

    srand(time(NULL));
    int i = 0;
    int low_value, high_value;

    while(i < ARRAY_LENGTH)
    {
        array[i] = rand () % (1000-100-1)+100;
        if (array[i] % 2 == 0)
        {
            array[i] = array[i] - 1;
            printf("%d\n", array[i]);
            i++;
        }
    }

    scan_values(&low_value, &high_value);
    values_of_range(array, low_value, high_value);
    return 0;
}
