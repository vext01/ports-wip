# $OpenBSD: Makefile.template,v 1.60 2010/10/24 20:41:23 ajacoutot Exp $

COMMENT =		GMP bindings for OCaml

V =			0.13
DISTNAME =		mlgmp-${V}
PKGNAME =		ocaml-gmp-${V}

CATEGORIES =		math
HOMEPAGE =		http://caml.inria.fr/cgi-bin/hump.en.cgi?contrib=278
MAINTAINER =		Edd Barrett <edd@openbsd.org>

# XXX
PERMIT_PACKAGE_CDROM =	Yes
PERMIT_PACKAGE_FTP =	Yes
PERMIT_DISTFILES_CDROM =Yes
PERMIT_DISTFILES_FTP =	Yes

MASTER_SITES =		http://theunixzoo.co.uk/files/

MODULES =		lang/ocaml
BUILD_DEPENDS =		devel/gmp
RUN_DEPENDS =		devel/gmp	# dlopen? XXX

USE_GMAKE =		Yes

# overide their site specific include/lib paths
MAKE_FLAGS +=		GMP_LIBDIR=${LOCALBASE}/lib
MAKE_FLAGS +=		GMP_INCLUDES=-I${LOCALBASE}/include
MAKE_FLAGS +=		CFLAGS_MISC="${CFLAGS}"

# XXX native PFRAG

# make dependencies are screwed up in the release tarball
pre-build:
	cd ${WRKBUILD} && ${MAKE_PROGRAM} clean

.include <bsd.port.mk>
