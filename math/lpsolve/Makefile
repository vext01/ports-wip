# $OpenBSD: Makefile.template,v 1.61 2012/03/29 13:41:58 sthen Exp $

COMMENT =		mixed integer linear programming solver

V =			5.5.2.0
DISTNAME =		lp_solve_${V}_source
PKGNAME =		lpsolve-${V}
WRKDIST =		${WRKDIR}/lp_solve_5.5

#SHARED_LIBS =		???

CATEGORIES =		math devel

HOMEPAGE =		http://lpsolve.sourceforge.net

MAINTAINER =		Edd Barrett <edd@openbsd.org>

# LGPL
PERMIT_PACKAGE_CDROM =	Yes
PERMIT_PACKAGE_FTP =	Yes
PERMIT_DISTFILES_CDROM =Yes
PERMIT_DISTFILES_FTP =	Yes

#WANTLIB =		???

MASTER_SITES =		${MASTER_SITE_SOURCEFORGE:=lpsolve/}

do-build:
	cd ${WRKSRC}/lpsolve55 && sh ccc
	cd ${WRKSRC}/lp_solve && sh ccc

#MODULES =		???
#BUILD_DEPENDS =	???
#RUN_DEPENDS =		???
#LIB_DEPENDS =		???
#REGRESS_DEPENDS =	???

#USE_GMAKE =		Yes
#USE_GROFF =		Yes
#USE_LIBTOOL =		Yes
#CONFIGURE_STYLE =	

#NO_REGRESS =		Yes

.include <bsd.port.mk>
