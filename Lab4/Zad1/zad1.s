SYSEXIT = 60
EXIT_SUCCESS = 1
 
.data
format_int: .asciz "%d\n"
format_float: .asciz "%f"
format_double: .asciz "%lf"
 
result: .asciz "%lf\n"
 
.bss
.comm int, 4 # int
.comm float, 4 # float
.comm double, 8 # double
 
 
.text
.global main
main:
 
movq $0, %rax # liczba argumentow zmiennoprzecinkowych przekazywanych do funckji
movq $format_int, %rdi # pierwszy argument, format w jakim ma zostać zapisany wynik w buforze
movq $int, %rsi        # drugi argument, adres buforu do ktorego maja zostac zapisane dane
call scanf
 
movq $0, %rax
movq $format_float, %rdi
movq $float, %rsi
call scanf
 
movq $0, %rax
movq $format_double, %rdi
movq $double, %rsi
call scanf
 
movq $2, %rax # 2 argumenty zmiennoprzecinkowe
movq int, %rdi # kopiowanie zawartosci int do %rdi
movss float, %xmm0 # -||- float do xmm0, pojedyncza precyzja
movsd double, %xmm1 # -||- double do xmm1, podwojna precyzja
 
call f # wynik w xmm0
 
push %rbx # workaround - tymczasowa zmiana szczytu stosu, zapobiegajaca zmianie 
          # ostatniej wartosci na stosie przez funkcje printf 
movq $1, %rax
movq $result, %rdi # przeslanie jednego argumentu
call printf # wyswietlenie wyniku
pop %rbx # wyrownanie stosu
 
zamknij:
movq $SYSEXIT, %rax
movq $EXIT_SUCCESS, %rdi
