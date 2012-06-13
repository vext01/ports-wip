# $OpenBSD: Makefile.template,v 1.61 2012/03/29 13:41:58 sthen Exp $

COMMENT =		application to control the JACK sound server
DISTNAME =		qjackctl-0.3.9
CATEGORIES =		audio x11

HOMEPAGE =		http://qjackctl.sourceforge.net

#MAINTAINER =		???

# XXX
PERMIT_PACKAGE_CDROM =	Yes
PERMIT_PACKAGE_FTP =	Yes
PERMIT_DISTFILES_CDROM =Yes
PERMIT_DISTFILES_FTP =	Yes

WANTLIB += ICE QtDBus QtGui QtXml SM X11 Xext Xi Xinerama Xrender
WANTLIB += c fontconfig freetype jack m portaudio pthread stdc++

MASTER_SITES =		${MASTER_SITE_SOURCEFORGE:=qjackctl/}


MODULES =		x11/qt4
LIB_DEPENDS =		audio/jack \
			audio/portaudio-svn

AUTOCONF_VERSION =	2.68
CONFIGURE_STYLE =	autoconf
CONFIGURE_FLAGS +=	CPPFLAGS=${CPPFLAGS}
CONFIGURE_FLAGS +=	LDFLAGS=${LDFLAGS}
CONFIGURE_ENV =		LDFLAGS=${LDFLAGS} CPPFLAGS=${CPPFLAGS}
MAKE_ENV =		${CONFIGURE_ENV}

CPPFLAGS =		"-I${MODQT_INCDIR} -I${LOCALBASE}/include -I${X11BASE}/include -I${MODQT_INCDIR}"
LDFLAGS =		"-L${MODQT_LIBDIR} -L${LOCALBASE}/lib -L${X11BASE}/lib -lpthread"

USE_GMAKE =		Yes

# why is this not defined in qt4.mk?
MODQT_QMAKE =		${LOCALBASE}/bin/qmake4
SUBST_VARS +=		MODQT_MOC MODQT_UIC MODQT_QMAKE CPPFLAGS CXXFLAGS

pre-configure:
	${SUBST_CMD} ${WRKSRC}/configure
	${SUBST_CMD} ${WRKSRC}/qjackctl.pro
	${SUBST_CMD} ${WRKSRC}/src/src.pro
	${SUBST_CMD} ${WRKSRC}/configure.ac

NO_REGRESS =		Yes

.include <bsd.port.mk>
