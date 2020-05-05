.include "linux.s"
.include "record-def.s"


# Purpose:  this function reads a record from the file
#           descriptor
# Input:    file descriptor and a buffer
# Output:   status code after writing data to the buffer

.equ ST_READ_BUFFER, 8
.equ ST_FD_READ, 12

.section .text

.globl read_record
.type read_record, @function

read_record:
    pushl %ebp
    movl %esp, %ebp

    # we use %ebx so we have to store previous value
    pushl %ebx
    movl ST_FD_READ(%ebp), %ebx
    movl ST_READ_BUFFER(%ebp), %ecx
    movl $RECORD_SIZE, %edx
    movl $SYS_READ, %eax
    int $LINUX_SYSCALL

    # %eax has return value which we will give back to our caller
    # restore ebx
    popl %ebx

    movl %ebp, %esp
    popl %ebp
    ret

# Purpose:  this function writes a record to the file
#           descriptor
# Input:    file descriptor and a buffer
# Output:   status code after writing data to the fd

.equ ST_WRITE_BUFFER, 8
.equ ST_FD_WRITE, 12

.globl write_record
.type write_record, @function

write_record:
    pushl %ebp
    movl %esp, %ebp
    pushl %ebx

    movl $SYS_WRITE, %eax
    movl ST_FD_WRITE(%ebp), %ebx
    movl ST_WRITE_BUFFER(%ebp), %ecx
    movl $RECORD_SIZE, %edx
    int $LINUX_SYSCALL

    popl %ebx
    movl %ebp, %esp
    popl %ebp
    ret
