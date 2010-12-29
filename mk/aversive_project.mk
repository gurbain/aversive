# Microb Technology, Eirbot, Droids-corp 2007 - Zer0
# Makefile for projects
# 
# Inspired by the WinAVR Sample makefile written by Eric
# B. Weddington, J�rg Wunsch, et al.
#
# On command line:
#
# make all = Make software.
#
# make clean = Clean out built project files.
#
# make program = Download the hex file to the device, using avrdude/avarice.  Please
#                customize the settings below first!
#
# make filename.s = Just compile filename.c into the assembler code only
#
# To rebuild project do "make clean" then "make all".
#

# default HOST is avr
ifeq ($(H),)
export HOST=avr
else
export HOST=host
endif

# absolute path to avoid some editors from beeing confused with vpath when 
# searching files
ABS_AVERSIVE_DIR:=$(shell cd $(AVERSIVE_DIR) ; pwd)
ABS_PROJECT_DIR:=$(shell pwd)

# includes for modules
MODULES_INC = $(addprefix $(ABS_AVERSIVE_DIR)/modules/,$(MODULES))

# List any extra directories to look for include files here.
#     Each directory must be seperated by a space.
EXTRAINCDIRS += . $(ABS_AVERSIVE_DIR)/include $(ABS_AVERSIVE_DIR)/modules $(MODULES_INC)
# base/utils, base/wait and base/list are deprecated dirs, we need them for compatibility
EXTRAINCDIRS += $(ABS_AVERSIVE_DIR)/modules/base/utils
EXTRAINCDIRS += $(ABS_AVERSIVE_DIR)/modules/base/wait
EXTRAINCDIRS += $(ABS_AVERSIVE_DIR)/modules/base/list


# Optional compiler flags.
#  -g:        generate debugging information
#  -O*:       optimization level
#  -f...:     tuning, see gcc manual and avr-libc documentation
#  -Wall...:  warning level
CFLAGS += -g 
CFLAGS += -O$(OPT)
CFLAGS += -Wall -Wstrict-prototypes
CFLAGS += $(patsubst %,-I%,$(EXTRAINCDIRS)) 
CFLAGS += -std=gnu99

# specific arch flags
ifeq ($(HOST),avr)
CFLAGS += -funsigned-char -funsigned-bitfields -fpack-struct -fshort-enums -mmcu=$(MCU) 
else
CFLAGS += -DHOST_VERSION
endif


ALL_CFLAGS += $(CFLAGS)
# specific arch flags
ifeq ($(HOST),avr)
# Combine all necessary flags and optional flags.
#  -Wa,...:   tell GCC to pass this to the assembler.
#    -ahlms:  create assembler listing
ALL_CFLAGS += -Wa,-adhlns=$(addprefix compiler_files/,$(<:.c=.$(HOST).lst))
else
ALL_CFLAGS +=
endif



#common asflags
ASFLAGS += 

ifeq ($(HOST),avr)
# Optional assembler flags.
#  -Wa,...:   tell GCC to pass this to the assembler.
#  -ahlms:    create listing
#  -gstabs:   have the assembler create line number information
ASFLAGS += -mmcu=$(MCU) $(patsubst %,-I%,$(EXTRAINCDIRS))
ASFLAGS += -Wa,-gstabs
ASFLAGS += -x assembler-with-cpp
else
ASFLAGS +=
endif




# Optional linker flags.
#  -Wl,...:   tell GCC to pass this to linker.
#  -Map:      create map file
#  --cref:    add cross reference to  map file
# Some variables are generated by config, see in .aversive_conf
ifeq ($(HOST),avr)
LDFLAGS += -mmcu=$(MCU) $(PRINTF_LDFLAGS)
LDFLAGS += -Wl,-Map=$(addprefix compiler_files/,$(TARGET).map),--cref
else
LDFLAGS += 
endif

LDFLAGS += $(MATH_LIB)


