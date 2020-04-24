# Purpose:  convert input file to an output file with all
#           the letters uppercased

# file names are provided as arguments: first argument is
# input file name, second argument is the output file name

.section .data

# Constants

# sys call numbers
.equ SYS_OPEN, 5
.equ SYS_WRITE, 4
.equ SYS_READ, 3
.equ SYS_CLOSE, 6
.equ SYS_EXIT, 1

# Options for open, look at /usr/include/asm/fcntl.h
.equ O_RDONLY, 0
.equ O_CREAT_WRONGLY_TRUNC, 03101

.equ STDIN, 0
.equ STDOUT, 1
.equ STDERR, 2

.equ LINUX_SYSCALL, 0x80

.equ EOF, 0

.equ NUM_ARGS, 2

.section .bss

.equ BUF_SIZE, 500
.lcomm BUF_DATA, BUF_SIZE

.lcomm FD_OUT, 4
.lcomm FD_IN, 4

.section .text

# Stack positions
.equ ST_SIZE_RESERVE, 8 # two 4-byte ints for file descriptors
# two file descriptors stored as local variables on the stack
.equ ST_FD_IN, -4
.equ ST_FD_OUT, -8
.equ ST_ARGC, 0
.equ ST_ARGV0, 4
.equ ST_ARGV1, 8
.equ ST_ARGV2, 12

.globl _start

_start:
    # save stack pointer
    movl %esp, %ebp

    # allocate space for local variables
    subl $ST_SIZE_RESERVE, %esp

open_files:
open_fd_in:
    # open syscall
    movl $SYS_OPEN, %eax
    # input filename is the first argument to the program
    movl ST_ARGV1(%ebp), %ebx
    movl $O_RDONLY, %ecx
    movl $0666, %edx
    int $LINUX_SYSCALL

store_fd_in:
    movl %eax, FD_IN

open_fd_out:
    # open syscall
    movl $SYS_OPEN, %eax
    # outiput filename is the second argument to the program
    movl ST_ARGV2(%ebp), %ebx
    movl $O_CREAT_WRONGLY_TRUNC, %ecx
    # mode for new file if it's created
    movl $0666, %edx
    int $LINUX_SYSCALL

store_fd_out:
    movl %eax, FD_OUT

read_loop_begin:
    # Read in a block from input file
    movl $SYS_READ, %eax
    # get input file descriptor
    movl FD_IN, %ebx
    # the location to read into
    movl $BUF_DATA, %ecx
    # size to read (at most this much will be read)
    movl $BUF_SIZE, %edx
    # size of buffer read is returned in %eax
    int $LINUX_SYSCALL

    # if reached the end, stop reading
    cmpl $EOF, %eax
    jle end_loop

continue_read_loop:
    # convert block to uppercase
    pushl $BUF_DATA # location of the buffer
    pushl %eax # size of the data (returned by read call previously)
    call convert_to_upper
    popl %eax # restore the size back
    addl $4, %esp # restore the stack

    # write the block to the output file
    movl %eax, %edx # size of the block
    movl $SYS_WRITE, %eax
    movl FD_OUT, %ebx
    movl $BUF_DATA, %ecx
    int $LINUX_SYSCALL

    jmp read_loop_begin

end_loop:
    # close the files
    movl $SYS_CLOSE, %eax
    movl FD_OUT, %ebx
    int $LINUX_SYSCALL

    movl $SYS_CLOSE, %eax
    movl FD_IN, %ebx
    int $LINUX_SYSCALL

    movl $SYS_EXIT, %eax
    movl $0, %ebx
    int $LINUX_SYSCALL

# Purpose: convert a block of data to the uppercase (ascii)

# arguments
.equ ST_BUFFER_LEN, 8
.equ ST_BUFFER, 12

# Constants
.equ LOWER_A, 'a'
.equ LOWER_Z, 'z'
.equ UPPER_CONVERSION, 'A' - 'a'

convert_to_upper:
    pushl %ebp
    movl %esp, %ebp

    movl ST_BUFFER(%ebp), %eax
    movl ST_BUFFER_LEN(%ebp), %ebx
    movl $0, %edi

    # do nothing for zero-length buffer
    cmpl $0, %ebx
    je end_convert_loop

convert_loop:
    movb (%eax, %edi, 1), %cl

    # go to the next byte unless it's between a and z
    cmpb $LOWER_A, %cl
    jl next_byte
    cmpb $LOWER_Z, %cl
    jg next_byte

    # otherwise convert byte to uppercase and write it back
    addb $UPPER_CONVERSION, %cl
    movb %cl, (%eax, %edi, 1)
next_byte:
    # go to the next byte unless we read the whole length
    incl %edi
    cmpl %edi, %ebx
    jne convert_loop

end_convert_loop:
    movl %ebp, %esp
    popl %ebp
    ret
