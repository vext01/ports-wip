# $OpenBSD: Makefile.template,v 1.60 2010/10/24 20:41:23 ajacoutot Exp $

COMMENT =		graphical toolkit based on SDL

DISTNAME =		agar-1.4.1

#SHARED_LIBS =		???

CATEGORIES =		devel graphics

HOMEPAGE =		http://libagar.org

MAINTAINER =		Edd Barrett <edd@openbsd.org>

# BSD
PERMIT_PACKAGE_CDROM =	Yes
PERMIT_PACKAGE_FTP =	Yes
PERMIT_DISTFILES_CDROM =Yes
PERMIT_DISTFILES_FTP =	Yes

#WANTLIB =		???

MASTER_SITES =		${MASTER_SITE_SOURCEFORGE:=agar/}

#MODULES =		???
#BUILD_DEPENDS =	???
#RUN_DEPENDS =		???
#LIB_DEPENDS =		???
#REGRESS_DEPENDS =	???

#USE_GMAKE =		Yes
#USE_GROFF =		Yes
USE_LIBTOOL =		Yes
CONFIGURE_STYLE =	simple
CONFIGURE_ARGS =	--prefix=${PREFIX}
#CONFIGURE_ENV +=	SH=bash

# Build system gets these wrong
#MAKE_ENV +=		"LIBDIR=${PREFIX}/lib"
#MAKE_ENV +=		"MANDIR=${PREFIX}/share/man"
#MAKE_ENV +=		"INCLDIR=${PREFIX}/include"

#NO_REGRESS =		Yes

.include <bsd.port.mk>
