# $OpenBSD: Makefile.template,v 1.60 2010/10/24 20:41:23 ajacoutot Exp $

#ONLY_FOR_ARCHS =	???
#NOT_FOR_ARCHS =	???
#SHARED_ONLY =		???

COMMENT =		Sega Megadrive/Genesis emulator

DISTNAME =		dgen-sdl-1.28

#SHARED_LIBS =		???

CATEGORIES =		emulators games

HOMEPAGE =		http://dgen.sourceforge.net/

# XXX
#MAINTAINER =		???

# XXX
PERMIT_PACKAGE_CDROM =	Yes
PERMIT_PACKAGE_FTP =	Yes
PERMIT_DISTFILES_CDROM =Yes
PERMIT_DISTFILES_FTP =	Yes

#WANTLIB =		???

MASTER_SITES =		${MASTER_SITE_SOURCEFORGE:=dgen/}

#MODULES =		???
#BUILD_DEPENDS =	???
#RUN_DEPENDS =		???
#LIB_DEPENDS =		???
#REGRESS_DEPENDS =	???

#USE_GMAKE =		Yes
#USE_GROFF =		Yes
#USE_LIBTOOL =		Yes
CONFIGURE_STYLE =	gnu
#CONFIGURE_ARGS +=	${CONFIGURE_SHARED}
CONFIGURE_ENV +=	LDFLAGS="-L${LOCALBASE}/lib"

#NO_REGRESS =		Yes


.include <bsd.port.mk>
