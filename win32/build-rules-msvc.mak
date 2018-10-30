# NMake Makefile portion for compilation rules
# Items in here should not need to be edited unless
# one is maintaining the NMake build files.  The format
# of NMake Makefiles here are different from the GNU
# Makefiles.  Please see the comments about these formats.

# Inference rules for compiling the .obj files.
# Used for libs and programs with more than a single source file.
# Format is as follows
# (all dirs must have a trailing '\'):
#
# {$(srcdir)}.$(srcext){$(destdir)}.obj::
# 	$(CC)|$(CXX) $(cflags) /Fo$(destdir) /c @<<
# $<
# <<
{..\lib\}.c{$(CFG)\$(PLAT)\gnulib\}.obj::
	$(CC) $(CFLAGS) $(ENCHANT_GNULIB_CFLAGS) $(ENCHANT_GNULIB_DEFINES) /Fo$(CFG)\$(PLAT)\gnulib\ /Fd$(CFG)\$(PLAT)\gnulib\ /c @<<
$<
<<

{..\src\}.c{$(CFG)\$(PLAT)\enchant-tools\}.obj::
	$(CC) $(ENCHANT_CFLAGS) $(ENCHANT_DEFINES) /Fo$(CFG)\$(PLAT)\enchant-tools\ /Fd$(CFG)\$(PLAT)\enchant-tools\ /c @<<
$<
<<

{..\providers\}.cpp{$(CFG)\$(PLAT)\enchant-providers\}.obj::
	@if not exist $(CFG)\$(PLAT)\enchant-providers\ $(MAKE) /f Makefile.vc $(MAKE_OPTS) $(CFG)\$(PLAT)\enchant-providers
	$(CC) $(ENCHANT_CXXFLAGS) $(ENCHANT_DEFINES) /Fo$(CFG)\$(PLAT)\enchant-providers\ /Fd$(CFG)\$(PLAT)\enchant-providers\ /c @<<
$<
<<

# Hmm, we can't use inference rules when using c99wrap...
$(CFG)\$(PLAT)\libenchant\lib.obj: ..\src\lib.c
	$(C99CC) $(ENCHANT_CFLAGS) $(ENCHANT_LIB_DEFINES) $(ENCHANT_LIB_VERSION_DEFINES) -Fo$@ -Fd$(@D)\ -c $**

$(CFG)\$(PLAT)\libenchant\pwl.obj: ..\src\pwl.c
	$(C99CC) $(ENCHANT_CFLAGS) $(ENCHANT_LIB_DEFINES) $(ENCHANT_LIB_VERSION_DEFINES) -Fo$@ -Fd$(@D)\ -c $**

$(CFG)\$(PLAT)\libenchant\libenchant.res: ..\src\libenchant.rc $(CFG)\$(PLAT)\libenchant
	rc /fo$@ ..\src\$(@B)

# Inference rules for building the test programs
# Used for programs with a single source file.
# Format is as follows
# (all dirs must have a trailing '\'):
#
# {$(srcdir)}.$(srcext){$(destdir)}.exe::
# 	$(CC)|$(CXX) $(cflags) $< /Fo$*.obj  /Fe$@ [/link $(linker_flags) $(dep_libs)]

# Rules for linking DLLs
# Format is as follows (the mt command is needed for MSVC 2005/2008 builds):
# $(dll_name_with_path): $(dependent_libs_files_objects_and_items)
#	link /DLL [$(linker_flags)] [$(dependent_libs)] [/def:$(def_file_if_used)] [/implib:$(lib_name_if_needed)] -out:$@ @<<
# $(dependent_objects)
# <<
# 	@-if exist $@.manifest mt /manifest $@.manifest /outputresource:$@;2
$(CFG)\$(PLAT)\gnulib.lib: config.h $(CFG)\$(PLAT)\gnulib $(gnulib_OBJS)
	lib $(ENCHANT_GNULIB_LIB_FLAGS) /out:$@ @<<
$(gnulib_OBJS)
<<

