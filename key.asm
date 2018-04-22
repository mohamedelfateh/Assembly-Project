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
        mov ebp,ScanCodeTableshiftCAPS
        mov ebx,ScanCodeTable
       ;pushad
;     ce: 
;     xor al,al
;     xor dl,dl
;     xor cx,cx
;     mov al,15
;     shl al,4
;      mov byte[edi+1],0x00
;       add edi,2
;       cmp edi,0xB8AF0
;       jl ce
;       popad
;        pushad
;     cr:
;     mov byte[edi+1],00
;     mov byte[edi+1],0xf0
;     add edi,2
;     cmp edi,0xB8FA0
;     jle cr 
;     
;       popad
       
       
       
L:      
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
        cmp al,0x2A
        je ls
        cmp al,0x36
        je rs
        cmp al , 0x1C
        je e
        cmp al,0x0F
        je tab
        cmp al ,0x0E
        je back
;        cmp al,0x53
;        je delete 
;        cmp al,0x47
;        je home
;        cmp al,0x4F
;        je end
        cmp al ,0x45
        je num
        
        push eax
        push ebp
        push edi                         
        mov edi,0xB8000
        xor ebp,ebp
tyb:    cmp byte[edi+1],0x17
        jne tnb       
        mov byte[edi+1],7
        mov al,0
        mov [edi],al
        add ebp,2                
tnb:    add edi,2       
        cmp edi,0xB8F9E
        jna tyb
        pop edi 
         
        push edi
reb:    mov al ,[edi+ebp]
        mov [edi],al        
        add edi,2
        cmp edi,0xB8F9E
        jb reb
        pop edi
        pop ebp
        pop eax
        
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

        xlat
        mov [edi],al
        add edi,2
        
        jmp L
c:
        NOT dword[CAPS]
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
        cmp dword[CAPS],-1
        je scaps
        ;mov byte[edi+1],0xf
    xlat
       
        mov [edi],al
        add edi,2
        ;mov byte[edi+1],4
        xchg ebx,esi
        jmp ls
        
scaps:
        xchg ebx,ebp
        xlat
        mov [edi],al
        add edi,2
        ;mov byte[edi+1],4
        xchg ebx,ebp
        jmp ls
        
rs:
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
            push ecx
        mov ecx,edi
        mov edi,0xB8F8E
     d:
        sub edi,2
        mov dl,[edi]
        mov [edi+2],dl
        
        cmp edi ,ecx
        
        jne d
        pop ecx
        cmp dword[CAPS],-1
        je scapsr
        ;mov byte[edi+1],0xf
    xlat
       
        mov [edi],al
        add edi,2
        ;mov byte[edi+1],4
        xchg ebx,esi
        jmp rs
        
scapsr:
         xchg ebx,ebp
        xlat
        mov [edi],al
        add edi,2
        ;mov byte[edi+1],4
        xchg ebx,ebp
        jmp rs
e:      
        push ebp
        push edi                 
        mov edi,0xB8000
        xor ebp,ebp
tye:    cmp byte[edi+1],0x17
        jne tne       
        mov byte[edi+1],7
        mov al,0
        mov [edi],al
        add ebp,2                
tne:    add edi,2
        
        cmp edi,0xB8F9E
        jna tye
        pop edi 
         
        push edi
re1:    mov al ,[edi+ebp]
        mov [edi],al        
        add edi,2
        cmp edi,0xB8F9E
        jb re1
        pop edi
        
        mov eax,edi
        sub eax , 0xB8000        
        mov ebp , 160
        xor edx,edx
        div ebp
        sub edx,160
        neg edx
        
        mov ebp,edi
        push edi
        mov edi,0xB8F9E
        sub edi,edx
re2:    mov al ,[edi]
        mov [edi+edx],al 
        mov al,0
        mov [edi],al       
        sub edi,2
        cmp edi,ebp
        jnb re2
        pop edi            
        pop ebp        
        add edi,edx     
        jmp L 

tab:    
        push ebp       
        push edi                 
        mov edi,0xB8000
        xor ebp,ebp
