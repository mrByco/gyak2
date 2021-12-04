#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <math.h>

void feltolt(int tomb[], int N);
double atlag(int tomb[], int N);
void beolvas(int *index);
void kiir(int tomb[], int N, double average, int index);

int main()
{
    int meret=6, index;
    int tomb[meret];
    feltolt(tomb, meret);
    printf("Atlag: %.2f\n", atlag(tomb, meret));
    double atlagv=atlag(tomb, meret);
    beolvas(&index);
    kiir(tomb, meret, atlagv, index);
    return 0;
}

void kiir(int tomb[], int N, double average, int index)
{
    int i;
    for(i=index;i<N;i++)
    {
        printf("A tomb %d. eleme: %d    Az atlagtol valo elterese: %d\n", i+1, tomb[i], abs(average-tomb[i]));
    }
}

void beolvas(int *index)
{
    int ok;
    char ch;
    do
    {
        ok=1;
        printf("Adjon meg egy ervenyes tomb indexet: ");
        if(scanf("%d", index)!=1 || *index<0 || *index>6)
        {
            printf("Nem ervenyes\n");
            while((ch=getchar()!='\n'));
            ok=0;
        }
    }while(!ok);
}

double atlag(int tomb[], int N)
{
    int i;
    double osszeg=0, db=0;
    for(i=0;i<N;i++)
    {
        osszeg+=tomb[i];
        db++;
    }
    return osszeg/db;
}

void feltolt(int tomb[], int N)
{
    int i, j, upper=NULL, lower=10;
    for(i=0;i<N;i++)
    {
        for(j=0;j<N;j++)
        {
            tomb[i]=j*j;
        }
    }
    for(i=0;i<N;i++)
    {
        printf("%d\n", tomb[i]);
    }
}
