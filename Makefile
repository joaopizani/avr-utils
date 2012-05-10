
#########  AVR Project Makefile Template   #########
######                                        ######
######    Copyright (C) 2003-2005,Pat Deegan, ######
######            Psychogenic Inc             ######
######          All Rights Reserved           ######
######                                        ######
###### You are free to use this code as part  ######
###### of your own applications provided      ######
###### you keep this copyright notice intact  ######
###### and acknowledge its authorship with    ######
###### the words:                             ######
######                                        ######
###### "Contains software by Pat Deegan of    ######
###### Psychogenic Inc (www.psychogenic.com)" ######
######                                        ######
###### If you use it as part of a web site    ######
###### please include a link to our site,     ######
###### http://electrons.psychogenic.com  or   ######
###### http://www.psychogenic.com             ######
######                                        ######
####################################################


## With some modifications to suit Arduino's
## oddities related to bootloader and programmer
##
## These modifications were done by
##
## João Paulo Pizani Flor
## joaopizani@gmail.com
## http://joaopizani.hopto.org



#####         Target Specific Details          #####
#####     Customize these for your project     #####

# Name of target controller 
# (e.g. 'at90s8515', see the available avr-gcc mmcu 
# options for possible values)
MCU=atmega168p

# id to use with programmer
# default: PROGRAMMER_MCU=$(MCU)
PROGRAMMER_MCU=atmega168

# Name of our project
# (use a single word, e.g. 'myproject')
PROJECTNAME=avr-utils

# Source files
# List C/C++/Assembly source files:
PRJSRC=src/timers-atmega168.c \
	   src/timers-atmega168p.c

# Header files
# List all headers of the project. They will be installed in the case of a lib.
PRJHEADERS=src/timers-atmega168.h \
		   src/timers-atmega168p.h \


include paths.def

# additional includes (e.g. -I/path/to/mydir)
INC=${EXT_INCFLAGS}

# libraries to link in (e.g. -lmylib)
LIBS=${EXT_LIBFLAGS}

# additional macro definition flags
DEFS=-DF_CPU=16000000UL

# Optimization level, 
# use s (size opt), 1, 2, 3 or 0 (off)
OPTLEVEL=1


#####      AVR Dude 'writeflash' options       #####
#####  If you are using the avrdude program
#####  (http://www.bsdhome.com/avrdude/) to write
#####  to the MCU, you can set the following config
#####  options and use 'make writeflash' to program
#####  the device.
AVRDUDE_PROGRAMMERID=arduino

# port--serial or parallel port to which your 
# hardware programmer is attached
#
AVRDUDE_PORT=/dev/ttyUSB0

# Necessary for arduino to set this up as 19200
AVRDUDE_BAUD=-b 19200





####################################################
#####                Config Done               #####
#####                                          #####
##### You shouldn't need to edit anything      #####
##### below to use the makefile but may wish   #####
##### to override a few of the flags           #####
##### nonetheless                              #####
#####                                          #####
####################################################


##### Flags ####

# HEXFORMAT -- format for .hex file output
HEXFORMAT=ihex

# compiler
CFLAGS=-I. $(INC) -g -mmcu=$(MCU) -O$(OPTLEVEL) \
	-fpack-struct -fshort-enums             \
	-funsigned-bitfields -funsigned-char    \
	-Wall -Wstrict-prototypes               \
    $(DEFS)                                 \
	-Wa,-ahlms=$(firstword                  \
	$(filter %.lst, $(<:.c=.lst)))

# c++ specific flags
CPPFLAGS=-fno-exceptions               \
	-Wa,-ahlms=$(firstword         \
	$(filter %.lst, $(<:.cpp=.lst))\
	$(filter %.lst, $(<:.cc=.lst)) \
	$(filter %.lst, $(<:.C=.lst)))

# assembler
ASMFLAGS =-I. $(INC) -mmcu=$(MCU)        \
	-x assembler-with-cpp            \
	-Wa,-gstabs,-ahlms=$(firstword   \
		$(<:.S=.lst) $(<.s=.lst))

# linker
LDFLAGS=-Wl,-Map,$(TRG).map -mmcu=$(MCU) \
	-lm $(LIBS)

# static library archiver (ar) flags
ARFLAGS=cqs



##### executables ####
CC=avr-gcc
AR=avr-ar
OBJCOPY=avr-objcopy
OBJDUMP=avr-objdump
SIZE=avr-size
AVRDUDE=avrdude
REMOVE=rm -f

##### automatic target names ####
EXETRG=$(PROJECTNAME).out
LIBTRG=lib$(PROJECTNAME).a
ifdef LIBRARY
	TRG=$(LIBTRG)
else
	TRG=$(EXETRG)
endif

DUMPTRG=$(PROJECTNAME).s
HEXROMTRG=$(PROJECTNAME).hex 
HEXTRG=$(HEXROMTRG) $(PROJECTNAME).ee.hex
GDBINITFILE=gdbinit-$(PROJECTNAME)

