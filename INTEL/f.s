section .text

global f

;f(unsigned char*, unsigned int, unsigned int):
f:
  push rbp
  mov rbp, rsp
  mov QWORD  [rbp-24], rdi
  mov DWORD  [rbp-28], esi
  mov DWORD  [rbp-32], edx
  mov DWORD  [rbp-4], 0
.L5:
  mov eax, DWORD  [rbp-4]
  cmp DWORD  [rbp-32], eax
  jbe .L6
  mov DWORD  [rbp-8], 0
.L4:
  mov eax, DWORD  [rbp-8]
  cmp DWORD  [rbp-28], eax
  jbe .L3
  mov rax, QWORD  [rbp-24]
  add rax, 5
  mov BYTE  [rax], 0
  add DWORD  [rbp-8], 1
  jmp .L4
.L3:
  add DWORD  [rbp-4], 1
  jmp .L5
.L6:
  nop
  pop rbp
  ret