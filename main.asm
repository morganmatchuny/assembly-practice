/*  
;******************************  
;* Morgan Matchuny
;* 8-bit positive int. division
;******************************    

			 .dseg   
			 .org 0x100							;originate data storage at address 0x100  
quotient:	 .byte 1							;uninitialized quotient variable stored in SRAM aka data segment  
remainder:   .byte 1							;uninitialized remainder variable stored in SRAM    
			 .set count = 0						;initialized count variable stored in SRAM  
												;******************************    
			 .cseg								; Declare and Initialize Constants (modify them for different results)    
			 .equ dividend = 13					;8-bit dividend constant (positive integer) stored in FLASH memory aka code segment    
			 .equ divisor = 3					;8-bit divisor constant (positive integer) stored in FLASH memory  

;******************************  
;* Vector Table (partial)  
;******************************  
 
			 .org  0x0 
reset:		 jmp   main							;RESET Vector at address 0x0 in FLASH memory (handled by MAIN) 
int0v:		 jmp   int0							;External interrupt vector at address 0x2 in Flash memory (handled by int0)  
;******************************  
;* MAIN entry point to program*  
;******************************    
			 .org  0x100						;originate MAIN at address 0x100 in FLASH memory (step through the code)  
main:		 call  init							;initialize variables subroutine, set break point here, check the STACK,SP,PC   
			 call  getnums						;Check the STACK,SP,PC here.   
			 call  test							;Check the STACK,SP,PC here.   
			 call  divide						;Check the STACK,SP,PC here. 
endmain:	 jmp   endmain
init:		 lds   r0,count						;get initial count, set break point here and check the STACK,SP,PC   
			 sts   quotient,r0					;use the same r0 value to clear the quotient-   
			 sts   remainder,r0					;and the remainder storage locations 
			 ret								;return from subroutine, check the STACK,SP,PC 
getnums: 
			 ldi   r30,dividend					;Check the STACK,SP,PC here.   
			 ldi   r31,divisor
			 ret								;Check the STACK,SP,PC here. 
test:		 cpi   r30,0						; is dividend == 0 ?   
			 brne  test2
test1:		 jmp   test1						; halt program, output = 0 quotient and 0 remainder 
test2:		 cpi   r31,0						; is divisor == 0 ?   
		     brne  test4
			 ldi   r30,0xEE						; set output to all EE's = Error division by 0   
			 sts   quotient,r30
			 sts   remainder,r30
test3:		 jmp   test3						; halt program, look at output 
test4:		 cp    r30,r31						; is dividend == divisor ?   
			 brne  test6
			 ldi   r30,1						;then set output accordingly   
			 sts   quotient,r30
 test5:		 jmp   test5						; halt program, look at output 
 test6:		 brpl  test8						; is dividend < divisor ?   
			 ser   r30         
			 sts   quotient,r30
			 sts   remainder,r30				; set output to all FF's = not solving Fractions in this program 
test7:		 jmp   test7						; halt program look at output 
test8:		 ret								;otherwise, return to do positive integer division 
divide:		 lds   r0,count						;student comment goes here 
divide1:	 inc   r0							;increment reg0  
		     sub    r30,r31						;subtracting r31 from r30  
		     brpl   divide1						;branch if positive- divide the result  
		     dec    r0							;decrement r0
		     add    r30,r31						;add r31 to r30   
		     sts    quotient,r0					;use r0 as quotient   
		     sts    remainder,r30				;give remainder using r30 
divide2:	 ret								;return
extint0:     jmp    extint0						;interrupt 0 handler goes here 
   .exit