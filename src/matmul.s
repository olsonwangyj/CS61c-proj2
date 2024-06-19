.globl matmul

.text
# =======================================================
# FUNCTION: Matrix Multiplication of 2 integer matrices
# 	d = matmul(m0, m1)
# Arguments:
# 	a0 (int*)  is the pointer to the start of m0 
#	a1 (int)   is the # of rows (height) of m0
#	a2 (int)   is the # of columns (width) of m0
#	a3 (int*)  is the pointer to the start of m1
# 	a4 (int)   is the # of rows (height) of m1
#	a5 (int)   is the # of columns (width) of m1
#	a6 (int*)  is the pointer to the the start of d
# Returns:
#	None (void), sets d = matmul(m0, m1)
# Exceptions:
#   Make sure to check in top to bottom order!
#   - If the dimensions of m0 do not make sense,
#     this function terminates the program with exit code 72.
#   - If the dimensions of m1 do not make sense,
#     this function terminates the program with exit code 73.
#   - If the dimensions of m0 and m1 don't match,
#     this function terminates the program with exit code 74.
# =======================================================
matmul:
    # Error checks
    ble a1, zero, error1
    ble a2, zero, error1
    ble a4, zero, error2
    ble a5, zero, error2
    bne a2, a4, error3
    
    # Prologue
    addi sp, sp, -40
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    sw s3, 12(sp)
    sw s4, 16(sp)
    sw s5, 20(sp)
    sw s6, 24(sp)
    sw s7, 28(sp)
    sw s8, 32(sp)
    sw s9, 36(sp)
    mv s0, a0
    mv s1, a1
    mv s2, a2
    mv s3, a3
    mv s4, a4
    li s5, 0
    mv s7, a6
    mv s8, a5

outer_loop_start:
    bge s5, s1, outer_loop_end
    li s6, 0


inner_loop_start:
    bge s6, s8, inner_loop_end
    li a0, 4
    mul a0, a0, s5
    mul a0, a0, s2
    add a0, s0, a0
    li a1, 4
    mul a1, a1, s6
    add a1, a1, s3
    li a3, 1
    add a4, x0, s8
    mv a2, s2
    mv s9, ra
    jal ra, dot
    mv ra, s9
    sw a0, 0(s7)
    addi s6, s6, 1
    addi s7, s7, 4
    j inner_loop_start
    
inner_loop_end:
    addi s5, s5, 1
    j outer_loop_start

outer_loop_end:
    

    # Epilogue
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw s4, 16(sp)
    lw s5, 20(sp)
    lw s6, 24(sp)
    lw s7, 28(sp)
    lw s8, 32(sp)
    lw s9, 36(sp)
    addi sp, sp, 40
    
    ret
    
error1:
    li a1, 72
    j exit2
    
error2:
    li a1, 73
    j exit2
    
error3:
    li a1, 74
    j exit2