# AVRDUDE does not know the ATMEGA1281 for now, consider it a 128.
ifeq ($(MCU),atmega1281)
AVRDUDE_MCU = atmega128
else
AVRDUDE_MCU = $(MCU)
endif

AVRDUDE_WRITE_FLASH = -U flash:w:$(TARGET).$(FORMAT_EXTENSION)
#AVRDUDE_WRITE_EEPROM = -U eeprom:w:$(TARGET).eep

# Optional AVRDUDE flags can be added in the makefile of the project
# (to adjust the baud rate, ...)
AVRDUDE_FLAGS_OPT +=

AVRDUDE_FLAGS = -p $(AVRDUDE_MCU) -P $(AVRDUDE_PORT) -c $(AVRDUDE_PROGRAMMER) $(AVRDUDE_FLAGS_OPT)

ifneq ($(AVRDUDE_DELAY),)
AVRDUDE_FLAGS += -i $(AVRDUDE_DELAY)
endif

export AVRDUDE_FLAGS

# Uncomment the following if you want avrdude's erase cycle counter.
# Note that this counter needs to be initialized first using -Yn,
# see avrdude manual.
#AVRDUDE_ERASE += -y

# Uncomment the following if you do /not/ wish a verification to be
# performed after programming the device.
#AVRDUDE_FLAGS += -V

# Increase verbosity level.  Please use this when submitting bug
# reports about avrdude. See <http://savannah.nongnu.org/projects/avrdude> 
# to submit bug reports.
#AVRDUDE_FLAGS += -v -v


# Sets the baudrate. Comment this if you want to have the default baudrate
AVRDUDE_FLAGS += -b $(AVRDUDE_BAUDRATE)

AVARICE_WRITE_FLASH = --erase --program --file $(TARGET).$(FORMAT_EXTENSION)
#AVARICE_WRITE_EEPROM = XXX

export AVARICE_FLAGS = -P $(MCU) --jtag $(AVARICE_PORT) --$(AVARICE_PROGRAMMER)


# ---------------------------------------------------------------------------


# Define programs and commands.
ifeq ($(HOST),avr)
export CC = avr-gcc
export AS = avr-as
export AR = avr-ar
OBJCOPY = avr-objcopy
OBJDUMP = avr-objdump
SIZE = avr-size
NM = avr-nm
OUTPUT = $(TARGET).elf 
OTHER_OUTPUT = $(TARGET).$(FORMAT_EXTENSION) $(TARGET).eep compiler_files/$(TARGET).lss compiler_files/$(TARGET).sym 
else
export CC = gcc
export AS = as
export AR = ar
OBJCOPY = objcopy
OBJDUMP = objdump
SIZE = size --format=Berkeley
NM = nm
OUTPUT = $(TARGET)
endif
export HOSTCC = gcc
export REMOVE = rm -f
export COPY = cp
export SHELL = bash
DATE=`date`
MD5 = md5sum
export AVRDUDE = avrdude
export AVARICE = avarice
HEXSIZE = $(SIZE) --target=$(FORMAT) $(OUTPUT)
ELFSIZE = $(SIZE) $(OUTPUT)
ELFMD5 = $(MD5) $(OUTPUT) | cut -b1-4
export AVRDUDE_PORT
export AVRDUDE_PROGRAMMER
export MCU
export PROGRAMMER

ifndef VERBOSE
QUIET = @
endif

# ---------------------------------------------------------------------------


# Define Messages
# English
MSG_SIZE_BEFORE = Size before: 
MSG_SIZE_AFTER = Size after:
MSG_FLASH = Creating load file for Flash:
MSG_EEPROM = Creating load file for EEPROM:
MSG_EXTENDED_LISTING = Creating Extended Listing:
MSG_SYMBOL_TABLE = Creating Symbol Table:
MSG_LINKING = Linking:
MSG_COMPILING = Compiling:
MSG_PREPROC = Preprocessing:
MSG_ASSEMBLING = Assembling:
MSG_CLEANING = Cleaning project:
MSG_MD5_BEFORE = Processing MD5:
MSG_MD5_AFTER = Processing MD5:
MSG_DEPCLEAN = Cleaning deps:
MSG_MODULE = ------ Compiling Module:


