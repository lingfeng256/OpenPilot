#
# Copyright (c) 2009-2013, The OpenPilot Team, http://www.openpilot.org
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
# or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License
# for more details.
#
# You should have received a copy of the GNU General Public License along
# with this program; if not, write to the Free Software Foundation, Inc.,
# 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
#

ifndef OPENPILOT_IS_COOL
    $(error Top level Makefile must be used to build this target)
endif

# Set developer code and compile options.
# Set to YES to compile for debugging
DEBUG ?= NO

# Set to YES to use the Servo output pins for debugging via scope or logic analyser
ENABLE_DEBUG_PINS ?= NO

# Set to YES to enable the AUX UART which is mapped on the S1 (Tx) and S2 (Rx) servo outputs
ENABLE_AUX_UART ?= NO

# Paths
TOPDIR		= .
OPSYSTEM	= $(TOPDIR)
OPSYSTEMINC	= $(OPSYSTEM)/inc
PIOSINC		= $(PIOS)/inc
PIOSCOMMON	= $(PIOS)/Common
PIOSBOARDS	= $(PIOS)/Boards
FLIGHTLIBINC	= $(FLIGHTLIB)/inc
STMSPDSRCDIR	= $(STMSPDDIR)/src
STMSPDINCDIR	= $(STMSPDDIR)/inc

ifeq ($(MCU),cortex-m3)
    PIOSSTM32F10X = $(PIOS)/STM32F10x
    APPLIBDIR     = $(PIOSSTM32F10X)/Libraries
    STMLIBDIR     = $(APPLIBDIR)
    STMSPDDIR     = $(STMLIBDIR)/STM32F10x_StdPeriph_Driver
    STMUSBDIR     = $(STMLIBDIR)/STM32_USB-FS-Device_Driver
    STMUSBSRCDIR  = $(STMUSBDIR)/src
    STMUSBINCDIR  = $(STMUSBDIR)/inc
    CMSISDIR      = $(STMLIBDIR)/CMSIS/Core/CM3
    DOSFSDIR      = $(APPLIBDIR)/dosfs
    MSDDIR        = $(APPLIBDIR)/msd
    RTOSDIR       = $(APPLIBDIR)/FreeRTOS
    RTOSSRCDIR    = $(RTOSDIR)/Source
    RTOSINCDIR    = $(RTOSSRCDIR)/include
else ifeq ($(MCU),cortex-m4)
    PIOSSTM32F4XX = $(PIOS)/STM32F4xx
    APPLIBDIR     = $(PIOSSTM32F4XX)/Libraries
    STMLIBDIR     = $(APPLIBDIR)
    STMSPDDIR     = $(STMLIBDIR)/STM32F4xx_StdPeriph_Driver
    PIOSCOMMONLIB = $(PIOSCOMMON)/Libraries
else
    $(error Unsupported MCU: $(MCU))
endif

# List C source files here (C dependencies are automatically generated).
# Use file-extension c for "c-only"-files

## Bootloader Core
SRC += $(OPSYSTEM)/main.c
SRC += $(OPSYSTEM)/pios_board.c
SRC += $(OPSYSTEM)/pios_usb_board_data.c
SRC += $(OPSYSTEM)/op_dfu.c

