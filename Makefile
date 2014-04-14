# avr_functions library Makefile

LIB =		avr_functions
TEST =		test_$(LIB)

TESTS =		Function_1 \
		Function_2

TEST_SOURCES :=	$(TESTS:%=test_%.S)
TEST_ELFS :=	$(TESTS:%=test_%.elf)
TEST_LSTS :=	$(TESTS:%=test_%.lst)

SIM_TARGET =	atmega328

CC =		avr-gcc
AR =		avr-ar
OBJCOPY =	avr-objcopy
OBJDUMP =	avr-objdump
FIG2DEV =	fig2dev

TCL =		tclsh8.5

override CFLAGS =	-Wall $(OPTIMIZE) $(DEFS) -mmcu=$(SIM_TARGET)
override LDFLAGS =	-Wl,-Map
override ASFLAGS =	-Wa,-mno-wrap,--gstabs

RESIDUE =	*.o \
		*.a \
		*.eps \
		*.png \
		*.pdf \
		*.bak \
		*.lst \
		*.map \
		*.hex \
		*.bin \
		*.srec \
		*.elf \
		$(TEST_SOURCES)

# Default target
.PHONY : all
all : $(LIB).o $(LIB).lst

.PHONY : test
test : $(TEST_ELFS)
	$(TCL) asm_unit_test.tcl

.PHONY : clean
clean :
	rm -rf $(RESIDUE)

%.elf : $(LIB).o %.S
	$(CC) $(CFLAGS) $(ASFLAGS) -o $@ $^

%.o : %.S
	$(CC) $(CFLAGS) $(ASFLAGS) -c -o $@ $^

%.lst : %.o
	$(OBJDUMP) -h -S $< > $@

# Need to mark as SECONDARY to prevent auto removal
.SECONDARY : $(TEST_SOURCES)
test_%.S : avr_test_template.S
	sed -e 's/Test_Function/$*/' avr_test_template.S > test_$*.S
