#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <math.h>

void initRand();
float* make_weights(float min, float max, int count);
void printArray(float* array, int count);
float get_tti(float height, float weight);
float sort_kid_arrays(float* tti_array, float* weight_array, float* height_array, int count);

int main()
{
    initRand();
    float heights[] = {1.2f, 1.16f, 1.52f, 1.18f, 1.34f};
    const int kidCount = sizeof(heights) / sizeof(float);
    float* weights = make_weights(35.f, 50.f, kidCount);
    printArray(heights, kidCount);
    printf("\n\n");
    printArray(weights, kidCount);

    float tti_array[kidCount];
    for (int i = 0; i < kidCount; i++){
        tti_array[i] = get_tti(heights[i], weights[i]);
    }
    printArray(tti_array, kidCount);

    for (int i = 0; i < kidCount; i++){
        printf("%.2f %.2f %.2f\n", heights[i], weights[i], tti_array[i]);
    }
    printf("\n");
    sort_kid_arrays(tti_array, weights, heights, kidCount);
    for (int i = 0; i < kidCount; i++){
        printf("%.2f %.2f %.2f\n", heights[i], weights[i], tti_array[i]);
    }
    printf("\n");
    printf("%-10s\t\t%-5s\n", "Kutya", "Cica");
    printf("-----------------------------------\n");
    printf("%-10d\t\t%-5d\n", 5421, 2242);
    printf("%-10d\t\t%-5d\n", 54, 2);
    printf("%-10d\t\t%-5d\n", 54654654, 245);

    return 0;
}

void initRand(){
    srand(time(NULL));
}

float* make_weights(float min, float max, int count){
    float* weights = malloc(count);
    for (int i = 0; i < count; i++){
        float random_normalized = (float)rand() / RAND_MAX;
        weights[i] = random_normalized * (max - min) + min;
    }
    return weights;
}

void printArray(float* array, int count){
    for (int i = 0; i < count; i++){
        printf("%.2f\n", array[i]);
    }
}

float get_tti(float height, float weight){
    return weight / pow(height, 2);
}

float sort_kid_arrays(float* tti_array, float* weight_array, float* height_array, int count){
    for (int i = 0; i < count - 1; i++){
        int max_index = i;
        float max = tti_array[i];
        for (int j = i + 1; j < count; j++){
            if (max < tti_array[j]){
                max_index = j;
                max = tti_array[j];
            }
        }
        if (max_index != i){
            float temp;

            temp = tti_array[i];
            tti_array[i] = tti_array[max_index];
            tti_array[max_index] = temp;

            temp = weight_array[i];
            weight_array[i] = weight_array[max_index];
            weight_array[max_index] = temp;

            temp = height_array[i];
            height_array[i] = height_array[max_index];
            height_array[max_index] = temp;
        }
    }
}
