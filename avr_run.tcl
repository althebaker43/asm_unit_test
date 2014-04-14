# Load the Simulavr library
load /home/allen/lib/libsimulavr.so

# Create AVR device
set avr_device [AvrFactory_makeDevice [AvrFactory_instance] atmega328]

# Print trace output to file
#$sysConHandler SetTraceFile {avr_trace_output.txt} 1000000
#SimulationMember_trace_on_set $avr_device 1

# Set clock frequency to 1 MHz
AvrDevice_SetClockFreq $avr_device 1000

# Load executable to device
AvrDevice_Load $avr_device "test_avr_functions.o"

# Terminate on return from main()
AvrDevice_RegisterTerminationSymbol $avr_device "exit"

set system_clock [GetSystemClock]
$system_clock Add $avr_device

# Set the system clock to run forever
$system_clock Endless

# Output value from register
set output_msg [format "Register 16 value: %x" [AvrDevice_GetCoreReg $avr_device 0x10]]
puts $output_msg

exit
