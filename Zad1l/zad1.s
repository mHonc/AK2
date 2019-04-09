.data
STDIN=0
STDOUT=1
SYSREAD=0
SYSWRITE=1
SYSOPEN=2
SYSCLOSE=3
FREAD=0
FWRITE=1
SYSEXIT=60
EXIT_SUCCESS=0
file_in1: .ascii "in1.txt\0"
file_in2: .ascii "in2.txt\0"
file_out: .ascii "out.txt\0"

.bss
.comm in1, 1024 #bufor przechowuje dane ascii z pliku 1
.comm in2, 1024 #bufor przechowuje dane z pliku 2
.comm value1, 264  #wartosc 1 # /24
.comm value2, 264  #wartosc 2
.comm sum, 264  #bufor sumy
.comm out, 705 #bufor wyjscia (8/3 * 264) + znak nowej linii

.text
.global main
main:

#zeruje value 1 i 2
movq $0, %rax
zeruj:
movq $0, value1(,%rax,1)
movq $0, value2(,%rax,1)
movq $0, sum(,%rax,1)
inc %rax
cmp $264, %rax
jl zeruj


#wczytanie pierwszej liczby
movq $SYSOPEN, %rax
movq $file_in1, %rdi
movq $FREAD, %rsi
movq $0, %rdx
syscall
movq %rax, %r8  #kopia uchwytu do pliku

movq $SYSREAD, %rax
movq %r8, %rdi
movq $in1, %rsi
movq $1024, %rdx
syscall
mov %rax, %r9   #r9 liczba odczytanych danych

#zamkniecie pliku
movq $SYSCLOSE, %rax
movq %r8, %rdi
movq $0, %rsi
movq $0, %rdx
syscall


#zapis liczby do bufora
dec %r9 #pomijam koniec lini
movq $-1, %r10  #licznik od poczatku

zapis1:
dec %r9
inc %r10

#zdekodownie 2 pierwszych bitow
movb in1(, %r9,1), %al  #wczytanie ascii
sub $'0',%al  #dekodowanie
cmp $0, %r9  #sprawdzenie czy nie jest to ostatni znak
jle zapis_buf

#kolejne 2 bity
dec %r9
movb in1(,%r9,1), %bl  #wczytanie ascii
sub $'0', %bl #odejmuje ascii
shl $2, %bl   #przesuwam
add %bl, %al  #dodaje do wyniku
cmp $0, %r9
jle zapis_buf

#kolejne 2 bity
dec %r9
movb in1(,%r9,1), %bl  #wczytanie ascii
sub $'0', %bl #odejmuje ascii
shl $4, %bl   #przesuwam
add %bl, %al  #dodaje do wyniku
cmp $0, %r9
jle zapis_buf

#kolejne 2 bity
dec %r9
movb in1(,%r9,1), %bl  #wczytanie ascii
sub $'0', %bl #odejmuje ascii
shl $6, %bl   #przesuwam
add %bl, %al  #dodaje do wyniku
cmp $0, %r9
jle zapis_buf

zapis_buf:
movb %al, value1(,%r10,1)  #zapis do bufora
cmp $0, %r9
jg zapis1


liczba2:
#wczytanie drugiej liczby
movq $SYSOPEN, %rax
movq $file_in2, %rdi
movq $FREAD, %rsi
movq $0, %rdx
syscall
movq %rax, %r8  #kopia uchwytu do pliku

movq $SYSREAD, %rax
movq %r8, %rdi
movq $in1, %rsi
movq $1024, %rdx
syscall
mov %rax, %r9   #r9 liczba odczytanych danych

#zamkniecie pliku
movq $SYSCLOSE, %rax
movq %r8, %rdi
movq $0, %rsi
movq $0, %rdx
syscall

#zapis liczby do bufora
dec %r9 #pomijam koniec lini
movq $-1, %r11  #licznik od poczatku

zapis2:
dec %r9
inc %r11

#zdekodownie 2 pierwszych bitow
movb in1(, %r9,1), %al  #wczytanie ascii
sub $'0',%al  #dekodowanie
cmp $0, %r9  #jezli jest co wczytaj
jle zapis_buf2

#kolejne 2 bity
dec %r9
movb in1(,%r9,1), %bl  #wczytanie ascii
sub $'0', %bl #odejmuje ascii
shl $2, %bl   #przesuwam
add %bl, %al  #dodaje do wyniku
cmp $0, %r9
jle zapis_buf2

#kolejne 2 bity
dec %r9
movb in1(,%r9,1), %bl  #wczytanie ascii
sub $'0', %bl #odejmuje ascii
shl $4, %bl   #przesuwam
add %bl, %al  #dodaje do wyniku
cmp $0, %r9
jle zapis_buf2

#kolejne 2 bity
dec %r9
movb in1(,%r9,1), %bl  #wczytanie ascii
sub $'0', %bl #odejmuje ascii
shl $6, %bl   #przesuwam
add %bl, %al  #dodaje do wyniku
cmp $0, %r9
jle zapis_buf2

zapis_buf2:
movb %al, value2(,%r11,1)  #zapis do bufora
cmp $0, %r9
jg zapis2

#dodanie wartosci
cl17c #czyscze flage przeniesienia
pushfq #umieszczam rejestr z flagami na stosie
mov $0, %r8 #licznik petli

dodaj:
mov value1(, %r8, 1), %al 
mov value2(, %r8, 1), %bl 

popfq       # Pobranie zawartości rejestru flagowego ze stosu
adc %bl, %al # Dodanie z propagacją i przyjęciem przeniesienia
pushfq       # Umieszczenie rejestru flagowego na stosie

mov %al, sum(, %r8, 1)
inc %r8    
cmp $263, %r8 
jl dodaj

# KONWERSJA NA SYSTEM ÓSEMKOWY I ZAPIS DO ASCII
mov $703, %r8  # Licznik out
mov $0, %r9 # Licznik sum
 
konwersja:
# pobranie 3 bajtow i sklejenie ich
mov $0, %rax
add $2, %r9
mov sum(, %r9, 1), %al
shl $8, %rax
dec %r9
mov sum(, %r9, 1), %al
shl $8, %rax
dec %r9
mov sum(, %r9, 1), %al
add $3, %r9
 
mov $8, %r10 
 
wewn:
mov %al, %bl  # przeniesienie wartosci al do bl
and $7, %bl   # zostawienie 3 bitow 
add $'0', %bl # kodowanie na ascii
mov %bl, out(, %r8, 1) # zapis znaku ASCII do bufora wyjściowego
 
shr $3, %rax # przesunięcie bitowe dotychczasowej liczby o 3 bity w prawo,
             # tak aby pozbyć się już zdekodowanych 3 bitów.
dec %r8      
dec %r10
cmp $0, %r10

jg wewn
 
cmp $263, %r9 
jl konwersja 

# Zapis do pliku
mov $SYSOPEN, %rax
mov $file_out, %rdi
mov $FWRITE, %rsi
mov $0644, %rdx
syscall
mov %rax, %r8
 
# Zapis bufora out do pliku
mov $704, %r9
movb $0x0A, out(, %r9, 1)
mov $SYSWRITE, %rax
mov %r8, %rdi
mov $out, %rsi
mov $705, %rdx
syscall
 
# Zamknięcie pliku
mov $SYSCLOSE, %rax
mov %r8, %rdi
mov $0, %rsi
mov $0, %rdx
syscall

koniec:
movq $SYSEXIT, %rax
movq $EXIT_SUCCESS, %rdi
syscall


 

