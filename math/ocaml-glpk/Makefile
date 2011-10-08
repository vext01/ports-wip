# $OpenBSD: Makefile.template,v 1.60 2010/10/24 20:41:23 ajacoutot Exp $

COMMENT =		glpk bindings for OCaml

DISTNAME =		ocaml-glpk-0.1.6

CATEGORIES =		math

HOMEPAGE =		http://ocaml-glpk.sourceforge.net/

MAINTAINER =		Edd Barrett <edd@openbsd.org>

# GPLv2
PERMIT_PACKAGE_CDROM =	Yes
PERMIT_PACKAGE_FTP =	Yes
PERMIT_DISTFILES_CDROM =Yes
PERMIT_DISTFILES_FTP =	Yes

WANTLIB =		glpk

MASTER_SITES =		${MASTER_SITE_SOURCEFORGE:=ocaml-glpk/}

MODULES =		lang/ocaml
LIB_DEPENDS =		devel/glpk

USE_GMAKE =		Yes
NO_REGRESS =		Yes

MAKE_ENV +=		"CPPFLAGS=-I${LOCALBASE}/include LDFLAGS=-L${LOCALBASE}/lib"

pre-install:
	touch ${WRKBUILD}/src/ld.conf.dummy
	mkdir -p ${PREFIX}/lib/ocaml/site-lib/glpk/

.include <bsd.port.mk>
