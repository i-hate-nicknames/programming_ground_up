    .include "linux.s"
    .include "record-def.s"

    .section .data
input_file_name:
    .ascii "records.dat\0"
output_file_name:
    .ascii "records.out.dat\0"

    .section .bss
    .lcomm record_buffer, 1

    ## local variable offsets
    .equ IN_FD, -4
    .equ OUT_FD, -8
    
    .section .text
    .globl _start
_start:
    movl %esp, %ebp
    subl $8, %esp

    movl $SYS_OPEN, %eax
    movl $input_file_name, %ebx
    movl $0, %ecx
    movl $0666, %edx
    int $LINUX_SYSCALL

    movl %eax, IN_FD(%ebp)

    movl $SYS_OPEN, %eax
    movl $output_file_name, %ebx
    movl $0101, %ecx
    movl $0666, %edx
    int $LINUX_SYSCALL

    movl %eax, OUT_FD(%ebp)

loop_begin:
    pushl IN_FD(%ebp)
    pushl $record_buffer
    call read_record
    addl $8, %esp

    cmpl $RECORD_SIZE, %eax
    jne loop_end
    incl record_buffer + RECORD_AGE
    pushl OUT_FD(%ebp)
    pushl $record_buffer
    call write_record
    add $8, %esp

    jmp loop_begin

loop_end:
    movl $SYS_EXIT, %eax
    movl $0, %ebx
    int $LINUX_SYSCALL
