# $OpenBSD: Makefile.template,v 1.60 2010/10/24 20:41:23 ajacoutot Exp $

#ONLY_FOR_ARCHS =	???
#NOT_FOR_ARCHS =	???
#SHARED_ONLY =		???
#COMES_WITH =		???
#BROKEN =		reason

#
# Very short description of the package, 60 chars max
#
COMMENT =		XXX

DISTNAME =		radare2-0.7

#SHARED_LIBS =		???

CATEGORIES =		devel

HOMEPAGE =		http://radare.nopcode.org/

#MAINTAINER =		???

# XXX
PERMIT_PACKAGE_CDROM =	Yes
PERMIT_PACKAGE_FTP =	Yes
PERMIT_DISTFILES_CDROM =Yes
PERMIT_DISTFILES_FTP =	Yes

#WANTLIB =		???

MASTER_SITES =		${HOMEPAGE}/get/

#MODULES =		???
#BUILD_DEPENDS =	???
#RUN_DEPENDS =		???
#LIB_DEPENDS =		???
#REGRESS_DEPENDS =	???

USE_GMAKE =		Yes
#USE_GROFF =		Yes
#USE_LIBTOOL =		Yes
CONFIGURE_STYLE =	gnu

CONFIGURE_ARGS +=	--with-ostype=linux

#NO_REGRESS =		Yes

MAKE_FLAGS =		EXT_SO=so
CFLAGS +=		-D__UNIX__

.include <bsd.port.mk>
