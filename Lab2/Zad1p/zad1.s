.data
STDIN = 0
STDOUT = 1
SYSREAD = 0
SYSWRITE = 1
SYSOPEN = 2
SYSCLOSE = 3
FREAD = 0
FWRITE = 1
SYSEXIT = 60
EXIT_SUCCESS = 0
file_in: .ascii "in.txt\0" 
file_out: .ascii "out.txt\0"

.bss
.comm in_buffer, 1024 # bufor zawierajacy znaki hex odczytane z pliku
.comm out_buffer, 1537 # bufor zawierajacy znaki oct, +1 uwzglednia koniec linii
                       # dwa znaki w hex odpowiadaja max 3 znakom oct
.comm temp, 516 # bufor zawierajacy sklejone bajty z in_buffer, podzielny przez 3

.text
.globl main # debugowanie

main:

# ZEROWANIE BUFORA TEMP
mov $516, %r8 # licznik
mov $0, %al # zerowanie bufora al

petla1:
dec %r8
mov %al, temp(, %r8, 1) # zerowanie bufora

cmp $0, %r8
jg petla1


# WCZYTYWANIE Z PLIKU
# otwarcie pliku
mov $SYSOPEN, %rax
mov $file_in, %rdi
mov $FREAD, %rsi
mov $0, %rdx
syscall
mov %rax, %r10 # Przepisanie identyfikatora otwartego pliku do R10

# zapis do bufora in_buffer
mov $SYSREAD, %rax
#mov $STDIN, %rdi
mov %r10, %rdi
mov $in_buffer, %rsi
mov $1024, %rdx
syscall
mov %rax, %r8 # Zapisanie ilości odczytanych bajtów do rejestru R8

# zamknięcie pliku
mov $SYSCLOSE, %rax
mov %r10, %rdi
mov $0, %rsi
mov $0, %rdx
syscall


# DEKODOWANIE WARTOSCI BUFORA I ZAPIS DO BUFORA TEMP W KONWENCJI LITTLE_ENDIAN
dec %r8 # pomijamy znak konca linii
mov $516, %r9 # licznik bufora temp

petla2:
# r8 = 1024, r9 = 516
dec %r8 # liczymy od 0, dlatego dekrementacja na poczatku
dec %r9

mov in_buffer(, %r8, 1), %al # wczytanie 4 bitow (0000xxxx)

# dekodowanie z ascii na hex
cmp $'A', %al
jge litera

cyfra:
sub $'0', %al
jmp przeskok1

litera:
sub $55, %al


# DEKODOWANIE KOLEJYCH 4 BITOW
przeskok1:
mov %al, %bl
dec %r8
mov in_buffer(, %r8, 1), %al

# dekodowanie z ascii na hex
cmp $ 'A', %al
jge litera2

cyfra2:
sub $'0', %al
jmp przeskok2

litera2:
sub $55, %al

cmp $0, %r8 # sprawdzenie czy bajt nie jest ostatnim
jle zapis

# ZAPIS SKLEJONYCH BAJTOW DO TEMP
przeskok2:
# sklejenie bajtow z rejestru bl i al, w tym celu mnozymy al przez 16
mov $16, %cl
mul %cl
add %bl, %al

zapis:
mov %al, temp(, %r9, 1) # zapis sklejonego bajtu do bufora temp, 
                        #znajduje sie teraz w konwencji little endian

cmp $0, %r8 
jg petla2    # powrot na poczatek petli



# KONWERSJA NA SYSTEM ÓSEMKOWY I ZAPIS DO ASCII
mov $515, %r8  # Licznik bajtów z bufora temp
mov $1535, %r9 # Licznik znaków ósemkowych z bufora out_buffer

konwersja:

#sklejenie 3 bajtow z temp, 3->2->1 
mov $0, %rax
sub $2, %r8
mov temp(, %r8,1), %al
shl $8, %rax
inc %r8
mov temp(, %r8,1), %al
shl $8, %rax
inc %r8
mov temp(, %r8,1), %al
sub $3, %r8

mov $8, %r11 # licznik 24/3

wewn:
mov %al, %bl # przeniesienie bajtu 
and $7, %bl # zostawienie 3 pierwszych bitow
add $'0', %bl
mov %bl, out_buffer(, %r9, 1)
dec %r9

shr $3, %rax # przesuniecie sklejonych bitow o 3 w prawo
             # aby uzyskac dostep do kolejnej 3 bitow

dec %r11
cmp $0, %r11
jg wewn # skok na poczatEK zagniezdzonej petli

cmp $0, %r8
jg konwersja # skok na poczatek petli 3, aby skleic kolejne 3 bajty


# ZAPIS DO PLIKU
# otwarcie pliku, jesli nie istnieje, tworzy go z prawami 644
mov $SYSOPEN, %rax
mov $file_out, %rdi
mov $FWRITE, %rsi
mov $0644, %rdx
syscall
mov %rax, %r8

# zapis bufora out do pliku
movq $1536, %r9
movb $0x0A, out_buffer(, %r9, 1)
mov $SYSWRITE, %rax
#mov $STDOUT, %rdi
mov %r8, %rdi
mov $out_buffer, %rsi
mov $1537, %rdx
syscall
 
# Zamknięcie pliku
mov $SYSCLOSE, %rax
mov %r8, %rdi
mov $0, %rsi
mov $0, %rdx
syscall
 
# ZWROT WARTOŚCI EXIT_SUCCESS
mov $SYSEXIT, %rax
mov $EXIT_SUCCESS, %rdi
syscall