INSTALL_PREFIX=$(PREFIX)


# Define all object files.

# Start by splitting source files by type
#  C++
CPPFILES=$(filter %.cpp, $(PRJSRC))
CCFILES=$(filter %.cc, $(PRJSRC))
BIGCFILES=$(filter %.C, $(PRJSRC))
#  C
CFILES=$(filter %.c, $(PRJSRC))
#  Assembly
ASMFILES=$(filter %.S, $(PRJSRC))


# List all object files we need to create
OBJDEPS=$(CFILES:.c=.o)    \
	$(CPPFILES:.cpp=.o)\
	$(BIGCFILES:.C=.o) \
	$(CCFILES:.cc=.o)  \
	$(ASMFILES:.S=.o)

# Define all lst files.
LST=$(filter %.lst, $(OBJDEPS:.o=.lst))

# All the possible generated assembly 
# files (.s files)
GENASMFILES=$(filter %.s, $(OBJDEPS:.o=.s)) 


.SUFFIXES : .c .cc .cpp .C .o .out .s .S \
	.hex .ee.hex .h .hh .hpp


.PHONY: writeflash install clean stats gdbinit


# Make targets:
# all, disasm, stats, hex, writeflash, install, clean
all: $(TRG)

disasm: $(DUMPTRG) stats

stats: $(TRG)
	$(OBJDUMP) -h $(TRG)
	$(SIZE) $(TRG)

hex: $(HEXTRG)

writeflash: hex
	$(AVRDUDE) -c $(AVRDUDE_PROGRAMMERID)   \
	 -p $(PROGRAMMER_MCU) -P $(AVRDUDE_PORT) -e        \
	 $(AVRDUDE_BAUD) -U flash:w:$(HEXROMTRG)

install: $(LIBTRG)
	install -d $(INSTALL_PREFIX)/lib
	install $(LIBTRG) $(INSTALL_PREFIX)/lib
	install -d $(INSTALL_PREFIX)/include
	install $(PRJHEADERS) $(INSTALL_PREFIX)/include


# How to generate the targets
$(DUMPTRG): $(TRG)
	$(OBJDUMP) -S  $< > $@


$(EXETRG): $(OBJDEPS)
	$(CC) $(LDFLAGS) -o $(TRG) $(OBJDEPS)

$(LIBTRG): $(OBJDEPS)
	$(REMOVE) $@
	$(AR) $(ARFLAGS) $@ $(OBJDEPS)



#### Generating assembly ####
# asm from C
%.s: %.c
	$(CC) -S $(CFLAGS) $< -o $@

# asm from (hand coded) asm
%.s: %.S
	$(CC) -S $(ASMFLAGS) $< > $@


# asm from C++
.cpp.s .cc.s .C.s :
	$(CC) -S $(CFLAGS) $(CPPFLAGS) $< -o $@


#### Generating object files ####
# object from C
.c.o: 
	$(CC) $(CFLAGS) -c $< -o $@


# object from C++ (.cc, .cpp, .C files)
.cc.o .cpp.o .C.o :
	$(CC) $(CFLAGS) $(CPPFLAGS) -c $< -o $@

# object from asm
.S.o :
	$(CC) $(ASMFLAGS) -c $< -o $@


#### Generating hex files ####
# hex files from elf
.out.hex:
	$(OBJCOPY) -j .text                    \
		-j .data                       \
		-O $(HEXFORMAT) $< $@

.out.ee.hex:
	$(OBJCOPY) -j .eeprom                  \
		--change-section-lma .eeprom=0 \
		-O $(HEXFORMAT) $< $@




#####  Generating a gdb initialisation file    #####
##### Use by launching simulavr and avr-gdb:   #####
#####   avr-gdb -x gdbinit-myproject           #####
gdbinit: $(GDBINITFILE)

$(GDBINITFILE): $(TRG)
	@echo "file $(TRG)" > $(GDBINITFILE)
	
	@echo "target remote localhost:1212" \
		                >> $(GDBINITFILE)
	
	@echo "load"        >> $(GDBINITFILE) 
	@echo "break main"  >> $(GDBINITFILE)
	@echo "continue"    >> $(GDBINITFILE)
	@echo
	@echo "Use 'avr-gdb -x $(GDBINITFILE)'"



#### Cleanup ####
clean:
	$(REMOVE) $(LIBTRG) $(LIBTRG).map
	$(REMOVE) $(EXETRG) $(EXETRG).map $(DUMPTRG)
	$(REMOVE) $(OBJDEPS)
	$(REMOVE) $(LST) $(GDBINITFILE)
	$(REMOVE) $(GENASMFILES)
	$(REMOVE) $(HEXTRG)
	$(REMOVE) *~
	


#####                    EOF                   #####
