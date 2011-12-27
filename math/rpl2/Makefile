# $OpenBSD: Makefile.template,v 1.60 2010/10/24 20:41:23 ajacoutot Exp $

COMMENT =		rpl/2 programming language

V =			4.1.4
DISTNAME =		rpl-${V}
PKGNAME =		rpl2-${V}

#SHARED_LIBS =		???

CATEGORIES =		math devel

HOMEPAGE =		http://www.rpl2.net

MAINTAINER =		Edd Barrett <edd@openbsd.org>

# XXX
PERMIT_PACKAGE_CDROM =	Yes
PERMIT_PACKAGE_FTP =	Yes
PERMIT_DISTFILES_CDROM =Yes
PERMIT_DISTFILES_FTP =	Yes

#WANTLIB =		???

MASTER_SITES =		http://www.rpl2.net/download/
EXTRACT_SUFX =		.tar.bz2

MODULES =		gcc4
#BUILD_DEPENDS =	???
#RUN_DEPENDS =		???
#LIB_DEPENDS =		???
#REGRESS_DEPENDS =	???

USE_GMAKE =		Yes
#USE_GROFF =		Yes
#USE_LIBTOOL =		Yes
CONFIGURE_STYLE =	gnu
CONFIGURE_ARGS +=	--disable-embedded-gnuplot

#NO_REGRESS =		Yes

.include <bsd.port.mk>
