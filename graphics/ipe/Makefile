# $OpenBSD: Makefile.template,v 1.61 2012/03/29 13:41:58 sthen Exp $

COMMENT =		extensible drawing editor

V =			7.1.2
DISTNAME =		ipe-7.1.2-src
PKGNAME =		ipe-${V}

# their libraries would be installed as libxxx.so.${V}, overide this.
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

WANTLIB += GL QtGui X11 Xrender c cairo expat fontconfig freetype
WANTLIB += glib-2.0 gobject-2.0 iconv intl lua m pixman-1 png
WANTLIB += pthread pthread-stubs stdc++ xcb xcb-render xcb-shm
WANTLIB += z

MASTER_SITES =		${MASTER_SITE_SOURCEFORGE:=ipe7/}

# Dependencies
MODULES =		lang/lua \
			x11/qt4
LIB_DEPENDS =		${MODLUA_LIB_DEPENDS} \
			${MODQT4_LIB_DEPENDS} \
			converters/libiconv
RUN_DEPENDS =		print/texlive/base \
			x11/xvkbd

MAKE_FLAGS +=		IPEPREFIX=${PREFIX} \
			IPE_USE_ICONV=-DIPE_USE_ICONV \
			ICONV_CFLAGS=-I${LOCALBASE}/include \
			ICONV_LIBS="-L${LOCALBASE}/lib -liconv" \
			OPENBSD_SO_VERSION=${OPENBSD_SO_VERSION}
MAKE_ENV +=		PKG_CONFIG_PATH=${LOCALBASE}/lib/qt4/pkgconfig
FAKE_FLAGS +=		INSTALL_ROOT=${WRKINST} \
			OPENBSD_SO_VERSION=${OPENBSD_SO_VERSION} \
			IPEMANDIR=${PREFIX}/man/man1 \
			IPEDOCDIR=${PREFIX}/share/doc/ipe

USE_GMAKE =		Yes
NO_REGRESS =		Yes

WRKDIST = ${WRKDIR}/${PKGNAME}
WRKSRC = ${WRKDIST}/src

post-install:
	perl -pi -e "s,/usr/share/,${LOCALBASE}/share/," \
		${WRKDIST}/fontmaps/texlive-fontmap.xml
	${INSTALL_DATA} -c ${WRKDIST}/fontmaps/texlive-fontmap.xml \
		${PREFIX}/share/ipe/7.1.2/fontmap.xml

.include <bsd.port.mk>