## PIOS Hardware
ifeq ($(MCU),cortex-m3)
    ## PIOS Hardware (STM32F10x)
    SRC += $(PIOSSTM32F10X)/pios_sys.c
    SRC += $(PIOSSTM32F10X)/pios_led.c
    SRC += $(PIOSSTM32F10X)/pios_delay.c
    SRC += $(PIOSSTM32F10X)/pios_usart.c
    SRC += $(PIOSSTM32F10X)/pios_irq.c
    SRC += $(PIOSSTM32F10X)/pios_debug.c
    SRC += $(PIOSSTM32F10X)/pios_gpio.c
    SRC += $(PIOSSTM32F10X)/pios_iap.c
    SRC += $(PIOSSTM32F10X)/pios_bl_helper.c
    SRC += $(PIOSSTM32F10X)/pios_usb.c
    SRC += $(PIOSSTM32F10X)/pios_usbhook.c
    SRC += $(PIOSSTM32F10X)/pios_usb_hid.c
    SRC += $(PIOSSTM32F10X)/pios_usb_hid_istr.c
    SRC += $(PIOSSTM32F10X)/pios_usb_hid_pwr.c

    ## Libraries for flight calculations
    SRC += $(FLIGHTLIB)/fifo_buffer.c

    ## CMSIS for STM32
    SRC += $(CMSISDIR)/core_cm3.c
    SRC += $(CMSISDIR)/system_stm32f10x.c

    ## Used parts of the STM-Library
    SRC += $(STMSPDSRCDIR)/stm32f10x_bkp.c
    SRC += $(STMSPDSRCDIR)/stm32f10x_crc.c
    SRC += $(STMSPDSRCDIR)/stm32f10x_dma.c
    SRC += $(STMSPDSRCDIR)/stm32f10x_exti.c
    SRC += $(STMSPDSRCDIR)/stm32f10x_flash.c
    SRC += $(STMSPDSRCDIR)/stm32f10x_gpio.c
    SRC += $(STMSPDSRCDIR)/stm32f10x_pwr.c
    SRC += $(STMSPDSRCDIR)/stm32f10x_rcc.c
    SRC += $(STMSPDSRCDIR)/stm32f10x_rtc.c
    SRC += $(STMSPDSRCDIR)/stm32f10x_spi.c
    SRC += $(STMSPDSRCDIR)/stm32f10x_usart.c
    SRC += $(STMSPDSRCDIR)/stm32f10x_dbgmcu.c
    SRC += $(STMSPDSRCDIR)/misc.c

    ## STM32 USB Library
    SRC += $(STMUSBSRCDIR)/usb_core.c
    SRC += $(STMUSBSRCDIR)/usb_init.c
    SRC += $(STMUSBSRCDIR)/usb_int.c
    SRC += $(STMUSBSRCDIR)/usb_mem.c
    SRC += $(STMUSBSRCDIR)/usb_regs.c
    SRC += $(STMUSBSRCDIR)/usb_sil.c
else ifeq ($(MCU),cortex-m4)
    ## PIOS Hardware (STM32F4xx)
    include $(PIOS)/STM32F4xx/library.mk
endif

## PIOS Hardware (Common)
SRC += $(PIOSCOMMON)/pios_board_info.c
SRC += $(PIOSCOMMON)/pios_com_msg.c
SRC += $(PIOSCOMMON)/printf-stdarg.c
SRC += $(PIOSCOMMON)/pios_usb_desc_hid_only.c
SRC += $(PIOSCOMMON)/pios_usb_util.c

# List C source files here which must be compiled in ARM-Mode (no -mthumb).
# Use file-extension c for "c-only"-files
SRCARM =

# List C++ source files here.
# Use file-extension .cpp for C++-files (not .C)
CPPSRC =

# List C++ source files here which must be compiled in ARM-Mode.
# Use file-extension .cpp for C++-files (not .C)
CPPSRCARM =

# List Assembler source files here.
# Make them always end in a capital .S. Files ending in a lowercase .s
# will not be considered source files but generated files (assembler
# output from the compiler), and will be deleted upon "make clean"!
# Even though the DOS/Win* filesystem matches both .s and .S the same,
# it will preserve the spelling of the filenames, and gcc itself does
# care about how the name is spelled on its command-line.
ifeq ($(MCU),cortex-m3)
    ASRC = $(PIOSSTM32F10X)/startup_stm32f10x_$(MODEL)$(MODEL_SUFFIX).S
else
    ASRC =
endif

# List Assembler source files here which must be assembled in ARM-Mode.
ASRCARM =

# List any extra directories to look for include files here.
#    Each directory must be seperated by a space.
EXTRAINCDIRS += $(PIOS)
EXTRAINCDIRS += $(PIOSINC)
EXTRAINCDIRS += $(FLIGHTLIBINC)
EXTRAINCDIRS += $(PIOSCOMMON)
EXTRAINCDIRS += $(PIOSBOARDS)
EXTRAINCDIRS += $(STMSPDINCDIR)
EXTRAINCDIRS += $(CMSISDIR)
EXTRAINCDIRS += $(HWDEFSINC)
EXTRAINCDIRS += $(OPSYSTEMINC)

ifeq ($(MCU),cortex-m3)
    EXTRAINCDIRS += $(PIOSSTM32F10X)
    EXTRAINCDIRS += $(OPUAVTALK)
    EXTRAINCDIRS += $(OPUAVTALKINC)
    EXTRAINCDIRS += $(OPUAVOBJ)
    EXTRAINCDIRS += $(OPUAVOBJINC)
    EXTRAINCDIRS += $(DOSFSDIR)
    EXTRAINCDIRS += $(MSDDIR)
    EXTRAINCDIRS += $(RTOSINCDIR)
    EXTRAINCDIRS += $(STMUSBINCDIR)
    EXTRAINCDIRS += $(APPLIBDIR)
    EXTRAINCDIRS += $(RTOSSRCDIR)/portable/GCC/ARM_CM3
