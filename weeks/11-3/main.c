#include <stdio.h>
#include <stdlib.h>

/*
3. Írjon C programot, amely az alábbi feladatokat külön függvényekben valósítja meg:
- Olvasson be ellenõrzött módon 3 különbözõ, pozitív (nem nulla) egyjegyû egész számot és tárolja
el tömbben.
- A számjegyek felhasználásával generálja a programból az összes lehetséges háromjegyû számot és
ezeket tárolja el egy tömbben. A tömb méretét az ismétlés nélküli permutáció képletével (n!)
számolja ki külön függvényben.
- Rendezze a generált számokat csökkenõ sorrendbe.
- Írja ki a rendezett sorozatot.
*/

//Start 11:46

void fill_int_array(int*);
int factorial(int);
int* generate_permutations(int*);

int main()
{
    int nums[3];
    fill_int_array(nums);

    int permutations[factorial(3)];


    return 0;
}

void fill_int_array(int* array){
    int inputsAreOk = 0;
    while (!inputsAreOk){
        inputsAreOk = 1;
        printf("\nPlease enter 3 signle digit numbers separated with spaces (1 2 3): ");
        scanf("%d %d %d", &array[0], &array[1], &array[2]);
        for (int i = 0; i < 3; i++){
            if (array[i] > 9 || array[i] < 1){
                inputsAreOk = 0;
                break;
            }
        }
        while(getchar() != '\n'){}
    }
    printf("\n%d %d %d\n", array[0], array[1], array[2]);
}

int factorial(int n){
    if (n == 1){
        return 1;
    }
    return n * factorial(n - 1);
}

int* generate_permutations(int* array){
    int array_lenght = sizeof(array)/sizeof(array[0]);
    int permutations_lenght = factorial(array_lenght));
    int permutations[permutations_lenght][];
    int current_perm_index = 0;
    int current_perm_spread;

    while (current_perm_index < array_lenght){
        current_perm_spread = factorial(array_lenght - 1);
        for (int i = 0; i < permutations_lenght; i++){
            permutations[i][current_perm_index] = array[]
        }

        current_perm_index++;
    }

    for (int i = 0; i < factorial(array); i++){

    }
}



