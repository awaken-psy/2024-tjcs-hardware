# ============================================
# 数组定义和数据段
# ============================================
.data
    matrix_a:    .space 240        # 数组A
    matrix_b:    .space 240        # 数组B
    matrix_c:    .space 240        # 数组C
    matrix_d:    .space 240        # 数组D

# ============================================
# 代码段
# ============================================
.text
    j startup
    exception_handler:
        nop
        j exception_handler

startup:
    # 初始化寄存器
    li $t0, 0           # 数组A元素值
    li $t1, 1           # 数组B元素值
    li $t2, 0           # 数组C元素值
    li $t3, 0           # 数组D元素值
    li $t4, 4           # 偏移量基值
    li $t5, 0           # A[i-1]初始值
    li $t6, 1           # B[i-1]初始值
    li $t7, 0           # 条件标志
    li $t8, 240         # 循环终止条件
    li $t9, 3           # 乘法常数3
    
    # 初始化数组A[0]
    li $s0, 0
    la $s1, matrix_a
    sw $t0, 0($s1)
    
    # 初始化数组B[0]
    la $s1, matrix_b
    sw $t0, 0($s1)
    
    # 初始化数组D[0]
    li $s2, 1
    la $s1, matrix_d
    sw $t1, 0($s1)

processing_loop:
    # 计算当前索引
    srl $s3, $t4, 2
    
    # 计算A[i] = A[i-1] + (i>>2)
    addu $t5, $t5, $s3
    la $s1, matrix_a
    addu $s1, $s1, $t4
    sw $t5, 0($s1)
    
    # 计算B[i] = B[i-1] + 3*(i>>2)
    mul $s4, $t9, $s3
    addu $t6, $t6, $s4
    la $s1, matrix_b
    addu $s1, $s1, $t4
    sw $t6, 0($s1)
    
    # 条件分支1: 前20个元素
    slti $t7, $t4, 80
    beq $t7, $zero, condition_2
    
    # 前20个元素的处理
    la $s1, matrix_d
    addu $s1, $s1, $t4
    sw $t6, 0($s1)
    
    # 保存中间值
    move $s5, $t5
    move $s6, $t6
    j condition_end

condition_2:
    # 条件分支2: 中间20个元素
    slti $t7, $t4, 160
    beq $t7, $zero, condition_3
    
    # C[i] = A[i] + B[i]
    addu $s5, $t5, $t6
    la $s1, matrix_c
    addu $s1, $s1, $t4
    sw $s5, 0($s1)
    
    # D[i] = A[i] * B[i]
    mul $s6, $t5, $t6
    la $s1, matrix_d
    addu $s1, $s1, $t4
    sw $s6, 0($s1)
    
    j condition_end

condition_3:
    # 条件分支3: 后20个元素
    # C[i] = A[i] * B[i]
    mul $s5, $t5, $t6
    la $s1, matrix_c
    addu $s1, $s1, $t4
    sw $s5, 0($s1)
    
    # D[i] = C[i] * B[i]
    mul $s6, $s5, $t6
    la $s1, matrix_d
    addu $s1, $s1, $t4
    sw $s6, 0($s1)

condition_end:
    # 循环控制
    addiu $t4, $t4, 4
    bne $t4, $t8, processing_loop
    
# ============================================
# 程序结束
# ============================================
program_exit:
    nop
    j program_exit