.data
ErrMsg: .asciiz "Invalid Argument"
WrongArgMsg: .asciiz "You must provide exactly two arguments"
EvenMsg: .asciiz "Even"
OddMsg: .asciiz "Odd"

arg1_addr : .word 0
arg2_addr : .word 0
num_args : .word 0

.text:
.globl main
main:
	sw $a0, num_args

	lw $t0, 0($a1)
	sw $t0, arg1_addr
	lw $s1, arg1_addr

	lw $t1, 4($a1)
	sw $t1, arg2_addr
	lw $s2, arg2_addr

	j start_coding_here

# do not change any line of code above this section
# you can add code to the .data section
start_coding_here:



	li $t1, 2 #load 2 to check for 2 arguments
	lw $t2, num_args #load number of args into t2
	beq $t1, $t2, target #check if number of arguments = 2
	li $v0, 4 #print string systcall
	la $a0, WrongArgMsg #load address for wrong number of arguments
	syscall
	j exit

target:

	lbu $t2, 0($s1) #load first character of first argument

	li $t1, 'O' #load character to check if equal
	bne $t1, $t2, target2 #check for next character
	j valid3 #jump to next check

target2:
	li $t1, 'S' #load character to check if equal
	bne $t1, $t2, target3 #check for next character
	j valid3 
target3:
	li $t1, 'T' #load character to check if equal
	bne $t1, $t2, target4 #check for next character
	j valid3 
target4:
	li $t1, 'I' #load character to check if equal
	bne $t1, $t2, target5 #check for next character
	j valid3 
target5:
	li $t1, 'E' #load character to check if equal
	bne $t1, $t2, target6 #check for next character
	j valid3 
target6:
	li $t1, 'C' #load character to check if equal
	bne $t1, $t2, target7 #check for next character
	j valid3
target7:
	li $t1, 'X' #load character to check if equal
	bne $t1, $t2, target8 #check for next character
	j valid3 
target8:
	li $t1, 'M' #load character to check if equal
	bne $t1, $t2, error #check for next character
	j valid3 #jump to errror
error:
	li $v0, 4 #print string syscall
	la $a0, ErrMsg
	syscall
	j exit	
	
valid3:	
	li $t0, '0' #check if equal to 0
	move $t1, $s2 #memory address for string of second argument counter
	lbu $t2, 0($t1) #get 0th  character
	beq $t0, $t2, check1
	j error

check1:
	addi $t1, $t1, 1 #increment memory address counter by 1
	li $t0, 'x' #create characterr x
	lbu $t2, 0($t1) #get 1st character
	beq $t0, $t2, check2 #check if 1st character is equal to x
	j error

check2:

	li $t3, 2 #i=2 loop counter from 2nd character to 10th
	li $t4, 10 #end of for loop
	addi $t1, $t1, 1 #increment address pointer to 2nd character
	loop1:
		beq $t3,$t4, part2 #if i is equal to 10 then leave loop and continue program
		lbu $t2, 0($t1) #get ith character
		li $t5, '\0' #create variable for null
		#move $a0, $t2 #ith character
		#li $v0, 11
		#syscall
		bne $t2, $t5, check3 #if ith character not equal to null character, go on to next check
		j error #if ith character equal to null character, then error
		
		check3:
			li $t5,'0' #check if equal to hexadecimal character
			bne $t2, $t5, check4
			j loopinc
		
		check4:
			li $t5,'1' #check if equal to hexadecimal character
			bne $t2, $t5, check5
			j loopinc
		
		check5:
			li $t5,'2' #check if equal to hexadecimal character
			bne $t2, $t5, check6
			j loopinc
		
		check6:
			li $t5,'3' #check if equal to hexadecimal character
			bne $t2, $t5, check7
			j loopinc
		
		check7:
			li $t5,'4' #check if equal to hexadecimal character
			bne $t2, $t5, check8
			j loopinc
		
		check8:
			li $t5,'5' #check if equal to hexadecimal character
			bne $t2, $t5, check9
			j loopinc
		
		check9:
			li $t5,'6' #check if equal to hexadecimal character
			bne $t2, $t5, check10
			j loopinc
		
		check10:
			li $t5,'7' #check if equal to hexadecimal character
			bne $t2, $t5, check11
			j loopinc
		
		check11:
			li $t5,'8' #check if equal to hexadecimal character
			bne $t2, $t5, check12
			j loopinc
		
		check12:
			li $t5,'9' #check if equal to hexadecimal character
			bne $t2, $t5, check13
			j loopinc
		
		check13:
			li $t5,'A' #check if equal to hexadecimal character
			bne $t2, $t5, check14
			j loopinc
		
		check14:
			li $t5,'B' #check if equal to hexadecimal character
			bne $t2, $t5, check15
			j loopinc
		
		check15:
			li $t5,'C' #check if equal to hexadecimal character
			bne $t2, $t5, check16
			j loopinc
		
		check16:
			li $t5,'D' #check if equal to hexadecimal character
			bne $t2, $t5, check17
			j loopinc
		
		check17:
			li $t5,'E' #check if equal to hexadecimal character
			bne $t2, $t5, check18
			j loopinc
		
		check18:
			li $t5,'F' #check if equal to hexadecimal character
			bne $t2, $t5, error
		
		loopinc: 
			addi $t1, $t1, 1 #increment pointer address for next character
			addi $t3, $t3, 1 #increment loop counter
			j loop1
				
	
