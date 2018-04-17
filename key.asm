bits 16
org 0x7C00
cli 
mov ah,2
mov al,6
mov dl,0x80
mov ch,0
mov dh,0
mov cl,2
mov bx,begin
int 0x13





jmp begin
times (510 - ($ - $$)) db 0
db 0x55, 0xAA
begin:        
	cli
	xor ax,ax
	mov ds,ax
	mov ss,ax
	mov edi, 0xB8000;
        mov esi,ScanCodeTableshift
        mov ecx,ScanCodeTableCAPS
        mov ebx,ScanCodeTable
       
       
       
L:      
        push edi 
        mov edi,0xB8000
        
     qw:cmp byte[edi+1],0x17
        je rt
        add edi,0x8FA0
        jl qw
        pop edi
        
        push ebx
        push ecx
        mov ecx,160
        mov eax,edi 
        sub eax,0xB8000
        xor edx,edx
        div ecx
        shr dl,1
         
        mov dh,al

        mov ah, 2
        mov bh, 0
        int 0x10
        pop ecx
        pop ebx
        
        in al,0x64; 0000000X
        and al,0x01
        jz L
        in al,0x60
        cmp al,0xE0
        je comp
        cmp al,0x80
        ja L 
        cmp al,0x3B        
        je f1
        cmp al,0x3C
        je f2
        cmp al,0x3D
        je f3
        cmp al, 0x1D
        je lctrl
        cmp al, 0x3A
        je c
;        cmp al,0x50
;        je down
;        cmp al,0x4B
;        je left
;        cmp al,0x4D
;        je right
;        cmp al,48
;        je up
        cmp al,0x2A
        je ls
        cmp al,0x36
        je rs
        cmp al , 0x1C
        je e
         cmp al ,0x0E
        je back
        cmp al ,0x45
        je num
       
        
        
        
i:      push ecx
        mov ecx,edi
        mov edi,0xB8F8E
     h:
        sub edi,2
        mov dl,[edi]
        mov [edi+2],dl
        
        cmp edi ,ecx
        
        jne h
        pop ecx
        
       ; mov byte[edi+1],0xf
        xlat
        mov [edi],al
        add edi,2
       ; mov byte[edi+1],4
        
        jmp L
c:
        xchg ebx,ecx
       
        jmp L
ls:
        
        push ebx
        push ecx
        mov ecx,160
        mov eax,edi 
        sub eax,0xB8000
        xor edx,edx
        div ecx
        shr dl,1
         
        mov dh,al

        mov ah, 2
        mov bh, 0
        int 0x10
        pop ecx
        pop ebx
        

        
        
        in  al,0x64
        test    al,1
        jz      ls
        
        in  al,0x60
        cmp al,0xAA
        je L
        
                        
        
        cmp al,0x2A
        je ls
       
        cmp al,0xE0
        je comp
        
        
        cmp al , 0x80
        ja ls
    
        xchg ebx,esi
        
;        mov ecx,edi
;        mov edi,0x8F8E
;u:      mov dl,[edi]
;        mov [edi+2],dl
;        cmp edi ,ecx
;        sub edi,2
;        jne u
;       

        push ecx
        mov ecx,edi
        mov edi,0xB8F8E
     u:
        sub edi,2
        mov dl,[edi]
        mov [edi+2],dl
        
        cmp edi ,ecx
        
        jne u
        pop ecx
         
        ;mov byte[edi+1],0xf
        xlat
        mov [edi],al
        add edi,2
        ;mov byte[edi+1],4
        xchg ebx,esi
        jmp ls
        
rs:
   
        in  al,0x64
        test    al,1
        jz      rs
        
        in  al,0x60
        cmp al,0xB6
        je L
        
        cmp al,0x36
        je rs
        
        cmp al,0xE0
        je comp
        
        cmp al , 0x80
        ja rs
    
        xchg ebx,esi
        xlat
        mov [edi],al
        add edi,2
        xchg ebx,esi
        jmp rs
e:
        mov eax,edi
        sub eax , 0xB8000
        
        mov ebp , 160
        xor edx,edx
        div ebp 
        sub edx,160
        neg edx
        
        add edi,edx
        jmp L 

down:
        add edi,160
       
        jmp L

left:  
        sub edi , 2
        
        
        jmp L

