# Sayan Sivakumaran
# ssivakumaran
# 110261379

.text

#------------------------------------- STRING COMPARISON ------------------------------#
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
	
#------------------------------------- FIND STRING ------------------------------#
find_string:
	addi $sp, $sp, -4	# Allocates space on stack
	sw $s0, 0($sp)		# Saved $s0 onto stack
	move $s0, $ra		# Move $ra value to be saved
	
	move $t2, $a0		# Keep base string address 
	li $t3, 0		# Keep track of index
	li $t4, 0		# Keep track of potential string index		
	j find_string.check_word
find_string.check_word:
	lb $t0, 0($a1)
	lb $t1, 0($t2)
	
	beq $t3, $a2, find_string.fail
	bne $t0, $t1, find_string.jump_to_next_word
	beq $t0, 0, find_string.found
	
	addi $a1, $a1, 1
	addi $t2, $t2, 1
	addi $t3, $t3, 1
	
	j find_string.check_word
find_string.found:
	move $v0, $t4
	j find_string.exit
find_string.jump_to_next_word:
	lb $t0, 0($a1)
	
	addi $a1, $a1, 1
	addi $t3, $t3, 1
	move $t2, $a0
	move $t4, $t3
	beq $t0, '\0', find_string.check_word
	j find_string.jump_to_next_word
find_string.check_found:
	bne $t1, 0, find_string.fail
	
	move $v0, $t4
	j find_string.exit
find_string.fail:
	li $v0, -1
	j find_string.exit
find_string.exit:
	move $ra, $s0		# Restore $ra value
	lw $s0, 0($sp)		# Restore $s0 value
	addi $sp, $sp, 4	# Allocates space on stack
	
	j return
#------------------------------------- HASH ------------------------------#
hash:
	addi $sp, $sp, -4	# Allocates space on stack
	sw $s0, 0($sp)		# Saved $s0 onto stack
	move $s0, $ra		# Move $ra value to be saved
	
	li $v0, 0
	lw $t0, 0($a0)
	j hash.loop
hash.loop:
	lb $t1, 0($a1)
	
	beq $t1, 0, hash.modulus
	
	add $v0, $v0, $t1
	addi $a1, $a1, 1
	
	j hash.loop
hash.modulus:
	div $v0, $t0
	mfhi $v0
	
	j hash.exit
hash.exit:
	move $ra, $s0		# Restore $ra value
	lw $s0, 0($sp)		# Restore $s0 value
	addi $sp, $sp, 4	# Allocates space on stack
	
	j return
#------------------------------------- CLEAR ------------------------------#
clear:
	addi $sp, $sp, -4	# Allocates space on stack
	sw $s0, 0($sp)		# Saved $s0 onto stack
	move $s0, $ra		# Move $ra value to be saved
	
	sw $zero, 4($a0)	# Reset size
	
	lw $t0, 0($a0)		# Load capacity
	addi $a0, $a0, 8	# Jump to first key
	sll $t0, $t0, 1		# Multiply by two, since values and keys array are next to each other
	li $t1, 0		# Iterator
	j clear.loop		# Loop through keys and values array
clear.loop:
	beq $t1, $t0, clear.exit

	sw $zero, 0($a0)	# Change value to 0
	
	addi $a0, $a0, 4
	addi $t1, $t1, 1
	
	j clear.loop	
clear.exit:
	move $ra, $s0		# Restore $ra value
	lw $s0, 0($sp)		# Restore $s0 value
	addi $sp, $sp, 4	# Allocates space on stack
	
	j return
