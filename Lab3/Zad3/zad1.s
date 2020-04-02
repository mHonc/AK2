.data
STDOUT = 1
SYSWRITE = 1
SYSEXIT = 60
EXIT_SUCCESS = 0
ILOSC_WYRAZOW = 8  # Wyraz ciągu do obliczenia


.text
.global main
 
main:
#
# Wywołanie funkcji obliczającej n-ty wyraz ciągu
#
push $ILOSC_WYRAZOW    # Umieszczenie parametru na stosie
call n                 # Wywołanie funkcji
pop %r8       
 
 
koniec:
mov $SYSEXIT, %rax
mov $EXIT_SUCCESS, %rdi
syscall
 
 
 

# Funkcja obliczająca n-ty wyraz ciągu
n:
 
# Pobranie przesłanego parametru - numeru wyrazu, do rejestru RAX.
push %rbp
mov %rsp, %rbp
mov 16(%rbp), %r8     # pobranie numeru wyrazu ze stosu
 
# Porównanie parametru "n" i skok do odpowiedniej etykiety
cmp $0, %r8
je pierwszy_wyraz 
cmp $1, %r8
je drugi_wyraz    
cmp $2, %r8
je trzeci_wyraz
 
# Jeśli n > 2:
mov $0, %rcx # Czyszczenie rejestru RCX.
             # Będzie on przechowywał dotychczasowy wynik.

# 2(n - 2) 
dec %r8
dec %r8
 
push %rcx
push %r8
call n
pop %r8
pop %rcx
mov %rbx, %rax  # zapis wyniku, aby go wymnozyc
mov $2, %r9
mul %r9         # 2(n - 2)
add %rax, %rcx 


# 3(n - 2) 
dec %r8
 
push %rcx
push %r8
call n
pop %r8
pop %rcx
mov %rbx, %rax  # zapis wyniku, aby go wymnozyc
mov $3, %r9
mul %r9         # 3(n - 3)
add %rax, %rcx 
 
 
# Zwrot wyliczonej wartości z rejestru RCX
mov %rcx, %rbx # wynik zwracany jest do rejestru rbx
mov %rbp, %rsp
pop %rbp
ret
 
 

# Zwrot wartości 2 jeśli przesłany parametr n=0
pierwszy_wyraz:
mov $2, %rbx
mov %rbp, %rsp
pop %rbp
ret
 
# Zwrot wartości 3 jeśli przesłany parametr n=1
drugi_wyraz:
mov $3, %rbx
mov %rbp, %rsp
pop %rbp
ret

# Zwrot wartości 1 jeśli przesłany parametr n=1
trzeci_wyraz:
mov $1, %rbx
mov %rbp, %rsp
pop %rbp
ret
