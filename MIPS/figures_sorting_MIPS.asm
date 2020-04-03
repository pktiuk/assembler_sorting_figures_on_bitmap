
.data
        header:		.space 128 #firstly used to load data from original header, later for storing copy of this header
        input_file_name:	.asciiz "./in.bmp"
        output_file_name:	.asciiz "./out.bmp"
#        squares: .space 60 #5squares*12 instead it will be allocated


.text 

.eqv MAX_SIGNED 0x7fffffff
#another squares
.eqv squares $s5
#file descriptor
.eqv file_descriptor $t0

#output bitmap
.eqv bmp_output $s0
#input bitmap
.eqv bmp_input $s1
#file offset
.eqv file_offset $s2
#file size
.eqv file_size $s6

#width of image (not in pixels but in bytes) =4*width_in_pixels
.eqv width $s3
#height of image
.eqv height $s4

#current square pointer square: +0 -num_of_pixels +4 min_iter +8 max_iter
.eqv square_curr $t1

#iterators for pixels x=0 -left y=0-bottom 
.eqv iter $t7

#temporary
.eqv tmp $t2
.eqv tmp2 $t3
.eqv tmp3 $t4
.eqv tmp4 $t8
.eqv tmp5 $t9

.eqv input_iter $a2
.eqv input_pointer $a3


.macro print_int (%x)
	li $v0, 1
	add $a0, $zero, %x
	syscall
	.end_macro
	
.macro print_str (%str)
	.data
	myLabel: .asciiz %str
	.text
	li $v0, 4
	la $a0, myLabel
	syscall
	.end_macro
	
.macro print_str_rej (%str,%x)
	.data
	myLabel: .asciiz %str
	.text
	li $v0, 4
	la $a0, myLabel
	syscall
	li $v0, 1
	add $a0, $zero, %x
	syscall
	.end_macro

.macro reopen_input_file
      move   $a0,   file_descriptor
      li    $v0,   16  #close file
      syscall 

      la   $a0,   input_file_name
      li   $a2,   0
      li   $a1,   0 
      li   $v0,   13 #open file
      syscall
      move    file_descriptor,    $v0
      blt     $v0,$zero,opening_error
      .end_macro

.macro multiply_u(%a,%b,%c) # in %c is saved result
      multu   %a, %b
      mflo  %c
      .end_macro
      


main:
      #alloc squares
      addi    $a0,$zero,    60
      li    $v0, 9 #alloc memory
      syscall
      move squares ,$v0

open_file:
      la   $a0,   input_file_name
      li   $a2,   0
      li   $a1,   0 
      li   $v0,   13 #open file
      syscall
      move    file_descriptor,    $v0
      bge     $v0,$zero,load_data_from_header

opening_error:
      print_str("\nFailed opening file\n")
	j exit

load_data_from_header:      
      #read BM:
      move   $a0,   file_descriptor
      la    $a1,    header   
      li    $a2,    2
      li    $v0,   14  #read from file  
      syscall    
      #read size
      move   $a0,   file_descriptor
      la    $a1,    header   
      li    $a2,    4
      li    $v0,   14  #read from file     
      syscall 
      lw file_size, header
      print_str_rej("\nFile size", file_size)
      
      #next 4 bytes (without any useful information)
      move   $a0,   file_descriptor   
      la    $a1,    header   
      li    $a2,    4
      li    $v0,   14  #read from file  
      syscall 
      
      #read offset
       move   $a0,   file_descriptor
      la    $a1,    header   
      li    $a2,    4
      li    $v0,   14  #read from file
      syscall 
      lw    file_offset, header
      print_str_rej("\nOffset", file_offset)
      
      #next 4 bytes (without any useful information)
      move   $a0,   file_descriptor   
      la    $a1,    header   
      li    $a2,    4
      li    $v0,   14  #read from file  
      syscall 
      
      #read width
      move   $a0,   file_descriptor
      la    $a1,    header
      li    $a2,    4
      li    $v0,   14  #read from file
      syscall 
      lw    width, header
      print_str_rej("\nWidth", width)
      #read height
      move   $a0,   file_descriptor
      la    $a1,    header
      li    $a2,    4
      li    $v0,   14  #read from file
      syscall 
      lw    height, header
      print_str_rej("\nHeight", height)