#------------------------------------- GET ------------------------------#
get:
	addi $sp, $sp, -24	# Allocates space on stack
	sw $s0, 20($sp)		# Saved $s0 onto stack
	sw $s1, 16($sp)
	sw $s2, 12($sp)
	sw $s3, 8($sp)
	sw $s4, 4($sp)
	sw $s5, 0($sp)
	sw $s6, 0($sp)
	move $s0, $ra		# Move $ra value to be saved
	move $s1, $a0		# Hash Table
	move $s2, $a1		# Key
	lb   $s3, 0($a0)	# Capacity
	
	jal hash		# Compute hash number
	move $s4, $v0		# Hash value
	move $s5, $zero		# Number of probes, exit when $s5 == $s3
	
	addi $s1, $s1, 8	# Jump to actual table
	
	move $t0, $s4
	sll $t0, $t0, 2		
	add $s1, $s1, $t0	# Advance to hash value index
	
	j get.search.check_loop_around
get.search.check_loop_around:
	sub $t0, $s3, $s4
	bne $t0, $s5, get.search	# If probes not at end, keep going
	
	move $t1, $s3			# Else, loop back through hash table
	sll $t1, $t1, 2
	sub $s1, $s1, $t1
	
	j get.search
get.search:
	beq $s5, $s3, get.error

	lw $a0, 0($s1)
	beq $a0, 0, get.error
	move $a1, $s2
	jal strcmp
	beq $v0, 0, get.success
	
	addi $s1, $s1, 4
	addi $s5, $s5, 1
	j get.search.check_loop_around	
get.error:
	li $v0, -1
	move $v1, $s5
	j get.exit
get.success:
	add $v0, $s5, $s4
	div $v0, $s3
	mfhi $v0
	
	move $v1, $s5
	j get.exit
get.exit:
	move $ra, $s0		# Restore $ra value
	lw $s5, 0($sp)
	lw $s4, 4($sp)
	lw $s3, 8($sp)
	lw $s2, 12($sp)		# Restore $s0 value
	lw $s1, 16($sp)
	lw $s0, 20($sp)
	addi $sp, $sp, 24	# Allocates space on stack
	
	j return
#------------------------------------- PUT ------------------------------#
put:
	addi $sp, $sp, -16	# Allocates space on stack
	sw $s0, 12($sp)		# Saved $s0 onto stack
	sw $s1, 8($sp)
	sw $s2, 4($sp)
	sw $s3, 0($sp)
	move $s0, $ra		# Move $ra value to be saved
	move $s1, $a0		# Hash table
	move $s2, $a1		# Key
	move $s3, $a2		# Value
	
	jal get
	beq $v0, -1, put.not_found
	
	move $t0, $v0		# Index of found element
	sll $t0, $t0, 2		# Multiply by 4 to get right index
	lw $t1, 0($s1)		# Capacity of hash table
	
	addi $s1, $s1, 8	# Jump ahead to actual hash table
	add $s1, $s1, $t0	# Move to key
	sw $s2, 0($s1)
	add $s1, $s1, $t1	# Jump ahead to value
	sw $s3, 0($s1)
	
	j put.exit
put.not_found:
	lw $t0, 0($s1)
	lw $t1, 4($s1)
	beq $t0, $t1, put.full
	
	move $a0, $s1
	move $a1, $s2
	jal hash	# Compute hash of key
	
	lw $t0, 0($s1)		# Get capacity
	move $t1, $v0		# Hash index
	sub $t2, $t0, $t1	# Limit to loop back
	move $t3, $zero		# Iterator for number of probes
	
	sll $v0, $v0, 2
	addi $s1, $s1, 8	# Jump ahead to actual hash table
	add $s1, $s1, $v0	# Jump ahead to start at hash
	
	j put.loop.check_loop_around
put.loop.check_loop_around:
	sub $t5, $t0, $t1
	bne $t3, $t5, put.loop	# If probes not at end, keep going
	
	move $t6, $t0			# Else, loop back through hash table
	sll $t6, $t6, 2
	sub $s1, $s1, $t6
	
	j put.loop
put.loop:
	lw $t4, 0($s1)
	beq $t4, 0, put.insert
	beq $t4, 1, put.insert
	
	addi $t3, $t3, 1
	addi $s1, $s1, 4
	j put.loop.check_loop_around