else ifeq ($(MCU),cortex-m4)
    EXTRAINCDIRS += $(PIOSSTM34FXX)
endif

# List any extra directories to look for library files here.
# Also add directories where the linker should search for
# includes from linker-script to the list
#     Each directory must be seperated by a space.
EXTRA_LIBDIRS =

# Extra Libraries
#    Each library-name must be seperated by a space.
#    i.e. to link with libxyz.a, libabc.a and libefsl.a:
#    EXTRA_LIBS = xyz abc efsl
# for newlib-lpc (file: libnewlibc-lpc.a):
#    EXTRA_LIBS = newlib-lpc
EXTRA_LIBS =

# Path to linker scripts
ifeq ($(MCU),cortex-m3)
    LINKERSCRIPTPATH = $(PIOSSTM32F10X)
else ifeq ($(MCU),cortex-m4)
    LINKERSCRIPTPATH = $(PIOSSTM32FXX)
endif

# Optimization level, can be [0, 1, 2, 3, s].
# 0 = turn off optimization. s = optimize for size.
# Note: 3 is not always the best optimization level.
ifeq ($(DEBUG), YES)
    OPT = 0
else
    OPT = s
endif

# Output format (can be ihex or binary or both).
#  binary to create a load-image in raw-binary format i.e. for SAM-BA,
#  ihex to create a load-image in Intel hex format
#LOADFORMAT = ihex
#LOADFORMAT = binary
LOADFORMAT = both

# Debugging format.
DEBUGF = dwarf-2

# Place project-specific -D (define) and/or -U options for C here.
ifeq ($(MCU),cortex-m3)
    CDEFS =  -DSTM32F10X_$(MODEL)
else ifeq ($(MCU),cortex-m4)
    CDEFS += -DSTM32F4XX
    CDEFS += -DSYSCLK_FREQ=$(SYSCLK_FREQ)
    CDEFS += -DHSE_VALUE=$(OSCILLATOR_FREQ)
endif

CDEFS += -DUSE_$(BOARD)
CDEFS += -DUSE_STDPERIPH_DRIVER

ifeq ($(ENABLE_DEBUG_PINS), YES)
    CDEFS += -DPIOS_ENABLE_DEBUG_PINS
endif
ifeq ($(ENABLE_AUX_UART), YES)
    CDEFS += -DPIOS_ENABLE_AUX_UART
endif

# Provide (only) the bootloader with board-specific defines
BLONLY_CDEFS += -DBOARD_TYPE=$(BOARD_TYPE)
BLONLY_CDEFS += -DBOARD_REVISION=$(BOARD_REVISION)
BLONLY_CDEFS += -DHW_TYPE=$(HW_TYPE)
BLONLY_CDEFS += -DBOOTLOADER_VERSION=$(BOOTLOADER_VERSION)
BLONLY_CDEFS += -DFW_BANK_BASE=$(FW_BANK_BASE)
BLONLY_CDEFS += -DFW_BANK_SIZE=$(FW_BANK_SIZE)
BLONLY_CDEFS += -DFW_DESC_SIZE=$(FW_DESC_SIZE)

# Place project-specific -D and/or -U options for Assembler with preprocessor here.
#ADEFS = -DUSE_IRQ_ASM_WRAPPER
ADEFS = -D__ASSEMBLY__

# Compiler flag to set the C Standard level.
# c89   - "ANSI" C
# gnu89 - c89 plus GCC extensions
# c99   - ISO C99 standard (not yet fully implemented)
# gnu99 - c99 plus GCC extensions
CSTANDARD = -std=gnu99

# Compiler flags.
#
#  -g*:          generate debugging information
#  -O*:          optimization level
#  -f...:        tuning, see GCC manual and avr-libc documentation
#  -Wall...:     warning level
#  -Wa,...:      tell GCC to pass this to the assembler.
#    -adhlns...: create assembler listing

