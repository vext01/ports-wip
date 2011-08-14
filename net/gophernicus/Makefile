# $OpenBSD: Makefile.template,v 1.60 2010/10/24 20:41:23 ajacoutot Exp $

COMMENT =		BSD licensed Gopher Server

DISTNAME =		gophernicus-1.1

CATEGORIES =		net

HOMEPAGE =		gopher://gophernicus.org

MAINTAINER =		Edd Barrett <edd@openbsd.org>

# BSD
PERMIT_PACKAGE_CDROM =	Yes
PERMIT_PACKAGE_FTP =	Yes
PERMIT_DISTFILES_CDROM =Yes
PERMIT_DISTFILES_FTP =	Yes

WANTLIB =		c

MASTER_SITES =		http://gophernicus.org/software/gophernicus/server/
FAKE_FLAGS +=		DESTDIR=${DESTDIR} PREFIX=${PREFIX}

#do-install:
#	${MAKE_PROGRAM} ${MAKE_FLAGS} ${INSTALL_TARGET}

#MODULES =		???
#BUILD_DEPENDS =	???
#RUN_DEPENDS =		???
#LIB_DEPENDS =		???
#REGRESS_DEPENDS =	???

#USE_GMAKE =		Yes
#USE_GROFF =		Yes

#NO_REGRESS =		Yes

.include <bsd.port.mk>
