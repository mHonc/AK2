.data
STDIN = 0
STDOUT = 1
SYSWRITE = 1
SYSREAD = 0
SYSEXIT = 60
EXIT_SUCCESS = 0
NR_CIAGU = 8
    
.text
.global main
 
main:
    
movq $NR_CIAGU, %r8   # przekazanie nr wyrazu do rejestru
call func
mov %r9, %rax


exit:
movq $SYSEXIT, %rax
movq $EXIT_SUCCESS, %rdi
syscall


func:
push %rbp
mov %rsp, %rbp
sub $16, %rsp
push %r8      # kopiowanie aktualnego nr_ciagu na stos, zeby nie zostal nadpisany
push %r10     # kopiowanie aktualnego wyniku zwracanego przez funkcje f(n-2)
cmp $0, %r8
je zero
cmp $1, %r8
je jeden
cmp $2, %r8
je dwa

dec %r8
dec %r8
call func
mov $2, %rax  
mul %r9          #wymnozenie wartosci (n - 2) przez 2
mov %rax, %r10
# %r10 = 2f(n-2)
        
dec %r8
call func
mov $3, %rax  
mul %r9
mov %rax, %r9
# %r9 = 3f(n-3)
        
add %r10, %r9 # wynik w rejestrze %r9
jmp koniec

zero:
movq $2, %r9
jmp koniec
    
jeden:
movq $3, %r9
jmp koniec
    
dwa:
movq $1, %r9
jmp koniec

koniec:
pop %r10           # przywracane poprzednie wartosci r8 i r10
pop %r8
mov %rbp, %rsp
pop %rbp
ret


