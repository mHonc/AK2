.text
.globl arctg
.type arctg, @function

arctg:
push %rbp            
movq %rsp, %rbp
sub $8, %rsp           # miejsce na x
sub $4, %rsp           # 32-bit int miejsce w pamieci na 2n+1


movsd %xmm0, -8(%rbp)  # umieszczenie w pamieci argumentu funkcji
mov $0, %r8            # suma
fldz                   # 0 na stosie FPU do sumowania szeregu

maclaurin:
inc %r8                # zlcizanie od 1, indeks argumentem

# obliczenie 2n+1
mov $2, %rax
mul %r8
inc %rax
mov %eax, -12(%rbp)    # zapisanie wyniku 2n+1 w pamieci


# potegowanie licznika
fldl -8(%rbp)           # umieszczenie na stosie FPU x
mov $1, %r9            

potega:
fmull -8(%rbp)         # Mnozenie st(0) przez podstawe potegi (w pamieci)
inc %r9                
cmp %r9, %rax         
jne potega

# dzielenie przez 2n + 1
fidivl -12(%rbp)

# sprawdzenie parzystosci (-1)^n
mov $0, %rdx          
mov %r8, %rax          
mov $2, %rcx         
div %rcx
cmp $1, %rdx            # w rdx reszta z dzielenia
jne suma                # reszta 0
fchs                    # reszta 1, zmiana znaku

suma:
faddp                   # dodanie st(0) do st(1), wynik w st(1)

cmp %r8, %rdi           # sprawdzenie czy n zostalo osiagniete, n w %rdi
jne maclaurin

fstpl -8(%rbp)          # zapisanie wyniku w pamieci
movsd -8(%rbp), %xmm0   # zwrot w xmm0

add $12, %rsp           # zwolnienie zmiennych lokalnych
pop %rbp               
ret
