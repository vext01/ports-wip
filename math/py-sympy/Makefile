# $OpenBSD$

COMMENT =		Computer algebra system (CAS) in Python

MODPY_EGG_VERSION =	0.7.1
DISTNAME =		sympy-${MODPY_EGG_VERSION}
PKGNAME =		py-sympy-${MODPY_EGG_VERSION}
CATEGORIES =		math

HOMEPAGE =		http://sympy.org

MAINTAINER =		Wen Heping <wenheping@gmail.com>

# BSD
PERMIT_PACKAGE_CDROM =	Yes
PERMIT_PACKAGE_FTP =	Yes
PERMIT_DISTFILES_CDROM =Yes
PERMIT_DISTFILES_FTP =	Yes

MASTER_SITES =		${MASTER_SITE_PYPI:=s/sympy/} \
			http://sympy.googlecode.com/files/

MODULES =		lang/python
RUN_DEPENDS =		devel/ipython

do-regress:
	        cd ${WRKSRC} && ${MODPY_BIN} setup.py test

post-install:
	mv ${PREFIX}/share/man/man1/isympy.1 ${PREFIX}/man/man1/


.include <bsd.port.mk>
