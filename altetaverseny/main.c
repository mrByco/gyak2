#include <stdio.h>
#include <stdlib.h>
#include <time.h>

#define JUMP_COUNT 3
#define MIN_JUMP 5.f
#define MAX_JUMP 7.f

float* get_float_array(int length, float min, float max);
void initRandom();
void print_results(int runner_id, float* array, int length);
void print_results_file(int runner_id, float* array, int length);
float get_best_result(float* array, int length);
int read_one_or_two_num();
int max_sort(float* array, int length);

float* get_common_jumps(float* jumpsA, float* jumpsB, int lenght);

// -1 if the a less, 0 if same, 1 if b less
int compare_float(float a, float b);

int main() {
    initRandom();
    //float* jumpsA = get_float_array(JUMP_COUNT, MIN_JUMP, MAX_JUMP);
    //float* jumpsB = get_float_array(JUMP_COUNT, MIN_JUMP, MAX_JUMP);
    float jumpsA[3] = {1.2f, 2.4f, 3.14f};
    float jumpsB[3] = {1.21f, 2.4f, 3.44f};

    print_results(1, jumpsA, JUMP_COUNT);
    print_results(2, jumpsB, JUMP_COUNT);

    print_results_file(1, jumpsA, JUMP_COUNT);
    print_results_file(2, jumpsB, JUMP_COUNT);

    printf("\n");

    float aMax = get_best_result(jumpsA, JUMP_COUNT);
    printf("1. versenyzo legjobb eredmeny: %.2f\n", aMax);
    float bMax = get_best_result(jumpsB, JUMP_COUNT);
    printf("2. versenyzo legjobb eredmeny: %.2f\n", bMax);

    int whoBest = compare_float(aMax, bMax);
    if (whoBest == -1) {
        printf("A 2. jatekos nyerte a versenyt!\n");
    } else if (whoBest == 1) {
        printf("Az 1. jatekos nyerte a versenyt!\n");
    } else {
        printf("Dontetlen!\n");
    }

    int num = read_one_or_two_num();
    float* winnerJumps = num == 1 ? jumpsA : jumpsB;
    max_sort(winnerJumps, JUMP_COUNT);

    print_results(1, winnerJumps, JUMP_COUNT);

    float* common = get_common_jumps(jumpsA, jumpsB, 3);

    for (int i = 0; i < 1; i++){
        printf("%.2f", common[i]);
    }
    return 0;
}

void initRandom() {
    srand(time(NULL));
}

float* get_float_array(int length, float min, float max) {
    float* array = malloc(sizeof(float) *length);
    for (int i = 0; i < length; i++) {
        float normalized = (float)rand() / RAND_MAX;
        array[i] = normalized * (max - min) + min;
    }
    return array;
}

void print_results(int runner_id, float* array, int length) {
    printf("%d", runner_id);
    printf(". versenyo: ");
    for (int i = 0; i < length; i++) {
        if (i != 0) {
            printf(", ");
        }
        printf("%.2f", array[i]);
    }
    printf("\n");
}

void print_results_file(int runner_id, float* array, int length) {
    FILE* file = fopen("results.txt", "wp");
    fprintf(file, "%d", runner_id);
    fprintf(file, ". versenyo: ");
    for (int i = 0; i < length; i++) {
        if (i != 0) {
            fprintf(file, ", ");
        }
        fprintf(file, "%.2f", array[i]);
    }
    fprintf(file, "\n");
    fclose(file);
}

float get_best_result(float* array, int length) {
    float max = array[0];
    for (int i = 0; i < length; i++) {
        if (max < array[i]) {
            max = array[i];
        }
    }
    return max;
}

int compare_float(float a, float b) {
    if (a == b) {
        return 0;
    }
    return a < b ? -1 : 1;
}

int read_one_or_two_num() {
    int valueOk = 0;
    int value;
    while(!valueOk) {
        printf("\nAdjon meg egy erteket (1 vagy 2): ");
        scanf("%d", &value);
        if (value == 1 || value == 2) {
            valueOk = 1;
        }
        while (getchar() != '\n');
    }
    printf("\n");
    return value;
}

int max_sort(float* array, int length) {
    for (int i = 0; i < length; i++) {
        int maxIndex = i;
        for (int j = i; j < length; j++) {
            if (array[maxIndex] < array[j]) {
                maxIndex = j;
            }
        }
        float temp = array[maxIndex];
        array[maxIndex] = array[i];
        array[i] = temp;
    }
}

float* get_common_jumps(float* jumpsA, float* jumpsB, int length) {
    int common_count = 0;
    float common[length];
    for (int i = 0; i < length; i++) {
        int same = 0;
        for (int j = 0; j < length; j++) {
            if (jumpsA[i] == jumpsB[j]) {
                same = 1;
            }
        }
        int contain_already = 0;
        for (int k = 1; k < length; k++) {
            if (jumpsA[i] == common[k]){
                contain_already = 1;
            }
        }
        if (!contain_already && same){
            common[common_count] = jumpsA[i];
            common_count++;
        }
    }
    float* result = malloc(common_count * sizeof(float));
    for (int i = 0; i < common_count; i++){
        result[i] = common[i];
    }
    return result;
