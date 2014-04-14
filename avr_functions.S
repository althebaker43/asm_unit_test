; avr_functions.S
;
;  Created: 4/12/2014
;   Author: Allen Baker

#include <avr/io.h>

; BEGIN CONSTANTS

; END CONSTANTS

    .section .data
; BEGIN GLOBALS

; END GLOBALS

; BEGIN STATIC

; END STATIC

    .section .text
; BEGIN PROGRAM CONSTANTS

; END PROGRAM CONSTANTS

; BEGIN PUBLIC FUNCTIONS

; Name: Function_1
; Descr: This function simply loads a constant value (0x55) into a register
;   (R16)
; Inputs: none
; Outputs:
;   R16: constant value (0x55)
    .align 2
    .global Function_1
Function_1:

    ldi     R16,0x55

    ret ; Return from Function_1


; Name: Function_2
; Descr: This function adds two variables
; Inputs:
;   R14: First operand
;   R15: Second operand
; Outputs:
;   R16: Sum of operands
    .align 2
    .global Function_2
Function_2:

    mov     R16,R14
    add     R16,R15

    ret ; Return from Function_2

; END GLOBAL FUNCTIONS

; BEGIN PRIVATE FUNCTIONS

; END PRIVATE FUNCTIONS
    .end
