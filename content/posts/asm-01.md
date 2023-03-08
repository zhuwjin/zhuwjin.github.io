---
title: "用汇编(MASM)写的小程序"
date: 2022-05-26T18:18:10+08:00 
draft: false
---
### DOSBOX的使用
右键DOSBOX点击打开文件所在位置

![](http://minio.jinjiang.life/blog/1-4.png)

![](http://minio.jinjiang.life/blog/BF.jpg)

找到文件夹里的`DOSBox 0.7.4-3 Options`，双击打开或右键点打开

![](https://jinjiang-blog.oss-cn-hangzhou.aliyuncs.com/masm2.png)

然后就会出现记事本打开一个文本文件

![](https://jinjiang-blog.oss-cn-hangzhou.aliyuncs.com/masm3.png)

找到你MASM放到哪个文件夹里的

![](https://jinjiang-blog.oss-cn-hangzhou.aliyuncs.com/masm4.png)

复制这个地址，然后修改刚刚的文本文件
在最下面添加两行
```
mount x 你的MASM路径
set PATH=%PATH%;x:\;
```

![](https://jinjiang-blog.oss-cn-hangzhou.aliyuncs.com/masm5.png)

保存，然后打开DOSBOX看看效果
就可以直接使用masm命令了

![](https://jinjiang-blog.oss-cn-hangzhou.aliyuncs.com/masm6.png)

接下来把工作区弄好，打开你写汇编代码的地方，复制路径

![](https://jinjiang-blog.oss-cn-hangzhou.aliyuncs.com/masm7.png)


然后再打开刚刚的`DOSBox 0.7.4-3 Options`

添加这两行
```
mount c 你的工作路径
c:
```
保存退出

![](https://jinjiang-blog.oss-cn-hangzhou.aliyuncs.com/masm8.png)

然后打开`DOSBOX`，它就会自动转到你的工作目录里了

![](https://jinjiang-blog.oss-cn-hangzhou.aliyuncs.com/masm9.png)

如果你使用了我的代码，在`DOSBOX`里运行`build.bat`，就可以将菜单程序编译了

![](https://jinjiang-blog.oss-cn-hangzhou.aliyuncs.com/masm10.png)

![](https://jinjiang-blog.oss-cn-hangzhou.aliyuncs.com/masm11.png)

然后运行菜单程序，输入`MENU.EXE`，菜单就出来啦

![](https://jinjiang-blog.oss-cn-hangzhou.aliyuncs.com/masm12.png)
![](https://jinjiang-blog.oss-cn-hangzhou.aliyuncs.com/masm13.png)

随便输一个数据显示出来

![](https://jinjiang-blog.oss-cn-hangzhou.aliyuncs.com/masm14.png)

[代码压缩包](https://jinjiang-blog.oss-cn-hangzhou.aliyuncs.com/asm%20%282%29.zip)

### 代码
```nasm
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
    cmp nn, 1                           ;nn等于1，表示光标在第一行，则执行成绩录入功能
    jne next2
    xor ax, ax                          ;清空ax里的内容
                                        ;接下来求下一个要插入数据的地址
                                        ;       ：grade的首地址 + 已经插入的个数(count) * 数据长度(18)
    mov al, count                       ;将已经录入的成绩个数移入al
    mov ah, 18                          ;将乘数移入ah准备作乘法
    mul ah                              ;乘法指令，   ax <-- ah * al
    mov dx, offset grade                ;将grade的首地址放入dx
    add dx, ax                          ;加上ax中的内容
    mov bl, count
    inc count                           ;将个数 + 1，这行代码放在call上或下面不影响，因为input中不用count变量了，并且count只能成功
    call input                          ;调用input，input的入口参数是dx

next2:
    cmp nn, 2                           ;成绩修改
    jne next3
    mov dx, offset grade
    mov bl, count
    call edit

next3:
    cmp nn, 3                           ;成绩排序
    jne next4
    mov dx, offset grade
    mov bl, count
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
    mov ax, 3
    int 10h
    mov ax,4c00h
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
    
    buffer0 db 6                                    ;输入缓冲区，用来学生id信息，长度6是因为后面需要留一个byte的空间
        db ?
        db 6 dup (?)
    buffer1 db 11                                   ;输入缓冲区，用来学生name信息
        db ?
        db 11 dup (?)
    buffer2 db 4                                    ;输入缓冲区，用来学生grade信息
        db ?
        db 4 dup (?)
data ends

code segment

input proc far                                      ;入口参数dx：要插入的数据的内存单元的偏移地址
    assume cs:code,ds:data

    push ds                                         ;保存寄存器中的内容，也就是主程序的数据段基址，子程序返回前需还原
    mov ax, data                                    ;将子程序的数据段基址移入ds
    mov ds, ax

    mov ax, 3
    int 10h                                         ;清空界面

    push dx                                         ;因为下面要用到dx，所以现将dx保存在栈中
    mov dx, offset input_info0                      ;输出提示信息
    mov ah, 9
    int 21h

    mov dx, offset buffer0                          ;输入学生id到buffer0
    mov ah, 0ah                                     ;此调用在课本137页有详细说明
    int 21h
    pop dx                                          ;从栈中恢复dx

    lea si, buffer0                                 ;将buffer用字符串传送指令传送到主程序的grade中
    add si, 2                                       ;buffer0中前两个byte为记录详细，不需要传送
    mov di, dx                                      ;将目的地址偏移量传送到di中
    mov cx, 5                                       ;传送byte个数
    rep movsb                                       ;es:di <-- ds:si; di++, si++；课本86-87页
                                                    ;因为子程序初始化的时候没改es，所以es中的地址还是主程序数据段的地址
                                                    ;这样从ds-->es就能将子程序中的数据传送到主程序


    push dx                                         ;因为下面要用到dx，所以现将dx保存在栈中
    mov dx, offset input_info1                      ;输出提示信息
    mov ah, 9
    int 21h

    mov dx, offset buffer1                          ;输入学生姓名
    mov ah, 0ah
    int 21h
    pop dx                                          ;从栈中恢复dx

    lea si, buffer1                                 ;传送到主程序
    add si, 2
    mov di, dx
    add di, 5
    mov cx, 10
    rep movsb



    push dx
    mov dx, offset input_info2                      ;输出提示信息
    mov ah, 9
    int 21h

    mov dx, offset buffer2                          ;输入成绩
    mov ah, 0ah
    int 21h
    pop dx

    lea si, buffer2                                 ;传送
    add si, 2
    mov di, dx
    add di, 15
    mov cx, 3
    rep movsb
    
    
    
    pop ds                                          ;恢复原来的ds
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

edit proc far                       ;入口参数dx：grade的起始地址
    assume cs:code,ds:data
    push ds                         ;保存寄存器
    mov ax, data
    mov ds, ax
    mov addr, dx                    ;将起始地址保存在addr中
    mov tag, 1                      ;初始化tag为 1

    mov ax, 3                       
    int 10h                         ;清屏
    
    mov dx, offset input_info0      ;输出提示信息
    mov ah, 9
    int 21h
    mov dx, offset buffer0          ;输入学号
    mov ah, 0ah                     
    int 21h

    call search                     ;调用search，搜索输入的学号的位置，入口参数为addr，出口参数为dx，和tag
                                    
    cmp tag, 1                      ;判断search的查找结果，1表示找到了，且dx中存放这个学号的起始地址
    jne exit1                       ;没找到，直接退出

    push dx                         ;保存dx，因为接下来要修改
    mov dx, offset input_info1      ;输出提示信息
    mov ah, 9
    int 21h
    mov dx, offset buffer1          ;输入成绩
    mov ah, 0ah
    int 21h
    pop dx                          ;恢复dx

    lea si, buffer1                 ;字符串的传送操作，和input中的一样，把新成绩传送到主程序中
    add si, 2
    mov di, dx
    add di, 15
    mov cx, 3
    rep movsb
    
    
exit1:
    pop ds
    ret
    
edit endp

search proc near                    ;入口参数addr，buffer0
    xor cx, cx                      ;清空cx
    mov cl, bl                      ;将成绩个数移动到cl中，来控制循环次数
    cmp cx, 0                       ;个数为0，直接查找失败
    je fail
    mov di, addr                    ;将grade首地址移动到mov中
    mov bx, di                      ;保存一下di中的内容
loop1:
    push cx                         ;保存一下cx
    mov si, offset buffer0          ;si存源操作数偏移地址
    add si, 2                       ;前面2个记录信息，不需要比较
    mov cx, 5                       ;比较的长度
    repz cmpsb                      ;比较 ds:si ---- es:di
                                    ;这里ds是子程序的数据段的段基址，es因为没改，所以是主程序的数据段的段基址，所以可以实现
                                    ;从子程序向主程序传送数据
    pop cx                          ;恢复cx
    jne next                        ;如果两个字符串不相等，比较下一个人的成绩
    jmp exit                        ;如果相等，查找结束，bx中就是这个成绩记录的首地址
next:
    add bx, 18                      ;下一个成绩的首地址为当前的 + 18
    mov di, bx                      ;把地址也写到di中，开始下一轮循环
    loop loop1
fail:                               ;如果循环结束了都没找到，这查找失败
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
    push dx
    xor cx, cx
    mov cl, bl
    cmp cx, 0
    je exit1
    dec cx
    cmp cx, 0
    je exit1
loop1:
    mov di, cx
    mov bp, sp
    mov ax, [bp]
loop2:
    mov bx, ax
    call comp
    cmp bl, 1
    je continue

    mov si, ax
    call swap
continue:
    add ax, 18
    loop loop2
    mov cx, di
    loop loop1

exit1:
    pop dx
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

exit:
    pop si
    pop bx
    pop ax
    ;出口参数dl

    ret
str2int endp

comp proc near
    ;入口参数bx
    push ax
    mov dx, bx
    call str2int
    mov ah, dl
    mov dx, bx
    add dx, 18
    call str2int
    mov al, dl
    mov bl, 1
    cmp ah, al
    ja next1
    mov bl, 0
next1:
    pop ax
    ;出口参数bl，大于等于为1，否则为0
    ret

comp endp

swap proc near
    ;入口参数si
    push ax
    push cx
    mov cx, 18
swap1:
    push cx
    mov al, [si]
    xchg al, [si + 18]
    mov [si], al
    pop cx
    inc si
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