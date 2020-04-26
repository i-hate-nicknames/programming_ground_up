.include "linux.s"

# Purpose:  print given string to stdout and print an additional
#           newline character
#           This function doesn't support more than 500 characters

# Input: the address of the first character in string

# Output: none

# Registers used:
# %al - current character
# %edx - index of current character
# %ecx - pointer to current character


.section .bss
.equ MAX_CHARS, 5
.equ BUF_SIZE, 6
.lcomm BUF_DATA, BUF_SIZE

.section .data
some_string:
.ascii "some guys kiss and tell\0"
newline_char:
.ascii "\n"

empty_str:
.ascii "\0"

.section .text

.globl printline
.type printline, @function

.equ ST_ARG_INPUT, 8

printline:
    pushl %ebp
    movl %esp, %ebp
    movl $0, %edx
    movl ST_ARG_INPUT(%ebp), %ecx
copy_loop:
    # todo: print multiple times from the same buffer
    cmpl $MAX_CHARS, %edx
    je end
    movb (%ecx), %al
    cmpb $0, %al
    je add_newline
    # copy character to the buffer
    movb %al, BUF_DATA(%edx)
    incl %edx
    incl %ecx
    jmp copy_loop
add_newline:
    movb newline_char, %al
    movb %al, BUF_DATA(%edx)
    incl %edx
print:
    movl $SYS_WRITE, %eax
    movl $STDOUT, %ebx
    movl $BUF_DATA, %ecx
    # buf size is already in %edx
    int $LINUX_SYSCALL
end:
    movl %ebp, %esp
    popl %ebp
    ret

.globl _start

_start:
    movl $some_string, %eax
    pushl %eax
    call printline
    movl $SYS_EXIT, %eax
    int $LINUX_SYSCALL
