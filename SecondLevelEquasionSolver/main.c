#include <stdio.h>
#include <stdlib.h>

struct Equasion {
    double a;
    double b;
    double c;
};

struct Solution {
    double x1;
    double x2;
};

void fillEquasionValues(struct Equasion *eq){
    printf("Give the factors of the equasion  separated by spaces (a b c): ");
    scanf("%lf %lf %lf", &eq->a, &eq->b, &eq->c);
    printf("\n");
}

struct Solution SolveEquasion(struct Equasion eq){
    struct Solution solution;
    solution.x1 = (-eq.b + sqrt(eq.b + 4 * eq.a * eq.c)) / (2 * eq.a);
    solution.x2 = (-eq.b - sqrt(eq.b + 4 * eq.a * eq.c)) / (2 * eq.a);
    return solution;
};

int main()
{
    struct Equasion eq;
    fillEquasionValues(&eq);
    struct Solution solution;
    solution = SolveEquasion(eq);
    printf("Roots are: %lf, %lf", solution.x1, solution.x2);

    return 0;
}

