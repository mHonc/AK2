#include <stdio.h>
#include <math.h>

extern int checkExceptions();
extern void clearMasks();
extern void setMasks();
extern void maskException(int);
extern void testDivByZero();

int main(void){
    int number, exceptions;
    do{
        printf("1. Check exceptions\n"
                "2. Mask exceptions\n"
                "3. Clear all masks\n"
		"4. Set all masks\n"
                "5. Divide by zero test\n0. Exit\n>");
        scanf("%d", &number);

        if (number == 1){
            exceptions = checkExceptions(); //zwraca na ktorych bitach sa wyjatki
            if (exceptions == 0){
                printf("No exceptions are set\n");
                continue;
            }
            if (exceptions % 2 == 1)    // bit 0
                printf("Invalid Operation Exception\n");
            
            exceptions = exceptions >> 1; // przesuniecie bitowe na kolejna pozycje
            if (exceptions % 2 == 1)    // bit 1
                printf("Denormal Operand Exception (#D)\n");

            exceptions = exceptions >> 1;
            if (exceptions % 2 == 1)    // bit 2
                printf("Divide-By-Zero Exception (#Z)\n");

            exceptions = exceptions >> 1;
            if (exceptions % 2 == 1)    // bit 3
                printf("Numeric Overflow Exception (#O)\n");

            exceptions = exceptions >> 1;
            if (exceptions % 2 == 1)    // bit 4
                printf("Numeric Underflow Exception (#U)\n");

            exceptions = exceptions >> 1;
            if (exceptions % 2 == 1)    // bit 5
                printf("Inexact-Result (Precision) Exception (#P)\n");
        }

        else if (number == 2){
            printf("Choose exception to mask:\n"
            "0. Invalid Operation Exception\n"
            "1. Denormal Operand Exception (#D)\n"
            "2. Divide-By-Zero Exception (#Z)\n"
            "3. Numeric Overflow Exception (#O)\n"
            "4. Numeric Underflow Exception (#U)\n"
            "5. Inexact-Result (Precision) Exception (#P)\n>");
            scanf("%d", &exceptions);
            if (exceptions > 5 || exceptions < 0){
                printf("Wrong argument!\n");
                continue;
            }

            maskException((int)pow(2,exceptions)); // przeslanie nr bitu do maskowania
        }

        else if (number == 3){
            clearMasks();
        }

	else if (number == 4){
            setMasks();
        }

        else if (number == 5){
            testDivByZero();
        }

    } while(number != 0);
}
