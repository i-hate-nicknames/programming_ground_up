# Purpose: This program finds the maximum number of
# a set of data items

# Variables:
# %edi - holds the index of the data item being examined
# %ebx - largest data item found
# %eax - current data item
# data_items: contains the item data, 0 - terminated


.section .data

data_items:
    .long 3, 11, 12, 13, 11, 5, 41, 42, 5, 3, 125
data_items_end:

.section .text

.globl _start

_start:
    movl $0, %edi # 0 to index register
    # load the first byte of data
    movl data_items(,%edi,4), %eax 
    movl %eax, %ebx # the first item is the biggest so far

start_loop:
    movl %edi, %ecx
    addl $data_items, %ecx
    cmpl $data_items_end, %ecx
    # exit when we reach last element
    jge loop_exit
    # increment index to the next
    addl $4, %edi
    # load next value, using index register %edi
    movl data_items(,%edi,1), %eax
    # compare current element with current maximum
    cmpl %ebx, %eax
    # when current is less, go back to the start of the
    # loop
    jle start_loop
    # otherwise, update maximum element
    movl %eax, %ebx
    # now go back to the start of the loop
    jmp start_loop
loop_exit:
    # exit program, %ebx already holds max element
    # which will be returned as exit code of the program
    movl $1, %eax
    int $0x80
