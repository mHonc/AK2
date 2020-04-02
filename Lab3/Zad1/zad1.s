.data
STDOUT = 1
SYSWRITE = 1
SYSEXIT = 60
EXIT_SUCCESS = 0
str: .asciz "**asdpasdo*****"
len2= .-str
str2: .asciz "******"
len1= .-str2



.text
.global main
main:
push $len2
push $len1
push $str
call f
mov %rax, %rbx

koniec:
movq $SYSEXIT, %rax
movq $EXIT_SUCCESS, %rdi
syscall

f:
push %rbp
movq %rsp, %rbp
sub $8, %rsp
movq 16(%rbp), %rax   # str
movq 24(%rbp), %rbx # dlugosc len1
movq 32(%rbp), %rcx # dlugosc len2
dec %rbx # odjecie znakow konca linii
dec %rcx

movq $0, %r8 # licznik petli # konwencja pierwszy znak na pozycji 0
movq $0, %r9 # licznik znakow *
movq $-1, %r10 # numer pozycji
movq $0, %r11 # pom


szukaj:
#pierwszy znak
movb (%rax,%r8,1), %dl # kopiuje str
cmp $'*', %dl # czy jest znakiem *
jne dalej
inc %r9
jmp ile_znakow

# czy dlugosc wystopien znaku sie zgadza
ile_znakow:
inc %r8
cmp %rcx, %r8
jge dalej
movb (%rax,%r8,1), %dl # kopiuje str
cmp $'*', %dl # czy jest znakiem *
jne dalej
inc %r9
cmp %rbx, %r9
jl ile_znakow
inc %r8 # inkrementacja, zeby po odjeciu dlugosci szukanego lancucha byl jego poczatek
mov %r8, %r10
mov %rbx, %r11
sub %r11, %r10
jmp powrot


dalej:
inc %r8
mov $0, %r9
cmp %rcx, %r8
jl szukaj


powrot:
movq $SYSWRITE, %rax
movq $STDOUT, %rdi
movq $str, %rsi
movq $len2, %rdx
syscall

movq %r10, %rax
movq %rbp, %rsp
pop %rbp
ret
