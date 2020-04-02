.data
STDIN = 0
STDOUT = 1
SYSWRITE = 1
SYSREAD = 0
SYSEXIT = 60
EXIT_SUCCESS = 0
NR_CIAGU = 8
    
.text
.global main
 
main:
    
push $NR_CIAGU
call func
pop %rax        #zapis wyniku do rax


exit:
movq $SYSEXIT, %rax
movq $EXIT_SUCCESS, %rdi
syscall


func:
push %rbp
mov %rsp, %rbp
sub $16, %rsp
mov 16(%rbp), %rbx
    # -8(%rbp) = n
        cmp $0, %rbx
        je is0
        cmp $1, %rbx
        je is1

        decq %rbx
        push %rbx
        call func # f(n-1)
        pop %rax 
        mov $5, %rbx  
        mul %rbx
        mov %rax, -16(%rbp)
        # -16(%rbp) = 5f(n-1)

        decq -8(%rbp)
        push -8(%rbp)
        call func
        pop %rbx
        # %rbx = f(n-2)
        
        sub  -16(%rbp), %rbx
        mov %rbx, 16(%rbp)
        jmp end
    is0:
        movq $3, 16(%rbp)
        jmp end
    is1:
        movq $1, 16(%rbp)    

end:
mov %rbp, %rsp
pop %rbp
ret


