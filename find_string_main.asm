.data
v0: .asciiz "v0: "
target: .asciiz "what"
strings: .ascii "kk\0cs\0Stony Brook University\0what\0yuo\0CSE 220\0argh\0oh\0OK thanks\0arrgghh\0u\0101\0hmmmm\0good game\0Universal Serial Bus\0you\0help\0sto\0gg\0Stony Brook\0subtraction\0Boise State University\0thx\0OH\0silly\0sillllllly\0thanks\0hepl\0hmm\0can\0usb\0wat\0calss\0sbu\0220\0MIPS\0class\0CSE101\0Applied Mathematics\0ams\0bsu\0i\0cna\0MIPSR10000\0sub\0you\0Computer Science\0I\0"
strings_length: .word 334

.text
.globl main
main:
la $a0, target
la $a1, strings
lw $a2, strings_length
jal find_string
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

li $v0, 10
syscall

.include "proj3.asm"
