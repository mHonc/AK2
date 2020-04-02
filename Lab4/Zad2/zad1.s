.data
 
.text
# deklarcja funkcji mozliwych do uzycia w programie C
.global szyfr_cezara
.type szyfr_cezara, @function
 
# funkcja przesuwajaca znak o 3
szyfr_cezara:
   
# odłożenie rejestru bazowego na stos i skopiwanie obecnej
# wartości wskaźnika stosu do rejestru bazowego
push %rbp  
mov %rsp, %rbp
 
# parametry wywołania funkcji umieszczone zostaną w rejestach RDI i RSI (text, len)

mov $0, %rax # lciznik znakow

petla:
 
# skopiowanie n-tego znaku stringa do rejestru BL
mov (%rdi, %rax, 1), %bl
 
cmp $'Z', %bl
jg zapisz
cmp $'A', %bl
jl zapisz
  
wielkie:
add $3, %bl
cmp $'Z', %bl
jle zapisz
sub $26, %bl # jesli wiekszy kod od Z, powrot na poczatek
 
# zapis zaszyfrowanego znaku do stringa, wartosc zwracana(string) umieszczona w %rax
zapisz:
mov %bl, (%rdi, %rax, 1)
inc %rax
cmp %rsi, %rax
jl petla
 
# przywrócenie poprzedniej wartości rejestru bazowego i wskaźnika stosu
mov %rbp, %rsp
pop %rbp
ret

