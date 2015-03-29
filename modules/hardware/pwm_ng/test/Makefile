MAKE = make -s
TARGET = main

# Aversive root directory
AVERSIVE_DIR = ../../../..

SRC = $(TARGET).c


ASRC =

CFLAGS += -I./config
CFLAGS += -Wall -DHOST_AVR
CFLAGS += -g -mmcu=$(MCU) -Wall -Wstrict-prototypes -Os -mcall-prologues -Wno-deprecated-declarations -D__PROG_TYPES_COMPAT__
#CFLAGS += -Werror
#CFLAGS += -DHOMOLOGATION

# link option
LDFLAGS = -T ../common/avr6.x

########################################

-include .aversive_conf
include $(AVERSIVE_DIR)/mk/aversive_project.mk

AVRDUDE_DELAY=50

prog_flash: $(TARGET).$(FORMAT_EXTENSION) $(TARGET).eep
	$(AVRDUDE) -D -V $(AVRDUDE_FLAGS) $(AVRDUDE_WRITE_FLASH) $(AVRDUDE_WRITE_EEPROM)

prog_eeprom:

prog_fuse:
