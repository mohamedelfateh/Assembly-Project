%include "io.inc"

section .text
global CMAIN
CMAIN:

    xor ecx,ecx 
    and ecx,eax
    mov ecx,10000
    l:
    inc eax
    loop l
    ;write your code here
    xor eax, eax
    ret