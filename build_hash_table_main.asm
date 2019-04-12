###############################################################
# 
# IMPORTANT NOTES
#
# The filename you provide should be given in an absolute path.
# Example: C:/Users/Joe/Documents/CSE 220/Project3/hash_table1.txt
#
# Alternatively, you can leave it as a relative path, but then
# you must move MARS into the same directory as the main files.
# Why? Because MARS is a little buggy with file I/O.
#
################################################################

.data
v0: .asciiz "v0: "

hash_table:
.word 29
.word 398
.word 588, 799, 346, 18, 195, 602, 92, 853, 645, 374, 15, 919, 362
.word 236, 417, 546, 515, 743, 845, 932, 63, 656, 296, 508, 989, 784

strings: .ascii "kk\0cs\0Stony Brook University\0what\0yuo\0CSE 220\0argh\0oh\0OK thanks\0arrgghh\0u\0101\0hmmmm\0good game\0Universal Serial Bus\0you\0help\0sto\0gg\0Stony Brook\0subtraction\0Boise State University\0thx\0OH\0silly\0sillllllly\0thanks\0hepl\0hmm\0can\0usb\0wat\0calss\0sbu\0220\0MIPS\0class\0CSE101\0Applied Mathematics\0ams\0bsu\0i\0cna\0MIPSR10000\0sub\0you\0Computer Science\0I\0"
strings_length: .word 334
filename: .asciiz "C:/Users/sivak/MIPS hw/hw3/subs1.txt"

.text
.globl main
main:
la $a0, hash_table
la $a1, strings
lw $a2, strings_length
la $a3, filename
jal build_hash_table
move $t0, $v0

la $a0, v0
li $v0, 4
syscall
li $v0, 1
move $a0, $t0
syscall
li $a0, '\n'
li $v0, 11
syscall

# You should probably write code here to print the state of the hash table.

li $v0, 10
syscall

.include "proj3.asm"
