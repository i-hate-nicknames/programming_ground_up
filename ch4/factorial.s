# Purpose: given a number computes its factorial

.section .data

.section .text

.globl _start
.globl factorial # to use factorial in other programs

_start:
    pushl $5

    call factorial_iter
    addl $4, %esp
    movl %eax, %ebx
    movl $1, %eax
    int $0x80

.type factorial,@function
factorial:
    push %ebp
    movl %esp, %ebp

    # move the argument to eax
    # 3rd thing on the stack: first is old ebp
    # and second is return address
    movl 8(%ebp), %eax

    cmpl $1, %eax
    je end_factorial

    decl %eax
    pushl %eax
    call factorial # calculate (n-1)!
    movl 8(%ebp), %ebx # load n to ebx
    imull %ebx, %eax # multiply n by (n-1)!

end_factorial:
    movl %ebp, %esp
    popl %ebp
    ret

.type factorial_iter,@function
factorial_iter:
    push %ebp
    movl %esp, %ebp

    # move argument to ebx
    movl 8(%ebp), %ebx
    # eax will hold intermediate result
    movl $1, %eax

factorial_iter_loop:
    cmpl $0, %ebx
    je end_factorial_iter
    imull %ebx, %eax
    decl %ebx
    jmp factorial_iter_loop

end_factorial_iter:
    movl %ebp, %esp
    popl %ebp
    ret