tyt:    cmp byte[edi+1],0x17
        jne tnt       
        mov byte[edi+1],7
        mov al,0
        mov [edi],al
        add ebp,2                
tnt:    add edi,2
        
        cmp edi,0xB8F9E
        jna tyt
        pop edi 
         
        push edi
rtab:   mov al ,[edi+ebp]
        mov [edi],al        
        add edi,2
        cmp edi,0xB8F9E
        jb rtab
        pop edi        
         ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
         mov ebp,edi
         sub ebp,2
         mov edi,0xB8F9E
         sub edi,8
rec:
         mov al,[edi]
         mov [edi+8],al
         mov al,0
         mov [edi],al
         sub edi,2
         cmp edi,ebp
         ja rec
         add edi,10
         pop ebp
         jmp L 
        
down:   
        add edi,160
        push edi         
        mov edi,0xB8000
tyd:     cmp byte[edi+1],0x17
        jne tnd       
        mov byte[edi+1],7        
tnd:     add edi,2
        cmp edi,0xB8F9E
        jna tyd 
        pop edi       
        jmp L

left:  
        sub edi , 2
        push edi 
        mov edi,0xB8000
tyl:     
        cmp byte[edi+1],0x17
        jne tnl       
        mov byte[edi+1],7        
tnl:     
        add edi,2
        cmp edi,0xB8F9E
        jne tyl 
        pop edi 
        jmp L

up:    
        sub edi, 160
        push edi 
        mov edi,0xB8000
tyu:     cmp byte[edi+1],0x17
        jne tnu       
        mov byte[edi+1],7        
tnu:     add edi,2
        cmp edi,0xB8F9E
        jna tyu 
        pop edi 
        jmp L

right: 
        add edi , 2
        push edi 
        mov edi,0xB8000
tyr:     cmp byte[edi+1],0x17
        jne tnr       
        mov byte[edi+1],7        
tnr:     add edi,2
        cmp edi,0xB8F9E
        jna tyr 
        pop edi 
        jmp L

end:    push ebp
        push edx
        xor edx,edx
        mov eax,edi
        sub eax,0xB8000
        mov ebp,160      
        div ebp
        sub edx,160
        neg edx
        add edi,edx
        sub edi,2
        pop edx
        pop ebp                                                
        jmp L
        
home:   push ebp
        push edx
        xor edx,edx
        mov eax,edi
        sub eax,0xB8000
        mov ebp,160      
        div ebp
        mov eax,edx
        ;mul dword[two]
        sub edi,edx
        pop edx
        pop ebp                                                 
        jmp L         

back:   
        push ebp
        cmp byte[edi+1],0x17
        je ryes1  
        sub edi,2           
        cmp byte[edi+1],0x17
        je ryes2                                               
        mov al,0
        mov [edi],al
        mov ebp,edi
rno:    mov al ,[edi+2]
        mov [edi],al        
        add edi,2
        cmp edi,0xB8F9E
        jb rno
        mov edi,ebp
        pop ebp
        jmp L
        
          
ryes1:   
        push ebp
        push edi                 
        mov edi,0xB8000
        xor ebp,ebp
tyba1:   cmp byte[edi+1],0x17
        jne tnba1       
        mov byte[edi+1],7
        mov al,0
        mov [edi],al
        add ebp,2                
tnba1:   add edi,2        
        cmp edi,0xB8F9E
        jna tyba1
        pop edi 
         
        push edi
rback1:  mov al ,[edi+ebp]
        mov [edi],al        
        add edi,2
        cmp edi,0xB8F9E
        jb rback1
        pop edi
        pop ebp
        jmp L
        
ryes2:   
        push ebp
        push edi                 
        mov edi,0xB8000
        xor ebp,ebp
tyba2:   cmp byte[edi+1],0x17
        jne tnba2       
        mov byte[edi+1],7
        mov al,0
        mov [edi],al
        add ebp,2                
tnba2:   add edi,2        
        cmp edi,0xB8F9E
        jna tyba2
        pop edi 
        add edi,2 
        push edi
