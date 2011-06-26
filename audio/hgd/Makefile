# $OpenBSD: Makefile,v 1.4 2011/04/22 08:21:28 edd Exp $

COMMENT =		music system for hackathons
DISTNAME =		hgd-0.4.0

CATEGORIES =		audio net
HOMEPAGE =		https://github.com/vext01/hgd/

MAINTAINER =		Edd Barrett <edd@openbsd.org>

FLAVORS =		python
FLAVOR ?=

# ISC
PERMIT_PACKAGE_CDROM =	Yes
PERMIT_PACKAGE_FTP =	Yes
PERMIT_DISTFILES_CDROM =Yes
PERMIT_DISTFILES_FTP =	Yes

WANTLIB =		c config crypto ssl sqlite3 tag tag_c

MASTER_SITES =		https://github.com/downloads/vext01/hgd/

CONFIGURE_STYLE =	gnu
CONFIGURE_ARGS =	--with-taglib \
			--with-libconfig

RUN_DEPENDS =		x11/mplayer
LIB_DEPENDS =		databases/sqlite3 \
			devel/libconfig \
			audio/taglib

.if ${FLAVOR:L:Mpython}
LIB_DEPENDS +=		${MODPY_LIB_DEPENDS}
WANTLIB +=		${MODPY_WANTLIB}
WANTLIB +=		m pthread util
MODULES =		lang/python
CONFIGURE_ARGS +=	--with-python=${MODPY_VERSION}
PKG_ARGS +=		-Dpython=1
.else
CONFIGURE_ARGS +=	--without-python
PKG_ARGS +=		-Dpython=0
.endif

NO_REGRESS =		Yes

# sub in correct paths
pre-configure:
	${SUBST_CMD} ${WRKSRC}/pydoc/txt/hgd.doccer.txt
	${SUBST_CMD} ${WRKSRC}/pydoc/txt/hgd.playlist.txt
	${SUBST_CMD} ${WRKSRC}/pydoc/txt/index.txt

.include <bsd.port.mk>