# Flags for C and C++ (arm-elf-gcc/arm-elf-g++)
ifeq ($(MCU),cortex-m4)
    # This is not the best place for these.  Really should abstract out
    # to the board file or something
    CFLAGS += -DSTM32F4XX
    CFLAGS += -DMEM_SIZE=1024000000
endif

CFLAGS += -mcpu=$(MCU)
CFLAGS += $(CDEFS)
CFLAGS += $(BLONLY_CDEFS)
CFLAGS += $(patsubst %,-I%,$(EXTRAINCDIRS)) -I.
CFLAGS += -mapcs-frame
CFLAGS += -fomit-frame-pointer
CFLAGS += -O$(OPT)
CFLAGS += -g$(DEBUGF)

ifeq ($(DEBUG), YES)
    CFLAGS += -DDEBUG
else
    CFLAGS += -fdata-sections -ffunction-sections
endif

CFLAGS += -Wall
# FIXME: STM32F4xx library raises strict aliasing and const qualifier warnings
ifneq ($(MCU),cortex-m4)
    CFLAGS += -Werror
endif
CFLAGS += -Wa,-adhlns=$(addprefix $(OUTDIR)/, $(notdir $(addsuffix .lst, $(basename $<))))

# Compiler flags to generate dependency files
CFLAGS += -MD -MP -MF $(OUTDIR)/dep/$(@F).d

# Flags only for C
#CONLYFLAGS += -Wnested-externs
CONLYFLAGS += $(CSTANDARD)

# Assembler flags.
#  -Wa,...:    tell GCC to pass this to the assembler.
#  -ahlns:     create listing
ASFLAGS =  -mcpu=$(MCU) -I. -x assembler-with-cpp
ASFLAGS += $(ADEFS)
ASFLAGS += -Wa,-adhlns=$(addprefix $(OUTDIR)/, $(notdir $(addsuffix .lst, $(basename $<))))
ASFLAGS += $(patsubst %,-I%,$(EXTRAINCDIRS))

MATH_LIB = -lm

# Linker flags.
#  -Wl,...:     tell GCC to pass this to linker.
#    -Map:      create map file
#    --cref:    add cross reference to  map file
LDFLAGS += -nostartfiles -Wl,-Map=$(OUTDIR)/$(TARGET).map,--cref,--gc-sections
LDFLAGS += $(patsubst %,-L%,$(EXTRA_LIBDIRS))
LDFLAGS += $(patsubst %,-l%,$(EXTRA_LIBS))
LDFLAGS += -lc -lgcc $(MATH_LIB)
LDFLAGS += -Wl,--warn-common
LDFLAGS += -Wl,--fatal-warnings

ifneq ($(DEBUG), YES)
    LDFLAGS += -Wl,-static
endif

# Set linker-script name depending on selected submodel name
ifeq ($(MCU),cortex-m3)
    LDFLAGS += -T$(LINKERSCRIPTPATH)/link_$(BOARD)_memory.ld
    LDFLAGS += -T$(LINKERSCRIPTPATH)/link_$(BOARD)_BL_sections.ld
else ifeq ($(MCU),cortex-m4)
    LDFLAGS += $(addprefix -T,$(LINKER_SCRIPTS_BL))
endif

# List of all source files.
ALLSRC     = $(ASRCARM) $(ASRC) $(SRCARM) $(SRC) $(CPPSRCARM) $(CPPSRC)
# List of all source files without directory and file-extension.
ALLSRCBASE = $(notdir $(basename $(ALLSRC)))

# Define all object files.
ALLOBJ     = $(addprefix $(OUTDIR)/, $(addsuffix .o, $(ALLSRCBASE)))

# Define all listing files (used for make clean).
LSTFILES   = $(addprefix $(OUTDIR)/, $(addsuffix .lst, $(ALLSRCBASE)))
# Define all depedency-files (used for make clean).
DEPFILES   = $(addprefix $(OUTDIR)/dep/, $(addsuffix .o.d, $(ALLSRCBASE)))

# Default target.
all: build

ifeq ($(LOADFORMAT),ihex)
build: elf hex sym
else ifeq ($(LOADFORMAT),binary)
build: elf bin sym
else ifeq ($(LOADFORMAT),both)
build: elf hex bin sym
else
    $(error "$(MSG_FORMATERROR) $(FORMAT)")
endif

# Link: create ELF output file from object files.
$(eval $(call LINK_TEMPLATE, $(OUTDIR)/$(TARGET).elf, $(ALLOBJ), $(ALLLIB)))

