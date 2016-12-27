
; A program to draw a circle using modified dda algorithm
; Mohanad S. Hamed

;***********************Utility Macros*************************
; Assign variable b to a
Assign macro a, b
    mov ax, [b]
    mov [a], ax    
endm

;a = -a 
Negate macro a
    mov ax, [a]
    neg ax
    mov [a], ax    
endm

;a = a+1 
IncVar macro a
    mov ax, [a]
    inc ax
    mov [a], ax    
endm

;a = a-1 
DecVar macro a
    mov ax, [a]
    dec ax
    mov [a], ax    
endm

Compare2Variables macro a, b
    mov cx, [a]
    cmp cx, [b]
endm

CompareVariableAndNumber macro a, b
    mov cx, [a]
    cmp cx, b
endm

;c = a+b
AddAndAssign macro c, a, b
    mov ax, [a]
    add ax, [b]
    mov [c], ax
endm 

;c = a-b
SubAndAssign macro c, a, b
    mov ax, [a]
    sub ax, [b]
    mov [c], ax
endm

;d = a+b+c
Add3NumbersAndAssign macro d, a, b, c
    mov ax, [a]
    add ax, [b]
    add ax, [c]
    mov [d], ax
endm 

;d = a-b-c
Sub3NumbersAndAssign macro d, a, b, c
    mov ax, [a]
    sub ax, [b]
    sub ax, [c]
    mov [d], ax
endm

DrawPixel macro x, y
    
    mov cx, [x]  ; column  
    mov dx, [y]  ; row  
     
    mov al, 10  ; green
    mov ah, 0ch ; put pixel
    int 10h     
endm
;***********************End Utility Macros*************************


;***********************Draw Circle Macro*************************
DrawCircle macro circleCenterX, circleCenterY, radius
    ;C# Code
;         int balance;
;         int xoff;
;         int yoff;
    balance dw 0
    xoff dw 0
    yoff dw 0 
    
    xplusx dw 0
    xminusx dw 0
    yplusy dw 0
    yminusy dw 0
    
    xplusy dw 0
    xminusy dw 0
    yplusx dw 0
    yminusx dw 0
    
    
    ;C# Code
    ;         xoff = 0;
    ;         yoff = radius;
    ;         balance = -radius;
    
    Assign yoff, radius
    
    Assign balance, radius
    Negate balance
    
    
    ;C# Code
    ;         while (xoff <= yoff)
    ;         {
    draw_circle_loop:
     
     AddAndAssign xplusx, circleCenterX, xoff
     SubAndAssign xminusx, circleCenterX, xoff
     AddAndAssign yplusy, circleCenterY, yoff
     SubAndAssign yminusy, circleCenterY, yoff
     
     AddAndAssign xplusy, circleCenterX, yoff
     SubAndAssign xminusy, circleCenterX, yoff
     AddAndAssign yplusx, circleCenterY, xoff
     SubAndAssign yminusx, circleCenterY, xoff
     
    ;C# Code
    ;        DrawPixel(circleCenterX + yoff, circleCenterY - xoff);
    ; part 1 from angle 0 to 45 counterclockwise
    DrawPixel xplusy, yminusx
    
    ;C# Code
    ;       DrawPixel(circleCenterX + xoff, circleCenterY - yoff);
    ; part 2 from angle 90 to 45 clockwise
    DrawPixel xplusx, yminusy
    
    ;C# Code
    ;       DrawPixel(circleCenterX - xoff, circleCenterY - yoff); 
    ; part 3 from angle 90 to 135 counterclockwise
    DrawPixel xminusx, yminusy
    
    ;C# Code
    ;        DrawPixel(circleCenterX - yoff, circleCenterY - xoff); 
    ; part 4 from angle 180 to 135 clockwise
    DrawPixel xminusy, yminusx
    
    ;C# Code
    ;       DrawPixel(circleCenterX - yoff, circleCenterY + xoff); 
    ; part 5 from angle 180 to 225 counterclockwise
    DrawPixel xminusy, yplusx
    
        ;C# Code
    ;       DrawPixel(circleCenterX - xoff, circleCenterY + yoff); 
    ; part 6 from angle 270 to 225 clockwise
    DrawPixel xminusx, yplusy
        
    ;C# Code
    ;       DrawPixel(circleCenterX + xoff, circleCenterY + yoff); 
    ; part 7 from angle 270 to 315 counterclockwise
    DrawPixel xplusx, yplusy
    
    
    ;C# Code
    ;       DrawPixel(circleCenterX + yoff, circleCenterY + xoff); 
    ; part 8 from angle 360 to 315 clockwise
    DrawPixel xplusy, yplusx

    
    ;C# Code
    ;        balance = balance + xoff + xoff;
    Add3NumbersAndAssign balance, balance, xoff, xoff
    
    ;C# Code
    ;            if (balance >= 0)
    ;            {
    ; 
    ;               yoff = yoff - 1;
    ;               balance = balance - yoff - yoff;
    ;               
    ;            }
    ; 
    ;            xoff = xoff + 1;
    CompareVariableAndNumber balance, 0
    jl balance_negative
    ;balance_positive:
    DecVar yoff
    
    Sub3NumbersAndAssign balance, balance, yoff, yoff
    
    balance_negative:
    IncVar xoff
    
    ;C# Code
    ;         while (xoff <= yoff)
    Compare2Variables xoff, yoff
    jg end_drawing
    jmp draw_circle_loop
    
    
    end_drawing:
    ; pause the screen for dos compatibility:    
endm
;***********************End Draw Circle Macro*************************




;***********************Main*************************
org  100h

mov ah, 0   ; set display mode function.
mov al, 13h ; mode 13h = 320x200 pixels, 256 colors.
int 10h     ; set it!


;C# Code
;         int circleCenterX = 40;
;         int circleCenterY = 40;
;         int radius = 20;
         
x dw 80 ; center x
y dw 80 ; center y
r dw 20 ; radius

DrawCircle x, y, r

;wait for keypress
  mov ah,00
  int 16h			

; return to text mode:
  mov ah,00 ; set display mode function.
  mov al,03 ; normal text mode 3
  int 10h   ; set it!


ret 

;***********************End Main*************************