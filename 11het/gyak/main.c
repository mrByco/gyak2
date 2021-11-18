#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <string.h>


void read7char(char*);
int validFormat();
int getMaxIntFromCharArray();

int main()
{
    char string[7];
    read7char(&string);

    int isValid = isValidFormat(string);
    if (isValid)
    {
        int max = getMaxIntFromCharArray(string);
        printf("Max is: %d", max);
    }
    return 0;
}

void read7char(char* str){
    do
    {
        printf("Give a string of 7 char: ");
        scanf("%s", str);
    }
    while(strlen(str) != 7);
}

int isValidFormat(char *str)
{
    for (int i = 0; i < 7; i++){
        if (i < 3 && (str[i] < 'A' || str[i] > 'z')){
            return 0;
        }
        else if (i > 3 && !(str[i] >= '0' && str[i] <= 'Z')){
            return 0;
        }
        else if (i == 3 && !(str[i] == '-')){
            return 0;
        }
    }
    return 1;
}

int getMaxIntFromCharArray(char *str)
{
    int max = -1;
    for (int i = 4; i < 7; i++)
    {
        int num = str[i] - '0';
        if (max < num)
        {
            max = num;
        }
    }
    return max;
}