$(CFG)\$(PLAT)\enchant-$(APIVERSION).lib: $(ENCHANT_DLL)

$(ENCHANT_DLL): $(CFG)\$(PLAT)\gnulib.lib $(CFG)\$(PLAT)\libenchant $(libenchant_OBJS)
	link /DLL $(LDFLAGS) $(ENCHANT_DEP_LIBS) -out:$@ -implib:$(CFG)\$(PLAT)\enchant-2.lib @<<
$(libenchant_OBJS)
<<
	@-if exist $@.manifest mt /manifest $@.manifest /outputresource:$@;2
	@-if exist $@.manifest del $@.manifest

$(CFG)\$(PLAT)\enchant-hunspell.dll: $(ENCHANT_DLL) $(CFG)\$(PLAT)\enchant-providers\enchant_hunspell.obj
	link /DLL $(LDFLAGS) $(CFG)\$(PLAT)\enchant-2.lib $(ENCHANT_DEP_LIBS) $(HUNSPELL_LIBS) -out:$@ $(@D)\enchant-providers\enchant_hunspell.obj
	@-if exist $@.manifest mt /manifest $@.manifest /outputresource:$@;2
	@-if exist $@.manifest del $@.manifest

# Rules for linking EXEs
# Format is as follows (the mt command is needed for MSVC 2005/2008 builds):
# $(exe_name_with_path): $(dependent_libs_files_objects_and_items)
#	link /DLL [$(linker_flags)] [$(dependent_libs)] -out:$@ @<<
# $(dependent_objects)
# <<
# 	@-if exist $@.manifest mt /manifest $@.manifest /outputresource:$@;1
$(CFG)\$(PLAT)\enchant-2.exe: $(ENCHANT_DLL) $(CFG)\$(PLAT)\enchant-tools $(CFG)\$(PLAT)\enchant-tools\enchant.obj
	link $(LDFLAGS) $(CFG)\$(PLAT)\enchant-2.lib $(ENCHANT_DEP_LIBS) -out:$@ $(@D)\enchant-tools\enchant.obj
	@-if exist $@.manifest mt /manifest $@.manifest /outputresource:$@;1
	@-if exist $@.manifest del $@.manifest

$(CFG)\$(PLAT)\enchant-lsmod-2.exe: $(ENCHANT_DLL) $(CFG)\$(PLAT)\enchant-tools $(CFG)\$(PLAT)\enchant-tools\enchant-lsmod.obj
	link $(LDFLAGS) $(CFG)\$(PLAT)\enchant-2.lib $(ENCHANT_DEP_LIBS) -out:$@ $(@D)\enchant-tools\enchant-lsmod.obj
	@-if exist $@.manifest mt /manifest $@.manifest /outputresource:$@;1
	@-if exist $@.manifest del $@.manifest

clean:
	@-del /f /q $(CFG)\$(PLAT)\*.lib
	@-del /f /q $(CFG)\$(PLAT)\*.exp
	@-del /f /q $(CFG)\$(PLAT)\*.pdb
	@-del /f /q $(CFG)\$(PLAT)\*.dll
	@-del /f /q $(CFG)\$(PLAT)\*.exe
	@-del /f /q $(CFG)\$(PLAT)\enchant-providers\*.obj
	@-del /f /q $(CFG)\$(PLAT)\enchant-providers\*.pdb
	@-del /f /q $(CFG)\$(PLAT)\enchant-tools\*.obj
	@-del /f /q $(CFG)\$(PLAT)\enchant-tools\*.pdb
	@-del /f /q $(CFG)\$(PLAT)\libenchant\*.res
	@-del /f /q $(CFG)\$(PLAT)\libenchant\*.obj
	@-del /f /q $(CFG)\$(PLAT)\libenchant\*.pdb
	@-del /f /q $(CFG)\$(PLAT)\gnulib\*.obj
	@-del /f /q $(CFG)\$(PLAT)\gnulib\*.pdb
	@-rmdir /s /q $(CFG)\$(PLAT)\libenchant
	@-rmdir /s /q $(CFG)\$(PLAT)\gnulib