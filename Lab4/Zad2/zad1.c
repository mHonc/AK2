#include <stdio.h>
 
// deklaracja funkcji, zostanie dolaczona podczas linkowania
extern void szyfr_cezara(char * str, int len);
 
// deklaracja zmiennych
char text[] = "*abcdefghijklmnouprstuwxyzABCDEFGHIJKLMNOUPRSTUWXYZ0123456789*";
int len = 62;
 
int main(void)
{
    // wywołanie funkcji Asemblerowej
    szyfr_cezara(&text, len);
 
    // wyświetlenie wyniku
    printf("%s\n", text);
 
    return 0;
}
