# $OpenBSD: Makefile.template,v 1.61 2012/03/29 13:41:58 sthen Exp $
#
COMMENT =		protocol decoder library for sigrok

V =			0.1.0
DISTNAME =		libsigrokdecode-${V}

SHARED_LIBS +=  	sigrokdecode 		0.0 # 0.0

LIB_DEPENDS =		devel/glib2
MODULES +=		lang/python \
			devel/gettext
WANTLIB +=		${MODPY_WANTLIB} glib-2.0 m util

MODPY_VERSION =		${MODPY_DEFAULT_VERSION_3}

CONFIGURE_STYLE =	gnu

.include <bsd.port.mk>
