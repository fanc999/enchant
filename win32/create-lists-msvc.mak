# Convert the source listing to object (.obj) listing in
# another NMake Makefile module, include it, and clean it up.
# This is a "fact-of-life" regarding NMake Makefiles...
# This file does not need to be changed unless one is maintaining the NMake Makefiles

# For those wanting to add things here:
# To add a list, do the following:
# # $(description_of_list)
# if [call create-lists.bat header $(makefile_snippet_file) $(variable_name)]
# endif
#
# if [call create-lists.bat file $(makefile_snippet_file) $(file_name)]
# endif
#
# if [call create-lists.bat footer $(makefile_snippet_file)]
# endif
# ... (repeat the if [call ...] lines in the above order if needed)
# !include $(makefile_snippet_file)
#
# (add the following after checking the entries in $(makefile_snippet_file) is correct)
# (the batch script appends to $(makefile_snippet_file), you will need to clear the file unless the following line is added)
#!if [del /f /q $(makefile_snippet_file)]
#!endif

# In order to obtain the .obj filename that is needed for NMake Makefiles to build DLLs/static LIBs or EXEs, do the following
# instead when doing 'if [call create-lists.bat file $(makefile_snippet_file) $(file_name)]'
# (repeat if there are multiple $(srcext)'s in $(source_list), ignore any headers):
# !if [for %c in ($(source_list)) do @if "%~xc" == ".$(srcext)" @call create-lists.bat file $(makefile_snippet_file) $(intdir)\%~nc.obj]
#
# $(intdir)\%~nc.obj needs to correspond to the rules added in build-rules-msvc.mak
# %~xc gives the file extension of a given file, %c in this case, so if %c is a.cc, %~xc means .cc
# %~nc gives the file name of a given file without extension, %c in this case, so if %c is a.cc, %~nc means a

NULL=

# For gnulib
!if [call create-lists.bat header enchant2_objs.mak.mak gnulib_OBJS]
!endif

!if [for %c in (..\lib\*.c) do @call create-lists.bat file enchant2_objs.mak.mak ^$(CFG)\^$(PLAT)\gnulib\%~nc.obj]
!endif

!if [call create-lists.bat footer enchant2_objs.mak.mak]
!endif

!if [call create-lists.bat header enchant2_objs.mak.mak libenchant_OBJS]
!endif

!if [for %c in (..\src\lib.c ..\src\pwl.c) do @call create-lists.bat file enchant2_objs.mak.mak ^$(CFG)\^$(PLAT)\libenchant\%~nc.obj]
!endif

!if [for %r in (..\src\libenchant.rc) do @call create-lists.bat file enchant2_objs.mak.mak ^$(CFG)\^$(PLAT)\libenchant\%~nr.res]
!endif

!if [call create-lists.bat footer enchant2_objs.mak.mak]
!endif

!include enchant2_objs.mak.mak

!if [del /f /q enchant2_objs.mak.mak]
!endif