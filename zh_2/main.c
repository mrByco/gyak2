#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#define ARRAY_LENGTH 6

void fill_array_with_random_odd(int *array);
void read_100_1000_interval(int *lower_bound, int *higher_bound);
void print_elements_in_range(int* array, int from, int to);
void print_average_of_elements_in_range(int* array, int from, int to);

int main() {
    int array[ARRAY_LENGTH];
    srand(time(NULL));
    fill_array_with_random_odd(array);
    for (int i = 0; i < ARRAY_LENGTH; i++) {
        printf("%d\n", array[i]);
    }
    int lower, higher;
    read_100_1000_interval(&lower, &higher);
    print_elements_in_range(array, lower, higher);
    print_average_of_elements_in_range(array, lower, higher);

}

void fill_array_with_random_odd(int *array) {
    for (int i = 0; i < ARRAY_LENGTH; i++) {
        int generated = (rand() % 899) + 100;
        if (generated % 2 == 0) {
            generated++;
        }
        array[i] = generated;
    }
}

void read_100_1000_interval(int *lower_bound, int *higher_bound) {
    int values_ok = 0;
    while (!values_ok) {
        printf("\nPlease enter an inteval between 100 and 1000 (215-785 format): ");
        int scan_res = scanf("%d-%d", lower_bound, higher_bound);
        if (*lower_bound < 100 || *higher_bound > 1000 || scan_res != 2 || *lower_bound >= *higher_bound){
            printf("\nWrong format!\n");
            while(getchar() != '\n');
        }else {
            values_ok = 1;
        }
    }
}

void print_elements_in_range(int *array, int from, int to){
    printf("Elements in the given range: \n");
    for (int i = 0; i < ARRAY_LENGTH; i++){
        if (array[i] > from && array[i] < to){
            printf("    -%d\n", array[i]);
        }
    }
}

void print_average_of_elements_in_range(int *array, int from, int to){
    int count = 0;
    for (int i = 0; i < ARRAY_LENGTH; i++){
        if (array[i] > from && array[i] < to){
            count++;
        }
    }
    printf("The elements in the range takes %.2lf percent of the whole array!\n", (double)count / (double)ARRAY_LENGTH * 100);
}
