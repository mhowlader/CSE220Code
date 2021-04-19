############################ DO NOT CREATE A .data SECTION ############################
############################ DO NOT CREATE A .data SECTION ############################
############################ DO NOT CREATE A .data SECTION ############################

############################## Do not .include any files! #############################

.text
eval:
	la $s0, val_stack
	la $s1, op_stack
	addi $s1, $s1 2000  #add 2000 to s1 to prevent overlap
	addi $sp, $sp, -4
	sw $ra, 0($sp) #store ra
	move $s2, $a0 #copy string address to $s2
	li $s3, 0 #top of valstack
	li $s4, 0 #top of op stack
	
	#### BEGINNING OF CHARLOOP ITERATING THROUGH EACH CHARACTER OF THE STRING
	
	
	charloop: 
		lbu $s5, 0($s2) #get ith character
		beq $s5, $0, endcharloop #while ith character does not equal null, continue interating. Otherwise, go to endcharloop
		move $a0, $s5 #move the ith character to a0
		jal is_digit 
		beq $v0, $0, operator #if it is a digit, move on, if not go to oeprator
			
			addi $s5, $s5, -48 #convert to int
			
			multdigloop:
			addi $s2, $s2, 1 #increment i
			lbu $s7, 0($s2) #get next character
			
			li $t0, '('
			beq $s7, $t0, IllFormedError
			#continue multdig
			move $a0, $s7 #move s7 to a0
			jal is_digit
			
			beq $v0, $0, endmultdigloop
			addi $s7, $s7, -48 #convert to int
			li $t0, 10
			mult $s5, $t0 #multiply $s5 by 10
			mflo $s5 #store product in $s5
			add $s5, $s5, $s7 #add s5 with s7)
			j multdigloop
			
			endmultdigloop:
			addi $s2, $s2, -1 #revert s2 back by 1
		
		
			move $a0, $s5 #move the number into a0
			#addi $a0, $a0, -48 #convert ascii to integer
			move $a1, $s3 #move the top of the stack into a1
			move $a2, $s0 #move the base address of valstack into a2
			jal stack_push
			move $s3, $v0 #move the new top of valstack into stack push
			addi $s2, $s2, 1
			j charloop
	
		operator: #if character is operator
			move $a0, $s5 #move the character to a0
			jal valid_ops
			beq $v0, $0, firstpar #if valid operator, then continue, otherwise go to first parenthesis
			
			
			#checknextoperror:
			#addi $s2, $s2, 1 #check next character
			#lbu $a0, 0($s2) #load next character
			#jal valid_ops
			#bne 
	                
                #BEGINNING OF OPERATOR LOOP THAT CHECKS WHETHER OPSTACK IS EMPTY AND WHETHER TOP HAS HIGHER PRECEDENCE
                # WHILE THATS TRUE IT POPS OPERATORS AND EVALUATES THE OPERANDS
                
		oploop:
                    move $a0, $s4 #store top of the stack of op stack
                    addi $a0, $a0 -4 #subtract 4 from top of op stack
                    jal is_stack_empty
                    beq $v0, $1, endoploop #while stack is not empty
                    move $a0, $s5 #move the operator into a0
                    jal op_precedence
                    move $s6, $v0 #store the op precedence of the ith character
                    move $a0, $s4
                    addi $a0, $a0, -4 #subtract 4 from tp of op_stack
                    move $a1, $s1 #load base address of opstack
                    jal stack_peek #peek the top of the stack
            
                    
                    ####check if the element at top of stack is a left parenthesis
                    li $t0, '(' #set $t0 to '('
                    beq $t0, $v0, endoploop  #if not equal to '(' continue oploop, if it is equal to '(' then go to endoploop
      
                	
                    move $a0, $v0 #move the top element of op stack into a0
                    jal op_precedence
                    slt $t0, $v0, $s6 #if top element of op stack is greater than or equal to the ith character operator, if not then go to endoploop
                    bne $t0, $0, endoploop 
                
                    move $a0, $s4 #top of opstack
                    addi $a0, $a0, -4 #subtract 4
                    move $a1, $s1
                    jal stack_pop #pop the top of opstack
                    move $s4, $v0 #adjust the top of op stack
                    addi $sp, $sp, -12 #lower stack pointer to store 3 variables. 
                    sw $v1, 8($sp) #store the operator that was popped out
                    move $a0, $s3 #top of val stack
                    addi $a0, $a0, -4
                    move $a1,$s0
                    jal stack_pop
                    move $s3, $v0 #readjust top of valstack
                    sw $v1, 4($sp) #store second operand in stack
                    
                    move $a0, $s3 #top of valstack
                    addi $a0, $a0, -4 #adjust tp before pop
                    move $a1, $s0 #get memory address of valstack
                    jal stack_pop
                    move $s3,$v0 #readjust top of valstack
                    lw $a2, 4($sp) #load the second operand from the stack
                    lw $a1, 8($sp) #load the operator from the stack
                    move $a0, $v1  #mvoe the first operator to #$a0
                    jal apply_bop
                    move $a0, $v0 #move the result to $a0
                    move $a1, $s3 #move the top of the valstack to the $a1
                    move $a2, $s0 #get memory address of valstack
                    jal stack_push #push result of operation to valstack
                    move $s3, $v0 #update new tp of valstack
                    addi $sp, $sp, 12
                    j oploop
	
	
		endoploop:
                	move $a0, $s5 #move operator to a0
                	move $a1, $s4 #move 
                	move $a2, $s1
                	jal stack_push
                	move $s4, $v0 #keep track of the new tp of the op stack
                	addi $s2, $s2, 1
                	j charloop
	
	
	
        	firstpar:
        	li $t0, '(' #set $t0 to open parenthesis
        	bne $t0, $s5, closepar
        	move $a0, $s5 #move first parenthesis to $a0
        	move $a1, $s4 #move top of operator stack into $a1
        	move $a2, $s1 #move address of operator stack into $a2
        	jal stack_push
        	move $s4, $v0 #adjust top of opstack
        	addi $s2, $s2, 1 #next index of string
        	j charloop
	
	
		closepar:
			li $t0, ')' #load $t0 with ')'
			bne $t0, $s5, tokenError #if the element equals ) then proceed, otherwise it's a token error
			
			closeparloop:
			move $a0,$s4 #move the top of op stack into a0
			addi $a0, $a0, -4  #subtract top of op stack by 4
			move $a1, $s1 #move the address of op stack into #a1
			jal stack_peek #do stack peek
			move $t0, $v0 #move the element at top of opstack to t0
			li $t1, '('
			beq $t0, $t1, popLeft #while element at top of opstack  isn't '(', continue loop, otherwise popleft
			
			##pop opstack, pop twice val stack, do binary op
			
                    move $a0, $s4 #top of opstack
                    addi $a0, $a0, -4 #subtract 4
                    move $a1, $s1
                    jal stack_pop #pop the top of opstack
                    move $s4, $v0 #adjust the top of op stack
                    addi $sp, $sp, -12 #lower stack pointer to store 3 variables. 
                    sw $v1, 8($sp) #store the operator that was popped out
                    move $a0, $s3 #top of val stack
                    addi $a0, $a0, -4
                    move $a1,$s0
                    jal stack_pop
                    move $s3, $v0 #readjust top of valstack
                    sw $v1, 4($sp) #store first operand in stack
                    
                    move $a0, $s3 #top of valstack
                    addi $a0, $a0, -4 #adjust tp before pop
                    move $a1, $s0 #get memory address of valstack
                    jal stack_pop
                    move $s3,$v0 #readjust top of valstack
                    lw $a2, 4($sp) #load the first operand from the stack
                    lw $a1, 8($sp) #load the operator from the stack
                    move $a0, $v1  #mvoe the second operator to #$a2
                    jal apply_bop
                    move $a0, $v0 #move the result to $a0
                    move $a1, $s3 #move the top of the valstack to the $a1
                    move $a2, $s0 #get memory address of valstack
                    jal stack_push #push result of operation to valstack
                    move $s3, $v0 #update new tp of valstack
                    addi $sp, $sp, 12
                    j closeparloop
			
			##end of close pare loop checking if top op opstack isn't a left parenthesis
			
			popLeft:
				move $a0, $s4 #move top of opstack into $a0
				addi $a0, $a0, -4 #subtract 4 from $a0
				move $a1, $s1 #move address of opstack into a1
				jal stack_pop
				move $s4, $v0 #adjust the new top of opstack
				addi $s2, $s2, 1 #go to next character
				j charloop
		
		
		
		
		
		tokenError:
		la $a0, BadToken
		li $v0, 4
		syscall
		
		j endeval
		
		
	
	
	##### BEGINNING OF ENDCHARLOOP ####
	endcharloop:
        move $a0, $s4 #store top of the stack of op stack
        addi $a0,$a0, -4 #subtract 4 from top of op stack
        jal is_stack_empty
        bne $v0, $0, getfinalresult #while stack is not empty
        

        move $a0, $s4
        addi $a0, $a0, -4
        move $a1, $s1
        jal stack_pop #pop the top of opstack
        move $s4, $v0 #adjust the top of op stack
        addi $sp, $sp, -12 #lower stack pointer to store 3 variables. 
        sw $v1, 8($sp) #store the operator that was popped out
        move $a0, $s3 #top of val stack
        addi $a0, $a0, -4
        move $a1,$s0
        jal stack_pop
        move $s3, $v0 #readjust top of valstack
        sw $v1, 4($sp) #store first operand in stack
        
        move $a0, $s3 #top of valstack
        addi $a0, $a0, -4 #adjust tp before pop
        move $a1, $s0 #get memory address of valstack
        jal stack_pop
        move $s3,$v0 #readjust top of valstack
        lw $a2, 4($sp) #load the first operand from the stack
        lw $a1, 8($sp) #load the operator from the stack
        move $a0, $v1  #mvoe the second operator to #$a2
        jal apply_bop
        move $a0, $v0 #move the result to $a0
        move $a1, $s3 #move the top of the valstack to the $a1
        move $a2, $s0 #get memory address of valstack
        jal stack_push #push result of operation to valstack
        move $s3, $v0 #update new tp of valstack
        addi $sp, $sp, 12
        j endcharloop
        
        ###### END of ENDCHARCLOOP
	
	getfinalresult: 
	move $a0,$s3 #top of valstack
	addi $a0, $a0, -4 #subtract 4
	move $a1, $s0 #address of valstack
	jal stack_pop #pop
	move $s3,$v0 #adjust top of valstack
	bgtz $s3, IllFormedError
	
	move $a0, $v1 #move final result into a0
	li $v0, 1 #print int
	syscall
	
	lw $ra, 0($sp)
	addi $sp, $sp, 4 #adjust stack
	
	endeval:
	li $v0, 10
	syscall
	
	IllFormedError:
	la $a0, ParseError
	li $v0, 4
	syscall
	j endeval
	
	
	
	
	
	
	
	
	
	
	

	
