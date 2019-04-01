# Sayan Sivakumaran
# ssivakumaran
# 110261379

.text

strcmp:
	lb $t0, 0($a0)
	lb $t1, 0($a1)
	li $v0, 0

	addi $sp, $sp, -4	# Allocates space on stack
	sw $s0, 0($sp)		# Saved $s0 onto stack
	move $s0, $ra		# Move $ra value to be saved
	
	beq $t0, 0, strcmp.check_both_empty
	beq $t1, 0, strcmp.second_string_empty
	
	jal strcmp.loop
strcmp.loop:
	lb $t0, 0($a0)
	lb $t1, 0($a1)
	
	sub $t2, $t0, $t1
	bne $t2, 0, strcmp.end_loop
	beq $t1, 0, strcmp.end_loop	# Check for equal strings
	
	addi $a0, $a0, 1
	addi $a1, $a1, 1
	j strcmp.loop
strcmp.end_loop:
	move $v0, $t2
	j strcmp.exit
strcmp.check_both_empty:
	beq $t1, 0, strcmp.both_empty
	j strcmp.first_string_empty
strcmp.first_string_empty:
	lb $t0, 0($a1)
	beq $t0, 0, strcmp.exit
	
	addi $v0, $v0, -1
	addi $a1, $a1, 1
	j strcmp.first_string_empty	
strcmp.second_string_empty:
	lb $t0, 0($a0)
	beq $t0, 0, strcmp.exit
	
	addi $v0, $v0, 1
	addi $a0, $a0, 1
	j strcmp.first_string_empty
strcmp.both_empty:
	li $v0, 0
	j strcmp.exit
strcmp.exit:
	move $ra, $s0		# Restore $ra value
	lw $s0, 0($sp)		# Restore $s0 value
	addi $sp, $sp, 4	# Allocates space on stack
	
	j return
find_string:
jr $ra

hash:
jr $ra

clear:
jr $ra

get:
jr $ra

put:
jr $ra

delete:
jr $ra

build_hash_table:
jr $ra

autocorrect:
jr $ra
#------------------------------------- UTILS ------------------------------#
return:
	jr $ra
