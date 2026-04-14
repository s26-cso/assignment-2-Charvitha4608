.data

.text
.globl next_greater

next_greater:
    # a0 = arr base address
    # a1 = n (size)
    # a2 = result array

    # save registers we are going to use
    addi sp, sp, -64
    sd ra, 56(sp)
    sd s0, 48(sp)
    sd s1, 40(sp)
    sd s2, 32(sp)
    sd s3, 24(sp)

    # move inputs into saved registers
    mv s0, a0      # arr
    mv s1, a1      # n
    mv s2, a2      # result

    li t0, 0       # i = 0

# set all result[i] = -1 initially
init_loop:
    bge t0, s1, init_done

    slli t1, t0, 2        # offset = i * 4
    add t1, s2, t1        # address of result[i]
    li t2, -1
    sw t2, 0(t1)          # result[i] = -1

    addi t0, t0, 1
    j init_loop

init_done:

    # stack empty  
    li s3, -1

    # start from rightmost element
    addi t0, s1, -1       # i = n-1

main_loop:
    blt t0, zero, done    # stop when i < 0

    # load current element arr[i]
    slli t1, t0, 2
    add t1, s0, t1
    lw t2, 0(t1)

# remove all elements from stack that are <= arr[i]
pop_loop:
    blt s3, zero, skip_pop   # if stack empty, stop

    # get index at top of stack
    slli t3, s3, 2
    add t3, sp, t3
    lw t4, 0(t3)

    # get value arr[top_index]
    slli t5, t4, 2
    add t5, s0, t5
    lw t6, 0(t5)

    # if arr[top] <= arr[i], pop it
    ble t6, t2, do_pop
    j skip_pop

do_pop:
    addi s3, s3, -1        # pop 
    j pop_loop

# if stack not empty, top gives next greater index
skip_pop:
    blt s3, zero, skip_store

    slli t3, s3, 2
    add t3, sp, t3
    lw t4, 0(t3)           # next greater index

    slli t5, t0, 2
    add t5, s2, t5
    sw t4, 0(t5)           # result[i] = index

# push current index onto stack
skip_store:
    addi s3, s3, 1
    slli t3, s3, 2
    add t3, sp, t3
    sw t0, 0(t3)

    addi t0, t0, -1        # move to left element
    j main_loop

done:
    # restore registers before returning
    ld ra, 56(sp)
    ld s0, 48(sp)
    ld s1, 40(sp)
    ld s2, 32(sp)
    ld s3, 24(sp)
    addi sp, sp, 64

    ret
