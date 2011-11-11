# $OpenBSD: Makefile.template,v 1.60 2010/10/24 20:41:23 ajacoutot Exp $

COMMENT =		conversion library for texas instruments calculators

DISTNAME =		libticonv-1.1.2

SHARED_LIBS +=		ticonv	0.0 # 5.4

CATEGORIES =		devel

HOMEPAGE =		http://lpg.ticalc.org/prj_tilp/

MAINTAINER =		Edd Barrett <edd@openbsd.org>

# GPLv2
PERMIT_PACKAGE_CDROM =	Yes
PERMIT_PACKAGE_FTP =	Yes
PERMIT_DISTFILES_CDROM =Yes
PERMIT_DISTFILES_FTP =	Yes

WANTLIB +=		glib-2.0 iconv intl pcre

MASTER_SITES =		XXX
EXTRACT_SUFX =		.tar.bz2

LIB_DEPENDS =		converters/libiconv \
			devel/glib2

USE_LIBTOOL =		Yes
CONFIGURE_STYLE =	gnu
CONFIGURE_ARGS =	CFLAGS=-I${LOCALBASE}/include LDFLAGS=-L${LOCALBASE}/lib

.include <bsd.port.mk>
