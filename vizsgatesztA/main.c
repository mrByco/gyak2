#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <math.h>
#include <string.h>
#define KID_COUNT 5


void initRandom();
float* get_weights(int count, float min, float max);
void print_array(float *array, int length);
float get_tti(float height, float weight);
void max_sort(float *array, int count);
char* get_weight_category();
void print_to_file(float *array, int count);

int main()
{
    initRandom();

    float hights[] = {1.20f, 1.16f, 1.52f, 1.18f, 1.34f};
    float* weights = get_weights(KID_COUNT, 35.0f, 50.0f);

    float tti[KID_COUNT];
    for (int i = 0; i < KID_COUNT; i++){
        tti[i] = get_tti(hights[i], weights[i]);
    }

    max_sort(tti, KID_COUNT);
    print_array(tti, KID_COUNT);

    char* cat = get_weight_category();
    printf("%s", cat);

    print_to_file(tti, KID_COUNT);

    return 0;
}

void initRandom(){
    srand(time(NULL));
}

float* get_weights(int count, float min, float max){
    float* weight_array = malloc(count * sizeof(float));
    for (int i = 0; i < count; i++){
        float normal_random = (double)rand() / (double)RAND_MAX;
        weight_array[i] = normal_random * (max - min) + min;

    }
    return weight_array;
}

void print_array(float* array, int length){
    for (int i = 0; i < length; i++){
        printf("%.2f\n", array[i]);
    }
}

float get_tti(float height, float weight){
    return weight / pow(height, 2);
}

void max_sort(float *array, int count){
    for (int i = 0; i < count; i++){
        int minI = array[i];
        for (int j = i; j < count; j++){
            if (array[minI] < array[j]){
                minI = j;
            }
        }
        float temp = array[i];
        array[i] = array[minI];
        array[minI] = temp;
    }
}

char* get_weight_category(){
    int valueOk = 0;
    char cat[8];
    while(!valueOk){
        printf("\nIrj be egy elhizasi kategoriat (sovany, normalis vagy elhizott): ");
        scanf("%s", &cat);
        if (strcmp(cat, "sovany") == 0 || strcmp(cat, "normalis") == 0 || strcmp(cat, "elhizott") == 0){
            valueOk = 1;
        }
        while(getchar() != '\n');
    }
    printf("\n");
    char *copy = malloc(8);
    int i;
    strcpy(copy, cat);
    return copy;

}

void print_to_file(float *array, int count){
    FILE* fptr = fopen("tt.txt", "wb");
    for (int i = 0; i < count; i++){
        fprintf(fptr, "%.2f\n", array[i]);
    }
    fclose(fptr);
}


