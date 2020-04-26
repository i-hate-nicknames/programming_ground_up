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
.equ BUF_SIZE, 50
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
    # write buffer when it's full
    cmpl $BUF_SIZE, %edx
    jl continue_writing
    # save %ecx because it may be modified by write_buffer
    pushl %ecx
    call write_buffer
    popl %ecx
    movl $0, %edx
continue_writing:
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
    call write_buffer
end:
    movl %ebp, %esp
    popl %ebp
    ret

write_buffer:
    pushl %ebp
    movl %esp, %ebp
    push %ebx

    movl $SYS_WRITE, %eax
    movl $STDOUT, %ebx
    movl $BUF_DATA, %ecx
    # buf size is already in %edx
    int $LINUX_SYSCALL
    popl %ebx
    movl %ebp, %esp
    popl %ebp
    ret
