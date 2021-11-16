#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#define MAX_CHOCKOLATE_TABLES 10

int main() {
    //Task 1
    float chockolateTableWeights[MAX_CHOCKOLATE_TABLES];
    srand(time(NULL));
    int i;
    for (i = 0; i < MAX_CHOCKOLATE_TABLES; i++) {
        double random = rand() % 1000;
        chockolateTableWeights[i] = (random / 100.0) + 95.0;
    }

    //Task 2
    for (i = 0; i < MAX_CHOCKOLATE_TABLES; i++) {
        printf("%.2f ", chockolateTableWeights[i]);
    }
    printf("\n");
    //Task 3
    int smalestOver100Index = -1;
    for (i = 0; i < MAX_CHOCKOLATE_TABLES; i++) {
        float currentWeight = chockolateTableWeights[i];
        if (currentWeight <= 100) {
            continue;
        }
        if (smalestOver100Index == -1 || currentWeight < chockolateTableWeights[smalestOver100Index]) {
            smalestOver100Index = i;
        }
    }
    //Task 3
    int valuesAreOkay = 0;
    int interval[2];
    while (!valuesAreOkay) {
        printf("Please give an interval ('a-b' format): ");
        scanf("%d-%d", &interval[0], &interval[1]);
        while(getchar() != '\n') {};
        if (interval[0] >= 95 && interval[0] <= 105
                && interval[1] >= 95 && interval[1] <= 105
                && interval[0] < interval[1]) {
            valuesAreOkay = 1;
        }
    }

    //Tast 4
    float averageSum = 0.0;
    int averageCount = 0;

    for (i = 0; i < MAX_CHOCKOLATE_TABLES; i++){
        if (chockolateTableWeights[i] > interval[0] && chockolateTableWeights[i] < interval[1]){
                averageSum += chockolateTableWeights[i];
                averageCount++;
        }
    }
    printf("The average mass of chockolates in the interval: %.3f", averageSum / averageCount);

    return 0;
}
