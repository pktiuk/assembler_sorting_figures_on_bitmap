section .text

global f



;Strictly defined
;R8, R9,R15 -used as tmp buffers
;R10-tmp_buffer
;R11-pbuffer
;R12-x (width)
;R13-y (height of pic)
;R14 -xmin for next figure (where it should be redrawn)

;COLORS: #0xff000000 black #0xffffffff white
;SQUARES DATA: 0-num of pixels 4-x min 8-x max 12-ymin 16-ymax


f: ;(char*, char*, unsigned int, unsigned int):
  push rbp ;calling this function
  mov rbp, rsp

  sub rsp, 136 ;move frame for allocated local variables
  mov R10, rdi ;tmp_buffer
  mov R11, rsi  ;pbuffer
  mov R12D, edx  ;x
  mov R13D, ecx  ;y
  
  lea rax, [rbp-128] ;location of squares
  mov QWORD [rbp-8], rax ;pointer to current_square
  ;fill squares fields with zeroes
    mov QWORD [rbp-128], 0 ;square 1
    mov QWORD [rbp-108], 0 ;square 2
    mov QWORD [rbp-88], 0 ;square 3
    mov QWORD [rbp-68], 0 ;square 4
    mov QWORD [rbp-48], 0 ;square 5

    mov r14d,0;
     
  mov DWORD [rbp-12], 0;y_iter for this loop set it's value to 0
main_search_loop_y_init:
  mov eax, DWORD [rbp-12]
  cmp eax, R13D
  jnb rewriting_squares_to_tmp_buff
  mov DWORD [rbp-16], 0 ;x_iter for this loop
main_y_loop_body:
  mov eax, DWORD [rbp-16]
  cmp eax, R12D
  jnb main_search_loop_increase_y_iter
  mov eax, DWORD [rbp-16]
  sal eax, 2
  mov edx, eax
  mov eax, DWORD [rbp-12]
  imul eax, R12D
  sal eax, 2
  mov eax, eax
  add rdx, rax
  mov rax, R11
  add rax, rdx
  mov r15, rax
  mov rax, r15
  movzx eax, BYTE [rax]
  cmp al, 0
  jne main_search_loop_increase_x_iter
  mov rax, QWORD [rbp-8]
  mov DWORD [rax], 0
  mov rax, QWORD [rbp-8]
  add rax, 4
  mov DWORD [rax], 16777215
  mov rax, QWORD [rbp-8]
  add rax, 8
  mov DWORD [rax], 0
  mov rax, QWORD [rbp-8]
  add rax, 12
  mov DWORD [rax], 16777215
  mov rax, QWORD [rbp-8]
  add rax, 16
  mov DWORD [rax], 0
  mov r8, QWORD [rbp-8]
  mov edx, DWORD [rbp-12]
  mov esi, DWORD [rbp-16]
  mov rax, R15
  mov rcx, r8
  mov rdi, rax
  call  check ; call checking function
  add QWORD [rbp-8], 20;change value of curr square pointer (now it points to next square)
main_search_loop_increase_x_iter:
  add DWORD [rbp-16], 1
  jmp main_y_loop_body
main_search_loop_increase_y_iter:
  add DWORD [rbp-12], 1
  jmp main_search_loop_y_init