# ---------------------------------------------------------------------------

OBJ = $(addprefix compiler_files/,$(SRC:.c=.$(HOST).o) $(ASRC:.S=.$(HOST).o))
DEPS = $(addprefix compiler_files/,$(SRC:.c=.$(HOST).d))
LST = $(OBJ:.o=.lst)
MODULES_LIB = $(addprefix compiler_files/,$(notdir $(MODULES:=.$(HOST).a)))
ifneq ($(P),)
PREPROC= $(addprefix compiler_files/,$(SRC:.c=.$(HOST).preproc))
else
PREPROC=
endif

# Variables n{\'e}cessaires pour les Makefile des modules
export AVERSIVE_DIR ABS_AVERSIVE_DIR
export CFLAGS EXTRAINCDIRS


# Default target.
all: compiler_files gccversion sizebefore md5sumbefore modules $(OUTPUT) $(OTHER_OUTPUT) sizeafter md5sumafter

# only compile project files
project: compiler_files gccversion sizebefore md5sumbefore $(OUTPUT) $(OTHER_OUTPUT) sizeafter md5sumafter

compiler_files:
	@mkdir -p compiler_files


# ------ Compilation/link/assemble targets

# Compile modules and create a library for each
modules: $(MODULES)


$(MODULES):
	@echo
	@echo $(MSG_MODULE) $@
	@$(MAKE) VPATH=$(ABS_AVERSIVE_DIR)/modules/$@ -f $(AVERSIVE_DIR)/modules/$@/Makefile

# Link: create ELF output file from object files.
$(OUTPUT): $(PREPROC) $(OBJ) $(MODULES_LIB)
	@echo $(MSG_LINKING) $@
	$(QUIET)$(CC) $(OBJ) $(MODULES_LIB) --output $@ $(LDFLAGS)


# Compile: create object files from C source files.
compiler_files/%.$(HOST).preproc : %.c
	@echo $(MSG_PREPROC) $<
	$(QUIET)$(CC) -E $(ALL_CFLAGS) $< -o $@

# Compile: create object files from C source files.
compiler_files/%.$(HOST).o : %.c
	@echo $(MSG_COMPILING) $<
	$(QUIET)$(CC) -c $(ALL_CFLAGS) $(ABS_PROJECT_DIR)/$< -o $@


# Compile: create assembler files from C source files.
compiler_files/%.$(HOST).s : %.c
	$(QUIET)$(CC) -S $(ALL_CFLAGS) $< -o $@


# Assemble: create object files from assembler source files.
compiler_files/%.$(HOST).o : %.S
	@echo $(MSG_ASSEMBLING) $<
	$(CC) -c $(ASFLAGS) $< -o $@



# ------ Conversion/listings targets

# Create final output files (.hex, .eep) from ELF output file.
%.$(FORMAT_EXTENSION): %.elf
	@echo $(MSG_FLASH) $@
	$(OBJCOPY) -O $(FORMAT) -R .eeprom $< $@

%.eep: %.elf
	@echo $(MSG_EEPROM) $@
	-$(OBJCOPY) -j .eeprom --set-section-flags=.eeprom="alloc,load" \
	--change-section-lma .eeprom=0 -O $(FORMAT) $< $@

# Create extended listing file from ELF output file.
compiler_files/%.lss: %.elf
	@echo $(MSG_EXTENDED_LISTING) $@
	$(OBJDUMP) -h -S $< > $@

# Create a symbol table from ELF output file.
compiler_files/%.sym: %.elf
	@echo $(MSG_SYMBOL_TABLE) $@
	$(NM) -n $< > $@


# ------ utils targets

# Display size/md5 of file.
sizebefore:
	@if [ -f $(OUTPUT) ]; then echo; echo $(MSG_SIZE_BEFORE); $(ELFSIZE); echo; fi

