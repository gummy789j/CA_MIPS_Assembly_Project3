.data
	prompt: .asciiz "Please input array A: \n"
	array_s: .space 205
	array_i: .space 1000
	char: .space 2
	null: .asciiz "" 
	space: .asciiz " " 
	newline: .asciiz "\n" 
	comma: .asciiz ","
	key: .asciiz "Please input a key value: \n"
	step: .asciiz "Step "
	unsorted_m: .asciiz "Error! The array is not sorted.\n"
	notfound_m: .asciiz "Not found!\n"
	colon: .asciiz ": "
	string1: .asciiz "A["
	string2: .asciiz "] "
	greater: .asciiz "> "
	less: .asciiz "< "
	equal: .asciiz "= "
	minus: .asciiz "-"
	error_m: .asciiz "error!"
	
.text
main: 
	add $v0, $zero, $zero	# initialize
	add $a0, $zero, $zero
	li $v0, 4   	 
	la $a0, prompt   
	syscall   		#print prompt

gets:   
	la $s1, array_s 		 #set base address of array to $s1 
loop:   				#start of read loop 
	jal getchar 	 	#jump to getchar in order to get  one charactor in buffer 
	lb $t0, char 	 	#load the char from char buffer into t0
	sb $t0, 0($s1) 	 	#store the char into the nth element of array 
	lb $t1, newline 		 #load newline char into t1 
	beq $t0, $t1, done	 #if end of string then jump to done 
	addi $s1, $s1, 1 		# base address ++
	j loop   		#jump to  loop 

getchar:  				 #read char from  buffer  
	li $v0, 8  		# read string 
	la $a0, char  		
	li $a1, 2  		
	syscall   		#store the char byte from  buffer into char 
	jr $ra   		#jump back to the gerchar function

	
done:  
	
	lb  $s4, comma 		 # load comma into $s4
	lb  $s7, minus		# load minus into $s7
	add $t0, $zero, $zero	#set $t0 as a counter for minus sign
	addi $s1, $s1, -1 	# relocate address to as the end point
	la $s0, array_s 	 	#set base address of array_s to as the start point 
	la $s5, array_i  		#set base address t of array_i to as the integer array start point to store
	add $s6, $zero, $zero 	 #set $s6 as a counter for digit
	
	lb $s1, newline		#load newline char into $s1
	
	
transition:
	lb $t1, 0($s0) 	#load char from array into t1 
	beq $t1, $s1, execute	# if read the newline then goto execute
	addi $s0, $s0, 1		# address ++
	jal m_count 	# check if minus or not
	jal checkcomma	# check if comma or not 
	addi $s6, $s6, 1 # digit count ++
	jal storedigit  # store first or second digit or third digit
	j transition 	# loop to transfer the char array to integer array
	

execute:
	jal checkdigit	# for the final number which be remain
	addi $s5, $s5, -1
	la $s0, array_i	#load integer array base address into the $s0
	lb $t1, 0($s0)		# to prepare to check it's sorted or not
	addi $t2, $t1, 0
execute2:			#check it's sorted or not
	beq $s0, $s5, inputkey	#after check , goto read the key of array
	addi $s0, $s0, 1
	lb $t1, 0($s0)
	j checksorted
	
inputkey:
	jal asc_desc
	li $v0, 4    #load syscall to print string for key
	la $a0, key 
	syscall  
	li $v0, 5
	syscall
	add $s3, $v0,$zero  # set the key of array into the $s3
	add $t0, $zero , $zero  #initiallize $t0 to as a step count
	addi $t0, $t0, 1
	add $t2, $zero , $zero  #initiallize $t2 to as a index
	la $s7, array_i	#load integer array base address into the $s0
	la $s0, array_i	#load integer array base address into the $s0
	sub $s1, $s5, $s0 #find the index of middle element 
	div $s1, $s1, 2 #set $s0 as address of middle element
	add $s1, $s1, $s0
	
binarysearch:
	lb $t1, 0($s1)		
	li $v0, 4
	la $a0, step
	syscall		#print step string
	li $v0, 1	
	add $a0, $t0, $zero
	syscall		#print step count
	li $v0, 4
	la $a0, colon
	syscall		#print colon
	li $v0, 4
	la $a0, string1
	syscall		#print string1
	li $v0, 1
	sub $s6, $s1, $s7
	add $a0, $s6, $zero
	syscall		#print index of array
	li $v0, 4
	la $a0, string2
	syscall		#print string2
	jal comparison
	addi $t0, $t0,1
	j binarysearch

storedigit:		#to chack 计 计 κ计
	bne $t2, $zero, storetwodigit  
	add $t2, $t1, $zero
	jr $ra
storetwodigit:
	bne $t3, $zero, storethreedigit 
	add $t3, $t1, $zero
	jr $ra
storethreedigit :
	add $t4, $t1, $zero
	jr $ra
m_count:		#to check it have minus or not
	beq $t1, $s7, m_count_e
	jr $ra
m_count_e:
	addi $t0, $t0, 1
	j transition	
checksorted:	# to check the array is sorted or not
	beq $t2, $t1, equal_s
	bgt $t2, $t1, greater_s
	blt $t2, $t1, less_s
equal_s:		# when two adjacent intedger are equal
	add $t2, $t1, $zero
	j execute2