part2:	

	li $t0, 2 #i=2 loop counter from 2nd character to 10th
	li $t1, 10 #end of for loop
	li $t5, 28 #number of spaces to shift left k
	move $t2, $s2 #memoroy address for 2nd argument
	addi $t2, $t2, 2 #move pointer to second index
	li $s3, 0 #main variable for the 32- bit binary of 2nd argument
	
	loop2:
		beq $t0, $t1, part2op #if i not equal to 10 then 
		
		lbu $t3, 0($t2) #load ith character into register
		
		li $t4, 'A' 
		bne $t3, $t4, letters1 #if not equal to A then check next letter
		j lettersmain #if equal to A then go to lettersmain
		
		letters1:
			li $t4, 'B'
			bne $t3, $t4, letters2
			j lettersmain
		
		letters2:
			li $t4, 'C'
			bne $t3, $t4, letters3
			j lettersmain
		
		letters3:
			li $t4, 'D'
			bne $t3, $t4, letters4
			j lettersmain
		
		letters4:
			li $t4, 'E'
			bne $t3, $t4, letters5
			j lettersmain
		
		letters5:
			li $t4, 'F'
			bne $t3, $t4, numbers
			j lettersmain
		
		lettersmain:
			addi $t3, $t3, -55 #subtract by 55 if character was a letter
			j shift1
		
		numbers:
			addi $t3, $t3, -48 #subtract by 48 if character was number
			j shift1
		
		shift1:
			sllv $t3,$t3,$t5 #shift it by k to fill out the binary
			or $s3, $s3, $t3 #combine with the main variable
			
			#loop back to beginning
			addi $t0, $t0 1 #increment loop counter by 1
			addi $t2, $t2, 1 #increment pointer for memory address
			addi $t5, $t5, -4 #decrement k by 4
			j loop2
	

part2op:
	lbu $s4, 0($s1) #load first character of first argument 
			
	li $t0, '0' #check if equaL to operation O
	beq $t0, $s4, opO
	
	li $t0, 'S'
	beq $t0, $s4, opS
	
	li $t0, 'T'
	beq $t0, $s4, opT
	
	li $t0, 'I'
	beq $t0, $s4, opI
	
	li $t0, 'E'
	beq $t0, $s4, opE
	
	li $t0, 'C'
	beq $t0, $s4, opC
	
	li $t0, 'X'
	beq $t0, $s4, opX
	
	li $t0, 'M'
	beq $t0, $s4, opM

opO:
	li $t0, 26 #shift right 26 times
	srlv $a0, $s3, $t0
	li $v0, 1
	syscall
	j exit


opS:
	li $t0, 6 
	sllv $a0, $s3,$t0 #shift left 6 times
	li $t0, 27
	srlv $a0, $a0,$t0 #shift right 27 times
	li $v0, 1
	syscall
	j exit
	

opT:
	li $t0, 11 
	sllv $a0, $s3,$t0 #shift left 11 times
	li $t0, 27
	srlv $a0, $a0,$t0 #shift right 27 times
	li $v0, 1
	syscall
	j exit
	
opI:
	li $t0, 16
	sllv $a0, $s3,$t0 #shift left 16 times
	li $t0, 16
	srav $a0, $a0,$t0 #shift right arithmetic 16 times
	li $v0, 1
	syscall
	j exit
	
opE:
	li $t0, 1
	and $t1,$s3,$t0 #do the and function with 1 and our main binary variable
	bne $t0, $t1, even #if the result is not equal to 1 then branch to even
	la $a0, OddMsg #if it is equal to 1, then it is odd
	j result
	even:
		la $a0, EvenMsg
	result:
		li $v0, 4
		syscall
		j exit
opC:

	move $t0, $s3 #copy s3 to t0
	li $a0, 0 #count for the answer
	li $t2, 1 #use for AND function
	countloop:
		beq $t0, $0, countresult
		and $t3, $t0, $t2 #and main variable with 1 which would leave a 1 if LSB is 1
		add $a0, $a0, $t3 #add the result to the count
		srlv $t0, $t0, $t2 #shift t0 to the right one time
		j countloop
	countresult:
		li $v0, 1
		syscall
		j exit
		

opX:
	li $t0, 1
	sllv $a0, $s3, $t0 #shift left by 1
	li $t0, 24
	srlv $a0, $a0, $t0 #shift right by 24
	addi $a0, $a0, -127
	li $v0, 1
	syscall
	j exit
opM:
	li $t0, 9 #shift to the left 9 times
	sllv $t1,$s3,$t0 #mantissa with 32 bits
	
	li $a0, '1'
	li $v0, 11
	syscall
	li $a0, '.'
	syscall
	move $a0,$t1
	li $v0, 35
	syscall
	
exit: 
li $v0, 10 #exit program
syscall