sizeafter:
	@if [ -f $(OUTPUT) ]; then echo; echo $(MSG_SIZE_AFTER); $(ELFSIZE); echo; fi

md5sumbefore:
	@if [ -f $(OUTPUT) ]; then echo; echo $(MSG_MD5_BEFORE); $(ELFMD5); echo; fi

md5sumafter:
	@if [ -f $(OUTPUT) ]; then echo; echo $(MSG_MD5_AFTER); $(ELFMD5); echo; fi


# Display compiler version information.
gccversion : 
	@$(CC) --version

# Program the device.  
program: $(TARGET).$(FORMAT_EXTENSION) $(TARGET).eep
	@if [ "$(PROGRAMMER)" = "avrdude" ]; then \
	  echo $(AVRDUDE) -e $(AVRDUDE_FLAGS) $(AVRDUDE_WRITE_FLASH) $(AVRDUDE_WRITE_EEPROM) ;\
	  $(AVRDUDE) -e $(AVRDUDE_FLAGS) $(AVRDUDE_WRITE_FLASH) $(AVRDUDE_WRITE_EEPROM) $(AVRDUDE_FLAGS_SIGNATURE_CHECK) ;\
	fi
	@if [ "$(PROGRAMMER)" = "avarice" ]; then \
	  echo $(AVARICE) $(AVARICE_FLAGS) $(AVARICE_WRITE_FLASH) $(AVARICE_WRITE_EEPROM) ;\
	  $(AVARICE) $(AVARICE_FLAGS) $(AVARICE_WRITE_FLASH) $(AVARICE_WRITE_EEPROM) ;\
	fi

# Program the device.  
erase: $(TARGET).$(FORMAT_EXTENSION) $(TARGET).eep
	@if [ "$(PROGRAMMER)" = "avrdude" ]; then \
	  echo $(AVRDUDE) $(AVRDUDE_FLAGS) -e ;\
	  $(AVRDUDE) $(AVRDUDE_FLAGS) -e ;\
	fi
	@if [ "$(PROGRAMMER)" = "avarice" ]; then \
	  echo "Not supported now." ; \
	fi

# reset the device.  
reset: 
	@if [ "$(PROGRAMMER)" = "avrdude" ]; then \
	  echo $(AVRDUDE) $(AVRDUDE_FLAGS) ;\
	  $(AVRDUDE) $(AVRDUDE_FLAGS) ;\
	fi
	@if [ "$(PROGRAMMER)" = "avarice" ]; then \
	  echo "Not supported now." ; \
	fi

debug: $(TARGET).$(FORMAT_EXTENSION)
	@if [ "$(PROGRAMMER)" = "avrdude" ]; then \
	  echo "Cannot debug with avrdude" ; \
	fi
	@if [ "$(PROGRAMMER)" = "avarice" ]; then \
	  echo $(AVARICE) $(AVARICE_FLAGS) :$(AVARICE_DEBUG_PORT) ;\
	  $(AVARICE) $(AVARICE_FLAGS) :$(AVARICE_DEBUG_PORT) ;\
	fi

fuse:
	@$(AVERSIVE_DIR)/config/prog_fuses.sh $(AVERSIVE_DIR)/config/fuses_defs/$(MCU)


# ------ config targets

config:
	@${SHELL} -n $(AVERSIVE_DIR)/config/config.in
	@HELP_FILE=$(AVERSIVE_DIR)/config/Configure.help \
		AUTOCONF_FILE=autoconf.h \
		${SHELL} $(AVERSIVE_DIR)/config/scripts/Configure $(AVERSIVE_DIR)/config/config.in

noconfig:
	@${SHELL} -n $(AVERSIVE_DIR)/config/config.in
	@HELP_FILE=$(AVERSIVE_DIR)/config/Configure.help \
		AUTOCONF_FILE=autoconf.h \
		${SHELL} $(AVERSIVE_DIR)/config/scripts/Configure -d $(AVERSIVE_DIR)/config/config.in

