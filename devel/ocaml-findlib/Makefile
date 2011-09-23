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

#WANTLIB =		???

MASTER_SITES =		http://download.camlcity.org/download/

MODULES =		lang/ocaml
#BUILD_DEPENDS =	???
#RUN_DEPENDS =		???
LIB_DEPENDS =		devel/glpk
#REGRESS_DEPENDS =	???

USE_GMAKE =		Yes
CONFIGURE_STYLE =	simple

#NO_REGRESS =		Yes
#MAKE_ENV +=		"CPPFLAGS=-I${LOCALBASE}/include LDFLAGS=-L${LOCALBASE}/lib"

.include <bsd.port.mk>
