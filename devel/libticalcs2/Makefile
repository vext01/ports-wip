# $OpenBSD: Makefile.template,v 1.60 2010/10/24 20:41:23 ajacoutot Exp $

COMMENT =		utility library for texas instruments calculators

DISTNAME =		libticalcs2-1.1.6

SHARED_LIBS +=		ticalcs2	0.0 # 9.3

CATEGORIES =		devel

HOMEPAGE =		http://lpg.ticalc.org/prj_tilp/

MAINTAINER =		Edd Barrett <edd@openbsd.org>

# GPLv2
PERMIT_PACKAGE_CDROM =	Yes
PERMIT_PACKAGE_FTP =	Yes
PERMIT_DISTFILES_CDROM =Yes
PERMIT_DISTFILES_FTP =	Yes

WANTLIB +=		glib-2.0 iconv intl pcre ticables2 ticonv tifiles2
WANTLIB +=		usb z

MASTER_SITES =		XXX
EXTRACT_SUFX =		.tar.bz2

LIB_DEPENDS =		devel/glib2 \
			devel/libticonv \
			devel/libtifiles2 \
			devel/libticables2

USE_LIBTOOL =		Yes
CONFIGURE_STYLE =	gnu

.include <bsd.port.mk>