is_digit:

	li $t0, 48
	bge $a0, $t0, nextdig #if less than 48, false
	j false
	nextdig:
	li $t0, 57
	ble $a0, $t0, true #if greater than 57, false
	j false
	
	
	false:
		li $v0, 0
		j endig
	true:
		li $v0, 1

	endig:
	jr $ra


stack_push:

	li $t0, 2000
	beq $a1, $t0, stacklimit
	add $t0, $a1,$a2 
	sw $a0, 0($t0) #store the element at the top of the stock
	addi $v0, $a1, 4 #shift the top of the stack by 4
	jr $ra

	stacklimit:
	la $a0, ParseError
	li $v0, 4
	syscall
	
	li $v0, 10
	syscall
stack_peek:
	bltz $a0, peekemptyerror
	
	
	add $t0,$a1, $a0 #add the top of the stack to the base address
	lw $v0, 0($t0) #value at the top of the stack
  	jr $ra
  	
  	peekemptyerror:
  	la $a0, ParseError
  	li $v0, 4
  	syscall
  	li $v0, 10
  	syscall
  



stack_pop:

	bltz $a0, popemptyerror
	move $v0,$a0  #move new top of tp into $v0
	
	add $t0,$a1, $v0 #add the top of the stack to the base address
	lw $v1, 0($t0) #value at the top of the stack
  	jr $ra
  	
  	popemptyerror:
  	la $a0, ParseError
  	li $v0, 4
  	syscall
  	li $v0, 10
  	syscall
 

