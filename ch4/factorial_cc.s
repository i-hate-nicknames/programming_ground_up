# Purpose: given a number computes its factorial
# Uses different calling convention: passing argument
# via %eax

.section .data

.section .text

.globl _start
.globl factorial # to use factorial in other programs

_start:
    movl $3, %eax
    call factorial
    movl %eax, %ebx
    movl $1, %eax
    int $0x80

.type factorial,@function
factorial:
    push %ebp
    movl %esp, %ebp

    cmpl $1, %eax
    je end_factorial

    # save argument
    pushl %eax
    # decrement argument by 1 and calculate factorial of that value
    decl %eax
    call factorial # calculate (n-1)!
    popl %ebx # load n to ebx
    imull %ebx, %eax # multiply n by (n-1)!

end_factorial:
    movl %ebp, %esp
    popl %ebp
    ret