rewriting_squares_to_tmp_buff: ;just rewriting values of squares to buffer(used for debugging)
    mov eax, DWORD [rbp-128]
    mov edx, eax
    mov rax, R10
    mov BYTE [rax], dl
    mov edx, DWORD [rbp-124]
    mov rax, R10
    add rax, 1
    mov BYTE [rax], dl
    mov edx, DWORD [rbp-120]
    mov rax, R10
    add rax, 2
    mov BYTE [rax], dl
    mov edx, DWORD [rbp-116]
    mov rax, R10
    add rax, 3
    mov BYTE [rax], dl
    mov edx, DWORD [rbp-112]
    mov rax, R10
    add rax, 4
    mov BYTE [rax], dl
    mov edx, DWORD [rbp-108]
    mov rax, R10
    add rax, 5
    mov BYTE [rax], dl
    mov edx, DWORD [rbp-104]
    mov rax, R10
    add rax, 6
    mov BYTE [rax], dl
    mov edx, DWORD [rbp-100]
    mov rax, R10
    add rax, 7
    mov BYTE [rax], dl
    mov edx, DWORD [rbp-96]
    mov rax, R10
    add rax, 8
    mov BYTE [rax], dl
    mov edx, DWORD [rbp-92]
    mov rax, R10
    add rax, 9
    mov BYTE [rax], dl
    mov edx, DWORD [rbp-88]
    mov rax, R10
    add rax, 10
    mov BYTE [rax], dl
    mov edx, DWORD [rbp-84]
    mov rax, R10
    add rax, 11
    mov BYTE [rax], dl
    mov edx, DWORD [rbp-80]
    mov rax, R10
    add rax, 12
    mov BYTE [rax], dl
    mov edx, DWORD [rbp-76]
    mov rax, R10
    add rax, 13
    mov BYTE [rax], dl
    mov edx, DWORD [rbp-72]
    mov rax, R10
    add rax, 14
    mov BYTE [rax], dl
    mov edx, DWORD [rbp-68]
    mov rax, R10
    add rax, 15
    mov BYTE [rax], dl
    mov edx, DWORD [rbp-64]
    mov rax, R10
    add rax, 16
    mov BYTE [rax], dl
    mov edx, DWORD [rbp-60]
    mov rax, R10
    add rax, 17
    mov BYTE [rax], dl
    mov edx, DWORD [rbp-56]
    mov rax, R10
    add rax, 18
    mov BYTE [rax], dl
    mov edx, DWORD [rbp-52]
    mov rax, R10
    add rax, 19
    mov BYTE [rax], dl
    mov edx, DWORD [rbp-48]
    mov rax, R10
    add rax, 20
    mov BYTE [rax], dl
    mov edx, DWORD [rbp-44]
    mov rax, R10
    add rax, 21
    mov BYTE [rax], dl
    mov edx, DWORD [rbp-40]
    mov rax, R10
    add rax, 22
    mov BYTE [rax], dl
    mov edx, DWORD [rbp-36]
    mov rax, R10
    add rax, 23
    mov BYTE [rax], dl
    mov edx, DWORD [rbp-32]
    mov rax, R10
    add rax, 24
    mov BYTE [rax], dl
    mov edx, DWORD [rbp-28]
    mov rax, R10
    add rax, 25
    mov BYTE [rax], dl


  mov r8d,0; init xmin for next figure
  ;select the smallest figure from squares
  ;take first not equal zero and compare it with others
  searching_for_the_smallest_fig:
    mov r15,0 ;now it will contain ptr to square with the smallest field

    ;checking square1
    cmp DWORD [rbp-128],0
    je checking_square2 ;check if field of 1-st square is greater than 0
    ;saving location
    mov r15, rbp
    add r15,-128
    checking_square2:
      cmp DWORD [rbp-108],0
      je checking_square3 ;check if not 0
      cmp r15,0
      je copying_square2 ;if this is zero then copy pointer

      mov eax,[r15]
      cmp DWORD[rbp-108],eax;if field of curr_square > field of saved square then go to checking the next one
      ja checking_square3

      copying_square2:
      mov r15,rbp
      add r15,-108

    checking_square3:
      cmp DWORD [rbp-88],0
      je checking_square4 ;check if not 0
      cmp r15,0
      je copying_square3 ;if this is zero then copy pointer

      mov eax,[r15]
      cmp DWORD[rbp-88],eax;if field of curr_square > field of saved square then go to checking the next one
      ja checking_square4

      copying_square3:
      mov r15,rbp
      add r15,-88

    checking_square4:
      cmp DWORD [rbp-68],0
      je checking_square5 ;check if not 0
      cmp r15,0
      je copying_square4 ;if this is zero then copy pointer

      mov eax,[r15]
      cmp DWORD[rbp-68],eax;if field of curr_square > field of saved square then go to checking the next one
      ja checking_square5

      copying_square4:
      mov r15,rbp
      add r15,-68


    checking_square5:
      cmp DWORD [rbp-48],0
      je check_if_found_any_square ;check if not 0
      cmp r15,0
      je copying_square5 ;if this is zero then copy pointer

      mov eax,[r15]
      cmp DWORD[rbp-48],eax;if field of curr_square > field of saved square then go to checking the next one
      ja check_if_found_any_square

      copying_square5:
      mov r15,rbp
      add r15,-48

    check_if_found_any_square:
      cmp r15,0
      je leave_function_f

      save_curr_pointer:
      mov DWORD [r15],0
      mov QWORD [rbp-8],r15 ;change value of pointer to current square


  mov r8d,0; init xmin for next figure
  mov rax, QWORD [rbp-8]
  add rax, 12
  mov r15d,DWORD [rax] ;now r15b will contain ymin

