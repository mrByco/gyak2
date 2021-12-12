#include <stdio.h>
#include "stdlib.h"
#include "time.h"
#include "math.h"
#include "string.h"

#define MIN_WEIGHT 30
#define MAX_WEIGHT 50
#define KID_COUNT 5

struct TT_DATA {
    int size;
    float *array;
} TT_DATA;

void fill_array_with_random_nums(float *array, int length, float min, float max);
void init_random();
float get_tti(float high, float weight);
void print_float_array(float *arr, int length);
void max_sort(float *arr, int length);
char* read_weight_category_text();
struct TT_DATA* filter_body_weights(float* tti_array, char *filter);
void print_to_file(struct TT_DATA *data);

int main() {
    float heights[] = {1.2f, 1.16f, 1.52f, 1.18f, 1.34f};
    float weights[KID_COUNT];

    init_random();
    fill_array_with_random_nums(weights, KID_COUNT, MIN_WEIGHT, MAX_WEIGHT);

    float tti_array[KID_COUNT];
    for (int i = 0; i < KID_COUNT; i++) {
        tti_array[i] = get_tti(heights[i], weights[i]);
    }

    print_float_array(tti_array, KID_COUNT);
    max_sort(tti_array, KID_COUNT);
    print_float_array(tti_array, KID_COUNT);

    char* str = read_weight_category_text();
    printf("Text is: %s", str);

    struct TT_DATA* data = filter_body_weights(tti_array, str);
    print_float_array(data->array, data->size);

    print_to_file(data);


    return 0;
}

void init_random() {
    srand(time(NULL));
}

void fill_array_with_random_nums(float *array, int length, float min, float max) {
    for (int i = 0; i < length; i++) {
        float normalized_random = (float) rand() / (float) RAND_MAX;
        array[i] = (normalized_random * (max - min) + min);
    }
}

float get_tti(float high, float weight) {
    return weight / pow(high, 2);
}

void print_float_array(float *arr, int length) {
    for (int i = 0; i < length; i++) {
        printf("\n%f", arr[i]);
    }
    printf("\n");
}

void max_sort(float *arr, int length) {
    for (int i = 0; i < length; i++) {
        int current_max_index = i;
        for (int j = i; j < length; j++) {
            if (arr[current_max_index] < arr[j]) {
                current_max_index = j;
            }
        }
        float temp = arr[i];
        arr[i] = arr[current_max_index];
        arr[current_max_index] = temp;
    }

}

char* read_weight_category_text(){
    char *str = malloc(12);
    int value_ok = 0;
    while (!value_ok){
        printf("Add meg a gyerek testsuly kategoriajat (sovany, normalis, dagi): ");
        scanf("%s", str);
        printf("\n");
        if (strcmp(str, "sovany") == 0 || strcmp(str, "normalis") == 0  || strcmp(str, "dagi") == 0 ){
            value_ok = 1;
        }
        while (getchar() != '\n');
    }
    return str;
}


struct TT_DATA* filter_body_weights(float* tti_array, char *filter){
    struct TT_DATA* data = malloc(sizeof(TT_DATA));
    float* tti_filtered = malloc(KID_COUNT * sizeof(float));
    data->size = 0;
    for (int i = 0; i < KID_COUNT; i++){
        if (strcmp("sovany", filter) == 0 && tti_array[i] < 18.5f){
            tti_filtered[data->size] = tti_array[i];
            data->size++;
        }
        else if (strcmp("normalis", filter) == 0 && tti_array[i] <= 25.f){
            tti_filtered[data->size] = tti_array[i];
            data->size++;
        }
        else if (tti_array[i] > 25.f) {
            tti_filtered[data->size] = tti_array[i];
            data->size++;
        }
    }
    data->array = tti_filtered;
    return data;
}

void print_to_file(struct TT_DATA *data){
    FILE *fptr = fopen("TT.txt", "wb");
    for (int i = 0; i < data->size; i++){
        fprintf(fptr, "%f\n", data->array[i]);
    }
    fclose(fptr);
}
