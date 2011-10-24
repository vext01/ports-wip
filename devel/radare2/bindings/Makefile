# $OpenBSD: Makefile,v 1.1.1.1 2011/07/21 01:35:51 edd Exp $

COMMENT =		Vala bindings for Radare2

DISTNAME =		r2-bindings-${V}
PKGNAME =		radare-bindings2-${V}

BUILD_DEPENDS =		devel/radare2/main>=${V}
RUN_DEPENDS =		lang/vala \
			devel/radare2/main>=${V}
MODULES =		lang/python

CONFIGURE_STYLE =	simple
CONFUGURE_ARGS =	--enable=python

MAKE_FLAGS =		PYTHON_VERSION=${MODPY_VERSION}

PKG_ARCH =		*

# fails to pick up python
post-configure:
	echo "python" >> ${WRKSRC}/supported.langs

.include <bsd.port.mk>
