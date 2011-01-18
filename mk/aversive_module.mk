# Microb Technology, Eirbot, Droids-corp 2005 - Zer0
# Makefile for projects
# 
# Inspired by the WinAVR Sample makefile written by Eric
# B. Weddington, J÷rg Wunsch, et al.
#

MSG_ARCHIVING = "\t[AR]\t\t"
MSG_DEPEND = "\t[DEPEND]\t"
MSG_COMPILING = "\t[CC]\t\t"
MSG_PREPROC = "\t[PREPROC]\t"

# default HOST is avr
ifeq ($(H),)
HOST=avr
else
HOST=host
endif

OBJ = $(addprefix compiler_files/,$(SRC:.c=.$(HOST).o) $(ASRC:.S=.$(HOST).o))
LST = $(OBJ:.o=.lst)
DEPS = $(addprefix compiler_files/,$(SRC:.c=.$(HOST).d))
ifneq ($(P),)
PREPROC= $(addprefix compiler_files/,$(SRC:.c=.$(HOST).preproc))
else
PREPROC=
endif

ifndef VERBOSE
QUIET = @
endif

# Default target.
all: compiler_files/$(TARGET).$(HOST).a

# Module library file
compiler_files/$(TARGET).$(HOST).a: $(PREPROC) $(OBJ)
	@echo -e $(MSG_ARCHIVING) $@
	$(QUIET)$(AR) rcs $@ $(OBJ)

# Automatically generate C source code dependencies. 
compiler_files/%.$(HOST).d : %.c
	@echo -e $(MSG_DEPEND) $<
	@set -e; rm -f $@; \
	$(CC) -M $(CFLAGS) $< > $@.$$$$; \
	sed 's,\($*\)\.o[ :]*,compiler_files/\1.$(HOST).o $@ : ,g' < $@.$$$$ > $@; \
	rm -f $@.$$$$

compiler_files/%.$(HOST).o : %.c
	@echo -e $(MSG_COMPILING) $@
	$(QUIET)$(CC) $(CFLAGS) $< -c -o $@

compiler_files/%.$(HOST).preproc : %.c
	@echo -e $(MSG_PREPROC) $@
	$(QUIET)$(CC) $(CFLAGS) $< -E -o $@

# Compile: create assembler files from C source files.
compiler_files/%.$(HOST).s : %.c
	$(CC) -S $(CFLAGS) $< -o $@

# Assemble: create object files from assembler source files.
compiler_files/%.$(HOST).o : %.S
	$(CC) -c -Wa,-adhlns=$(@:.o=.lst) $(ASFLAGS) $< -o $@


# Remove the '-' if you want to see the dependency files generated.
ifeq (,$(findstring clean,$(MAKECMDGOALS)))
-include $(DEPS)
endif

# Clean all objects 
clean:
	$(REMOVE) compiler_files/$(TARGET).$(HOST).a
	$(REMOVE) $(OBJ) 
	$(REMOVE) $(LST)
	$(REMOVE) $(PREPROC)

depclean:
	$(REMOVE) $(DEPS)

# Listing of phony targets.
.PHONY : all clean deps
