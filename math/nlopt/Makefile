# $OpenBSD: Makefile.template,v 1.60 2010/10/24 20:41:23 ajacoutot Exp $

COMMENT =		library for nonlinear optimization

DISTNAME =		nlopt-2.2.4

SHARED_LIBS +=  nlopt                     0.0 # 6.2
SHARED_LIBS +=  nlopt_guile               0.0 # 6.2

CATEGORIES =		math

HOMEPAGE =		http://ab-initio.mit.edu/wiki/index.php/NLopt

MAINTAINER =		Edd Barrett <edd@openbsd.org>

# LGPL
PERMIT_PACKAGE_CDROM =	Yes
PERMIT_PACKAGE_FTP =	Yes
PERMIT_DISTFILES_CDROM =Yes
PERMIT_DISTFILES_FTP =	Yes

WANTLIB +=		blas cruft fftw3 g2c lapack m ncurses octave octinterp
WANTLIB +=		readline stdc++ z

MASTER_SITES =		http://ab-initio.mit.edu/nlopt/

MODULES =		lang/python
BUILD_DEPENDS =		math/octave \
			math/py-numpy
RUN_DEPENDS =		${BUILD_DEPENDS}
USE_LIBTOOL =		Yes

CONFIGURE_STYLE =	gnu
CONFIGURE_ARGS +=	${CONFIGURE_SHARED}

.include <bsd.port.mk>
