.data
STDIN = 0
STDOUT = 1
SYSREAD = 0
SYSWRITE = 1
SYSEXIT = 60
EXIT_SUCCESS = 0
 
.bss
.comm ascii_in1, 1024 # Bufor przechowujący pierwszy ciąg znaków ASCII
.comm ascii_in2, 1024 # Bufor przechowujący drugi ciąg znaków ASCII
.comm ascii_out, 1027 # Bufor przechowujący wynikowy ciąg znaków ASCII
                      # Jest on większy od poprzednich o 1 znak,
                      # aby pomieścić przeniesienie z poprzedniej pozycji
                      # i znak nowej linii.
.comm value_in1, 513 # Bufor przechowujący pierwszą liczbę w postaci bajtowej
.comm value_in2, 513 # -||- drugą
.comm value_out, 513 # -||- wynik
 
.text
.globl main
 
main:
# WYZEROWANIE BUFORÓW WARTOŚCI
mov $513, %r8
mov $0, %al
 
petla1:
dec %r8
mov %al, value_in1(, %r8, 1)
mov %al, value_in2(, %r8, 1)
cmp $0, %r8
jg petla1
 
 
 
# WCZYTANIE PIERWSZEGO CIĄGU
mov $SYSREAD, %rax
mov $STDIN, %rdi
mov $ascii_in1, %rsi
mov $1024, %rdx
syscall
 
# DEKODOWANIE JEGO WARTOŚCI W PĘTLI
mov %rax, %r8 # Przeniesienie długości wczytanego ciągu do rejestru R8
dec %r8       # Nie potrzebujemy znaku końca linii
mov $513, %r9 # Licznik do pętli (liczymy od końca)
 
petla2:
dec %r8
dec %r9
 
# DEKODOWANIE PIERWSZYCH 4 BITÓW
mov ascii_in1(, %r8, 1), %al
 
# Wybór odpowiedniej sytuacji poniżej
cmp $'A', %al
jge litera
 
# Jeśli cyfra < A
sub $'0', %al
jmp powrot_do_petli2_1
 
# Jeśli cyfra >= A
litera:
sub $55, %al
 
# Powrót do pętli po odjęciu kodu '0' lub 'A'
# aby uzyskać wartośc cyfry z jej kodu ASCII.
powrot_do_petli2_1:
 
# Wyskok z pętli jeśli zdekodowano ostatnią cyfrę z bufora valueX_in
cmp $0, %r8
jle powrot_do_petli2_3
 
# DEKODOWANIE KOLEJNYCH 4 BITÓW
mov %al, %bl
dec %r8
mov ascii_in1(, %r8, 1), %al
 
cmp $'A', %al
jge litera2
 
sub $'0', %al
jmp powrot_do_petli2_2
 
litera2:
sub $55, %al
 
powrot_do_petli2_2:
# Pomnożenie wartości zdekodowanej cyfry przez 16 (drugiej części
# bajtu) i dodanie jej do obecnej liczby w buforze.
mov $16, %cl
mul %cl
add %bl, %al
 
# Zapisanie zdekodowanego bajtu danych do nowego bufora
powrot_do_petli2_3:
mov %al, value_in1(, %r9, 1)
 
# Powrót na początek pętli, aż do zdekodowania całego ciągu
cmp $0, %r8
jg petla2
 
 
 
# WCZYTANIE DRUGIEGO CIĄGU
mov $SYSREAD, %rax
mov $STDIN, %rdi
mov $ascii_in2, %rsi
mov $1024, %rdx
syscall
 
# DEKODOWANIE JEGO WARTOŚCI W PĘTLI
mov %rax, %r8
dec %r8
mov $513, %r9
 
petla3:
dec %r8
dec %r9
 
# DEKODOWANIE PIERWSZYCH 4 BITÓW
mov ascii_in2(, %r8, 1), %al
 
cmp $'A', %al
jge litera3
 
sub $'0', %al
jmp powrot_do_petli3_1
 
litera3:
sub $55, %al
 
powrot_do_petli3_1:
cmp $0, %r8
jle powrot_do_petli3_3
 
# DEKODOWANIE KOELJNYCH 4 BITÓW
mov %al, %bl
dec %r8
mov ascii_in2(, %r8, 1), %al
 
cmp $'A', %al
jge litera4
 
sub $'0', %al
jmp powrot_do_petli3_2
 
litera4:
sub $55, %al
 
powrot_do_petli3_2:
mov $16, %cl
mul %cl
add %bl, %al
 
# Zapisanie zdekodowanej bajtu do nowego bufora
powrot_do_petli3_3:
mov %al, value_in2(, %r9, 1)
 
cmp $0, %r8
jg petla3
 
 
 
# DODANIE OBU WARTOSCI
clc           # Wyczyszczenie flagi przeniesienia z poprzedniej pozycji
pushfq        # Umieszczenie rejestru flagowego na stosie
mov $512, %r8 # Licznik do pętli
 
petla4:
mov value_in1(, %r8, 1), %al # Odczyt wartości z buforów
mov value_in2(, %r8, 1), %bl # do rejestrów AL i BL
popfq        # Pobranie zawartości rejestru flagowego ze stosu
             # (rozkaz CMP modyfikuje flagę przeniesienia)
adc %bl, %al # Dodanie z propagacją i przyjęciem przeniesienia
pushfq       # Umieszczenie rejestru flagowego na stosie
mov %al, value_out(, %r8, 1) # Zapis nowej wartości do bufora
 
dec %r8     # Zmniejszenie licznika pętli i powrót na jej początek
cmp $0, %r8 # aż do wykonania dodawania dla każdej pozycji w buforze wynikowym.
jg petla4
 
 
 
# ZAMIANA NA ZNAKI HEX
mov $512, %r8  # Liczniki do pętli
mov $1025, %r9
 
petla5:
mov value_out(, %r8, 1), %al # Odczyt wartości
mov %al, %bl # Skopiowanie wartości do rejestru AL
mov %al, %cl # -||- CL
# "Rozdzielenie" liczby na dwie 4 bitowe części.
# W rejestrze BL znajdą się 4 najmniej znaczące bity.
# W rejestrze CL 4 kolejne.
shr $4, %cl
and $0b1111, %bl
and $0b1111, %cl
add $'0', %bl # Dodanie kodów ASCII '0' do każdej z części
add $'0', %cl
 
# Jeśli wartość w BL jest większa niż 9,
# dodanie stosownej wartości, tak aby wynikiem była litera A-F.
cmp $'9', %bl
jle dalej
add $7, %bl
 
dalej:
# Podobnie jak wyżej, ale dla rejestru CL.
cmp $'9', %cl
jle dalej2
add $7, %cl
 
dalej2:
# Zapis wartości do bufora wynikowego
# i zmniejszenie licznika pozycji w tym buforze.
mov %bl, ascii_out(, %r9, 1)
dec %r9
mov %cl, ascii_out(, %r9, 1)
dec %r9
 
# Zmniejszenie licznika pętli i wykonanie jej dla wszystkich pozycji liczb.
dec %r8
cmp $0, %r8
jge petla5
 
 
 
# WYŚWIETLENIE WYNIKU
movq $1026, %r8
movb $0x0A, ascii_out(, %r8, 1) # Dodanie do wyniku znaku końca linii
mov $SYSWRITE, %rax
mov $STDOUT, %rdi
mov $ascii_out, %rsi
mov $1027, %rdx
syscall
 
# ZWROT WARTOŚCI EXIT_SUCCESS
mov $SYSEXIT, %rax
mov $EXIT_SUCCESS, %rdi
syscall