prepare_output_and_input_data:
      li tmp,4
      multiply_u(width,tmp,width)                    #width in bytes
      sub	tmp, file_size, file_offset			# num of bytes used as array of colors
      move    $a0,    tmp
      li    $v0, 9 #alloc memory
      syscall
      move bmp_output ,$v0
      
      move    $a0,    tmp
      li    $v0, 9 #alloc memory
      syscall
      move bmp_input ,$v0
 
      reopen_input_file()
      #copy header of input file to memory 
      move   $a0,  file_descriptor  
      la    $a1,    header
      move    $a2,    file_offset
      li    $v0,   14  #read from file   
      syscall


      #copy array of colors to allocated memory
      move   $a0,  file_descriptor  
      move    $a1,    bmp_input
      move    $a2,    tmp
      li    $v0,   14  #read from file   
      syscall 
      
      #close input file
      move   $a0,  file_descriptor
      li    $v0,   16  #close file
      syscall


#copy input file to output, bezause we will work on output file, recursively filling it with white pixels, and later we will redraw sorted figures from input to output
rewrite_input_to_output:
      li iter,0
rewriting_loop:
      add tmp,iter,bmp_input
      lw tmp2,(tmp)
      add tmp,iter,bmp_output
      sw tmp2,(tmp)

rewriting_loop_check:
      addi iter,iter,4
      sub		tmp, file_size, file_offset
      bge		tmp, iter, rewriting_loop	# if $t0 >= $t1 then rewriting_loop


#main loop counting an measuring figures
loop_init:
      li iter,0
      move square_curr,squares
      addiu square_curr,square_curr,-12
      
      



loop_itself:
#load byte
      add tmp,iter,bmp_output
      lw tmp3,(tmp)
      li tmp2, 0xffffffff#ARGB -#0xff000000 black #0xffffffff white


      beq tmp3,tmp2,check_loop #if this pixel is white we go to check the next one

calling_procedure:
      move input_iter,iter
      move input_pointer,tmp #pointer to this pixel
      jal black_pixel_found_in_main_loop





check_loop:
      addi iter,iter,4
      sub		tmp, file_size, file_offset
      bgt		tmp, iter, loop_itself	# if $t0 >= $t1 then loop_itself
      j drawing_sorted_figures

black_pixel_found_in_main_loop:
      #one of figures is saved to squares, so we have to move square pointer
      print_str("found black block")
      addi square_curr,square_curr,12

black_pixel_found:
      addiu $sp,$sp,-4 #move stack pointer
      sw $ra,0($sp) #save return address

      print_str_rej("\nFound black pixel for iter:",input_iter)
      ###function body:
      #paint this pixel white because of recursion
      li tmp,0xffffffff
      sw tmp,(input_pointer)

      #increase field counter
      lw tmp,(square_curr)
      addi tmp2,tmp,1
      sw tmp2,(square_curr)

      #check if field==1, then save frames describing location
      bne tmp,$zero,update_frames_of_curr_square
      sw input_iter,4(square_curr)
      sw input_iter,8(square_curr)

update_frames_of_curr_square:
 #count current x,y value
      divu    input_iter, width
      mfhi    tmp       #x - |a/b|
      mflo    tmp2      #y  - a-|a/b|*b   

      #load saved x,y min value
      lw tmp3, 4(square_curr)
      divu    tmp3, width
      mfhi    tmp3       #x
      mflo    tmp4      #y
check_min_x:
      bge		tmp, tmp3, check_min_y	# if tmp >= temp3 then check_min_y
                                          #if tmp < tmp 3 then update

      #update min_x
      sub   tmp3,tmp3,tmp
      lw    tmp5,4(square_curr)
      sub   tmp3,tmp5,tmp3
      sw    tmp3,4(square_curr)
check_min_y:
      bge         tmp2,tmp4,check_max_x

      #update min_y
      sub     tmp4, tmp4, tmp2
      multu   tmp4, width
      mflo    tmp4
      lw      tmp5,4(square_curr)
      sub     tmp5,tmp5,tmp4
      sw      tmp5,4(square_curr)
check_max_x:
      #load saved x,y max values
      lw tmp3, 8(square_curr)
      divu    tmp3, width
      mfhi    tmp3       #x
      mflo    tmp4      #y

      ble		tmp, tmp3, check_max_y	# if tmp <= tmp3 then check_max_y

      #update max_x
      sub   tmp3,tmp,tmp3
      lw    tmp5,8(square_curr)
      add   tmp3,tmp5,tmp3
      sw    tmp3,8(square_curr)      
check_max_y:
      ble		tmp2, tmp4, checking_neighbours	# if tmp2 <= tmp4 then checking_neighbours
      
      #update max_y
      sub     tmp4, tmp2,tmp4
      multu   tmp4, width
      mflo    tmp4
      lw      tmp5,8(square_curr)
      add     tmp5,tmp5,tmp4
      sw      tmp5,8(square_curr)

      
      

checking_neighbours:

