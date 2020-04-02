.data
STDOUT = 1
SYSWRITE = 1
SYSEXIT = 60
EXIT_SUCCESS = 0
tekst: .ascii "*"
tekst_len = .-tekst
nowa_linia: .ascii "\n"
nowa_len = .-nowa_linia
W = 5
 
.text
.global main 
main:
mov $W, %rax
mov $2, %r8
mul %r8
dec %rax
push %rax # H
push $W   # W
call write

koniec:
mov $SYSEXIT, %rax
mov $EXIT_SUCCESS, %rdi
syscall


write:
push %rbp
movq %rsp, %rbp
sub $8, %rsp
movq 16(%rbp), %r8   # W
movq 24(%rbp), %r9   # H 
mov %r8, %rbx

# Do dołu
NaDol:
mov %r8, %r10

linia_down:
movq $SYSWRITE, %rax
movq $STDOUT, %rdi
movq $tekst, %rsi
movq $tekst_len, %rdx
syscall

dec %r10
cmp $0, %r10
jg linia_down

movq $SYSWRITE, %rax
movq $STDOUT, %rdi
movq $nowa_linia, %rsi
movq $nowa_len, %rdx
syscall

dec %r8
cmp $0, %r8
jg NaDol

add $2, %r8 # r8 = 2
NaGore:
mov %r8, %r10

linia_up: 
movq $SYSWRITE, %rax
movq $STDOUT, %rdi
movq $tekst, %rsi
movq $tekst_len, %rdx
syscall

dec %r10
cmp $0, %r10
jg linia_up

movq $SYSWRITE, %rax
movq $STDOUT, %rdi
movq $nowa_linia, %rsi
movq $nowa_len, %rdx
syscall

inc %r8
cmp %rbx, %r8
jle NaGore



movq %rbp, %rsp
pop %rbp
ret



 

