# add test cases to data section
# Test your code with different Network layouts
# Don't assume that we will use the same layout in all our tests
.data
Name1: .asciiz "Cacophonix"
Name2: .asciiz "Getafix"
Name_prop: .asciiz "NAME"

Network:
  .word 5   #total_nodes (bytes 0 - 3)
  .word 10  #total_edges (bytes 4- 7)
  .word 12  #size_of_node (bytes 8 - 11)
  .word 12  #size_of_edge (bytes 12 - 15)
  .word 3   #curr_num_of_nodes (bytes 16 - 19)
  .word 2   #curr_num_of_edges (bytes 20 - 23)
  .asciiz "NAME" # Name property (bytes 24 - 28)
  .asciiz "FRIEND" # FRIEND property (bytes 29 - 35)
   # nodes (bytes 36 - 95)	
  .byte 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0	
   # set of edges (bytes 96 - 215)
  .word 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0

.text:
main:
	
	la $a0, Network
	addi $t0, $a0, 36
	addi $t1, $a0, 72
	addi $t2, $a0, 48
	addi $t3, $a0, 84
	sw $t0, 96($a0) #network + 36
	sw $t1, 100($a0)#network +72
	sw $t2, 108($a0)#network +48
	sw $t1, 112($a0)#network +72
	
	la $a0, Network
	move $a1, $t0
	move $a2, $t2
	jal is_relation_exists
	
	#write test code
	move $a0, $v0
	li $v0, 1
	syscall
	li $v0, 10
	syscall
	
.include "hw4.asm"