# Assemble: create object files from assembler source files.
$(foreach src, $(ASRC), $(eval $(call ASSEMBLE_TEMPLATE, $(src))))

# Assemble: create object files from assembler source files. ARM-only
$(foreach src, $(ASRCARM), $(eval $(call ASSEMBLE_ARM_TEMPLATE, $(src))))

# Compile: create object files from C source files.
$(foreach src, $(SRC), $(eval $(call COMPILE_C_TEMPLATE, $(src))))

# Compile: create object files from C source files. ARM-only
$(foreach src, $(SRCARM), $(eval $(call COMPILE_C_ARM_TEMPLATE, $(src))))

# Compile: create object files from C++ source files.
$(foreach src, $(CPPSRC), $(eval $(call COMPILE_CPP_TEMPLATE, $(src))))

# Compile: create object files from C++ source files. ARM-only
$(foreach src, $(CPPSRCARM), $(eval $(call COMPILE_CPP_ARM_TEMPLATE, $(src))))

# Compile: create assembler files from C source files. ARM/Thumb
$(eval $(call PARTIAL_COMPILE_TEMPLATE, SRC))

# Compile: create assembler files from C source files. ARM only
$(eval $(call PARTIAL_COMPILE_ARM_TEMPLATE, SRCARM))

$(OUTDIR)/$(TARGET).bin.o: $(OUTDIR)/$(TARGET).bin

# Add jtag targets (program and wipe)
$(eval $(call JTAG_TEMPLATE,$(OUTDIR)/$(TARGET).bin,$(BL_BANK_BASE),$(BL_BANK_SIZE),$(OPENOCD_JTAG_CONFIG),$(OPENOCD_CONFIG)))

.PHONY: elf lss sym hex bin bino
elf: $(OUTDIR)/$(TARGET).elf
lss: $(OUTDIR)/$(TARGET).lss
sym: $(OUTDIR)/$(TARGET).sym
hex: $(OUTDIR)/$(TARGET).hex
bin: $(OUTDIR)/$(TARGET).bin
bino: $(OUTDIR)/$(TARGET).bin.o

# Display sizes of sections.
$(eval $(call SIZE_TEMPLATE, $(OUTDIR)/$(TARGET).elf))

# Generate Doxygen documents
docs:
	doxygen  $(DOXYGENDIR)/doxygen.cfg

# Install: install binary file with prefix/suffix into install directory
install: $(OUTDIR)/$(TARGET).bin
ifneq ($(INSTALL_DIR),)
	@$(ECHO) $(MSG_INSTALLING) $(call toprel, $<)
	$(V1) $(MKDIR) -p $(INSTALL_DIR)
	$(V1) $(INSTALL) $< $(INSTALL_DIR)/$(INSTALL_PFX)$(TARGET)$(INSTALL_SFX).bin
else
	$(error INSTALL_DIR must be specified for $@)
endif

# Target: clean project.
clean: clean_list

clean_list :
	@echo $(MSG_CLEANING)
	$(V1) $(RM) -f $(OUTDIR)/$(TARGET).map
	$(V1) $(RM) -f $(OUTDIR)/$(TARGET).elf
	$(V1) $(RM) -f $(OUTDIR)/$(TARGET).hex
	$(V1) $(RM) -f $(OUTDIR)/$(TARGET).bin
	$(V1) $(RM) -f $(OUTDIR)/$(TARGET).sym
	$(V1) $(RM) -f $(OUTDIR)/$(TARGET).lss
	$(V1) $(RM) -f $(OUTDIR)/$(TARGET).bin.o
	$(V1) $(RM) -f $(ALLOBJ)
	$(V1) $(RM) -f $(LSTFILES)
	$(V1) $(RM) -f $(DEPFILES)
	$(V1) $(RM) -f $(SRC:.c=.s)
	$(V1) $(RM) -f $(SRCARM:.c=.s)
	$(V1) $(RM) -f $(CPPSRC:.cpp=.s)
	$(V1) $(RM) -f $(CPPSRCARM:.cpp=.s)

# Create output files directory
# all known MS Windows OS define the ComSpec environment variable
$(shell $(MKDIR) -p $(OUTDIR) 2>/dev/null)

# Include the dependency files.
-include $(shell $(MKDIR) -p $(OUTDIR)/dep 2>/dev/null) $(wildcard $(OUTDIR)/dep/*)

# Listing of phony targets.
.PHONY : all build clean clean_list install
