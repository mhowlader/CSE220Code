############################ DO NOT CREATE A .data SECTION ############################
############################ DO NOT CREATE A .data SECTION ############################
############################ DO NOT CREATE A .data SECTION ############################
.text:

str_len:
	li $t0, 0 #length counter
	str_len_loop:
		lbu $t1, 0($a0) #get character from string
		beq $t1, $0, end_str_len_loop #if it equals null character than end loop
		addi $t0, $t0, 1 #increment counter
		addi $a0, $a0, 1 #increment string address pointer
		j str_len_loop
			
	end_str_len_loop:
		move $v0, $t0 #set v0 to counter
		jr $ra
str_equals:
	str_equals_loop:
		lbu $t0, 0($a0) #get char first strin
		lbu $t1, 0($a1) #get char second string
		bne $t0, $t1, str_not_equal
		beq $t0, $0, str_equal #if the character is null chraracter then loop is over and strings are equal
		addi $a0, $a0, 1
		addi $a1, $a1, 1
		j str_equals_loop
	
	str_equal:
		li $v0, 1
		j end_str_equals
	str_not_equal:
		li $v0, 0
	end_str_equals:
		jr $ra
str_cpy:
	li $t0, 0#number of characters copied
	str_cpy_loop:
		lbu $t1, 0($a0) #get the character to copy
		beq $t1, $0, end_str_cpy_loop #if character is null then leave loop
		sb $t1, 0($a1) #copy character to a1
		addi $a0, $a0, 1
		addi $a1, $a1, 1 #increment the addresses
		addi $t0, $t0, 1 #increment num characters copied
		j str_cpy_loop
		
	end_str_cpy_loop:
		sb $0, 0($a1) #store null character
		move $v0, $t0
		jr $ra
create_person:
	lw $t0, 0($a0) #get max number of nodes
	lw $t1, 16($a0) #get current number of nodes
	beq $t0, $t1, network_at_capacity #if max num of nodes and cur num of nodes were equal then return -1
	lw $t2, 8($a0) #get the size of each node
	mult $t1, $t2
	mflo $t0 #multiply cur number of nodes with size of each node
	addi $t1, $t1, 1 #increment the current number of nodes
	sw $t1, 16($a0) #store the new current number of nodes in the network)
	addi $a0, $a0, 36 #shift the address to beginning of nodes array
	add $v0, $a0, $t0 #add the product to the base address
	j end_create_person
	
	network_at_capacity:
		li $v0, -1
	end_create_person:	
		jr $ra
is_person_exists:
	lw $t0, 8($a0) #get size of nodes
	lw $t1, 16($a0) #get current number of nodes
	addi $a0, $a0, 36 #add 36 to network to bring it to nodes array
	blt $a1, $a0, person_not_exists #if person is less than the beginning of nodes array then not exists
	sub $t2, $a1, $a0 #subtract person with beginning of nodes array address
	div $t2, $t0 #divide the difference by size of nodes
	mfhi $t2 #remainder
	bnez $t2, person_not_exists #if not perfectly divisible then person not exists
	mflo $t2 #quotient
	bge $t2, $t1, person_not_exists #if quotient is greater than or equal to current number of nodes, then person not exists
	li $v0, 1
	j end_is_person_exists
	
	person_not_exists:
		li $v0, 0
	end_is_person_exists:
		jr $ra
is_person_name_exists:
	addi $sp, $sp, -24
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $s3, 12($sp)
	sw $s4, 16($sp)
	sw $ra, 20($sp)

	lw $s2, 8($a0) #get size of nodes
	lw $s3, 16($a0) #get current number of nodes
	addi $s0, $a0, 36 #add 36 to network to bring it to nodes array
	move $s1, $a1 #store name in s1
	li $s4, 0 #i counter
	person_name_exists_loop: #while i less than current number of nodes
		bge $s4, $s3, name_not_exists #if i greater than or equal to the current number of nodes, then person name doesn't exist
		move $a0, $s0 #address in nodes array
		move $a1, $s1 #person name being checked
		jal str_equals
		bnez $v0, name_exists #if not equal to 0, means that it's equal to 1 meaning the strings are equal meaning that name exists
		add $s0, $s0, $s2 #add to the nodes array the size of each node
		addi $s4, $s4, 1 #increment i
		j person_name_exists_loop
	name_exists:
		li $v0, 1
		move $v1, $s0 #store the address of the node
		j end_person_name_exists
	name_not_exists:
		li $v0, 0	
	end_person_name_exists:	
		lw $s0, 0($sp)
		lw $s1, 4($sp)
		lw $s2, 8($sp)
		lw $s3, 12($sp)
		lw $s4, 16($sp)
		lw $ra, 20($sp)	
		addi $sp, $sp, 24
		jr $ra
