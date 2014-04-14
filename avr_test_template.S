    
    .section .text
    
    .global main
main:
    
    rcall       Test_Function

    ret ; Return from main
    
    .global __vector_default
__vector_default:
    reti

    .end
