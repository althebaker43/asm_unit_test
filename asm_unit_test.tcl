package require tcltest

eval ::tcltest::configure $argv

# Load the Simulavr library
load /home/allen/lib/libsimulavr.so

# Test list and counter
set functions [list \
    Function_1 \
    Function_2 \
]
set function_idx 0

# Maximum simulation time
set MAX_RUNTIME 1000000

# Create AVR device
set avr_device [AvrFactory_makeDevice [AvrFactory_instance] atmega328]

# Set clock frequency to 1 MHz
AvrDevice_SetClockFreq $avr_device 1000

# Initialize simulation clock
set system_clock [GetSystemClock]

# Common setup script for all tests
set avr_setup {
    global avr_device
    global functions

    # Get name of current test
    set current_function [lindex $functions $function_idx]
    set current_test test_$current_function

    # Load test executable to device
    AvrDevice_Load $avr_device $current_test.elf

    # Terminate on return from main()
    AvrDevice_RegisterTerminationSymbol $avr_device "exit"

    # Add our device to the simulation
    $system_clock Add $avr_device
}

# Common cleanup script for all tests
set avr_cleanup {
    global system_clock
    global avr_device

    # Increment test index
    set function_idx [expr {$function_idx + 1}]

    # Reset the simulation
    $system_clock ResetClock

    # Reset the device
    AvrDevice_Reset $avr_device
}

::tcltest::test Function_1 {
    load constant value
} -setup $avr_setup -body {
    global avr_device
    global system_clock

    # Initialize output register
    AvrDevice_SetCoreReg $avr_device 0x10 0x00

    # Start the simulation with no maximum time
    $system_clock Run $MAX_RUNTIME

    # Return hex-formatted value in R16
    set avr_output [format "0x%x" [AvrDevice_GetCoreReg $avr_device 0x10]]
    return $avr_output

} -result {0x55} -cleanup $avr_cleanup

::tcltest::test Function_2 {
    sum of two variables
} -setup $avr_setup -body {
    global avr_device
    global system_clock

    # Initialize input and output registers
    AvrDevice_SetCoreReg $avr_device 0x0E 0x02
    AvrDevice_SetCoreReg $avr_device 0x0F 0x03
    AvrDevice_SetCoreReg $avr_device 0x10 0x00

    # Start the simulation with no maximum time
    $system_clock Run $MAX_RUNTIME

    # Return hex-formatted value in R16
    set avr_output [format "0x%x" [AvrDevice_GetCoreReg $avr_device 0x10]]
    return $avr_output

} -result {0x05} -cleanup $avr_cleanup