add_person_property:
	addi $sp, $sp, -20
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $s3, 12($sp)
	sw $ra, 16($sp)
	
	move $s0, $a0 #network address
	move $s1, $a1 #person address
	move $s2, $a2 #prop_name
	move $s3, $a3 #property value
	
	#create name string
	addi $sp, $sp, -5
	li $t0, 'N'
	sb $t0, 0($sp)
	li $t0, 'A'
	sb $t0, 1($sp)
	li $t0, 'M'
	sb $t0, 2($sp)
	li $t0, 'E'
	sb $t0, 3($sp)
	li $t0, 0
	sb $t0, 4($sp)
	
	#check if property name equals NAME
	move $a0, $s2 #prop name
	addi $a1, $s0, 24 #get to address of name property
	#move $a1, $sp
	jal str_equals
	addi $sp, $sp, 5 #restore stack
	beqz $v0, prop_not_name_error
	
	
	
	#check if person exists
	move $a0, $s0 #network
	move $a1, $s1 #person node
	jal is_person_exists
	beqz $v0, property_person_not_exists_error
	
	#check if size of propval is less than size of the node
	move $a0, $s3 
	jal str_len
	lw $t0, 8($s0) #get size of node
	bge $v0, $t0 person_property_name_large_error#if size of prop val greater than size of node then error
	
	#check if name already exists
	move $a0, $s0
	move $a1, $s3
	jal is_person_name_exists
	bnez $v0, person_property_name_exists_error
	
	#copy prop val to node address
	move $a0, $s3
	move $a1, $s1
	jal str_cpy
	li $v0, 1
	j end_person_property
	prop_not_name_error:
		li $v0, 0
		j end_person_property
		
	property_person_not_exists_error:
		li $v0, -1
		j end_person_property
	person_property_name_large_error:
		li $v0, -2
		j end_person_property
	person_property_name_exists_error:
		li $v0, -3
	end_person_property:
		lw $s0, 0($sp)
		lw $s1, 4($sp)
		lw $s2, 8($sp)
		lw $s3, 12($sp)
		lw $ra, 16($sp)	
		addi $sp, $sp, 20
		jr $ra
get_person:
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	jal is_person_name_exists
	beqz $v0, end_get_person #if 0 means person not exists
	move $v0, $v1 #move the address to the $v0
	
	end_get_person:
		lw $ra, 0($sp)
		addi $sp, $sp, 4
		jr $ra
