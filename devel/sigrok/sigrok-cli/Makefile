# $OpenBSD: Makefile.template,v 1.61 2012/03/29 13:41:58 sthen Exp $
#
COMMENT =		protocol decoder library for sigrok

V =			0.3.1
DISTNAME =		sigrok-cli-${V}

LIB_DEPENDS =		devel/glib2 \
			devel/sigrok/libsigrok \
			devel/sigrok/libsigrokdecode

WANTLIB += c ftdi glib-2.0 gthread-2.0 iconv intl m pcre pthread
WANTLIB += python3.2m sigrok sigrokdecode usb usb-1.0 util z zip

CONFIGURE_STYLE =	gnu

.include <bsd.port.mk>
