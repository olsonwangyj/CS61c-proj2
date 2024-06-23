.globl read_matrix

.text
# ==============================================================================
# FUNCTION: Allocates memory and reads in a binary file as a matrix of integers
#
# FILE FORMAT:
#   The first 8 bytes are two 4 byte ints representing the # of rows and columns
#   in the matrix. Every 4 bytes afterwards is an element of the matrix in
#   row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is a pointer to an integer, we will set it to the number of rows
#   a2 (int*)  is a pointer to an integer, we will set it to the number of columns
# Returns:
#   a0 (int*)  is the pointer to the matrix in memory
# Exceptions:
# - If malloc returns an error,
#   this function terminates the program with error code 88.
# - If you receive an fopen error or eof, 
#   this function terminates the program with error code 90.
# - If you receive an fread error or eof,
#   this function terminates the program with error code 91.
# - If you receive an fclose error or eof,
#   this function terminates the program with error code 92.
# ==============================================================================
read_matrix:

    # Prologue
	addi sp, sp, -28
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    sw s3, 12(sp)
    sw s4, 16(sp)
    sw s5, 20(sp)
    sw ra, 24(sp)
    mv s0, a0
    mv s1, a1
    mv s2, a2
    
    mv a1, s0
    add a2, x0, x0
    call fopen
    li t0, -1
    beq a0, t0, fopen_error
   
    mv s3, a0                  # s3 is the file descriptor
    mv a1, s3
    mv a2, s1
    li a3, 4
    call fread
    bne a0, a3, fread_error
    
    mv a1, s3
    mv a2, s2
    li a3, 4
    call fread
    bne a0, a3, fread_error
    
    lw t0, 0(s1)
    lw t1, 0(s2)
    mul s4, t0, t1              # s4 is the row * col
    li t2, 4
    mul s4, t2, s4
    mv a0, s4
    call malloc
    beq a0, x0, malloc_error
    mv s5, a0                   # s5 is the array
    mv a1, s3
    mv a2, s5
    mv a3, s4
    call fread
    bne a0, a3, fread_error
    
    mv a1, s3
    call fclose
    bne a0, x0, fclose_error
    
    mv a0, s5
    mv a1, s1
    mv a2, s2
    
    # Epilogue
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw s4, 16(sp)
    lw s5, 20(sp)
    lw ra, 24(sp)
    addi sp, sp, 28

    ret
    
fopen_error:
    li a1, 90
    j exit2

fread_error:
    li a1, 91
    jal exit2
    
malloc_error:
    li a1, 88
    jal exit2
    
fclose_error:
    li a1, 92
    jal exit2
    