.globl classify

.text
classify:
    # =====================================
    # COMMAND LINE ARGUMENTS
    # =====================================
    # Args:
    #   a0 (int)    argc
    #   a1 (char**) argv
    #   a2 (int)    print_classification, if this is zero, 
    #               you should print the classification. Otherwise,
    #               this function should not print ANYTHING.
    # Returns:
    #   a0 (int)    Classification
    # Exceptions:
    # - If there are an incorrect number of command line args,
    #   this function terminates the program with exit code 89.
    # - If malloc fails, this function terminats the program with exit code 88.
    #
    # Usage:
    #   main.s <M0_PATH> <M1_PATH> <INPUT_PATH> <OUTPUT_PATH>

    li t0, 5
    bne a0, t0, error_89

	# =====================================
    # LOAD MATRICES
    # =====================================
    
    addi sp, sp, -52
    sw ra, 0(sp)
    sw s0, 4(sp)
    sw s1, 8(sp)
    sw s2, 12(sp)
    sw s3, 16(sp)
    sw s4, 20(sp)
    sw s5, 24(sp)
    sw s6, 28(sp)
    sw s7, 32(sp)
    sw s8, 36(sp)
    sw s9, 40(sp)
    sw s10, 44(sp)
    sw s11, 48(sp)

    mv s1, a1
    mv s2, a2


    # Load pretrained m0
    li a0, 4
    call malloc
    beq a0, x0, error_88
    mv s3, a0           # s3 is the memory of row for m0
    li a0, 4
    call malloc
    beq a0, x0, error_88
    mv s4, a0           # s4 is the memory of col for m0
    lw a0, 4(s1)
    mv a1, s3
    mv a2, s4
    call read_matrix
    mv s5, a0           # s5 if the memory of m0



    # Load pretrained m1
    li a0, 4
    call malloc
    beq a0, x0, error_88
    mv s6, a0           # s6 is the memory of row for m1
    li a0, 4
    call malloc
    beq a0, x0, error_88
    mv s7, a0           # s7 is the memory of col for m1
    lw a0, 8(s1)
    mv a1, s6
    mv a2, s7
    call read_matrix
    mv s8, a0           # s8 if the memory of m1



    # Load input matrix
    li a0, 4
    call malloc
    beq a0, x0, error_88
    mv s9, a0           # s9 is the memory of row for input
    li a0, 4
    call malloc
    beq a0, x0, error_88
    mv s10, a0           # s10 is the memory of col for input
    lw a0, 12(s1)
    mv a1, s9
    mv a2, s10
    call read_matrix
    mv s11, a0           # s11 if the memory of input

    
    lw s3, 0(s3)
    lw s4, 0(s4)
    lw s6, 0(s6)
    lw s7, 0(s7)
    lw s9, 0(s9)
    lw s10, 0(s10)

    # =====================================
    # RUN LAYERS
    # =====================================
    # 1. LINEAR LAYER:    m0 * input
    # 2. NONLINEAR LAYER: ReLU(m0 * input)
    # 3. LINEAR LAYER:    m1 * ReLU(m0 * input)
    li t0, 4
    mul t0, t0, s3
    mul t0, t0, s10
    mv a0, t0
    call malloc
    beq a0, x0, error_88
    mv s0, a0
    mv a6, s0
    mv a0, s5
    mv a1, s3
    mv a2, s4
    mv a3, s11
    mv a4, s9
    mv a5, s10
    call matmul
    # mv s0, a6            # linear 1 s0
    mv a0, s0
    mul a1, s3, s10
    call relu
    li t0, 4
    mul t0, t0, s6
    mul t0, t0, s10
    mv a0, t0
    call malloc
    beq a0, x0, error_88
    mv s5, a0
    mv a6, s5
    mv a0, s8
    mv a1, s6
    mv a2, s7
    mv a3, s0
    mv a4, s3
    mv a5, s10
    call matmul
    mv s0, s5
    #mv s0, a6            # linear 2 s0


    # =====================================
    # WRITE OUTPUT
    # =====================================
    # Write output matrix
    lw a0, 16(s1)
    mv a1, s0
    mv a2, s6
    mv a3, s10
    call write_matrix

    # =====================================
    # CALCULATE CLASSIFICATION/LABEL
    # =====================================
    # Call argmax
    mv a0, s0
    mul a1, s6, s10
    call argmax
    mv s1, a0
    
    bne s2, x0, not_print
    
    # Print classification
    mv a1, s1
    call print_int


    # Print newline afterwards for clarity
    li a1 '\n'
    jal print_char

not_print:
    #mv a0, s0
    #call free
    #mv a0, s5
    #call free
    #mv a0, s8
    #call free
    #mv a0, s11
    #call free
    #mv a0, s1

    lw ra, 0(sp)
    lw s0, 4(sp)
    lw s1, 8(sp)
    lw s2, 12(sp)
    lw s3, 16(sp)
    lw s4, 20(sp)
    lw s5, 24(sp)
    lw s6, 28(sp)
    lw s7, 32(sp)
    lw s8, 36(sp)
    lw s9, 40(sp)
    lw s10, 44(sp)
    lw s11, 48(sp)
    addi sp, sp, 52
    
    ret
    
error_89:
    li a1, 89
    jal exit2
    
error_88:
    li a1, 88
    jal exit2