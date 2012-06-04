# $OpenBSD: Makefile.template,v 1.61 2012/03/29 13:41:58 sthen Exp $

COMMENT =		source code editor and build tool for OCaml

DISTNAME =		ocamleditor-1.7.2
CATEGORIES =		editors devel
HOMEPAGE =		http://ocamleditor.forge.ocamlcore.org
MAINTAINER =		Edd Barrett <edd@openbsd.org>

# GPLv3
PERMIT_PACKAGE_CDROM =	Yes
PERMIT_PACKAGE_FTP =	Yes
PERMIT_DISTFILES_CDROM =Yes
PERMIT_DISTFILES_FTP =	Yes

# Needs it's own source and parts of the ocaml compiler tree too
OCAML_BASEVERSION = \
	${OCAML_VERSION:C/([[:digit:]]+\.[[:digit:]]+)\.[[:digit:]]+/\1/}
# When updating, it is not enough to bump DISTNAME version since
# the url suffix changes per release.
MASTER_SITES =	https://forge.ocamlcore.org/frs/download.php/858/
MASTER_SITES0 =	http://caml.inria.fr/pub/distrib/ocaml-${OCAML_BASEVERSION}/

DISTFILES =	${DISTNAME}${EXTRACT_SUFX} \
		ocaml-${OCAML_VERSION}${EXTRACT_SUFX}:0

MODULES=	lang/ocaml

LIB_DEPENDS =	x11/gtk+2
RUN_DEPENDS =	textproc/ocaml-xml-light \
		x11/lablgtk2
BUILD_DEPENDS =	${RUN_DEPENDS}

WANTLIB += GL X11 Xcomposite Xcursor Xdamage Xext Xfixes Xi Xinerama
WANTLIB += Xrandr Xrender atk-1.0 c cairo expat fontconfig freetype
WANTLIB += gdk-x11-2.0 gdk_pixbuf-2.0 gio-2.0 glib-2.0 gobject-2.0
WANTLIB += gtk-x11-2.0 iconv intl m pango-1.0 pangocairo-1.0 pangoft2-1.0
WANTLIB += pixman-1 png pthread pthread-stubs xcb xcb-render xcb-shm
WANTLIB += z

post-extract:
	mkdir ${WRKBUILD}/src/ocaml-src && \
	for i in utils parsing typing; do \
	    cp -r \
		${WRKDIR}/ocaml-${OCAML_VERSION}/$$i \
		${WRKSRC}/src/ocaml-src; \
	done

do-build:
	cd ${WRKBUILD} && ocaml build.ml -with-compiler-libs

do-install:
	cd ${WRKBUILD} && ocaml build.ml -install -prefix ${PREFIX}

.include <bsd.port.mk>
