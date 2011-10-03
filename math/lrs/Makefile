# $OpenBSD: Makefile.template,v 1.60 2010/10/24 20:41:23 ajacoutot Exp $

COMMENT =		solve vertex enumeration and convex hull problems

DISTNAME =		lrslib-042c
PKGNAME =		lrs-042

CATEGORIES =		math

HOMEPAGE =		http://cgm.cs.mcgill.ca/~avis/C/lrs.html

MAINTAINER =		Edd Barrett <edd@openbsd.org>

# GPLv2
PERMIT_PACKAGE_CDROM =	Yes
PERMIT_PACKAGE_FTP =	Yes
PERMIT_DISTFILES_CDROM =Yes
PERMIT_DISTFILES_FTP =	Yes

WANTLIB =		c gmp

MASTER_SITES =		http://cgm.cs.mcgill.ca/~avis/C/lrslib/

MAKE_FILE =		makefile
MAKE_FLAGS =		CPPFLAGS=-I${LOCALBASE}/include LDFLAGS=-L${LOCALBASE}/lib
ALL_TARGET =		gmp	# build with arbitrary precision numbers

LIB_DEPENDS =		devel/gmp

NO_REGRESS =		Yes

BINARIES =		glrs gnash 2gnash gredund
do-install:
.for i in ${BINARIES}
	${INSTALL_PROGRAM} ${WRKBUILD}/${i} ${PREFIX}/bin/
.endfor

.include <bsd.port.mk>