check_left:
print_str("cL")
      #check if is current pixel left one
      divu input_iter,width
      mfhi tmp
      beq  tmp,$zero, check_right

      #load left one
      lw tmp,-4(input_pointer)
      li tmp2, 0xffffffff #white
      beq tmp,tmp2,check_right

      #calling recursively
      print_str("jump left")
      addiu $sp,$sp,-4 #move stack pointer
      sw input_iter,0($sp) #save input_iter
      addiu input_iter,input_iter,-4
      addiu $sp,$sp,-4 #move stack pointer
      sw input_pointer,0($sp) #save input_pointer
      addiu input_pointer,input_pointer,-4
      jal black_pixel_found

      lw input_pointer,($sp)
      addiu $sp,$sp,4
      lw input_iter,($sp)
      addiu $sp,$sp,4


check_right:
print_str("cR")
      #check if is current pixel right one
      divu input_iter,width
      mfhi tmp
      addi  tmp,tmp,4
      beq  tmp,width, check_top

      #load right one
      lw tmp,4(input_pointer)
      li tmp2, 0xffffffff #white
      beq tmp,tmp2,check_top

      #calling recursively
      print_str("jump right")
      addiu $sp,$sp,-4 #move stack pointer
      sw input_iter,0($sp) #save input_iter
      addiu input_iter,input_iter,4
      addiu $sp,$sp,-4 #move stack pointer
      sw input_pointer,0($sp) #save input_pointer
      addiu input_pointer,input_pointer,4
      jal black_pixel_found

      lw input_pointer,($sp)
      addiu $sp,$sp,4
      lw input_iter,($sp)
      addiu $sp,$sp,4
check_top:
print_str("cT")
      
      
      
      #check if is current pixel top one
      divu input_iter,width
      mflo tmp #y
      addi  tmp,tmp,1
      beq  tmp,height, check_bottom

      addu tmp,input_pointer,width
      lw tmp,(tmp)
      li tmp2, 0xffffffff #white
      beq tmp,tmp2,check_bottom

      #calling recursively
      print_str("jump top")
      addiu $sp,$sp,-4 #move stack pointer
      sw input_iter,0($sp) #save input_iter
      addu input_iter,input_iter,width
      addiu $sp,$sp,-4 #move stack pointer
      sw input_pointer,0($sp) #save input_pointer
      addu input_pointer,input_pointer,width
      jal black_pixel_found

      lw input_pointer,($sp)
      addiu $sp,$sp,4
      lw input_iter,($sp)
      addiu $sp,$sp,4

check_bottom:
      #check if is current pixel bottom one
      divu input_iter,width
      mflo tmp #y
      beq  tmp,$zero, black_pixel_found_returning

      move tmp, input_pointer
      subu    tmp, tmp, width
      lw tmp,(tmp)
      li tmp2, 0xffffffff #white
      beq tmp,tmp2,black_pixel_found_returning

      #calling recursively
      print_str("jump bottom")
      addiu $sp,$sp,-4 #move stack pointer
      sw input_iter,0($sp) #save input_iter
      subu input_iter,input_iter,width
      addiu $sp,$sp,-4 #move stack pointer
      sw input_pointer,0($sp) #save input_pointer
      subu input_pointer,input_pointer,width
      jal black_pixel_found

      lw input_pointer,($sp)
      addiu $sp,$sp,4
      lw input_iter,($sp)
      addiu $sp,$sp,4

      #returning
black_pixel_found_returning:
      lw $ra,0($sp) #load return address
      addiu $sp,$sp,4 #move stack pointer (deallocate)
      jr $ra



drawing_sorted_figures:
      move tmp,squares
      lw tmp2,(tmp)
      print_str_rej("\nSquare1 field:", tmp2)
      lw tmp2,4(tmp)
      print_str_rej(" min: ", tmp2)
      lw tmp2,8(tmp)
      print_str_rej(" max: ", tmp2)

      addiu tmp,tmp,12
      lw tmp2,(tmp)
      print_str_rej("\nSquare2 field:", tmp2)
      lw tmp2,4(tmp)
      print_str_rej(" min: ", tmp2)
      lw tmp2,8(tmp)
      print_str_rej(" max: ", tmp2)

      addiu tmp,tmp,12
      lw tmp2,(tmp)
      print_str_rej("\nSquare3 field:", tmp2)
      lw tmp2,4(tmp)
      print_str_rej(" min: ", tmp2)
      lw tmp2,8(tmp)
      print_str_rej(" max: ", tmp2)

      addiu tmp,tmp,12
      lw tmp2,(tmp)
      print_str_rej("\nSquare4 field:", tmp2)
      lw tmp2,4(tmp)
      print_str_rej(" min: ", tmp2)
      lw tmp2,8(tmp)
      print_str_rej(" max: ", tmp2)

      addiu tmp,tmp,12
      lw tmp2,(tmp)
      print_str_rej("\nSquare5 field:", tmp2)
      lw tmp2,4(tmp)
      print_str_rej(" min: ", tmp2)
      lw tmp2,8(tmp)
      print_str_rej(" max: ", tmp2)



