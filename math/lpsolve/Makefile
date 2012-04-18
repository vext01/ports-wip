# $OpenBSD: Makefile.template,v 1.61 2012/03/29 13:41:58 sthen Exp $

COMMENT =		mixed integer linear programming solver

V_MAJOR =		5.5
V =			${V_MAJOR}.2.0
DISTNAME =		lp_solve_${V}_source
PKGNAME =		lpsolve-${V}
WRKDIST =		${WRKDIR}/lp_solve_${V_MAJOR}

SHARED_LIBS =		lpsolve55	0.0	# unversioned upstream

CATEGORIES =		math devel

HOMEPAGE =		http://lpsolve.sourceforge.net

MAINTAINER =		Edd Barrett <edd@openbsd.org>

# LGPL
# Also contains static LUSOL library which is also LGPL2
PERMIT_PACKAGE_CDROM =	Yes
PERMIT_PACKAGE_FTP =	Yes
PERMIT_DISTFILES_CDROM =Yes
PERMIT_DISTFILES_FTP =	Yes

WANTLIB +=		c m

MASTER_SITES =		${MASTER_SITE_SOURCEFORGE:=lpsolve/}

# Docs are distributed separately
DOCDISTFILE =		lp_solve_5.5.2.0_doc${EXTRACT_SUFX}
DISTFILES +=		${DOCDISTFILE}
EXTRACT_ONLY =		${DISTNAME}${EXTRACT_SUFX}

# Build is a series of shell scripts
MAKE_ENV +=	CC=${CC} LIBlpsolve55_VERSION=${LIBlpsolve55_VERSION}
do-build:
	cd ${WRKSRC}/lpsolve55 && \
		${MAKE_ENV} sh -x ccc
	cd ${WRKSRC}/lp_solve && ${MAKE_ENV} sh -x ccc

do-install:
	@# Libs
	${INSTALL_DATA} ${WRKSRC}/lpsolve55/bin/liblpsolve55.a ${PREFIX}/lib/
	${INSTALL_DATA} \
		${WRKSRC}/lpsolve55/bin/liblpsolve55.so.${LIBlpsolve55_VERSION} \
		${PREFIX}/lib/
	@# Headers	
	${INSTALL_DATA_DIR} ${PREFIX}/include/lpsolve/
.for i in declare.h fortify.h ini.h lp_*.h lpkit.h lpsolve.h ufortify.h yacc_read.h
		${INSTALL_DATA} ${WRKSRC}/${i} ${PREFIX}/include/lpsolve/
.endfor
	@# Standalone solver
	${INSTALL_PROGRAM} ${WRKSRC}/lp_solve/bin/lp_solve ${PREFIX}/bin/

# Install docs from separate docs tarball
DOCDIR =	${PREFIX}/share/doc/lpsolve
post-install:
	${INSTALL_DATA_DIR} ${DOCDIR}
	${TAR} zxf ${DISTDIR}/${DOCDISTFILE} -C ${DOCDIR}
	chown -R ${SHAREOWN}:${SHAREGRP} ${DOCDIR}

NO_REGRESS =		Yes

.include <bsd.port.mk>
