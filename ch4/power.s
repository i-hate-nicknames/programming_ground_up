# Purpose: illustrate how functions work
# compute the value of 2^3 + 3^4

.section .data

.section .text

.globl _start

_start:
    pushl $3
    pushl $2
    call power # calculate 2^3, result in eax
    addl $8, %esp # remove pushed arguments
    pushl %eax # push 2^3 to the stack
    pushl $4
    pushl $3
    call power # calculate 3^4, result in eax
    addl $8, %esp # remove arguments
    popl %ebx # move 2^3 to ebx from the stack
    addl %eax, %ebx # add eax (3^4) and ebx (2^3), result in ebx

    # call exit system call, result as status code in ebx
    movl $1, %eax
    int $0x80

# Purpose: compute the value of a number raised to a power

# Input:    First argument - the base number
#           Second argument - the power to raise to

# Output:   Will give the result as a return value

# Notes:    the power must be 1 or greater

# Variables:
#           %ebx - holds the base number
#           %ecx - holds the power
#           -4(%ebp) - holds the current result
#           %eax is used for temp storage

# tell the linker that its a function
.type power, @function

power:
    # setup stack
    pushl %ebp
    movl %esp, %ebp
    subl $4, %esp # reserve space for one local variable

    # put arguments to registers
    movl 8(%ebp), %ebx 
    movl 12(%ebp), %ecx

    movl %ebx, -4(%ebp) # store current result

power_loop_start:
    cmpl $1, %ecx
    je end_power
    movl -4(%ebp), %eax
    imull %ebx, %eax

    movl %eax, -4(%ebp)
    decl %ecx
    jmp power_loop_start

end_power:
    movl -4(%ebp), %eax
    movl %ebp, %esp
    popl %ebp
    ret