move input_pointer,$zero #it will be used in redrawing do describe x location of next figure
#find the sallest square from list
find_the_smallest_fig:
            li tmp, MAX_SIGNED
            lw tmp2,(squares)
            beq         tmp2,$zero,check_square2     #check if field = 0
            blt		tmp, tmp2, check_square2	# if tmp > tmp2 then check_square

            move tmp,tmp2
            addiu square_curr,squares,0

      check_square2:
            lw tmp2,12(squares)
            beq         tmp2,$zero,check_square3     #check if field = 0
            blt		tmp, tmp2, check_square3	# if tmp > tmp2 then check_square

            move tmp,tmp2
            addiu square_curr,squares,12

      check_square3:
            lw tmp2,24(squares)
            beq         tmp2,$zero,check_square4     #check if field = 0
            blt		tmp, tmp2, check_square4	# if tmp > tmp2 then check_square

            move tmp,tmp2
            addiu square_curr,squares,24
      check_square4:
            lw tmp2,36(squares)
            beq         tmp2,$zero,check_square5     #check if field = 0
            blt		tmp, tmp2, check_square5	# if tmp > tmp2 then check_square

            move tmp,tmp2
            addiu square_curr,squares,36

      check_square5:
            lw tmp2,48(squares)
            beq         tmp2,$zero,check_if_found_something     #check if field = 0
            blt		tmp, tmp2, check_if_found_something	# if tmp > tmp2

            move tmp,tmp2
            addiu square_curr,squares,48

      check_if_found_something:
            li tmp2,MAX_SIGNED
            beq		tmp, tmp2, save_output_file	# if tmp == $zero then save
      




#redraw squares from input to output file
redraw_found_square_init:
      lw    iter,4(square_curr)
      sw    $zero,(square_curr) #to be sure it won't be drawn anymore

      lw tmp2,8(square_curr)
      sub tmp5,tmp2,iter #distance from
      divu tmp5,width
      mfhi    tmp       #square x - |a/b|
      mflo    tmp2      #square y  - a-|a/b|*b 
      print_str_rej("\nSquare width:" ,tmp)
      print_str_rej(" height:",tmp2)

loop_x_body:
      #load from input
      addu tmp3,bmp_input,iter
      lw tmp4,(tmp3)

      #save to output
      addu tmp3,bmp_output,iter

      lw tmp5,4(square_curr)
      divu tmp5,width
      mfhi tmp5 #load x_min of current square
      addu tmp3, tmp3,input_pointer
      subu tmp3,tmp3,tmp5

      mflo tmp5 #load y_min of current square
      multu tmp5,width
      mflo tmp5
      subu tmp3,tmp3,tmp5
      
      sw tmp4,(tmp3)

      addi iter,iter,4

      #check if end on square
      lw tmp5,8(square_curr)
      bgt		iter, tmp5, go_to_next_figure	# this square is finished

      #check if it should go to next line
      divu tmp5,width
      mfhi tmp5
      divu iter,width
      mfhi tmp4
      ble tmp4,tmp5,loop_x_body #if tmp4(y_current)<=tmp5(max_y) just go to next x

      addu iter,iter,width #add width of image
      sub iter,iter,tmp #subtract width of this box (tmp was saved in redraw_found_square_init)
      addiu iter,iter,-4

      j loop_x_body

go_to_next_figure:
      lw tmp5, 4(square_curr)
      divu tmp5,width
      mfhi tmp5
      lw tmp4, 8(square_curr)
      divu tmp4,width
      mfhi tmp4
      subu tmp4,tmp4,tmp5
      addiu tmp4,tmp4,8

      addu input_pointer,tmp4,input_pointer
      print_str_rej("\ninput_pointer: ",input_pointer)

      j find_the_smallest_fig


save_output_file:
	la $a0, output_file_name
	li $a1, 1 #flag (1-write-only)
	li $a2, 0 #mode
	li $v0, 13 #open file
	syscall
      move    file_descriptor,    $v0

#write header to file
      move $a0, file_descriptor
	la $a1, header
	move $a2, file_offset
	li $v0, 15 #write to file
	syscall
#write rest of image
      sub		tmp, file_size, file_offset		# tmp = file_size - file_offset
      move $a0, file_descriptor
	la $a1, (bmp_output)
	move $a2, tmp
	li $v0, 15 #write to file
	syscall

      

      move $a0, file_descriptor
      li    $v0,   16  #close file
	syscall

exit:
	li $v0, 10 #close app
	syscall