up:    
        sub edi, 160
      
        jmp L

right: 
        add edi , 2
      
        jmp L

back:  cmp byte[edi+1],0x17
        je backselr
        sub edi,2
        cmp byte[edi+1],0x17
        je backsell
        jne tl       
     tl:mov dl,0
        mov [edi],dl
        mov ebp,edi
     r: mov dl ,[edi+2]
        mov [edi],dl
        
        add edi,2
        cmp edi,0xB8F9E
        jb r
        mov edi,ebp
        ;add edi,2
        jmp L
        
backsell:
        mov byte[edi+1],0x7
        mov byte[edi],0
        
        ;cmp edi,[selbegin]
        ;ja backsell
        sub edi,2
        cmp byte[edi+1],0x17
        je backsell
        add edi,2
        
        push ecx
        mov ecx,edi
       
      tu:  cmp edi,0xB8F9E
      
        jg sr
        
 ww:    add edi,2
        cmp byte[edi],0
        je ww
        
       kl: 
      
      
       
       mov dl,0
      cmp edi,ecx
      je www
       mov [edi],dl
        mov ebp,edi
     rb:mov dl ,[edi+2]
        mov [edi],dl
        
        add edi,2
        cmp edi,0xB8F9E
        jb rb
        mov edi,ebp
        sub edi,2
        
        cmp edi,ecx       
        jg kl
       
        www:
         pop ecx
        
        jmp L
        sr:
        
        push ebp
        mov ebp,[edi+2]
        mov [edi],ebp
        add edi,2
        
        pop ebp 
        jmp tu
        
           
backselr:
        push ecx
        mov ecx,edi
        
backselrs:       
        mov byte[edi+1],0x7
        mov byte[edi],0
        add edi,2 
         cmp byte[edi+1],0x17
        je backselrs
        ;cmp edi,selend
        mov edi,ecx
        push ebp
  xyz:  mov ebp,[edi+2]    
        mov [edi],ebp
        add edi,2        
        cmp edi,0xB8f9E
        jb xyz
        
        mov edi,ecx
        cmp byte[edi+2],0
        je xyz
pop ecx
;     
;      
      
        
        jmp L
         

num:    mov bx,ScanCodeTablenum
        in al,0x64; 0000000X
        and al,0x01
        jz num
        in al,0x60
        cmp al,0x80
        ja num
        cmp al,0x45
        je nm
       ;  mov byte[edi+1],0xf
        xlat
        mov [edi],al
        add edi,2
       ; mov byte[edi+1],4
        
        jmp num
                         
       nm:mov bx, ScanCodeTable
          jmp L                                                   

sleft:  test dword[checksel],0
        jnz wx
        mov dword[selend],edi
    wx: sub edi ,2
        mov byte[edi+1] ,0x17
        
        
        jmp L

sdown:  push ebp
        xor ebp,ebp
ld:     mov byte[edi+1],0x17        
        add edi,2
        inc ebp
        cmp edi,0xB8F90
        je L
        cmp ebp ,80
        jna ld 
        pop ebp
        jmp L
        
sup:    push ebp
        xor ebp,ebp
lup:    mov byte[edi+1],0x17
        inc ebp
        sub edi,2
        cmp edi,0xB8000
        je L
        cmp ebp,80
        jna lup
        pop ebp
        jmp L
        
sright:
        
        
       add dword[number],1
        
        inc edi
        mov byte[edi],0x17
        inc edi
        jmp L
        

comp:   in al,0x64
        test al,1
        jz comp
        in al ,0x60
        cmp al,0xAA
        je sh
        cmp al,0xB6
        je sh
        cmp al,0x50
        je down
        cmp al ,0x4B
        je left
        cmp al ,0x48
        je up
        cmp al , 0x4D
        je right
        jmp L
        

        
sh:     in al,0x64
        test al,1
        jz sh
        in al,0x60
;        cmp al,0xE0
;        jne sh
        in al,0x64
        and al,0x01
        in al , 0x60
        cmp al,0x4B
        je sleft
        
        cmp al, 0x50
        je sdown
        cmp al, 0x4D
        je sright
        cmp al,0x48
        je sup
        jmp L
               
        f1: 
        mov ah,0
        mov al,5
        int 0x10
        
        
        
        f2:
        mov ah,1
        mov al,5
        int 0x10
        
        
        
        f3:
        mov ah,2
        mov al,5 
        int 0x10
        
