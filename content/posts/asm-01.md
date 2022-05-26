---
title: "用汇编(MASM)写的小程序"
date: 2022-05-26T18:18:10+08:00 
draft: false
---

```x86asm
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


