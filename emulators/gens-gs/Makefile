# $OpenBSD: Makefile.template,v 1.60 2010/10/24 20:41:23 ajacoutot Exp $

#ONLY_FOR_ARCHS =	???
#SHARED_ONLY =		???

COMMENT =		Sega Megadrive/Genesis emulator

V =			r7
DISTNAME =		Gens-gs-${V}
PKGNAME =		gens-gs-${V}

#SHARED_LIBS =		???

CATEGORIES =		emulators games

HOMEPAGE =		http://segaretro.org/Gens/GS

MAINTAINER =		Edd Barrett <edd@openbsd.org>

# XXX
PERMIT_PACKAGE_CDROM =	Yes
PERMIT_PACKAGE_FTP =	Yes
PERMIT_DISTFILES_CDROM =Yes
PERMIT_DISTFILES_FTP =	Yes

#WANTLIB =		???

MASTER_SITES =		http://segaretro.org/images/6/6d/
WRKDIST =		${WRKDIR}/gens-gs-r7

#MODULES =		???

BUILD_DEPENDS +=	devel/sdl

.if ${MACHINE_ARCH} == "i386" || ${MACHINE_ARCH} == "amd64"
BUILD_DEPENDS +=	devel/nasm
.endif

#RUN_DEPENDS =		???
#LIB_DEPENDS =		???
#REGRESS_DEPENDS =	???

USE_GMAKE =		Yes
#USE_GROFF =		Yes
#USE_LIBTOOL =		Yes
CONFIGURE_STYLE =	autoconf automake
AUTOCONF_VERSION =	2.63
AUTOMAKE_VERSION =	1.10

#AUTOCONF_VERSION =	??? (defaults to 2.13)
#AUTOMAKE_VERSION =	??? (defaults to 1.4)

#NO_REGRESS =		Yes

#pre-configure:
#	cp ${WRKSRC}/configure.ac ${WRKSRC}/configure.in

.include <bsd.port.mk>
