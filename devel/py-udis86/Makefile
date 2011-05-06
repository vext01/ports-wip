# $OpenBSD: Makefile.template,v 1.60 2010/10/24 20:41:23 ajacoutot Exp $

COMMENT =		Python bindings for udis86

V =			1.0.0
DISTNAME =		pyudis86-${V}
PKGNAME =		py-udis86-${V}

CATEGORIES =		devel

HOMEPAGE =		https://github.com/sbz/pyudis86/

MAINTAINER =		Edd Barrett <edd@openbsd.org>

# 3-clause BSD
PERMIT_PACKAGE_CDROM =	Yes
PERMIT_PACKAGE_FTP =	Yes
PERMIT_DISTFILES_CDROM =Yes
PERMIT_DISTFILES_FTP =	Yes

WANTLIB =		udis86

MASTER_SITES =		https://github.com/downloads/sbz/pyudis86/

MODULES =		lang/python
LIB_DEPENDS =		devel/udis86

NO_REGRESS =		Yes

post-install:
	${INSTALL_SCRIPT_DIR} ${PREFIX}/share/examples/py-udis86
	${INSTALL_SCRIPT} ${WRKSRC}/examples/sample.py \
		${PREFIX}/share/examples/py-udis86

.include <bsd.port.mk>