rewriting_square_y_loop:
  mov rax, QWORD [rbp-8]
  add rax, 12
  mov edx, DWORD [rax];load y min
  mov rax, QWORD [rbp-8]
  add rax, 16
  mov eax, DWORD [rax]
  cmp edx, eax ;load y max
  ja end_of_rewriting_square_loop

 ;loop_drawing_line init
    mov rax, QWORD [rbp-8]
    add rax, 4
    mov edx, DWORD [rax]; edx contains min X for this figure
    mov r8d,edx; now R8 will contain current X for this figure
    check_rewriting_x_loop: ;check if we should leave loop
    mov rax, QWORD [rbp-8]
    add rax, 8
    mov eax, DWORD [rax];eax contains max X value for this figure
    cmp r8d, eax ;if r8d>eax then leave loop
    ja increase_iter_for_y

    ;loop_drawing_line body
      mov rax, QWORD [rbp-8]
      add rax, 12
      mov eax, DWORD [rax] ;load current y min
      imul eax, R12D ;y*width
      add eax, r8d;y*width+x
      sal eax, 2;*=4
      mov edx, eax ;load calculated offset to edx (and rdx)
      lea rcx, [rdx+r10]
      mov r9d, DWORD [rcx]

      mov rax, QWORD [rbp-8]
      add rax, 4
      mov ebx, DWORD [rax]
      sub ebx,r14d
      sal ebx,2
      sub edx,ebx

      mov ebx,r15d
      imul ebx, R12d
      sal ebx,2 ;ymin*width*4
      sub edx,ebx ;move figure down

      add rdx, r11
      mov DWORD [rdx], r9d

    ;loop_drawing_line end
    add r8d,1
    jmp check_rewriting_x_loop

increase_iter_for_y:
  mov rax, QWORD [rbp-8]
  add rax, 12
  mov edx, DWORD [rax]; load y min
  add edx, 1
  mov DWORD [rax], edx;increase value of y min (I use it as an iterator)
  jmp rewriting_square_y_loop
;leave figure loop
  end_of_rewriting_square_loop:

  mov rax, QWORD [rbp-8]
  add rax, 4
  mov ebx, DWORD [rax];;load x min
  mov eax, DWORD [rax+4];load xmax
  sub eax,ebx
  add r14d,eax
  add r14d,2


  jmp searching_for_the_smallest_fig 
  
  leave_function_f:
  nop
  leave
  ret



 check: ; call checking function:
  push rbp
  mov rbp, rsp
  sub rsp, 24
  mov QWORD [rbp-8], rdi ;ptr to current pixel
  mov DWORD [rbp-12], esi ;x
  mov DWORD [rbp-16], edx ;y
  mov QWORD [rbp-24], rcx ;curr_square

  mov rax, QWORD [rbp-8] 
  movzx eax, BYTE [rax]
  cmp al, 0
  jne leave_check_function

