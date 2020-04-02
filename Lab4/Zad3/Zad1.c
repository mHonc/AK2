#include <stdio.h>
 

char str[] = "*abcdefghijklmnouprstuwxyzABCDEFGHIJKLMNOUPRSTUWXYZ0123456789*";
const int len = 62;
 
int main(void)
{
    
    asm(
    "mov $0, %%rbx \n" // zerowanie %rbx, licznika do pętli.
 
    "petla: \n" 
 
    "mov (%0, %%rbx, 1), %%al \n" // skopiowanie n-tej komórki stringa
     // do %al,  %0 to wskaźnik na pierwszą komórkę stringa
 
    // sprawdzenie czy wielkie
    "cmp $'Z', %%al \n"
    "jg zapisz \n"
    "cmp $'A', %%al \n"
    "jl zapisz \n"

    // szyfr cezara dla wielkich liter
    "wielkie: \n"
    "add $3, %%al \n" 
    "cmp $'Z', %%al \n"
    "jle zapisz \n"
    "sub $26, %%al \n" 

    
    "zapisz: \n" 
    "mov %%al, (%0, %%rbx, 1) \n" // zapisanie wartości do stringa
 
    "inc %%rbx \n"      // zwiększenie licznika pętli
    "cmp len, %%ebx \n" // porównanie licznika pętli ze stałą "len"
                        // zadeklarowaną w kodzie C, ebx poniewaz zmienna w
                        // w jezyku jest 32 bitowa
    "jl petla \n" 
 
    : // brak parametrow wyjsciowych
 
    :"r"(&str) // lista parametrów wejściowych - zmiennych które zostaną
    // zapisane do rejestrów i będzie możliwy ich odczyt w kodzie Asemblerowym
    
    :"%rax", "%rbx" // rejestry których będziemy używać w kodzie Asemblerowym.
    );
     
    printf("%s\n", str);
 
    return 0;
}
