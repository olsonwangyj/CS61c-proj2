.globl argmax

.text
# =================================================================
# FUNCTION: Given a int vector, return the index of the largest
#	element. If there are multiple, return the one
#	with the smallest index.
# Arguments:
# 	a0 (int*) is the pointer to the start of the vector
#	a1 (int)  is the # of elements in the vector
# Returns:
#	a0 (int)  is the first index of the largest element
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 77.
# =================================================================
argmax:
    # Prologue
    addi sp, sp, -8
    sw s0, 0(sp)
    sw s1, 4(sp)
    li s0, 0
    li s1, 0
    li t1, 1
    bge a1, t1, loop_start
    li a0, 77
    ecall

loop_start:
    bge s1, a1, loop_end
    li t0, 4
    mul t1, s1, t0
    add t1, a0, t1
    lw t1, 0(t1)
    mul t2, s0, t0
    add t2, a0, t2
    lw t2, 0(t2)
    beq t1, t2, loop_continue
    blt t1, t2, loop_continue
    mv s0, s1

loop_continue:
    addi s1, s1, 1
    j loop_start

loop_end:
    mv a0, s0
    # Epilogue
    lw s0, 0(sp)
    lw s1, 4(sp)
    addi sp, sp, 8

    ret
