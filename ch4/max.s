# Purpose: working with pointers

.section .data

lst1:
    .long 1, 2, 5
lst1_end:

lst2:
    .long 5, 0, 3
lst2_end:

lst3:
    .long 31, 1, 12, 3
lst3_end:

.section .text

.globl _start

_start:
    # call max three times, return result of the third call
    # as exit status
    movl $lst1_end, %eax
    pushl %eax
    movl $lst1, %eax
    pushl %eax
    call max
    movl $lst2_end, %eax
    pushl %eax
    movl $lst2, %eax
    pushl %eax
    call max
    movl $lst3_end, %eax
    pushl %eax
    movl $lst3, %eax
    pushl %eax
    call max
    movl %eax, %ebx
    movl $1, %eax
    int $0x80


# Purpose:  calculate maximum number in a list
# Input:    first argument - start of the list
#           second argument - an address after the last element
# Output:   will give the maximum number as a return value in %eax
# Notes:    assume that list holds at least one element
# Variables:
#           %eax current max number
#           %ebx current number
#           %ecx pointer to the current number
max:
    pushl %ebp
    movl %esp, %ebp
    movl 8(%ebp), %ecx
    movl (%ecx), %eax
max_loop:
    movl (%ecx), %ebx
    cmpl %ebx, %eax
    jge max_skip
    movl %ebx, %eax
max_skip:
    addl $4, %ecx
    # check if we reached the end of the list
    cmpl 12(%ebp), %ecx
    jge max_end
    jmp max_loop

max_end:
    movl %ebp, %esp
    popl %ebp
    ret
