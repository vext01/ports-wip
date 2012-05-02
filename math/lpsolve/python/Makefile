# $OpenBSD: Makefile,v 1.1.1.1 2012/04/20 09:54:11 edd Exp $

COMMENT =		Python bindings for lpsolve
DISTNAME =		lp_solve_${V}_Python_source
MODPY_EGG_VERSION =	5.5.0.9	# interface version differs from release vers
PKGNAME =		py-lpsolve-${V}

LIB_DEPENDS +=		math/lpsolve/core \
			${MODFORTRAN_LIB_DEPENDS}
BUILD_DEPENDS +=	math/py-numpy
RUN_DEPENDS +=		math/py-numpy

MODULES =		lang/python fortran
MODFORTRAN_COMPILER =	gfortran

WRKDIST =		${WRKDIR}/lp_solve_${V_MAJOR}/extra/Python
CFLAGS +=		"-Wl,--export-dynamic"

WANTLIB +=		lpsolve55 ${MODFORTRAN_WANTLIB} ${MODPY_WANTLIB}

NUMPY_PATH =		${MODPY_LIBDIR}/site-packages/numpy/core/include
SUBST_VARS +=		NUMPY_PATH MODFORTRAN_WANTLIB
pre-configure:
	${SUBST_CMD} ${WRKBUILD}/setup.py

NO_REGRESS =		Yes

.include <bsd.port.mk>
