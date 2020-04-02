.text
.global add_ASM
.global rdtsc

.type add_ASM, @function
.type rdtsc, @function

add_ASM:
push %rbp
movq %rsp, %rbp

# vec1 w rdi, vec2 w rsi, n w rdx

movq $0, %r8
movq $0, %r9

next:
movq (%rdi,%r8,8), %mm0
movq (%rsi, %r8,8), %mm1
paddw %mm1, %mm0
movq  %mm0  ,(%rdi,%r8,8)
inc %r8
cmp %rdx,%r8
jne next


mov %rbp, %rsp
pop %rbp
ret

rdtsc:
push %rbp
movq %rsp, %rbp

mov $0, %rax
mov $0, %rdx
rdtsc
shl $32, %rdx
or %rdx, %rax 
# wynik w rax

mov %rbp, %rsp
pop %rbp
ret

