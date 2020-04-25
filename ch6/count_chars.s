.include "linux.s"
# Purpose: count the characters until null byte is reached

# Input: the address of the first character in string

# Output: returns lengh in %eax

# Registers used:
# %ecx - character count
# %al - current char
# %edx - current character address

.section .text
.globl count_chars
.type count_chars, @function

.equ STR_ADDR, 8

count_chars:
    pushl %ebp
    movl %esp, %ebp

    movl STR_ADDR(%ebp), %edx
    movl $0, %ecx
cmp_loop:
    movb (%edx), %al
    cmpb $0, %al
    je end
    incl %ecx
    incl %edx
    jmp cmp_loop

end:
    movl %ecx, %eax
    movl %ebp, %esp
    popl %ebp
    ret
