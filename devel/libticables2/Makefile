# $OpenBSD: Makefile.template,v 1.60 2010/10/24 20:41:23 ajacoutot Exp $

COMMENT =		interface with Texas instruments calculators

DISTNAME =		libticables2-1.3.2

SHARED_LIBS +=		ticables2	0.0 # 4.0

CATEGORIES =		devel

HOMEPAGE =		http://lpg.ticalc.org/prj_tilp/

MAINTAINER =		Edd Barrett <edd@openbsd.org>

# GPLv2
PERMIT_PACKAGE_CDROM =	Yes
PERMIT_PACKAGE_FTP =	Yes
PERMIT_DISTFILES_CDROM =Yes
PERMIT_DISTFILES_FTP =	Yes

WANTLIB +=		glib-2.0 iconv intl pcre usb

MASTER_SITES =		XXX
EXTRACT_SUFX =		.tar.bz2

LIB_DEPENDS =		devel/libusb \
			devel/glib2

USE_LIBTOOL =		Yes
CONFIGURE_STYLE =	gnu

.include <bsd.port.mk>