lctrl:
        in al,0x64
        and al,0x01
        jz lctrl
        in al,0x60
        cmp al,0x9D
        je L
        cmp al,0x80
        ja lctrl
        cmp al,0x1D
        je lctrl
        cmp al,0x2E
        je copy
        cmp al,0x2F
        je paste
        cmp al,0x1E
        je sall
        cmp al,0x2D
        je cut
        jmp L

sall:   push ecx
        mov ecx,edi
        mov edi,0xB8000
      j:mov byte[edi+1],0x17
        add edi,2        
        cmp edi,0xB8F9E
        jl j
        mov edi,ecx
        pop ecx
        jmp L 
        

copy:
        
        
        push ecx
        mov ecx,edi
       
        push ebp
        xor ebp , ebp
       z:
        cmp byte[edi+1],0x17
        je iu
        pop ebp
        mov edi , ecx
        pop ecx         
        jmp lctrl
        


iu:
        push si
        mov si ,[edi]
        mov byte[edi+1],7
        add edi,2
        mov [coppy+ebp],si
        inc ebp
        mov [number],ebp
        
        pop si
        cmp edi,[selend]
        jl iu
        jmp z 

paste:                  
        push ecx
        xor ecx,ecx
        push esi 
        xor esi,esi
        
        jn:
        mov ecx,[coppy+esi]
        mov [edi],ecx
        add edi,2
        inc esi
        cmp esi,dword[number]
        jl jn
        pop esi 
        pop ecx
        jmp lctrl
        
        
        
del:    
        push ecx
        mov ecx,edi
        cmp byte[edi+1],0x17
        je dels
      n:add edi,2
        cmp ecx,edi
        jl dels 
        
        jmp lctrl
dels:  
        
        mov byte[edi],0
        add edi,2
        cmp edi,dword[selend]
        jl del
        
    ; p: mov dl ,[edi+2]
;        mov [edi],dl
;        
;        add edi,2
;        cmp edi,0xB8FA0
;        jb r
;        mov edi,ebp
;        jmp n
;        
cut:    cmp byte[edi+1],4
        je cuts        
        add edi,2
        jmp lctrl
cuts:   mov byte[edi+1],7
        add edi,2
        
        
rt:     mov byte[edi+1],0x7
        mov byte[edi],0
        add edi,2
        cmp byte[edi+1],0x17
        je rt
        jmp L        
        
ackspace:
        mov byte[edi],0
                       
                             
ScanCodeTableCAPS: db "//1234567890-=//QWERTYUIOP[]\/ASDFGHJKL;//'/ZXCVBNM,.//// /"
ScanCodeTableshift: db "/~!@#$%^&*()_+//QWERTYUIOP{}|/ASDFGHJKL:///ZXCVBNM<>?/// /"
ScanCodeTable: db "//1234567890-=//qwertyuiop[]\/asdfghjkl;//'/zxcvbnm,.//// /" 
ScanCodeTablenum: db "//1234567890-=//qwertyuiop[]//asdfghjkl;//'\zxcvbnm,.//// /////        789-456+1230." 
coppy: times(80*25) db 0
number: dd 0
selbegin: dd 0
selend: dd 0
checksel: dd 0
times (0x400000 - 512) db 0

db 	0x63, 0x6F, 0x6E, 0x65, 0x63, 0x74, 0x69, 0x78, 0x00, 0x00, 0x00, 0x02
db	0x00, 0x01, 0x00, 0x00, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF
db	0x20, 0x72, 0x5D, 0x33, 0x76, 0x62, 0x6F, 0x78, 0x00, 0x05, 0x00, 0x00
db	0x57, 0x69, 0x32, 0x6B, 0x00, 0x00, 0x00, 0x00, 0x00, 0x40, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x40, 0x00, 0x00, 0x00, 0x78, 0x04, 0x11
db	0x00, 0x00, 0x00, 0x02, 0xFF, 0xFF, 0xE6, 0xB9, 0x49, 0x44, 0x4E, 0x1C
db	0x50, 0xC9, 0xBD, 0x45, 0x83, 0xC5, 0xCE, 0xC1, 0xB7, 0x2A, 0xE0, 0xF2
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00