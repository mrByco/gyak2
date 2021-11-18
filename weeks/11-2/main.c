#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <ctype.h>
#define ARRAY_LENGHT 10

/*
2. Inicializáljon egy karaktertömböt az angol ABC betûivel. Az alábbi feladatokat külön
függvényekben valósítsa meg:
- A tömb elemeit felhasználva véletlenszerûen állítson elõ egy 10 hosszúságú karakterláncot.
- Keressen a karakterláncban karakter ismétlõdést, vagyis olyan esetet, amikor az i-edik karakter
megegyezik az i+1-edikkel.
- Olvasson be egy karaktert.
- Számolja meg, hogy a beolvasott karakter hányszor fordul elõ a karakterláncban.
*/

void fill_ch_array(char*);
int get_char_repetition_index(char*);
char read_char();
int count_char_in_array(char*, char);

int main() {
    char chars[ARRAY_LENGHT];
    //65 90
    srand(time(NULL));
    fill_ch_array(chars);

    int repetition = get_char_repetition_index(chars);
    if (repetition == -1){
        printf("There is not repetition in the array!\n");
    }
    else {
        printf("The %d. and the %d. characters are the same!\n", repetition + 1, repetition + 2);
    }

    printf("Please enter a character to be counted in the random array: ");
    char user_ch = read_char();
    int char_count = count_char_in_array(chars, user_ch);
    printf("\nFound %d '%c' chars in the array.", char_count, user_ch);
    return 0;
}

void fill_ch_array(char * chars) {
    for (int i = 0; i < ARRAY_LENGHT; i++) {
        char ch = (rand() % 26) + 65;
        chars[i] = ch;
        printf("%d %c\n", ch, ch);
    }
}

int get_char_repetition_index(char* chars) {
    for (int i = 1; i < ARRAY_LENGHT; i++) {
        if (chars[i - 1] == chars[i]){
            return i - 1;
        }
    }
    return -1;
}

char read_char(){
    char ch;
    while (1){
        scanf("%c", &ch);
        if (isalpha(ch) && getchar() == '\n'){
            return ch;
        }
        printf("\nInvalid input!\n");
        while (getchar() != '\n'){};
    }
}

int count_char_in_array(char* ch_array, char user_ch){
    int count = 0;
    for (int i = 0; i < ARRAY_LENGHT; i++){
        if (ch_array[i] == toupper(user_ch)){
            count++;
        }
    }
    return count;
}
