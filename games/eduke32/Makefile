# $OpenBSD$

COMMENT =	Enhanced Duke Nukem 3D engine
RDATE =         20120301
RTAG =          2394
DISTNAME =	eduke32_src_${RDATE}-${RTAG}
PKGNAME =	eduke32-2.0.0.${RTAG}
EXTRACT_SUFX =	.tar.bz2
CATEGORIES =	games x11 wip

HOMEPAGE =	http://www.eduke32.com/

MAINTAINER =	Ryan Freeman <ryan@slipgate.org>

# GPLv2, BUILD license
PERMIT_PACKAGE_CDROM =  "BUILD engine license is not compatible with GPLv2."
PERMIT_PACKAGE_FTP =    "BUILD engine license is not compatible with GPLv2."
PERMIT_DISTFILES_CDROM ="BUILD engine license is not compatible with GPLv2."
PERMIT_DISTFILES_FTP =  "BUILD engine license is not compatible with GPLv2."

.if ${MACHINE_ARCH} == "i386"
BUILD_DEPENDS += devel/nasm
.endif

WANTLIB =	SDL c m pthread stdc++ SDL_mixer>=3 vorbisfile vpx

LIB_DEPENDS =	audio/libvorbis \
		devel/sdl \
		multimedia/libvpx \
		devel/sdl-mixer 

RUN_DEPENDS =	games/duke3ddata

MASTER_SITES =	http://dukeworld.duke4.net/eduke32/synthesis/${RDATE}-${RTAG}/ \
		http://devio.us/~iku/dist/

DISTFILES =	${DISTNAME}${EXTRACT_SUFX}

SEPERATE_BUILD = concurrent
MAKE_FLAGS =	PRETTY_OUTPUT=0 DEBUGANYWAY=1
USE_GMAKE =	Yes
NO_REGRESS =	Yes

WRKDIST =	${WRKDIR}/eduke32_${RDATE}-${RTAG}/

pre-configure:
	${SUBST_CMD} ${WRKSRC}/source/game.c
	${SUBST_CMD} ${WRKSRC}/source/astub.c

do-install:
	${INSTALL_PROGRAM} ${WRKBUILD}/eduke32 ${PREFIX}/bin
	${INSTALL_PROGRAM} ${WRKBUILD}/mapster32 ${PREFIX}/bin

.include <bsd.port.mk>
