# $OpenBSD: Makefile.template,v 1.61 2012/03/29 13:41:58 sthen Exp $

COMMENT =		XXX

DISTNAME =		liblo-0.26	

SHARED_LIBS +=		lo	0.0 # 7.0

CATEGORIES =		audio

HOMEPAGE =		http://XXX.com

#MAINTAINER =		???

# XXX
PERMIT_PACKAGE_CDROM =	Yes
PERMIT_PACKAGE_FTP =	Yes
PERMIT_DISTFILES_CDROM =Yes
PERMIT_DISTFILES_FTP =	Yes

WANTLIB +=		c m pthread

MASTER_SITES =		${MASTER_SITE_SOURCEFORGE:=liblo/}

#MODULES =		???
#BUILD_DEPENDS =	???
#RUN_DEPENDS =		???
#LIB_DEPENDS =		???
#REGRESS_DEPENDS =	???

#USE_GMAKE =		Yes
#USE_GROFF =		Yes
USE_LIBTOOL =		Yes
CONFIGURE_STYLE =	gnu

#NO_REGRESS =		Yes

.include <bsd.port.mk>
