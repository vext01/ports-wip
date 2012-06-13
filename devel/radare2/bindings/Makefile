# $OpenBSD: Makefile,v 1.1.1.1 2011/07/21 01:35:51 edd Exp $

COMMENT =		Vala bindings for Radare2

PKGNAME =		radare-bindings2-${V}

BUILD_DEPENDS =		devel/radare2/main>=${V}
RUN_DEPENDS =		lang/vala \
			devel/radare2/main>=${V}

WRKDIST =		${WRKDIR}/radare2-${V}/r2-bindings

PKG_ARCH =		*

CONFIGURE_ENV +=	PYTHON_CONFIG=python2.7-config
CONFIGURE_ARGS =	--enable-devel --enable=python,vala

# This would go if we wanted to package other bindings.
#NO_BUILD =		Yes

# Only install vala bindings for now. Maybe more in the future.
#INSTALL_TARGET =	install-vapi

.include <bsd.port.mk>
