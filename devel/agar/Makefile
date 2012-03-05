# $OpenBSD: Makefile.template,v 1.60 2010/10/24 20:41:23 ajacoutot Exp $

COMMENT =		graphical toolkit based on SDL

DISTNAME =		agar-1.4.1

SHARED_LIBS +=  ag_core                   0.0 # 4.0
SHARED_LIBS +=  ag_dev                    0.0 # 4.0
SHARED_LIBS +=  ag_gui                    0.0 # 4.0
SHARED_LIBS +=  ag_math                   0.0 # 4.0
SHARED_LIBS +=  ag_rg                     0.0 # 4.0
SHARED_LIBS +=  ag_vg                     0.0 # 4.0

CATEGORIES =		devel graphics

HOMEPAGE =		http://libagar.org

MAINTAINER =		Edd Barrett <edd@openbsd.org>

# BSD
PERMIT_PACKAGE_CDROM =	Yes
PERMIT_PACKAGE_FTP =	Yes
PERMIT_DISTFILES_CDROM =Yes
PERMIT_DISTFILES_FTP =	Yes

MASTER_SITES =		${MASTER_SITE_SOURCEFORGE:=agar/}

LIB_DEPENDS =		devel/sdl \
			graphics/jpeg \
			graphics/png

USE_GMAKE =		Yes
USE_LIBTOOL =		Yes
CONFIGURE_STYLE =	simple
CONFIGURE_ARGS =	--prefix=${PREFIX}

# double primes DESTDIR
FAKE_FLAGS +=		DESTDIR=""

.include <bsd.port.mk>
