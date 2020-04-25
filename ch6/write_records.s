.include "linux.s"
.include "record-def.s"

.section .data

# data of the records to write
# each text data item is padded with null bytes to
# occupy the fixed size specified in record-def.s

# .rept is used for padding: basically it repeats
# specified number of times whatever follows up until .endr

record1:
    .ascii "fredrick\0"
    .rept 31 # padding up to 40 bytes
    .byte 0
    .endr

    .ascii "Bartlett\0"
    .rept 31
    .byte 0
    .endr

    .ascii "4242 S Prairie\nTulsa, OK 55555\0"
    .rept 209
    .byte 0
    .endr

    .long 45 # age

record2:
    .ascii "Marilyn\0"
    .rept 32 # padding up to 40 bytes
    .byte 0
    .endr

    .ascii "Taylor\0"
    .rept 33
    .byte 0
    .endr

    .ascii "2224 S Johannan St\nChicago, IL 12345\0"
    .rept 203
    .byte 0
    .endr

    .long 29 # age

record3:
    .ascii "Derrick\0"
    .rept 32 # padding up to 40 bytes
    .byte 0
    .endr

    .ascii "McIterre\0"
    .rept 31
    .byte 0
    .endr

    .ascii "500 W Oakland\nSan Diego, CA 54321\0"
    .rept 206
    .byte 0
    .endr

    .long 31 # age

file_name:
    .ascii "records.dat\0"

.section .text

.equ ST_FD, -4

.globl _start

_start:
    movl %esp, %ebp
    subl $4, %esp

    movl $SYS_OPEN, %eax
    movl $file_name, %ebx
    movl $0101, %ecx # create if it doesn't exist and open for writing
    movl $0666, %edx
    int $LINUX_SYSCALL
    movl %eax, ST_FD(%ebp)

    pushl ST_FD(%ebp)
    pushl $record1
    call write_record
    addl $8, %esp

    pushl ST_FD(%ebp)
    pushl $record2
    call write_record
    addl $8, %esp

    pushl ST_FD(%ebp)
    pushl $record3
    call write_record
    addl $8, %esp

    movl $SYS_CLOSE, %eax
    movl ST_FD(%ebp), %ebx
    int $LINUX_SYSCALL

    movl $SYS_EXIT, %eax
    movl $0, %ebx
    int $LINUX_SYSCALL
