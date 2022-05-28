---
title: "用汇编(MASM)写的小程序"
date: 2022-05-26T18:18:10+08:00 
draft: false
---

```
extrn input:far, edit:far, sort:far, output:far

disp macro x,length,color               ;用来显示的宏，x为横坐标偏移量，length为字符串长度，color为颜色
     mov ax,1301h
     mov bx,color
     mov cx,length
     mov dh,yy
     mov dl,x
     mov bp,addr
     int 10h                            ;10号BIOS调用
     endm



data segment
    l0 db '        MENU         '
    l1 db '====================='
    l2 db '|   INPUT  GRADE    |'
    l3 db '|   EDIT   GRADE    |'
    l4 db '|   SORT   GRADE    |'
    l5 db '|   OUTPUT GRADE    |'
    l6 db '|   EXIT            |'
    l7 db '====================='       ;l0-l6存要显示的菜单字符串
    LL EQU $-l7                         ;一个菜单字符串的长度
    XX equ (80-ll)/2                    ;xx输出是横向偏移量，让菜单显示在屏幕中间
    yy db ?                             ;行号（相对屏幕第一行）
    nn dw 1                             ;行号（相对l0行）
    tab dw ?,l2,l3,l4,l5,l6             ;记录字符串的偏移地址
    addr dw ?                           ;字符串偏移量
    grade db 50 dup(5 dup(?), 10 dup(?), 3 dup (?))
    count db 0
data ends




stack segment para stack 'stack'        ;堆栈段
    db 256 dup(0)
stack ends

code segment
    assume cs:code,ss:stack,ds:data

start:
    mov ax, data
    mov ds, ax
    mov es, ax
last1:
    mov ax, 3
    int 10h                             ;设置显示模式
    mov yy, 8                           ;让屏幕上方有8个空行
    mov addr, offset l0                 ;将偏移量变量设为l0，准备打印l0行的内容
last2:
    disp xx, ll, 0fh                    ;先以无颜色打印所有行
    add addr, ll                        ;
    inc yy                              ;
    cmp yy, 16                          ;
    jl last2                            ;
    mov nn, 1                           ;将当前行号设为1，准备将第一行上色 
    call compute                        ;计算需要刷新的字符串的偏移量
    disp xx+4, ll-8, 51h                ;上色刷新,+4表示前面4个字符不刷新,-8表示后面8个字符不刷新,51为颜色编号



scan:
    mov ah, 1
    int 16h                             ;扫描是否键盘有输入
    jz scan                             ;没有输入就继续扫描，有则判断并处理
    mov ah, 0                           
    int 16h                             ;获取键盘输入的ascii码
    cmp ah, 80                          ;80为下键
    je down                             ;转到下键的处理代码
    cmp ah, 72                          ;72为上键
    je up                               ;转到上键的处理代码
    cmp al, 0dh                         ;0dh为回车
    je enter
    jmp scan

down:                                   ;下键的处理代码
    cmp nn, 5                           ;行号为5则到底了，不处理
    je scan
    call compute                        ;计算当前行需要刷新的字符串的偏移量
    disp xx+4, ll-8, 0fh                ;将当前的一行颜色复原
    inc nn                              ;移动到下一行
    call compute                        
    disp xx+4, ll-8, 51h                ;将颜色改变表示预选中这一行
    jmp scan                            ;返回继续扫描键盘接下来的操作

up:
    cmp nn, 1
    je scan
    call compute
    disp xx+4, ll-8, 0fh
    dec nn                              ;和下键的处理代码一样，只是需要判断上界和向上移动
    call compute
    disp xx+4, ll-8, 51h
    jmp scan


enter:
    cmp nn, 1                           ;成绩录入
    jne next2
    xor ax, ax
    mov al, count
    mov ah, 18
    mul ah
    mov dx, offset grade
    add dx, ax
    ;mov bl, count
    inc count
    call input

next2:
    cmp nn, 2                           ;成绩修改
    jne next3
    call edit

next3:
    cmp nn, 3                           ;成绩排序
    jne next4
    call sort

next4:
    cmp nn, 4                           ;成绩输出
    jne next5
    mov dx, offset grade
    mov bl, count
    call output

next5:
    cmp nn, 5                           ;退出
    je exit
    jmp last1

exit:
    mov dx, offset grade
    mov ah, 9
    int 21h
    mov dl, 'z'
    mov ah, 02h
    int 21h
    mov al,byte ptr nn
    mov ah,4ch
    int 21h




compute proc near                       ;计算需要刷新的字符串的偏移量
    mov di,nn                           
    add di,di                           ;因为tab存的是dw类型所以要乘以2
    mov ax,tab[di]                      ;找到当前行的字符串偏移量
    add ax,4                            ;因为前面有四个其他字符不用刷新上色，所以加4
    mov addr,ax                         ;将计算出的偏移量存起来
    mov al,byte ptr nn                  
    add al,9
    mov yy,al                           ;相对l0的行数+9位相对屏幕的行数
    ret
compute endp


code ends
    end start
```

