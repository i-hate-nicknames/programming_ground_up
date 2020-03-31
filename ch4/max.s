# Purpose: working with pointers

.section .data

lst1:
    .long 1, 2, 5
lst1_end:

lst2:
    .long 5, 0, 3, 51
lst2_end:

lst3:
    .long 31, 1, 12, 3
lst3_end:

.section .text

.globl _start

# Just to show off: create an improvised list on the stack,
# with the top of the stack reserved as list end address,
# and three local variables after that that constitute the list
# Collect max numbers from different lists via max procedure
# and then call max procedure on the improvised list to get
# max value among the results

_start:
    # init "root" stack frame
    movl %esp, %ebp
    # reserve 16 bytes space for three integers and the list
    # ending
    subl $16, %esp
    # call max three times, store results as local variables
    # on the stack
    movl $lst1_end, %eax
    pushl %eax
    movl $lst1, %eax
    pushl %eax
    call max
    movl %eax, -4(%ebp)
    movl $lst2_end, %eax
    pushl %eax
    movl $lst2, %eax
    pushl %eax
    call max
    movl %eax, -8(%ebp)
    movl $lst3_end, %eax
    pushl %eax
    movl $lst3, %eax
    pushl %eax
    call max
    movl %eax, -12(%ebp)


    # call max giving it addresses to our stack. Since stack grows
    # downwards, we pass -12(%ebp) as start of the list and %ebp
    # as the end
    movl %ebp, %eax
    pushl %eax
    # put the addres of the first variable, the start of the list
    movl %ebp, %eax
    subl $12, %eax
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
