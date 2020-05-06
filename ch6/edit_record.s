    .include "linux.s"
    .include "record-def.s"

    .section .data
input_file_name:
    .ascii "records.dat\0"

    .section .bss
    .lcomm record_buffer, 1

    ## local variable offsets
    .equ IN_FD, -4
    
    .section .text
    .globl _start
_start:
    movl %esp, %ebp
    subl $4, %esp

    movl $SYS_OPEN, %eax
    movl $input_file_name, %ebx
    movl $0102, %ecx
    movl $0666, %edx
    int $LINUX_SYSCALL

    movl %eax, IN_FD(%ebp)

loop_begin:
    pushl IN_FD(%ebp)
    pushl $record_buffer
    call read_record
    addl $8, %esp

    cmpl $RECORD_SIZE, %eax
    jne loop_end
    incl record_buffer + RECORD_AGE

    pushl IN_FD(%ebp)
    pushl $RECORD_OFFSET
    call adjust_position
    add $8, %esp
    
    pushl IN_FD(%ebp)
    pushl $record_buffer
    call write_record
    add $8, %esp

    jmp loop_begin

loop_end:
    movl $SYS_EXIT, %eax
    movl $0, %ebx
    int $LINUX_SYSCALL

    ## this function adjusts position in the given file
    ## arguments: 1st: file descriptor
    ##            2nd: bytes to adjust the position
    ## The number to adjust is added to current position
    ## in the fd

    .equ SEEK_CUR, 1
    .equ ADJUST_FD_ARG, 12
    .equ ADJUST_NUM_ARG, 8
adjust_position:
    pushl %ebp
    movl %esp, %ebp

    movl $SYS_LSEEK, %eax
    movl ADJUST_FD_ARG(%ebp), %ebx
    movl ADJUST_NUM_ARG(%ebp), %ecx
    movl $SEEK_CUR, %edx
    int $LINUX_SYSCALL
    
    movl %ebp, %esp
    popl %ebp
    ret