greater_s:		# when one adjacent intedger are greater than the next
	add $t2, $t1, $zero
	addi $t3, $t3, 1
	beq $t4, $zero, execute2
	j unsorted
	
less_s:		# when one adjacent intedger are less than the next
	add $t2, $t1, $zero
	addi $t4, $t4, 1
	beq $t3, $zero, execute2
	j unsorted

asc_desc:
	beq $t4, $zero, asc	#check it's asc or desc
	beq $t3, $zero, desc
	j error
asc:
	add $t9, $zero, $zero 
	jr $ra
desc:
	addi $t9, $t9, 1
	jr $ra

checkcomma:	# if charactor is comma then it means that it have to be the end sign of  a number, so i have to combine $t2 $t3 $t4
	beq $t1, $s4, checkdigit
	jr $ra

checkdigit:
	beq $s6, 1, one  # if count == 1 ウ计
	beq $s6, 2, ten  # if count == 2 ウ计
	beq $s6, 3, hundred   # if count == 3 ウ计 
	j error	
one:			# when it read the comma and just have one digit have been read before 

	addi $t2, $t2, -48
	beq $t0, 1, trans_m
	j finalnum

ten:			# when it read the comma and just have two digit have been read before 
	addi $t2, $t2, -48
	mulo $t2, $t2, 10
	addi $t3, $t3, -48
	add $t2, $t2, $t3
	beq $t0, 1, trans_m
	j finalnum
	
hundred:			# when it read the comma and just have three digit have been read before 
	addi $t2, $t2, -48
	mulo $t2, $t2, 100
	addi $t3, $t3, -48
	mulo $t3, $t3, 10
	addi $t4, $t4, -48
	add $t2, $t2, $t3
	add $t2, $t2, $t4
	beq $t0, 1, trans_m
	j finalnum
trans_m:			# if minus sign is 1 , the number should be change to negative
	sub $t2, $zero, $t2
	j finalnum
finalnum:			 
	sb $t2, 0($s5)		# put the integer into the new array
	addi $s5, $s5, 1
	
	add $t0, $zero, $zero
	add $t2, $zero, $zero
	add $t3, $zero, $zero
	add $t4, $zero, $zero
	add $s6, $zero, $zero
	beq $t1, $s1, finalone		# the final number in array cuz it doesn't have comma as its end sign, so it have an extra block to complete it
	j transition
finalone:	
	jr $ra
comparison:				# compare operation in the binary search
	beq $t9, $zero, comparison_asc	# distinct two condition about asc and desc
	j comparison_desc

comparison_asc:				# print different logic sign
	beq $s3, $t1, equal_asc
	bgt $s3, $t1, greater_asc
	blt $s3, $t1, less_asc
equal_asc:
	li $v0, 4
	la $a0, equal
	syscall
	li $v0, 1
	add $a0, $s3, $zero
	syscall
	j FIN
greater_asc:
	li $v0, 4
	la $a0, less
	syscall
	j leftchild
less_asc:
	li $v0, 4
	la $a0, greater
	syscall
	j rightchild
comparison_desc:
	beq $s3, $t1, equal_desc
	bgt $s3, $t1, greater_desc
	blt $s3, $t1, less_desc
equal_desc:
	li $v0, 4
	la $a0, equal
	syscall
	li $v0, 1
	addi $a0, $s3, 0
	syscall
	j FIN
greater_desc:
	li $v0, 4
	la $a0, less
	syscall
	j rightchild
less_desc:
	li $v0, 4
	la $a0, greater
	syscall
	j leftchild
leftchild:				# goto leftchild
	li $v0, 1
	addi $a0, $s3, 0
	syscall
	li $v0, 4
	la $a0, newline
	syscall
	beq $s5, $s0, notfound
	addi $s5, $s1, -1
	sub $s1, $s5, $s0 #find the index of middle element 
	div $s1, $s1, 2 #set $s0 as address of middle element
	add $s1, $s0, $s1
	jr $ra
rightchild:				# goto rightchild 
	li $v0, 1
	addi $a0, $s3, 0
	syscall
	li $v0, 4
	la $a0, newline
	syscall
	beq $s5, $s0, notfound
	addi $s0, $s1, 1
	sub $s1, $s5, $s0 #find the index of middle element 
	div $s1, $s1, 2 #set $s0 as address of middle element
	add $s1, $s0, $s1
	jr $ra

unsorted:			#if unsorted
	la $a0, unsorted_m
	li $v0, 4
	syscall
	li $v0, 10  #ends program 
	syscall 

notfound:			#if not found
	li $v0, 4
	la $a0, step
	syscall		#print step string
	addi $t0, $t0,1
	li $v0, 1	
	add $a0, $t0,$zero
	syscall		#print step count
	li $v0, 4
	la $a0, colon
	syscall		#print colon
	la $a0, notfound_m
	li $v0, 4
	syscall
	li $v0, 10  #ends program 
	syscall 
		
error:   	
	la $a0, error_m
	li $v0, 4
	syscall
	li $v0, 10  #ends program 
	syscall 

FIN: 
	
	li $v0, 10  #ends program 
	syscall 
	j FIN2
	
FIN2:
	li $v0, 10
	syscall