```
public input
data segment
    input_info0 db 'input student id(length:5):', '$'
    input_info1 db 0dh,0ah,'input student name(length:10):', '$'
    input_info2 db 0dh,0ah,'input student grade(0-100):', '$'
    
    buffer0 db 6
        db ?
        db 6 dup (?)
    buffer1 db 11
        db ?
        db 11 dup (?)
    buffer2 db 4
        db ?
        db 4 dup (?)
data ends

code segment

input proc far
    assume cs:code,ds:data

    push ds;保存寄存器
    mov ax, data
    mov ds, ax

    mov ax, 3
    int 10h

    push dx                     ;输出提示信息
    mov dx, offset input_info0
    mov ah, 9
    int 21h

    mov dx, offset buffer0      ;输入学生id到buffer
    mov ah, 0ah
    int 21h
    pop dx

    lea si, buffer0             ;将buffer用字符串传送指令传送到主程序
    add si, 2                   ;的grade
    mov di, dx
    mov cx, 5
    rep movsb


    push dx
    mov dx, offset input_info1  ;输出提示信息
    mov ah, 9
    int 21h

    mov dx, offset buffer1      ;输入学生姓名
    mov ah, 0ah
    int 21h
    pop dx

    lea si, buffer1             ;传送到主程序
    add si, 2
    mov di, dx
    add di, 5
    mov cx, 10
    rep movsb



    push dx
    mov dx, offset input_info2  ;输出提示信息
    mov ah, 9
    int 21h

    mov dx, offset buffer2      ;输入成绩
    mov ah, 0ah
    int 21h
    pop dx

    lea si, buffer2             ;传送
    add si, 2
    mov di, dx
    add di, 15
    mov cx, 3
    rep movsb
    
    
    
    pop ds
    ret
    input endp
    code ends
    end
```

```
public edit
data segment
    input_info0 db 'input student id(length:5):', '$'
    input_info1 db 0dh,0ah,'input new grade(0-100):', '$'
    tag db ?    
    addr dw ?
    buffer0 db 6
        db ?
        db 6 dup (?)
    buffer1 db 4
        db ?
        db 4 dup (?)
data ends

code segment

edit proc far
    assume cs:code,ds:data

    push ds;保存寄存器
    mov ax, data
    mov ds, ax
    mov addr, dx
    mov tag, 1

    mov ax, 3
    int 10h
    
    mov dx, offset input_info0      ;输出提示信息
    mov ah, 9
    int 21h
    mov dx, offset buffer0
    mov ah, 0ah
    int 21h

    call search                     ;

    cmp tag, 1
    jne exit1

    push dx
    mov dx, offset input_info1
    mov ah, 9
    int 21h
    mov dx, offset buffer1
    mov ah, 0ah
    int 21h
    pop dx

    lea si, buffer1
    add si, 2
    mov di, dx
    add di, 15
    mov cx, 3
    rep movsb
    
    
exit1:
    pop ds
    ret
    
edit endp

search proc near
    xor cx, cx
    mov cl, bl
    mov di, addr
    mov bx, di
loop1:
    push cx
    mov si, offset buffer0
    add si, 2
    mov cx, 5
    repz cmpsb
    pop cx
    jne next
    jmp exit
next:
    add bx, 18
    mov di, bx
    loop loop1
    mov tag, 0

exit:
    mov dx, bx
    ;出口参数dx
    ret


search endp

    code ends
    end
```

