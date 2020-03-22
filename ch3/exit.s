# Purpose: simple program that exists and returns status code to
# the kernel

# Input: none

# Output: returns the status code, that can be viewed via
# echo $? after running the program

# Variables:
#       %eax holds the system call number
#       %ebx holds the return status
        .section .data

        .section .text
        .globl _start

_start:
        # this is the linux kernel command number (system call) for
        # exiting a program
        movl $1, %eax

        # this is the status number that we return
        movl $15, %ebx

        # This is the interrupt to perform a system call
        int $0x80
