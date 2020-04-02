.bss
    .comm controlWord, 2

.text
.global checkExceptions, clearMasks, setMasks, maskException, testDivByZero
.type checkExceptions, @function
.type maskException, @function
.type testDivByZero, @function
.type setMasks, @function
.type clearMasks, @function

finit

checkExceptions:
    mov $0, %rax
    fstsw %ax           # wczytanie zawartosc rejestru statusu (statusword) do %ax
    fwait               # upewnienie, ze kolejna instrukacja wykona sie po wczytaniu do %ax
    and $0x0ff, %ax     # zostawienie tylko bitow wyjatkow
ret                     # wynik w rax

clearMasks:
    fnstcw controlWord   # wczytanie zawartosci rejestru kontrolnego do bufora
    fwait                
    mov controlWord, %ax
    and $0xffc0, %ax         # zamaskowanie wszystkich wyjatkow, mlodsze 6 bitow (maski) = 0
    mov %ax, controlWord
    fldcw controlWord   # zaladowanie do rejestru kontrolnego
ret

setMasks:
    fnstcw controlWord
    fwait
    mov controlWord, %ax
    or $0xffff, %ax           # udostepnienie wszystkich wyjatkow, mlodsze 6 bitow = 1
    mov %ax, controlWord
    fldcw controlWord 
ret


maskException:                # numer wyjatku w %rdi
    fnstcw controlWord
    fwait
    mov controlWord, %ax
    or %di, %ax               # udostepnienie wyjatku
    mov %ax, controlWord
    fldcw controlWord
ret

testDivByZero:
    fldz        # zaladowanie 0 do stosu fpu
    fld1        # zaladowanie 1 do stosu fpu
    fdivp       # dzielenie ST(0) / ST(1)
    fstp %st    # czyszczenie ostaniej wartosci stosu
ret
