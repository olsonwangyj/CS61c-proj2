.globl dot

.text
# =======================================================
# FUNCTION: Dot product of 2 int vectors
# Arguments:
#   a0 (int*) is the pointer to the start of v0
#   a1 (int*) is the pointer to the start of v1
#   a2 (int)  is the length of the vectors
#   a3 (int)  is the stride of v0
#   a4 (int)  is the stride of v1
# Returns:
#   a0 (int)  is the dot product of v0 and v1
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 75.
# - If the stride of either vector is less than 1,
#   this function terminates the program with error code 76.
# =======================================================
dot:
    li t0, 1
    blt a2, t0, error1
    blt a3, t0, error2
    blt a4, t0, error2
    # Prologue
    addi sp, sp, -16
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    sw ra, 12(sp)
    li s1, 0
    li s0, 0
    mv s2, a2

loop_start:
    bge s1, s2, loop_end
    mul t0, a3, s1
    mul t1, a4, s1
    li t3, 4
    mul t0, t0, t3
    mul t1, t1, t3
    add t0, a0, t0
    add t1, a1, t1
    lw t0, 0(t0)
    lw t1, 0(t1)
    mul t2, t0, t1
    add s0, s0, t2
    addi s1, s1, 1
    j loop_start

loop_end:
    mv a0, s0

    # Epilogue
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw ra, 12(sp)
    addi sp, sp, 16
    
    ret

error1:
    li a0, 75
    ecall
    j exit
    
error2:
    li a0, 76
    ecall

exit: