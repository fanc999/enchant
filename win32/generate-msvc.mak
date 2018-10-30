# NMake Makefile portion for code generation and
# intermediate build directory creation
# Items in here should not need to be edited unless
# one is maintaining the NMake build files.

# Copy config.h
config.h: config.h.win32
	@copy $(@F).win32 $@

# Create the build directories

$(CFG)\$(PLAT)\gnulib	\
$(CFG)\$(PLAT)\libenchant	\
$(CFG)\$(PLAT)\enchant-tools	\
$(CFG)\$(PLAT)\enchant-providers:
	@-mkdir $@