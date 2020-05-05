.include "linux.s"
.include "record-def.s"

.section .data
file_name:
    .ascii "records.dat\0"

.section .bss
.lcomm record_buffer, RECORD_SIZE

.section .text

.globl _start

_start:
    # offsets for space for local variables
    .equ ST_IN_FD, -4
    .equ ST_OUT_FD, -8
    movl %esp, %ebp
    subl $8, %esp

    movl $SYS_OPEN, %eax
    movl $file_name, %ebx
    movl $0, %ecx # open for read only
    movl $0666, %edx
    int $LINUX_SYSCALL

    movl %eax, ST_IN_FD(%ebp)

    # even though it's a constant we still
    # save it, in case we would like to switch
    # to a filename later
    movl $STDOUT, ST_OUT_FD(%ebp)

read_loop:
    # read from input fd into buffer
    pushl ST_IN_FD(%ebp)
    pushl $record_buffer
    call read_record
    # if size read is not the same as size of a record
    # goto end
    cmpl $RECORD_SIZE, %eax
    jne end
    
    # print record's first name
    # since first name is first
    pushl $record_buffer + RECORD_FIRSTNAME
    call printline
    pushl $record_buffer + RECORD_LASTNAME
    call printline
    subl $8, %esp
    jmp read_loop

end:
    movl $SYS_EXIT, %eax
    movl $0, %ebx
    int $LINUX_SYSCALL
