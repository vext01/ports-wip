# $OpenBSD: Makefile.template,v 1.60 2010/10/24 20:41:23 ajacoutot Exp $

COMMENT =		next generation typesetter

# http://foundry.supelec.fr/gf/download/frsrelease/392/1730/luatex-beta-0.70.1.tar.bz2
DISTNAME =		luatex-beta-0.70.1
PKGNAME =		luatex-0.70.1

#SHARED_LIBS =		???

CATEGORIES =		print textproc

HOMEPAGE =		http://www.luatex.org/

MAINTAINER =		Edd Barrett <edd@openbsd.org>

# XXX
PERMIT_PACKAGE_CDROM =	Yes
PERMIT_PACKAGE_FTP =	Yes
PERMIT_DISTFILES_CDROM =Yes
PERMIT_DISTFILES_FTP =	Yes

BUILD_DEPENDS =		shells/bash
#WANTLIB =		???

MASTER_SITES =		http://foundry.supelec.fr/gf/download/frsrelease/392/1730/
EXTRACT_SUFX =		.tar.bz2

DIST_SUBDIR =		luatex-beta-0.70.1
CONFIGURE_STYLE =	simple
CONFIGURE_SCRIPT =	build.sh


#USE_GMAKE =		Yes
#USE_GROFF =		Yes

#NO_REGRESS =		Yes

.include <bsd.port.mk>
