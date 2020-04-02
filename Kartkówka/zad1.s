.data
STDOUT = 1
SYSWRITE = 1
SYSEXIT = 60
EXIT_SUCCESS = 0
tekst: .ascii "*"
tekst_len = .-tekst
nowa_linia: .ascii "\n"
nowa_len = .-nowa_linia
spacja: .ascii "_"
spacja_len = .-spacja
W = 7 # parametr W
 
.text
.global main 
main:

push $W   # odlozenie W na stos
call write # wywolanie funkcji rysujacej choinke

#call print_star
#call print_star
#call print_endl

koniec:
mov $SYSEXIT, %rax
mov $EXIT_SUCCESS, %rdi
syscall

# funkcja rysujaca choinke
write:
push %rbp
movq %rsp, %rbp
sub $8, %rsp
movq 16(%rbp), %r8   # W 
mov %r8, %rbx
mov $1, %r9  # licznik

NaGore:
mov %r9, %r10

linia_up:
#wyspis w petli ilosci * w danej linii 
call print_star # wypis jednej gwiazdki
dec %r10
cmp $0, %r10
jg linia_up

# wypis nowej linii
call print_endl
inc %r9
cmp %rbx, %r9
jle NaGore


movq %rbp, %rsp
pop %rbp
ret


# funkcja wypisujaca pojedyncza gwiazdke, po gwiazdce spacja
print_star:
push %rbp
movq %rsp, %rbp
sub $8, %rsp

movq $SYSWRITE, %rax
movq $STDOUT, %rdi
movq $tekst, %rsi
movq $tekst_len, %rdx
syscall

movq %rbp, %rsp
pop %rbp
ret


# funkcja wypisujaca znak nowej linii
print_endl:
push %rbp
movq %rsp, %rbp
sub $8, %rsp

movq $SYSWRITE, %rax
movq $STDOUT, %rdi
movq $nowa_linia, %rsi
movq $nowa_len, %rdx
syscall

movq %rbp, %rsp
pop %rbp
ret

# funkcja wypisujaca znak spacji
print_space:
push %rbp
movq %rsp, %rbp
sub $8, %rsp

movq $SYSWRITE, %rax
movq $STDOUT, %rdi
movq $spacja, %rsi
movq $spacja_len, %rdx
syscall

movq %rbp, %rsp
pop %rbp
ret





