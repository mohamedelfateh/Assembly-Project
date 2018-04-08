%include "io.inc"

section .text
global CMAIN
CMAIN:

    xor ecx,ecx 
    and ecx,eax
    add ecx,10000
    ;write your code here
    xor eax, eax
    ret