# NMake Makefile portion for enabling features for Windows builds

# You may change these lines to customize the .lib files that will be linked to

HUNSPELL_LIBS = hunspell.lib

# Todo! Untested provider config's
ASPELL_CFLAGS = /I$(PREFIX)\include\aspell
ASPELL_LIBS = aspell-6.lib
HSPELL_CFLAGS = /I$(PREFIX)\include\hspell
HSPELL_LIBS = hspell.lib
VOIKKO_CFLAGS = /I$(PREFIX)\include\voikko
VOIKKO_LIBS = voikko.lib
ZEMBEREK_CFLAGS = /I$(PREFIX)\include\zemberek
ZEMBEREK_LIBS = zemberek.lib

# Please do not change anything beneath this line unless maintaining the NMake Makefiles

ENCHANT_DEP_LIBS =	\
	gmodule-2.0.lib	\
	glib-2.0.lib	\
	$(CFG)\$(PLAT)\gnulib.lib

ENCHANT_GNULIB_CFLAGS =	\
	/I.\lib	\
	/I..\lib	\
	/I.	\
	/FImsvc_recommended_pragmas.h	\
	/FIarg-nonnull.h	\
	/FIc++defs.h	\
	/FIunused-parameter.h	\
	/FIwarn-on-use.h	\
	/FI_Noreturn.h

ENCHANT_GNULIB_DEFINES =	\
	/DHAVE_CONFIG_H	\
	/DNO_XMALLOC

ENCHANT_LIB_VERSION_DEFINES =	\
	/DENCHANT_MAJOR_VERSION=\"2\"	\
	/DENCHANT_VERSION_STRING=\"2.2.3\"

ENCHANT_DEFINES =	\
	$(ENCHANT_GNULIB_DEFINES)

ENCHANT_LIB_DEFINES =	\
	$(ENCHANT_DEFINES)	\
	/D_ENCHANT_BUILD=1

ENCHANT_CFLAGS =	\
	$(CFLAGS)	\
	/I..\src	\
	$(ENCHANT_GNULIB_CFLAGS)	\
	/I$(PREFIX)\include\glib-2.0	\
	/I$(PREFIX)\lib\glib-2.0\include	\
	/I$(PREFIX)\include

ENCHANT_CXXFLAGS = /EHsc $(ENCHANT_CFLAGS)

!if "$(VSVER)" == "9"
ENCHANT_LIB_DEFINES =	\
	$(ENCHANT_LIB_DEFINES)	\
	/D_CRT_NOFORCE_MANIFEST=1

ENCHANT_CXXFLAGS = $(ENCHANT_CXXFLAGS) /Dnullptr=NULL
!endif

# Note: c99wrap.exe must be in your PATH for pre-2013 Visual Studio!
!if $(VSVER) < 12
ENCHANT_CFLAGS = $(ENCHANT_CFLAGS:/=-)
ENCHANT_LIB_DEFINES = $(ENCHANT_LIB_DEFINES:/=-)
ENCHANT_LIB_VERSION_DEFINES = $(ENCHANT_LIB_VERSION_DEFINES:/=-)
ENCHANT_LIB_VERSION_DEFINES = $(ENCHANT_LIB_VERSION_DEFINES:\"=\\\")
C99CC = c99wrap $(CC)
!else
C99CC = $(CC)
!endif

ENCHANT_GNULIB_LIB_FLAGS = $(LDFLAGS_ARCH)

!if "$(CFG)" == "release" || "$(CFG)" == "Release"
ENCHANT_GNULIB_LIB_FLAGS = $(ENCHANT_GNULIB_LIB_FLAGS) /LTCG
!endif

!ifdef USE_LIBTOOL_DLLNAME
ENCHANT_DLL = $(CFG)\$(PLAT)\libenchant-2.2.dll
!else
ENCHANT_DLL = $(CFG)\$(PLAT)\enchant-2-vs$(PDBVER).dll
!endif

ENCHANT_TOOLS =	\
	$(CFG)\$(PLAT)\enchant-2.exe	\
	$(CFG)\$(PLAT)\enchant-lsmod-2.exe

APIVERSION = 2

MAKE_OPTS = CFG^=$(CFG)

ENCHANT_PROVIDERS =
!ifndef NO_HUNSPELL_PROVIDER
ENCHANT_PROVIDERS = $(CFG)\$(PLAT)\enchant-hunspell.dll
!else
MAKE_OPTS = $(MAKE_OPTS) NO_HUNSPELL_PROVIDER^=1
!endif
