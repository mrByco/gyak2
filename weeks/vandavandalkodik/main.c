#include <stdio.h>
#include <stdlib.h>
#include <time.h>

void feltolt(int tomb[], int N);
void forditva(int tomb[], int forditott[], int N);
void kiir(int tomb[], int forditott[], int N);
int monoton(int tomb[], int N);

int main()
{
    int meret=6;
    int tomb[meret];
    int forditott[meret];
    feltolt(tomb, meret);
    forditva(tomb, forditott, meret);
    kiir(tomb, forditott, meret);
    if(monoton(tomb, meret)==0)
    {
        printf("\nA sorozat nem monton novekvo");
    }
    else
    {
        printf("\nA sorozat monoton novekvo");
    }
    return 0;
}

void feltolt(int tomb[], int N)
{
    int i, upper=500, lower=50;
    srand(time(NULL));
    for(i=0;i<N;i++)
    {
        tomb[i]=rand()%(upper-lower)+lower;
    }
}

void forditva(int tomb[], int forditott[], int N)
{
    int i, s=0;
    for(i=N-1;i>=0;i--)
    {
        forditott[s]=tomb[i];
        s++;
    }
}

void kiir(int tomb[], int forditott[], int N)
{
    int i;
    for(i=0;i<N;i++)
    {
        printf("%d\n", tomb[i]);
    }
    printf("\n");
    for(i=0;i<N;i++)
    {
        printf("%d\n", forditott[i]);
    }
}

int monoton(int tomb[], int N)
{
    int igen=1, i;
    for(i=1;i<N;i++)
    {
        if(tomb[i-1]>tomb[i])
        {
            igen=0;
        }
    }
    return igen;
}