rback2:  mov al ,[edi]
        sub edi,ebp
        mov [edi],al
        add edi,ebp        
        add edi,2
        cmp edi,0xB8F9E
        jb rback2
        pop edi
        pop ebp
        jmp L
        
delete:   
        push ebp
        cmp byte[edi+1],0x17
        je ryes1  
        sub edi,2           
        cmp byte[edi+1],0x17
        je ryes2 
        add edi,2
          
        mov al,0
        mov [edi],al
        mov ebp,edi
rd:     mov al ,[edi+2]
        mov [edi],al        
        add edi,2
        cmp edi,0xB8F9E
        jb rd
        mov edi,ebp
        pop ebp
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

sleft:  sub edi ,2
        mov [selend],edi
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
        
sright: mov [selbegin],edi
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
        cmp al,0x53
        je delete
        cmp al,0x47
        je home
        cmp al,0x4F
        je end
        jmp L
        

        
sh:     in al,0x64
        test al,1
        jz sh
        in al,0x60
        cmp al,0xE0
        jne sh
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
        cmp al,0x53
        je delete
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
        cmp al,0x2D
        je cut
        cmp al,0x2E
        je copy
        cmp al,0x2F
        je paste
        cmp al,0x0F
        je changepage
        cmp al,0x1E
        je sall
        
        jmp L

sall:   
        push edi
        mov edi,0xB8FA0
ni:     sub edi,2
        mov al,[edi]
        cmp al,0x20
        je ni
        
sl:     cmp edi,0xB8000
        jl sen
        mov byte[edi+1],0x17
        sub edi,2
        jmp sl
sen:    pop edi
        jmp lctrl        
;jse:    add edi,2
;        cmp edi,0xB8F90
;        je jou
;        mov al,[edi]
;        cmp al,0x20
;        je jse
;        mov byte[edi+1],0x17
;        jmp jse 
;jou:    pop edi
;        jmp lctrl        

paste:  push ebp
        push esi
                 
        mov ebp,edi
        add ebp,2
        mov edi,0xB8F9E
        mov esi,2
        mov eax,[number]
        mul esi
        mov esi,eax
        sub edi,esi
recu:   mov al,[edi]
        mov [edi+esi],al
        mov al,0
        mov [edi],al
        sub edi,2
        cmp edi,ebp
        jae recu
        mov edi,ebp
        pop esi
        pop ebp
               
        push ebp
        xor ebp,ebp        
jn:
        mov al,[coppy+ebp]
        mov [edi],al
        add edi,2
        inc ebp
        cmp ebp,dword[number]
        jl jn
        pop ebp
        jmp lctrl

copy:   
        push ecx
        mov ecx,edi
        mov edi,0xB7FFE
        push ebp
        xor ebp , ebp
       z:
        add edi,2
        mov al,[edi]
        cmp byte[edi+1],0x17
        je iu
        cmp edi,0xB8F9E         
        jl z
        mov [number],ebp
        pop ebp
        mov edi , ecx
        pop ecx
        jmp lctrl

iu:
        mov byte[edi+1],7
        mov al ,[edi]                
        mov [coppy+ebp],al
        inc ebp
        jmp z

        
cut:   
        push ecx
        mov ecx,edi
        mov edi,0xB7FFE
        push ebp
        xor ebp , ebp
zc:
        add edi,2
        mov al,[edi]
        cmp byte[edi+1],0x17
        je ic
        cmp edi,0xB8F9E         
        jl zc
        mov edi , ecx
rc:     
        mov al ,[edi+ebp*2]
        mov [edi],al        
        add edi,2
        cmp edi,0xB8F9E
        jb rc        
        mov edi , ecx
        mov [number],ebp
        pop ebp        
        pop ecx
        jmp lctrl

ic:
        mov byte[edi+1],7
        mov al ,[edi]                
        mov [coppy+ebp],al
        mov al,0
        mov [edi],al
        inc ebp
        jmp zc        
        

changepage:
        
        cmp dword[crtpage],3
        je savepage3
        cmp dword[crtpage],2
        je savepage2
     
