# deklaracja stałych
.data
STDIN = 0
STDOUT = 1
SYSREAD = 0
SYSWRITE = 1
SYSEXIT = 60
EXIT_SUCCESS = 0
BUFLEN = 512
POCZATEK_DUZYCH = 0x41
KONIEC_DUZYCH = 0x5A
POCZATEK_MALYCH = 0x61
KONIEC_MALYCH = 0x7A
 
# alokacja pamięci pod bufory na wczytywany
# i wyświetlany tekst
.bss
.comm textin, 512
.comm textout, 512
 
.text
.globl _start
 
_start:
# pobranie od użytkownika ciągu znaków
mov $SYSREAD, %rax
mov $STDIN, %rdi
mov $textin, %rsi
mov $BUFLEN, %rdx
syscall
 
# przeniesienie długości wczytanego ciągu do R8
# i wyzerowanie "licznika" RDI (potrzebnego dalej w pętli)
mov %rax, %r8
mov $0, %rdi
 
jmp petla
 
petla:
# odczyt znaku do rejestru AH
mov textin(, %rdi, 1), %ah
 
# jeśli kod znaku jest większy niż początek wielkich liter,
# przeskok do etykiety duze
cmp $POCZATEK_DUZYCH, %ah
jge duze
jmp powrot_do_petli
 
duze:
# jeśli kod znaku jest większy niż koniec wielkich liter,
# przeskok do etykiety sprawdzaj_dalej
cmp $KONIEC_DUZYCH, %ah
jge sprawdzaj_dalej
# w przeciwnym wypadku (znak to wielka litera)
add $8, %ah # dodanie do kodu znaku liczby 8
jmp powrot_do_petli
 
sprawdzaj_dalej:
# jeśli kod znaku jest większy niż początek małych liter,
# przeskok do etykiety male
cmp $POCZATEK_MALYCH, %ah
jge male
jmp powrot_do_petli
 
male:
# jeśli kod znaku jest większy niż koniec małych liter,
# przeskok do etykiety powrot_do_petli
cmp $KONIEC_MALYCH, %ah
jge powrot_do_petli
# w przeciwnym przypadku (znak jest małą literą)
add $6, %ah # dodanie do kodu znaku liczby 6
jmp powrot_do_petli
 
powrot_do_petli:
# zapis znaku do bufora wyjściowego
movb %ah, textout(, %rdi, 1)
 
# zwiększenie licznika i wykonanie kolejnych
# iteracji pętli dla kolejnych znaków
inc %rdi
cmp %r8, %rdi
jle petla
 
# wyświetlenie danych zapisanych do bufora wyjściowego
mov $SYSWRITE, %rax
mov $STDOUT, %rdi
mov $textout, %rsi
mov %r8, %rdx
syscall
 
# zakończenie działania programu i zwrot wartości na wyjściu
mov $SYSEXIT, %rax
mov $EXIT_SUCCESS, %rdi
syscall
