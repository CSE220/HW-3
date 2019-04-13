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
	addi $sp, $sp, -28	# Allocates space on stack
	sw $s0, 24($sp)		# Saved $s0 onto stack
	sw $s1, 20($sp)
	sw $s2, 16($sp)
	sw $s3, 12($sp)
	sw $s4, 8($sp)
	sw $s5, 4($sp)
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
	lw $s6, 0($sp)
	lw $s5, 4($sp)
	lw $s4, 8($sp)
	lw $s3, 12($sp)
	lw $s2, 16($sp)		# Restore $s0 value
	lw $s1, 20($sp)
	lw $s0, 24($sp)
	addi $sp, $sp, 28	# Allocates space on stack
	
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
	sll $t1, $t1, 2		# Multiply by 4 to get right index
	
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
	addi $sp, $sp, -32	# Allocates space on stack
	sw $s0, 28($sp)		# Saved $s0 onto stack
	sw $s1, 24($sp)
	sw $s2, 20($sp)
	sw $s3, 16($sp)
	sw $s4, 12($sp)
	sw $s5, 8($sp)
	sw $s6, 4($sp)
	sw $s7, 0($sp)		# Temporary storage for key index value
	move $s0, $ra		# Move $ra value to be saved
	move $s1, $a0		# Hash Table
	move $s2, $a1		# Strings
	move $s3, $a2		# Length of strings
	move $s4, $a3		# Filename
	move $s5, $zero		# Iterator for # of elements inserted
	
	move $a0, $s1
	jal clear	# Clear Hash Table
	
	move $a0, $s4	# Open File
	move $a1, $zero
	li $v0, 13
	syscall
	beq $v0, -1, build_hash_table.exit # If no file, exit
	move $s6, $v0	# Save file descriptor
	
	j build_hash_table.read_key
build_hash_table.read_key:
	addi $sp, $sp, -80
	move $t0, $sp	# Temporary input buffer
	move $t1, $sp	# Starting address of temporary input buffer
	j build_hash_table.loop_key
build_hash_table.loop_key:
	move $a0, $s6	# Load file descriptor
	move $a1, $t0	# Temporary input buffer
	li $a2, 1	# Read character by character
	li $v0, 14
	syscall
	
	beq $v0, 0, build_hash_table.done
	
	lb $t2, 0($t0)
	beq $t2, ' ', build_hash_table.parse_key
	addi $t0, $t0, 1
	j build_hash_table.loop_key	
build_hash_table.parse_key:
	li $t5, '\0'
	sb $t5, 0($t0)	# Change space to null terminator
	
	move $a0, $t1
	move $a1, $s2
	move $a2, $s3
	jal find_string
	move $s7, $v0		# Store key address so not erased for value search
	
	j build_hash_table.read_value	
build_hash_table.read_value:
	addi $sp, $sp, -80
	move $t0, $sp	# Temporary input buffer
	move $t1, $sp	# Starting address of temporary input buffer
	j build_hash_table.loop_value
build_hash_table.loop_value:
	move $a0, $s6	# Load file descriptor
	move $a1, $t0	# Temporary input buffer
	li $a2, 1	# Read character by character
	li $v0, 14
	syscall
	
	lb $t2, 0($t0)
	beq $t2, '\n', build_hash_table.parse_value
	addi $t0, $t0, 1
	j build_hash_table.loop_value	
build_hash_table.parse_value:
	li $t5, '\0'
	sb $t5, 0($t0)	# Change \n to null terminator
	move $a0, $t1
	move $a1, $s2
	move $a2, $s3
	jal find_string
	move $t7, $v0
	j build_hash_table.insert
build_hash_table.insert:
	move $a0, $s1
	move $a1, $s7	# Restore key from storage
	add $a1, $a1, $s2
	
	move $a2, $t7	# Move value index here
	add $a2, $a2, $s2

	move $a0, $s1	
	jal put
	
	addi $s5, $s5, 1
	addi $sp, $sp, 80	# Deallocate space
	addi $sp, $sp, 80	# Deallocate space

	j build_hash_table.read_key
build_hash_table.done:
	addi $sp, $sp, 80	# Deallocate space
	move $a0, $s6	# Close file
	li $v0, 16
	syscall
	
	move $v0, $s5	# Number of inserted elements
	j build_hash_table.exit