is_stack_empty:

	bgez $a0, notempty #if less than 0, then empty
	li $v0,1
	j endempty
	notempty:
	li $v0,0
	
	endempty:
 	jr $ra

valid_ops:
	li $t0, '+'
	bne $a0, $t0, valid1
	j true
	valid1:
	li $t0, '-'
	bne $a0, $t0, valid2
	j true
	valid2:
	li $t0, '*'
	bne $a0, $t0, valid3
	j true
	valid3:
	li $t0, '/'
	bne $a0, $t0, false
	j true
	


  jr $ra

op_precedence:

	addi $sp, $sp, -4 #make space in the stack
	sw $ra, 0($sp) #store ra in the stack
	jal valid_ops
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	bne $v0, $0, prec1 #if not valid op, then error
	j error
	prec1:
	li $t0, '+'
	bne $a0, $t0,prec2 #if op is a plus sign, then go to plusminus
	j plusminus
	prec2:
	li $t0, '-'
	bne $a0, $t0, multdiv #if op is a minus sign, then go to plusminus, otherwise go to multdiv
	j plusminus
	multdiv:
	li $v0, 2
	j endprec
	
	plusminus:
	li $v0, 1
	j endprec
	
	
	
	error:
	la $a0, BadToken
	li $v0, 4
	syscall
	li $v0, 10
	syscall
	
	endprec:
 	jr $ra

apply_bop:
	li $t0, '+'
	bne $a1, $t0, bopsub #if op is plus, then add the operands
	add $v0, $a0, $a2 
	j endbop
	
	bopsub:
	li $t0, '-'
	bne $a1, $t0, bopmult # if op is minus, then subtract the operands
	sub $v0, $a0, $a2
	j endbop
	
	bopmult:
	li $t0, '*'
	bne $a1, $t0, bopdiv # if op is mult, then mult the oeprands
	mult $a0, $a2
	mflo $v0
	j endbop
	
	bopdiv:
	
	beq $a2, $0, divbyzeroerror
	div $a0, $a2
	mflo $v0 #quotient
	mfhi $t0
	
	beq $t0, $0, endbop #if remainder does not equal to 0
	bgez $a0, check2 #if less than 0
	bltz $a2, check2 #greater than or equal to 0
	addi $v0, $v0, -1 #add -1 to quotient
	j endbop
	
	check2:
	bltz $a0, endbop
	bgez $a2, endbop
	addi $v0, $v0 -1
	j endbop
	
	endbop:
	jr $ra
	
	divbyzeroerror:
	la $a0, ApplyOpError
	li $v0, 4
	syscall
	
	li $v0, 10
	syscall
	
