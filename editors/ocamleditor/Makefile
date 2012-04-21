# $OpenBSD: Makefile.template,v 1.61 2012/03/29 13:41:58 sthen Exp $

COMMENT =		source code editor and build tool for OCaml

DISTNAME =		ocamleditor-1.7.0	

#SHARED_LIBS =		???

CATEGORIES =		editors devel

HOMEPAGE =		http://ocamleditor.forge.ocamlcore.org

MAINTAINER =		Edd Barrett <edd@openbsd.org>

# GPLv3
PERMIT_PACKAGE_CDROM =	Yes
PERMIT_PACKAGE_FTP =	Yes
PERMIT_DISTFILES_CDROM =Yes
PERMIT_DISTFILES_FTP =	Yes

#WANTLIB =		???

# Needs it's own source and parts of the ocaml compiler tree too
OCAML_V =	3.12	#must be the same as lang/ocaml
MASTER_SITES =	http://forge.ocamlcore.org/frs/download.php/844/
MASTER_SITES0 =	http://caml.inria.fr/pub/distrib/ocaml-${OCAML_V}/

DISTFILES =	${DISTNAME}${EXTRACT_SUFX} \
		ocaml-${OCAML_V}.1${EXTRACT_SUFX}:0
WRKDIST =	${WRKDIR}/ocamleditor

# Dependencies
#
#MODULES =		???
BUILD_DEPENDS =		textproc/ocaml-xml-light \
			x11/lablgtk2
#RUN_DEPENDS =		???
#LIB_DEPENDS =		???
#REGRESS_DEPENDS =	???

#MAKE_FLAGS =		???
#MAKE_ENV =		???
#FAKE_FLAGS =		???
#REGRESS_FLAGS =	???

#USE_GMAKE =		Yes
#USE_GROFF =		Yes
#NO_REGRESS =		Yes

.include <bsd.port.mk>
