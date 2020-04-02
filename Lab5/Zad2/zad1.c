// Szereg Mclaurina arctg(x) dla |x| < 1
// y = (-1)^n * (x^(2n + 1)) / (2n + 1)


#include <stdio.h>
#include <math.h>

extern double arctg(double, int);
double arctg_C(double x, int n);

int main(void){
    double x;
    int n;
    printf("x: (-1,1):");
    scanf("%lf", &x);
    printf("Liczba iteracji:");
    scanf("%d", &n);

    double wynikC = arctg_C(x, n);
    double wynikASM = arctg(x, n);
    
    printf("%lf\n", wynikC);
    printf("%lf\n", wynikASM);
}

double arctg_C(double x, int n)
{
    int wyraz, i;
    double licznik, wynik;
    double suma = 0;
    
    for(i = 0; i <= n; i++)
    {
        wyraz = 2*i + 1;
        licznik = pow(x, (double)wyraz);
        wynik = licznik/(double)wyraz;

        if(i % 2 == 1)
        {
            wynik = -wynik;
        }

        suma += wynik;
    }

    return suma;
}