menuconfig:
	@${SHELL} -n $(AVERSIVE_DIR)/config/config.in
	@make -C $(AVERSIVE_DIR)/config/scripts/lxdialog all
	@HELP_FILE=$(AVERSIVE_DIR)/config/Configure.help \
		AUTOCONF_FILE=autoconf.h \
		${SHELL} $(AVERSIVE_DIR)/config/scripts/Menuconfig $(AVERSIVE_DIR)/config/config.in

# ------ clean targets

mrproper: clean_list
	$(REMOVE) compiler_files/*


clean: depclean clean_list modules_clean


# clean modules files
modules_clean: $(patsubst %,%_clean,$(MODULES))


$(patsubst %,%_clean,$(MODULES)):
	@$(MAKE) VPATH=$(ABS_AVERSIVE_DIR)/modules/$(@:_clean=) -f $(ABS_AVERSIVE_DIR)/modules/$(@:_clean=)/Makefile clean


clean_list :
	@echo
	@echo $(MSG_CLEANING)
	$(REMOVE) $(OUTPUT) $(OTHER_OUTPUT)
	$(REMOVE) compiler_files/$(TARGET).map
	$(REMOVE) $(OBJ)
	$(REMOVE) $(PREPROC)
	$(REMOVE) $(LST)




# ------ dependencies targets

depclean: dep_list modules_depclean


modules_depclean: $(patsubst %,%_depclean,$(MODULES))


$(patsubst %,%_depclean,$(MODULES)):
	@$(MAKE) VPATH=$(ABS_AVERSIVE_DIR)/modules/$(@:_depclean=) -f $(ABS_AVERSIVE_DIR)/modules/$(@:_depclean=)/Makefile depclean


dep_list:
	@echo
	@echo $(MSG_DEPCLEAN)
	$(REMOVE) $(DEPS)


# Automatically generate C source code dependencies. 
compiler_files/%.$(HOST).d: %.c
	@mkdir -p compiler_files ; \
	error=0; \
	for conf_file in .config autoconf.h .aversive_conf; do \
	  if [ ! -f $$conf_file ]; then \
	    echo "$$conf_file file is missing"; \
	    error=1; \
	  fi ; \
	done; \
	for module in `echo $(MODULES)`; do \
	  conf=`basename $$module"_config.h"`; \
	  if [ -f $$module/config/$$conf ]; then \
	    if [ ! -f $$conf ]; then \
	      echo "$$conf file is missing"; \
	      error=1; \
	    fi ; \
	  fi ; \
	done; \
	if [ $$error -eq 1 ]; then \
	  echo "Missing config files, please run make menuconfig or make config"; \
	  exit 1; \
	fi
	@echo Generating $@
	@set -e; rm -f $@; \
	$(CC) -M $(CFLAGS) $< > $@.$$$$; \
	sed 's,\($*\)\.o[ :]*,compiler_files/\1.$(HOST).o $@ : ,g' < $@.$$$$ > $@; \
	rm -f $@.$$$$



# include the deps file only for other targets than menuconfig or config
ifeq (,$(findstring config,$(MAKECMDGOALS)))
ifeq (,$(wildcard .config))
$(error You need to call make config or make menuconfig first)
endif
ifeq (,$(wildcard autoconf.h))
$(error Missing autoconf.h -- You need to call make noconfig)
endif
ifeq (,$(wildcard .aversive_conf))
$(error Missing .aversive_conf -- You need to call make noconfig)
endif

ifeq (,$(findstring mrproper,$(MAKECMDGOALS)))
-include $(addprefix compiler_files/,$(SRC:.c=.$(HOST).d))
endif
else
ifneq (1,$(words $(MAKECMDGOALS)))
$(error You need to call make config or make menuconfig without other targets)
endif
endif


# ------ Listing of phony targets.

.PHONY : all sizebefore sizeafter gccversion \
	clean clean_list program md5sumafter md5sumbefore \
	depclean dep_list modules $(MODULES)  \
	menuconfig config

