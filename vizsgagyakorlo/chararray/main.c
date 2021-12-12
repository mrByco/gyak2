#include <stdio.h>
#include <stdlib.h>
#define STR_COUNT 5
#include <string.h>

void printStringsDoublePtr(char** strings, int lenght);
void printStrArrayPointers(char* strings[], int lenght);
void orderStrArrayByLenght(char* strings[], char* ordered[], int length);

int main()
{
    char* strings[STR_COUNT] = {"Zsombor", "Geza", "Zsanett", "Akos", "Jozsi"};

    printStringsDoublePtr(strings, STR_COUNT);
    printStrArrayPointers(strings, STR_COUNT);
    char* ordered[STR_COUNT];
    orderStrArrayByLenght(strings, ordered, STR_COUNT);
    printStrArrayPointers(ordered, STR_COUNT);

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

void orderStrArrayByLenght(char* strings[], char* ordered[], int length){
    for (int i = 0; i < length; i++){
        int max = strlen(strings[0]);
        for (int j = i; j < length; j++){
            if (max < strlen(strings[j])){
                    max = strlen(strings[j]);
            }
        }
        ordered[i] = &(strings[max]);
    }
}
