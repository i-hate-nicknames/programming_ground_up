.include "linux.s"
.include "record-def.s"

.section .text

.globl _start

_start:
    movl $1, %eax
    movl %eax, smth
    movl $SYS_EXIT, %eax
    movl $0, %ebx
    int $LINUX_SYSCALL
