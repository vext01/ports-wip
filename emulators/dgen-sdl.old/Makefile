# $OpenBSD: Makefile.template,v 1.60 2010/10/24 20:41:23 ajacoutot Exp $

COMMENT =		Sega Megadrive/Genesis emulator
DISTNAME =		dgen-sdl-1.29
CATEGORIES =		emulators games
HOMEPAGE =		http://dgen.sourceforge.net/
MAINTAINER =		Edd Barrett <edd@openbsd.org>

# Various parts of dgen are under different licenses
# Mainly a 3 clause BSD license, but also:
#  - musa non-commercial license
#  - starscream non-commercial license
#  - mz80 non-commercial license
#  - cz80 non-commercial license
PERMIT_PACKAGE_CDROM =	No
PERMIT_PACKAGE_FTP =	Yes
PERMIT_DISTFILES_CDROM =No
PERMIT_DISTFILES_FTP =	Yes

WANTLIB =		GL SDL archive c m pthread stdc++

MASTER_SITES =		${MASTER_SITE_SOURCEFORGE:=dgen/}

BUILD_DEPENDS =		devel/sdl

# optimisation for x86 using asm
.if ${MACHINE_ARCH} == "i386"
BUILD_DEPENDS +=        devel/nasm
.endif

# when building hq4x.o:
# cc1: out of memory allocating 4072 bytes after a total of 0 bytes
VMEM_WARNING = Yes

LIB_DEPENDS =		devel/sdl \
			archivers/libarchive

CONFIGURE_STYLE =	gnu
CONFIGURE_ENV +=	LDFLAGS="-L${LOCALBASE}/lib"

SAMPLEDIR =	${PREFIX}/share/examples/dgen-sdl/
DOCDIR =	${PREFIX}/share/doc/dgen-sdl/
# cover our asses by providing copies of the non-free(ish) licenses
# particularly starscream:
# "Starscream may be distributed freely in unmodified form, as long as this
# documentation is included."
LICENSES =	musa/musa-readme.txt star/stardoc.txt \
		mz80/mz80.txt cz80/cz80-readme.txt
post-install:
	mkdir ${SAMPLEDIR}
	cp ${WRKSRC}/sample.dgenrc ${SAMPLEDIR}
	mkdir -p ${DOCDIR}
	cp ${WRKSRC}/musa/readme.txt ${WRKSRC}/musa/musa-readme.txt
	cp ${WRKSRC}/cz80/readme.txt ${WRKSRC}/cz80/cz80-readme.txt
.for i in ${LICENSES}
	cp ${WRKSRC}/$i ${DOCDIR}
.endfor

.include <bsd.port.mk>
