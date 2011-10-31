# $OpenBSD$

COMMENT =	symbolic mathematics for Python

DISTNAME =	sympy-0.7.1
CATEGORIES =	math

HOMEPAGE =	http://sympy.org

MAINTAINER =	Edd Barrett <edd@openbsd.org>

# XXX
PERMIT_PACKAGE_CDROM =	Yes
PERMIT_PACKAGE_FTP =	Yes
PERMIT_DISTFILES_CDROM =Yes
PERMIT_DISTFILES_FTP =	Yes

MASTER_SITES =		http://sympy.googlecode.com/files/

MODULES =	lang/python
RUN_DEPENDS =	devel/ipython

NO_REGRESS =	Yes

#pre-configure:
#	@find ${WRKDIST} -name \*.py | \
#		xargs perl -pi -e 's,/usr/bin/env python,${MODPY_BIN},g'

.include <bsd.port.mk>
