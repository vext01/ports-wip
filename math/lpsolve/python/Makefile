# $OpenBSD: Makefile,v 1.1.1.1 2012/04/20 09:54:11 edd Exp $

COMMENT =		Python bindings for lpsolve
DISTNAME =		lp_solve_5.5.2.0_Python_source
MODPY_EGG_VERSION =	5.5.0.9	# interface version differs from release version
PKGNAME =		py-lpsolve-${V}

LIB_DEPENDS +=		math/lpsolve/core
BUILD_DEPENDS +=	math/py-numpy
RUN_DEPENDS +=		math/py-numpy

MODULES =		lang/python

WRKDIST =		${WRKDIR}/lp_solve_${V_MAJOR}/extra/Python
BUILD_ENV +=		CFLAGS=-I/usr/local/include/lpsolve

# LGPLv2.1
PERMIT_PACKAGE_CDROM =	Yes
PERMIT_PACKAGE_FTP =	Yes
PERMIT_DISTFILES_CDROM =Yes
PERMIT_DISTFILES_FTP =	Yes

WANTLIB += lpsolve55 python2.7

NUMPY_PATH =		${MODPY_LIBDIR}/site-packages/numpy/core/include
SUBST_VARS +=		NUMPY_PATH
pre-configure:
	${SUBST_CMD} ${WRKBUILD}/setup.py

NO_REGRESS =		Yes

.include <bsd.port.mk>