put.insert:
	sw $s2, 0($s1)	# Insert key
	move $t9, $t0
	sll $t9, $t9, 2
	add $s1, $s1, $t9
	sw $s3, 0($s1)	# Insert value
	j put.end
put.end:
	add $v0, $t1, $t3
	div $v0, $t0
	mfhi $t9
	move $v0, $t9
	move $v1, $t3
	
	j put.exit	
put.full:
	li $v0, -1
	li $v1, -1
	j put.exit
put.exit:
	move $ra, $s0		# Restore $ra value
	lw $s3, 0($sp)
	lw $s2, 4($sp)
	lw $s1, 8($sp)
	lw $s0, 12($sp)		# Restore $s0 value
	addi $sp, $sp, 16	# Allocates space on stack
	
	j return
#------------------------------------- DELETE ------------------------------#
delete:
	addi $sp, $sp, -8	# Allocates space on stack
	sw $s0, 4($sp)		# Saved $s0 onto stack
	sw $s1, 0($sp)
	move $s0, $ra		# Move $ra value to be saved
	move $s1, $a0
	
	lw $t0, 4($a0)
	beq $t0, 0, delete.empty
	
	jal get
	beq $v0, -1, delete.exit
	
	lw $t0, 4($s1)
	addi $t0, $t0, -1
	sw $t0, 4($s1)
	
	lw $t1, 0($s1)	# Load capacity
	sll $t1, $t1, 2	# Get capacity jump
	sll $t0, $v0, 2	# Get hash jump
	
	addi $s1, $s1, 8	# Jump to actual table
	add $s1, $s1, $t0	# Jump to hash
	sw $zero, 0($s1)
	add $s1, $s1, $t1	# Jump to value
	sw $zero, 0($s1)
	
	j delete.exit
	
delete.empty:
	li $v0, -1
	li $v1, 0
	j delete.exit
delete.exit:
	move $ra, $s0		# Restore $ra value
	lw $s1, 0($sp)
	lw $s0, 4($sp)		# Restore $s0 value
	addi $sp, $sp, 8	# Allocates space on stack
	
	j return
#------------------------------------- BUILD HASH TABLE ------------------------------#
build_hash_table:
	addi $sp, $sp, -24	# Allocates space on stack
	sw $s0, 20($sp)		# Saved $s0 onto stack
	sw $s1, 16($sp)
	sw $s2, 12($sp)
	sw $s3, 8($sp)
	sw $s4, 4($sp)
	sw $s5, 0($sp)
	move $s0, $ra		# Move $ra value to be saved
	move $s1, $a0		# Hash Table
	move $s2, $a1		# Strings
	move $s3, $a2		# Length of strings
	move $s4, $a3		# Filename
	move $s5, $zero		# Iterator
	
	move $a0, $s1
	jal clear	# Clear Hash Table
	
	move $a0, $s4	# Open File
	li $v0, 13
	syscall
	
build_hash_table.exit:
	move $ra, $s0		# Restore $ra value
	lw $s5, 0($sp)
	lw $s4, 4($sp)
	lw $s3, 8($sp)
	lw $s2, 12($sp)
	lw $s1, 16($sp)
	lw $s0, 20($sp)		# Restore $s0 value
	addi $sp, $sp, 24	# Allocates space on stack
	
	j return
#------------------------------------- AUTOCORRECT ------------------------------#
autocorrect:
	addi $sp, $sp, -4	# Allocates space on stack
	sw $s0, 0($sp)		# Saved $s0 onto stack
	move $s0, $ra		# Move $ra value to be saved
autocorrect.exit:
	move $ra, $s0		# Restore $ra value
	lw $s0, 0($sp)		# Restore $s0 value
	addi $sp, $sp, 4	# Allocates space on stack
	
	j return
#------------------------------------- UTILS ------------------------------#
return:
	jr $ra
