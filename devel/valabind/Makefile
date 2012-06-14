# $OpenBSD: Makefile.template,v 1.61 2012/03/29 13:41:58 sthen Exp $


COMMENT =		vala to swig interface convertor
DISTNAME =		valabind-20120614
CATEGORIES =		devel

HOMEPAGE =		http://hg.youterm.com/valabind
MAINTAINER =		Edd Barrett <edd@openbsd.org>

# GPLv2
PERMIT_PACKAGE_CDROM =	Yes
PERMIT_PACKAGE_FTP =	Yes
PERMIT_DISTFILES_CDROM =Yes
PERMIT_DISTFILES_FTP =	Yes

WANTLIB +=		c glib-2.0 gobject-2.0 iconv intl pthread vala-0.16

MASTER_SITES =		http://theunixzoo.co.uk/files/

BUILD_DEPENDS =		lang/vala
LIB_DEPENDS =		lang/vala

USE_GMAKE =		Yes

# prevents double prefixing
FAKE_FLAGS =		DESTDIR= MANDIR=${DESTDIR}${PREFIX}/man

#NO_REGRESS =		Yes

.include <bsd.port.mk>
