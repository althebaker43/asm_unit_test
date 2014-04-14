source asm_unit_test.tcl

proc Test_Function_1 {

    global R16

    set R16 0

    Test_Function Function_1

    Assert_Equal R16 0x55
}