is_relation_exists:
	lw $t0, 20($a0) #current number of edges
	lw $t1, 0($a0) #total nodes
	lw $t2, 8($a0) #size of a node
	mult $t1, $t2 #multiply total nodes by size of a node
	addi $a0, $a0, 36 #adjust network to beginning of nodes array
	mflo $t1 #get the product
	add $a0, $a0, $t1 #adjust network address to beginnign of edges array
	li $t4, 4
	div $a0, $t4 #divide by 4 to word-align
	mfhi $t5 #remainder
	beqz $t5, cont_is_relation_exists #if remainder is 0
	sub $t4, $t4, $t5 #subtract the remainder from 4
	add $a0, $a0, $t4
	cont_is_relation_exists:
		
	li $t1, 0 #i
	#while i less than cur num of edges
	is_relation_exists_loop:
		beq $t1, $t0, no_relation_exists #if i equal to cur num of edges then no relation exists
		lw $t2, 0($a0) #load edge person 1
		lw $t3, 4($a0) #load edge person 2
		bne $a1, $t2, comp_person1_second_edge #if person1 equals edge person 1 then continue, if not equal then compare person1 to edge person 2
		bne $a2, $t3, inc_is_relation_loop #if person2 equals edgeperson2 then relation does exist, otherwise go to next edge
		j relation_exists
		comp_person1_second_edge:
			bne $a1, $t3, inc_is_relation_loop #if person1 equals edgeperson2 then continue, otherwise go to next edge
			bne $a2, $t2, inc_is_relation_loop #if person2 equals edgeperson1 then relation does exist, otherwise go to next edge
			j relation_exists
		inc_is_relation_loop:
			addi $a0, $a0, 12 #increment to next edge
			addi $t1, $t1, 1 #increment i
			j is_relation_exists_loop
		
	relation_exists:
		li $v0, 1	
		move $v1, $a0 #set v1 to the address of the edge where relation is found for part 11
		j end_is_relation_exists
	no_relation_exists:
		li $v0, 0
	end_is_relation_exists:
		jr $ra
add_relation:
	addi $sp, $sp, -16
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $ra, 12($sp)
	
	move $s0, $a0 #network
	move $s1, $a1 #person1
	move $s2, $a2 #person2
	
	#check if person1 and person2 exists
	jal is_person_exists
	beqz $v0, relation_person_not_exists_error
	move $a0, $s0
	move $a1, $s2
	jal is_person_exists
	beqz $v0, relation_person_not_exists_error
	
	#check if edges at capacity
	lw $t0, 4($s0) #get total number of edges
	lw $t1, 20($s0) #get current number of edges
	beq $t0, $t1, edge_capacity_error #if total nuber of edges equals current number of edges then error
	
	#check if relation already exists
	move $a0, $s0
	move $a1, $s1
	move $a2, $s2
	jal is_relation_exists
	bnez $v0, relation_already_exists_error
	
	#check if person1 equals person2
	beq $s1, $s2, relation_persons_equal_error
	#add the relation
	lw $t0, 20($s0) #current number of edges
	addi $t1, $t0, 1 #increment number of edges
	sw $t1, 20($s0) #store the new number of edges
	lw $t1, 0($s0) #total nodes
	lw $t2, 8($s0) #size of a node
	mult $t1, $t2 #multiply total nodes by size of a node
	addi $s0, $s0, 36 #adjust network to beginning of nodes array
	mflo $t1 #get the product
	add $s0, $s0, $t1 #adjust network address to beginnign of edges array
	li $t4, 4
	div $s0, $t4 #divide by 4 to word-align
	mfhi $t5 #remainder
	beqz $t5, cont_add_relation #if remainder is 0
	sub $t4, $t4, $t5 #subtract the remainder from 4
	add $s0, $s0, $t4
	cont_add_relation:
	
	li $t1, 12 
	mult $t0, $t1 #multiply the current number of edges (before we incremented it) by 12 to find the offset
	mflo $t0 #product
	add $s0, $s0, $t0 #go to where the new reelation will be made
	
	sw $s1, 0($s0) #person1
	sw $s2, 4($s0) #person2
	sw $0, 8($s0) #friend property set to 0
	li $v0, 1
	j end_add_relation
	relation_person_not_exists_error:
		li $v0,0
		j end_add_relation
	edge_capacity_error:
		li $v0, -1
		j end_add_relation
	relation_already_exists_error:
		li $v0, -2
		j end_add_relation
	relation_persons_equal_error:
		li $v0, -3
	end_add_relation:
		lw $s0, 0($sp)
		lw $s1, 4($sp)
		lw $s2, 8($sp)
		lw $ra, 12($sp)	
		addi $sp, $sp, 16
		jr $ra
