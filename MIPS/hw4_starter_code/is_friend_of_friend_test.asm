# add test cases to data section
# Test your code with different Network layouts
# Don't assume that we will use the same layout in all our tests
.data
Name1: .asciiz "Jane"
Name2: .asciiz "John"
Name3: .asciiz "Ali"
Name4: .asciiz "Jasmine"
Name5: .asciiz "Joel"
Name_prop: .asciiz "NAME"
Frnd_prop: .asciiz "FRIEND"

Network:
  .word 5   #total_nodes (bytes 0 - 3)
  .word 10  #total_edges (bytes 4- 7)
  .word 12  #size_of_node (bytes 8 - 11)
  .word 12  #size_of_edge (bytes 12 - 15)
  .word 3   #curr_num_of_nodes (bytes 16 - 19)
  .word 3   #curr_num_of_edges (bytes 20 - 23)
  .asciiz "NAME" # Name property (bytes 24 - 28)
  .asciiz "FRIEND" # FRIEND property (bytes 29 - 35)
   # nodes (bytes 36 - 95)	
  .byte 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0	
   # set of edges (bytes 96 - 215)
  .word 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0

.text:
main:
	la $a0, Network
	move $s0, $a0
	addi $t0, $a0, 36 #0th #jane
	addi $t1, $a0, 72 #3rd
	addi $t2, $a0, 48 #1st #john
	addi $t3, $a0, 84 #4th
	addi $t4, $a0, 60 #2nd #ali
	li $t5, 1
	
	sw $t0, 96($a0) #jane
	sw $t2, 100($a0) #john
	sw $0, 104($a0) #friendship is 0
	sw $t0, 108($a0) # jane
	sw $t4, 112($a0) #ali
	sw $t5, 116($a0) #friendship 1
	sw $t2, 120($a0) #john
	sw $t4, 124($a0) #ali
	sw $t5, 128($a0) #friendship 1
	
	
	#exists friendsip between jane and ali, and john and ali
	la $a0, Name1
	addi $a1, $s0, 36 #Jane
	jal str_cpy
	la $a0, Name2
	addi $a1, $s0, 48 #John
	jal str_cpy
	la $a0, Name3
	addi $a1, $s0, 60 #Ali
	jal str_cpy
	
	
	
	la $a0, Network
	la $a1, Name1
	la $a2, Name1
	jal is_friend_of_friend
	
	#write test code
	move $a0, $v0
	li $v0, 1
	syscall
	
	li $v0, 10
	syscall
	
.include "hw4.asm"
