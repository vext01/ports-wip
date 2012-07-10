# $OpenBSD: Makefile.template,v 1.61 2012/03/29 13:41:58 sthen Exp $
#
COMMENT =		core library for sigrok

V =			0.1.1
DISTNAME =		libsigrok-${V}

SHARED_LIBS +=  	sigrok 		0.0 # 0.0

WANTLIB += ftdi glib-2.0 gthread-2.0 iconv intl pcre usb usb-1.0
WANTLIB += z zip

LIB_DEPENDS =		devel/libftdi \
			devel/glib2 \
			devel/libusb1 \
			archivers/libzip

#USE_LIBTOOL =		Yes

CONFIGURE_STYLE =	gnu

.include <bsd.port.mk>