build_hash_table.exit:
	move $ra, $s0		# Restore $ra value
	lw $s7, 0($sp)
	lw $s6, 4($sp)
	lw $s5, 8($sp)
	lw $s4, 12($sp)
	lw $s3, 16($sp)
	lw $s2, 20($sp)
	lw $s1, 24($sp)
	lw $s0, 28($sp)		# Restore $s0 value
	addi $sp, $sp, 32	# Allocates space on stack
	
	j return
#------------------------------------- AUTOCORRECT ------------------------------#
autocorrect:
	lw $t0, 0($sp)		# Get string length
	lw $t1, 4($sp)		# Get filename
	addi $sp, $sp, -32	# Allocates space on stack
	sw $s0, 28($sp)		# Saved $s0 onto stack
	sw $s1, 24($sp)
	sw $s2, 20($sp)
	sw $s3, 16($sp)
	sw $s4, 12($sp)
	sw $s5, 8($sp)	# Used
	sw $s6, 4($sp)
	sw $s7, 0($sp)	# Used
	
	move $s0, $ra		# Move $ra value to be saved
	move $s1, $a0		# Hash Table
	move $s2, $a1		# Source string
	move $s3, $a2		# Destination string
	move $s4, $zero		# Iterator for number of replacements
	move $s7, $zero		# Flag for if we are at last word
	
	move $a0, $s1
	move $a1, $a3
	move $a2, $t0
	move $a3, $t1
	jal build_hash_table
	
	lw $s6, 0($s1)		# Load capacity
	sll $s6, $s6, 2		# Amount to jump to go from key -> value
	
	j autocorrect.next_source_word_setup
autocorrect.next_source_word_setup:
	move $s5, $s2	# Store starting address of word
	j autocorrect.next_source_word
autocorrect.next_source_word:
	lb $t0, 0($s2)
	beq $t0, ' ', autocorrect.check_replaceable
	beq $t0, '\0', autocorrect.flag_last_word
	
	addi $s2, $s2, 1
	j autocorrect.next_source_word
autocorrect.flag_last_word:
	li $s7, 1	# Flag now so we know later in program to stop
	j autocorrect.check_replaceable
autocorrect.check_replaceable:
	sb $zero, 0($s2)	# Temporarily change space to \0 for get
	
	move $a0, $s1
	move $a1, $s5		# Load starting address of word
	jal get
	bne $v0, -1, autocorrect.get_replace_word

	move $t2, $s5	# Need move to $t2 to write string
	j autocorrect.write_string
autocorrect.get_replace_word:
	addi $s4, $s4, 1	# Increase replace count by 1

	move $t1, $s1	     # Load hash table
	addi $t1, $t1, 8     # Jump to actual hash table
	sll $v0, $v0, 2
	add $t1, $t1, $v0    # Jump to key
	add $t1, $t1, $s6    # Jump to value
	lw $t2, 0($t1)	     # Store value string into $t2
	
	j autocorrect.write_string
autocorrect.write_string:
	lb $t3, 0($t2)
	beq $t3, 0, autocorrect.end_replace_word
	
	sb $t3, 0($s3)	# Write to dest string
	
	addi $s3, $s3, 1
	addi $t2, $t2, 1
	
	j autocorrect.write_string
autocorrect.end_replace_word:
	beq $s7, 1, autocorrect.end_replace_last_word
	li $t0, ' '
	sb $t0, 0($s3)
	addi $s3, $s3, 1
	sb $t0, 0($s2)
	addi $s2, $s2, 1
	
	j autocorrect.next_source_word_setup
autocorrect.end_replace_last_word:
	li $t0, '\0'
	sb $t0, 0($s3)
	sb $t0, 0($s2)
	
	j autocorrect.finish
autocorrect.finish:
	move $v0, $s4
	j autocorrect.exit
autocorrect.exit:
	move $ra, $s0		# Restore $ra value
	lw $s7, 0($sp)
	lw $s6, 4($sp)
	lw $s5, 8($sp)
	lw $s4, 12($sp)
	lw $s3, 16($sp)
	lw $s2, 20($sp)
	lw $s1, 24($sp)
	lw $s0, 28($sp)		# Restore $s0 value
	addi $sp, $sp, 32	# Allocates space on stack
	
	j return
#------------------------------------- UTILS ------------------------------#
return:
	jr $ra
