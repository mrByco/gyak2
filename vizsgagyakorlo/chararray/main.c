#include <stdio.h>
#include <stdlib.h>
#define STR_COUNT 5
#include <string.h>

void printStringsDoublePtr(char** strings, int lenght);
void printStrArrayPointers(char* strings[], int lenght);
void orderStrArrayByLenght(char* strings[], int length);

int main()
{
    char* strings[STR_COUNT] = {"gg", "Geza", "Jozsi", "Zsombor", "Zsanett"};

    printStringsDoublePtr(strings, STR_COUNT);
    printStrArrayPointers(strings, STR_COUNT);

    const int birthday = 17;
    printf("%d\n", birthday);
    int* p = &birthday;
    *p = 1;
    int** pp = &p;

    printf("\n\n");
    orderStrArrayByLenght(strings, STR_COUNT);
    printStrArrayPointers(strings, STR_COUNT);

    return 0;
}


void printStringsDoublePtr(char** strings, int lenght){
    for (int i = 0; i < lenght; i++){
        printf("%s\n", strings[i]);
    }
}


void printStrArrayPointers(char* strings[], int lenght){
    for (int i = 0; i < lenght; i++){
        printf("%s\n", strings[i]);
    }
}

void orderStrArrayByLenght(char* strings[], int length){
    for (int i = 0; i < length; i++){
        int maxIndex = i;
        for (int j = i; j < length; j++){
            if (strlen(strings[maxIndex]) < strlen(strings[j])){
                    maxIndex = j;
            }
        }
        char* temp = strings[i];
        strings[i] = strings[maxIndex];
        strings[maxIndex] = temp;
    }
}
