# $OpenBSD: Makefile.template,v 1.60 2010/10/24 20:41:23 ajacoutot Exp $

COMMENT =		OCaml library manager

# http://download.camlcity.org/download/findlib-1.2.7.tar.gz
V =			1.2.7
DISTNAME =		findlib-${V}
PKGNAME =		ocaml-findlib-${V}

#SHARED_LIBS =		???

CATEGORIES =		devel

HOMEPAGE =		http://ocaml-glpk.sourceforge.net/

MAINTAINER =		Edd Barrett <edd@openbsd.org>

# XXX
PERMIT_PACKAGE_CDROM =	Yes
PERMIT_PACKAGE_FTP =	Yes
PERMIT_DISTFILES_CDROM =Yes
PERMIT_DISTFILES_FTP =	Yes

WANTLIB =		c curses m pthread

MASTER_SITES =		http://download.camlcity.org/download/

MODULES =		lang/ocaml
LIB_DEPENDS =		devel/glpk

USE_GMAKE =		Yes
CONFIGURE_STYLE =	simple

NO_REGRESS =		Yes

# patch in correct SYSCONFDIR path for config file
pre-configure:
	${SUBST_CMD} ${WRKSRC}/configure

post-install:
	mkdir ${PREFIX}/share/examples/ocaml-findlib/
	mv ${WRKINST}/${SYSCONFDIR}/findlib.conf ${PREFIX}/share/examples/ocaml-findlib/

.include <bsd.port.mk>