;copy pixel to tmp_buffer
  mov eax,[rbp-16] ;load y
  imul eax,R12D
  sal eax,2
  mov ebx,eax ;in ebx we have y*width*4
  mov eax,[rbp-12] ;load x
  sal eax,2 ;x*4
  add eax,ebx
  mov r9d,eax

  mov r8,R10
  add r8,r9
  mov DWORD [r8],0xff000000 ;move this black pixel to tmp buffer

  mov rax, QWORD [rbp-8]
  mov DWORD [rax], 0xffffffff ;make whis pixel white

  mov rax, QWORD [rbp-24]
  mov eax, DWORD [rax]
  lea edx, [rax+1]
  mov rax, QWORD [rbp-24]
  mov DWORD [rax], edx

  mov rax, QWORD [rbp-24]
  add rax, 4
  mov eax, DWORD [rax] ;load x min of current square
  
  cmp DWORD [rbp-12], eax
  jnb go_to_xmax
  mov rax, QWORD [rbp-24]
  lea rdx, [rax+4]
  mov eax, DWORD [rbp-12]
  mov DWORD [rdx], eax;update value of x min
go_to_xmax: ;go to xmax
  mov rax, QWORD [rbp-24]
  add rax, 8
  mov eax, DWORD [rax]
  cmp DWORD [rbp-12], eax
  jbe go_to_ymin
  mov rax, QWORD [rbp-24]
  lea rdx, [rax+8]
  mov eax, DWORD [rbp-12]
  mov DWORD [rdx], eax
go_to_ymin:
  mov rax, QWORD [rbp-24]
  add rax, 12
  mov eax, DWORD [rax]
  cmp DWORD [rbp-16], eax
  jnb go_to_ymax
  mov rax, QWORD [rbp-24]
  lea rdx, [rax+12]
  mov eax, DWORD [rbp-16]
  mov DWORD [rdx], eax
go_to_ymax:
  mov rax, QWORD [rbp-24]
  add rax, 16
  mov eax, DWORD [rax]
  cmp DWORD [rbp-16], eax
  jbe check_left
  mov rax, QWORD [rbp-24]
  lea rdx, [rax+16]
  mov eax, DWORD [rbp-16]
  mov DWORD [rdx], eax
check_left:
  cmp DWORD [rbp-12], 0
  je check_right
  mov eax, DWORD [rbp-12]
  lea esi, [rax-1]
  mov rax, QWORD [rbp-8]
  lea rdi, [rax-4]
  mov r8, QWORD [rbp-24]
  mov eax, DWORD [rbp-16]
  mov rcx, r8
  mov edx, eax
  call  check ; call checking function
check_right:
  mov eax, DWORD [rbp-12]
  sub eax, 1
  cmp R12d, eax
  jbe check_up
  mov eax, DWORD [rbp-12]
  lea esi, [rax+1]
  mov rax, QWORD [rbp-8]
  lea rdi, [rax+4]
  mov r8, QWORD [rbp-24]
  mov eax, DWORD [rbp-16]
  mov rcx, r8
  mov edx, eax
  call  check ; call checking function
check_up:
  cmp DWORD [rbp-16], 0
  je check_down
  mov eax, DWORD [rbp-16]
  lea esi, [rax-1]
  mov eax, R12d
  sal eax, 2
  mov eax, eax
  neg rax
  mov rdx, rax
  mov rax, QWORD [rbp-8]
  lea rdi, [rdx+rax]
  mov r8, QWORD [rbp-24]
  mov eax, DWORD [rbp-12]
  mov rcx, r8
  mov edx, esi
  mov esi, eax
  call  check ; call checking function
check_down:
  mov eax, DWORD [rbp-16]
  add eax, 1
  cmp R13d, eax
  jbe leave_check_function
  mov eax, DWORD [rbp-16]
  lea esi, [rax+1]
  mov eax, R12d
  sal eax, 2
  mov edx, eax
  mov rax, QWORD [rbp-8]
  lea rdi, [rdx+rax]
  mov r8, QWORD [rbp-24]
  mov eax, DWORD [rbp-12]
  mov rcx, r8
  mov edx, esi
  mov esi, eax
  call  check ; call checking function
leave_check_function:
  nop
  leave
  ret