add_relation_property:
	move $fp, $sp
	addi $sp, $sp, -28
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $s3, 12($sp)
	sw $s4, 16($sp)
	sw $s5, 20($sp)
	sw $ra, 24($sp)
	
	move $s0, $a0 #network
	move $s1, $a1 #person1
	move $s2, $a2 #person2
	move $s3, $a3 #prop_name
	lw $s4, 0($fp) #prop_val
	
	#check if relation exists
	jal is_relation_exists
	beqz $v0, add_rel_prop_rel_not_exists
	move $s5, $v1 #store address of edge where relation is found
	
	#check if prop_name is FRIEND
	addi $a0, $s0, 29 #load friend string
	move $a1, $s3 #prop name
	jal str_equals
	beqz $v0, prop_name_not_friend
	
	#check if prop val less than 0
	bltz $s4, prop_val_less_than_zero
	
	sw $s4, 8($s5) #set the friend property of the edge to prop_val
	li $v0, 1
	j end_add_relation_property
	add_rel_prop_rel_not_exists:
		li $v0, 0
		j end_add_relation_property
	prop_name_not_friend:
		li $v0, -1
		j end_add_relation_property
	prop_val_less_than_zero:
		li $v0, -2
	end_add_relation_property:	
		lw $s0, 0($sp)
		lw $s1, 4($sp)
		lw $s2, 8($sp)
		lw $s3, 12($sp)
		lw $s4, 16($sp)
		lw $s5, 20($sp)
		lw $ra, 24($sp)	
		addi $sp, $sp, 28
		jr $ra
is_friend_of_friend:
	addi $sp, $sp, -28
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $s3, 12($sp)
	sw $s4, 16($sp)
	sw $s5, 20($sp)
	sw $ra, 24($sp)

	move $s0, $a0 #nework
	move $s1, $a1 #name1
	move $s2, $a2 #name2
	
	#check if names exist
	jal get_person
	beqz $v0, FOF_name_not_exists #if name1 not in network, error
	move $s1, $v0 #person1 node address
	move $a0, $s0
	move $a1, $s2 #name2
	jal get_person
	beqz $v0, FOF_name_not_exists
	move $s2, $v0 #person2 node address
	
	#check if they are the same people
	beq $s1, $s2, not_FOF
	
	#check if they are direct friends
	move $a0, $s0
	move $a1, $s1
	move $a2, $s2
	jal are_friends
	bnez $v0, not_FOF #if they are direct friends then they're not FOF
	
	#go through all the nodes to see if there are FOFs
	lw $s3, 16($s0) #current number of nodes, i
	lw $s4, 8($s0) #get size of node
	addi $s5, $s0, 36 #go to 0th node address
	FOF_loop:
		blez $s3, not_FOF #while current number of nodes greater than 0, do loop. Otherwise not FOF
		#check if person1 is direct friends with person3
		move $a0, $s0
		move $a1, $s1
		move $a2, $s5
		jal are_friends
		beqz $v0, inc_FOF_loop #if they arent friends go to next node
		#check if person2 is direct friends with person3
		move $a0, $s0
		move $a1, $s2
		move $a2, $s5
		jal are_friends
		beqz $v0, inc_FOF_loop #if they aren't friends go to next loop, otherwise that means persion1 and person2 are FOF
		li $v0, 1
		j end_is_friend_of_friend
	
		inc_FOF_loop:
			add $s5, $s5, $s4 #increment node address by the size of a node
			addi $s3, $s3, -1 #i--
			j FOF_loop
	
	not_FOF:
		li $v0, 0
		j end_is_friend_of_friend
	FOF_name_not_exists:
		li $v0, -1
	end_is_friend_of_friend:	
		lw $s0, 0($sp)
		lw $s1, 4($sp)
		lw $s2, 8($sp)
		lw $s3, 12($sp)
		lw $s4, 16($sp)
		lw $s5, 20($sp)
		lw $ra, 24($sp)	
		addi $sp, $sp, 28
		jr $ra
		
are_friends:
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	jal is_relation_exists
	beqz $v0, not_friends
	lw $t0, 8($v1) #get the friend property
	blez $t0, not_friends #if friend property less than or equal to 0 then not friends, otherwise if greater than 0 then they are friends
	li $v0, 1 #are friends
	j end_are_friends
	not_friends:
		li $v0, 0
	end_are_friends:
		lw $ra, 0($sp)
		addi $sp, $sp, 4
		jr $ra
