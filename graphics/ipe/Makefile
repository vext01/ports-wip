# $OpenBSD: Makefile.template,v 1.61 2012/03/29 13:41:58 sthen Exp $

COMMENT =		extensible drawing editor

V =			7.1.2
DISTNAME =		ipe-7.1.2-src
PKGNAME =		ipe-${V}

# their libraries would be install as libxxx.so.${V}, overide this.
OPENBSD_SO_VERSION =	0.0

SHARED_LIBS +=		ipe		${OPENBSD_SO_VERSION}
SHARED_LIBS +=		ipecairo	${OPENBSD_SO_VERSION}
SHARED_LIBS +=		ipecanvas	${OPENBSD_SO_VERSION}
SHARED_LIBS +=		ipelua		${OPENBSD_SO_VERSION}
SHARED_LIBS +=		ipeui		${OPENBSD_SO_VERSION}

CATEGORIES =		graphics math

HOMEPAGE =		http://ipe7.sourceforge.net/

MAINTAINER =		Edd Barrett <edd@openbsd.org>

# GPLv3+
PERMIT_PACKAGE_CDROM =	Yes
PERMIT_PACKAGE_FTP =	Yes
PERMIT_DISTFILES_CDROM =Yes
PERMIT_DISTFILES_FTP =	Yes

#WANTLIB =		???

MASTER_SITES =		${MASTER_SITE_SOURCEFORGE:=ipe7/}

# Dependencies
MODULES =		lang/lua \
			x11/qt4
LIB_DEPENDS =		${MODLUA_LIB_DEPENDS} \
			${MODQT4_LIB_DEPENDS} \
			converters/libiconv

#MAKE_FLAGS +=		IPEPREFIX=${PREFIX} IPE_USE_ICONV=-DIPE_USE_ICONV CPPFLAGS+=-I${LOCALBASE}/include
MAKE_FLAGS +=		IPEPREFIX=${PREFIX} \
			OPENBSD_SO_VERSION=${OPENBSD_SO_VERSION}
MAKE_ENV +=		PKG_CONFIG_PATH=${LOCALBASE}/lib/qt4/pkgconfig
FAKE_FLAGS +=		INSTALL_ROOT=${WRKINST}/${PREFIX} \
			OPENBSD_SO_VERSION=${OPENBSD_SO_VERSION}
#REGRESS_DEPENDS =	???

USE_GMAKE =		Yes
#USE_GROFF =		Yes
#USE_LIBTOOL =		Yes
#CONFIGURE_STYLE =	gnu

#IS_INTERACTIVE =		Yes
#REGRESS_IS_INTERACTIVE =	Yes

#NO_REGRESS =		Yes

WRKDIST = ${WRKDIR}/${PKGNAME}/src

.include <bsd.port.mk>