savepage1:

        mov dword[crtpage],2
        push ecx
        ;mov [c1],edi
        xor ecx,ecx
        mov edi,0xb8000
        rec3:mov al,[edi]
        mov [p1+ecx*4],al
        mov al,0
        mov [edi],al
        add edi,2
        inc ecx
        cmp edi,0xb8fA0
        jb rec3
        pop ecx
        jmp rebackpage2
rebackpage1:
        push ecx
        mov edi,0xb8000
        xor ecx,ecx
rec4:   mov al,[p1+4*ecx]
        mov [edi],al
        add edi,2
        inc ecx
        cmp edi,0xb8fA0
        jna rec4
        
        ;mov edi,dword[c1]
        ;mov edi,0xB8000
        mov edi,0xB8FA0
ns1:    sub edi,2
        cmp edi,0xB8000
        je nw1
        
        mov al,[edi]
        cmp al,0x20
        je ns1
        add edi,2
nw1:        
        pop ecx
        jmp L

savepage2:
        mov dword[crtpage],3
        push ecx
        ;mov dword[c2],edi
        
        xor ecx,ecx
        mov edi,0xb8000
        rec5:mov al,[edi]
        mov [p2+4*ecx],al
        mov al,0
        mov[edi],al
        add edi,2
        inc ecx
        cmp edi,0xb8f9E
        jb rec5
        pop ecx
        jmp rebackpage3

rebackpage2:
        push ecx
        mov edi,0xb8000
        xor ecx,ecx
        rec6:mov al,[p2+ecx*4]
        mov [edi],al
        add edi,2
        inc ecx
        cmp edi,0xb8fA0
        jna rec6
        
        ;mov edi,[c2]
        ;mov edi,0xB8000
        mov edi,0xB8FA0
ns2:    sub edi,2 
        cmp edi,0xB8000
        je nw2
        
        mov al,[edi]
        cmp al,0
        je ns2
        add edi,2
nw2:  
        pop ecx
        jmp L

savepage3:
        mov dword[crtpage],1
        push ecx
        xor ecx,ecx
        mov edi,0xb8000
        rec8:mov al,[edi]
        mov [p3+4*ecx],al
        mov al,0
        mov[edi],al
        add edi,2
        inc ecx
        cmp edi,0xb8fA0
        jb rec8
        pop ecx
        jmp rebackpage1

rebackpage3:

        mov edi,0xb8000
        push ecx
        xor ecx,ecx
rec9:   mov al,[p3+4*ecx]
        mov [edi],al
        add edi,2
        inc ecx
        cmp edi,0xb8fA0
        jna rec9
        ;mov edi,0xb8000
        mov edi,0xB8FA0
ns3:    sub edi,2 
        cmp edi,0xB8000
        je nw3
        
        mov al,[edi]
        cmp al,0
        je ns3
        add edi,2
nw3:  
    pop ecx
        jmp L
        
        
        

                       

                                     
                                                                          
CAPS: dd 0                                                                                                                                                     
ScanCodeTableCAPS: db "//1234567890-=//QWERTYUIOP[]\/ASDFGHJKL;//'/ZXCVBNM,.//// /"
ScanCodeTableshift: db "/~!@#$%^&*()_+//QWERTYUIOP{}|/ASDFGHJKL:///ZXCVBNM<>?/// /"
ScanCodeTableshiftCAPS: db "/~!@#$%^&*()_+//qwertyuiop{}|/asdfghjkl://'/zxcvbnm<>?/// /"
ScanCodeTable: db "//1234567890-=//qwertyuiop[]\/asdfghjkl;//'/zxcvbnm,.//// /" 
ScanCodeTablenum: db "//1234567890-=//qwertyuiop[]//asdfghjkl;//'\zxcvbnm,.//// /////        789-456+1230." 
coppy: times(80*25) db 0
number: dd 0
selbegin: db 0
selend: db 0
p1: times(2000) dd 0
p2: times(2000) dd 0
p3: times(2000) dd 0
crtpage: dd 1
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