.data
STDOUT = 1
SYSWRITE = 1
SYSEXIT = 60
EXIT_SUCCESS = 0
tekst: .ascii "*"
tekst_len = .-tekst
nowa_linia: .ascii "\n"
nowa_len = .-nowa_linia
W = 7
 
.text
.global main 
main:
push $W   # W
call print

koniec:
mov $SYSEXIT, %rax
mov $EXIT_SUCCESS, %rdi
syscall


print:
push %rbp
movq %rsp, %rbp
sub $8, %rsp
movq 16(%rbp), %r8   # W 
mov %r8, %rbx
mov $1, %r9 

NaGore:
mov %r9, %r10

linia_up:
#wyspis w petli ilosci * w danej linii 
call write
dec %r10
cmp $0, %r10
jg linia_up

# wypis nowej linii
movq $SYSWRITE, %rax
movq $STDOUT, %rdi
movq $nowa_linia, %rsi
movq $nowa_len, %rdx
syscall

inc %r9
cmp %rbx, %r9
jle NaGore


movq %rbp, %rsp
pop %rbp
ret


write:
push %rbp
movq %rsp, %rbp

movq $SYSWRITE, %rax
movq $STDOUT, %rdi
movq $tekst, %rsi
movq $tekst_len, %rdx

ret




 

