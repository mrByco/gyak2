#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <math.h>
#define ARRAY_LENGTH 6


int fillup (int min, int max)
{
    int range = (max - min);
    int div = RAND_MAX / range;
    int value = min + (rand()/ div);
    return value;
}
void scan_index (int *bottom, int *top)
{
    int ok;
    char ch;
    do
    {
        ok = 1;
        printf("Type two indexes of array (0-%d):\n", ARRAY_LENGTH - 1);
        int read_number_count = scanf("%d %d", bottom , top);
        if (read_number_count != 2  || *bottom < 0 || *bottom > *top || *top >= ARRAY_LENGTH)
        {
            printf("Wrong value!\n");
            ok = 0;
            while((ch=getchar()) != '\n');
        }
    }while(!ok);
    printf("\nValues read: %d-%d\n", *bottom, *top);
}

/*void print_values_between(int *array, int from, int to){
    int print_value = 0;
    for (int i = 0; i < ARRAY_LENGTH; i++){
        if (array[i] == array[from]){
            print_value = 1;
        }

        if (print_value == 1){
            printf("\n - %d", array[i]);
        }

        if (array[i] == array[to]){
            print_value = 0;
        }
    }
    printf("\n");
}*/

void print_values_between_simplified(int *array, int from, int to){
    for (int i = from; i <= to; i++){
        printf("   - %d\n", array[i]);
    }
}

int get_max_in_range(int *array, int from, int to){
    int max = 0;
    for (int i = from; i <= to; i++){
        if (array[i] > max){
            max = array[i];
        }
    }
    return max;
}

int main()
{
    int array[ARRAY_LENGTH];
    srand (time(NULL));

    int i, lower_value, higher_value;

    printf("The elements in the array:\n");

    for (i = 0; i < ARRAY_LENGTH; i++)
    {
        array[i] = fillup (1, 100);
        printf("%d\n", array[i]);
    }

    scan_index(&lower_value, &higher_value);
    print_values_between_simplified(array, lower_value, higher_value);

    int maxy = get_max_in_range(array, lower_value, higher_value);
    printf("%d", maxy);


    return 0;
}