```
public sort

code segment
sort proc far
    assume cs:code
    push ax
    push bx
    push cx
    push dx
    push si
    push di

    
    xor cx, cx
    mov cl, bl



    dec cx

loop1:
    mov di, cx
    mov bp, sp
    mov ax, [bp + 4]
loop2:
    mov bx, ax
    add bx, 18
    push ax
    call comp
    pop ax
    cmp bl, 1
    je continue
    push di
    mov si, ax
    mov di, ax
    add di, 18
    call swap
    pop di
continue:
    add ax, 18
    loop loop2
    mov cx, di
    loop loop1

    pop di
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    ret
sort endp


str2int proc near
    ;入口参数dx
    push ax
    push bx
    push si
    add dx, 15
    mov si, dx
    mov al, [si]
    cmp al, 0dh
    je zero
    sub al, 30h
    mov bl, [si + 1]
    cmp bl, 0dh
    je next
    mov ah, 10
    mul ah
    add al, bl
    sub al, 30h
    mov bl, [si + 2]

    

    cmp bl, 0dh
    je next
    mov al, 100
next:
    mov dl, al
    jmp exit
zero:
    mov dl, 0
    jmp exit
    ;mov ah, dl

    ;mov dl, ah
    ;mov ah, 02h
    ;int 21h

    ;mov ax, 4c00h
    ;int 21h

exit:
    pop si
    pop bx
    pop ax
    ;出口参数dl

    ret
str2int endp

comp proc near
    ;入口参数ax, bx
    mov dx, ax
    call str2int
    mov ah, dl
    mov dx, bx
    call str2int
    mov al, dl
    mov bl, 1
    cmp ah, al
    ja next1
    mov bl, 0
next1:
    ;出口参数bl，大于等于为1，否则为0
    ret

comp endp

swap proc near
    ;入口参数si, di
    push ax
    push cx
    mov cx, 18
swap1:
    
    
    push cx
    ;mov si, bx
    ;mov di, dx
    mov al, [si]
    xchg al, [di]
    mov [si], al
    pop cx
    inc si
    inc di
    loop swap1
    pop cx
    pop ax
    ret
swap endp



    code ends
    end
```

```
public output

disp macro x,y,length,color               ;用来显示的宏，x为横坐标偏移量，length为字符串长度，color为颜色
     mov ax,1301h
     mov bx,color
     mov cx,length
     mov dh,y
     mov dl,x
     mov bp,addr
     int 10h                            ;10号BIOS调用
     endm

data segment
    l0 db '    ID       NAME     GRADE '
    l1 db '+--------------------------+'
    l2 db '|       |            |     |'
    ll equ $-l2
    xx equ (80-ll)/2
    yy db ?
    addr dw ?
    grades dw ?
    count db ?
    
    nn db 0                             ;行号（相对l0行）
data ends

code segment
output proc far
    assume cs:code,ds:data

    push ds;保存寄存器
    push es
    mov ax, data
    mov ds, ax
    mov es, ax
    mov grades, dx
    mov count, bl

    mov ax, 3
    int 10h
    mov addr, offset l0
    disp xx, 6 ,ll, 0fh
    mov addr, offset l1
    disp xx, 7 ,ll, 0fh 
    mov addr, offset l2
    mov cx, 10
    mov yy, 8
print_frame:
    push cx
    disp xx, yy ,ll, 0fh
    pop cx
    inc yy
    loop print_frame 
    mov addr, offset l1
    disp xx, 18 ,ll, 0fh 
    jmp print_grades
scan1:
    mov ah, 1
    int 16h                             ;扫描是否键盘有输入
    jz scan1 
    mov ah, 0                           
    int 16h
    cmp ah, 80                          ;80为下键
    je down                             ;转到下键的处理代码
    cmp ah, 72                          ;72为上键
    je up                               ;转到上键的处理代码
    cmp al, 113
    je exit
    jmp scan1

down:
    mov al, nn
    add al, 10
    cmp al, count
    jae scan1
    inc nn
    jmp print_grades
up:
    mov al, nn
    cmp al, 0
    jbe scan1
    dec nn
    jmp print_grades

exit:
    pop es
    pop ds
    ret

print_grades:
    xor cx, cx
    mov cl, 10
    mov al, count
    sub al, nn
    cmp cl, al
    jb next1
    mov cl, al
next1:
    cmp cx, 0
    jbe scan1
    pop es
    mov yy, 8
    mov ax, grades
    mov addr, ax
    xor ax, ax
    mov al, nn
    mov ah, 18
    mul ah
    add addr, ax
print_cow:
    push cx
    push addr
    push es
    mov ax, ds
    mov es, ax
    mov addr, offset l2
    disp xx, yy ,ll, 0fh
    pop es
    pop addr
    disp xx+2, yy, 5, 0fh
    add addr, 5
    jmp gateway2
gateway1:
    jmp print_cow
gateway2:    
    disp xx+10, yy, 10, 0fh
    add addr, 10
    disp xx+23, yy, 3, 0fh
    add addr, 3
    inc yy
    pop cx
    dec cx
    cmp cx, 0
    ja gateway1
    push es
    jmp scan1


    
output endp
    code ends
    end
```