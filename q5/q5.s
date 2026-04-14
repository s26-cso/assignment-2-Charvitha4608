.data
filename: .asciz "input.txt"
mode:     .asciz "r"
yesmsg:   .asciz "Yes\n"
nomsg:    .asciz "No\n"

.text
.globl main

main:
    # save registers
    addi sp, sp, -16
    sw ra, 12(sp)
    sw s0, 8(sp)
    sw s1, 4(sp)
    sw s2, 0(sp)

    # open file
    la a0, filename
    la a1, mode
    call fopen
    mv s0, a0          # s0 is file pointer

    # if file not opened
    beqz s0, exit

    # move to end to get size
    mv a0, s0
    li a1, 0
    li a2, 2  # as SEEK_END = 2
    call fseek

    # get size
    mv a0, s0
    call ftell
    mv s1, a0  # length

    li s2, 0           # left
    addi t0, s1, -1    # right 

loop:
    # stop when pointers cross
    bge s2, t0, is_palindrome

    # read left char
    mv a0, s0
    mv a1, s2
    li a2, 0  
    call fseek

    mv a0, s0
    call fgetc
    mv t1, a0

    # read right char
    mv a0, s0
    mv a1, t0
    li a2, 0
    call fseek

    mv a0, s0
    call fgetc
    mv t2, a0

    # compare
    bne t1, t2, not_palindrome

    # move both ptrs
    addi s2, s2, 1
    addi t0, t0, -1
    j loop

not_palindrome:
    la a0, nomsg
    call printf

    mv a0, s0
    call fclose
    j exit

is_palindrome:
    la a0, yesmsg
    call printf

    mv a0, s0
    call fclose

exit:
    # restore registers
    lw ra, 12(sp)
    lw s0, 8(sp)
    lw s1, 4(sp)
    lw s2, 0(sp)
    addi sp, sp, 16

    li a0, 0
    ret
