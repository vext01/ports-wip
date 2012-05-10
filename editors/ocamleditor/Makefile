# $OpenBSD: Makefile.template,v 1.61 2012/03/29 13:41:58 sthen Exp $

COMMENT =		source code editor and build tool for OCaml

DISTNAME =		ocamleditor-1.7.2

#SHARED_LIBS =		???

CATEGORIES =		editors devel

HOMEPAGE =		http://ocamleditor.forge.ocamlcore.org

MAINTAINER =		Edd Barrett <edd@openbsd.org>

# GPLv3
PERMIT_PACKAGE_CDROM =	Yes
PERMIT_PACKAGE_FTP =	Yes
PERMIT_DISTFILES_CDROM =Yes
PERMIT_DISTFILES_FTP =	Yes

# Needs it's own source and parts of the ocaml compiler tree too
OCAML_V =	3.12	# must be the same as lang/ocaml
OCAML_MINOR_V =	1
# Not when updating, it is not enough to bump DISTNAME version
# the url suffix changes per release.
MASTER_SITES =	https://forge.ocamlcore.org/frs/download.php/858/
MASTER_SITES0 =	http://caml.inria.fr/pub/distrib/ocaml-${OCAML_V}/

DISTFILES =	${DISTNAME}${EXTRACT_SUFX} \
		ocaml-${OCAML_V}.${OCAML_MINOR_V}${EXTRACT_SUFX}:0
#WRKDIST =	${WRKDIR}/ocamleditor

LIB_DEPENDS =		textproc/ocaml-xml-light \
			x11/lablgtk2 \
			x11/gtk+2

WANTLIB += GL X11 Xcomposite Xcursor Xdamage Xext Xfixes Xi Xinerama
WANTLIB += Xrandr Xrender atk-1.0 c cairo expat fontconfig freetype
WANTLIB += gdk-x11-2.0 gdk_pixbuf-2.0 gio-2.0 glib-2.0 gobject-2.0
WANTLIB += gtk-x11-2.0 iconv intl m pango-1.0 pangocairo-1.0 pangoft2-1.0
WANTLIB += pixman-1 png pthread pthread-stubs xcb xcb-render xcb-shm
WANTLIB += z

OCAML_SOURCES =		${WRKDIR}/ocaml-${OCAML_V}.${OCAML_MINOR_V}
do-build:
	mkdir ${WRKBUILD}/src/ocaml-src && \
		for i in utils parsing typing; do \
		cp -r ${OCAML_SOURCES}/$$i ${WRKSRC}/src/ocaml-src; done && \
		cd ${WRKBUILD} && ocaml build.ml -with-compiler-libs

# spits out binaries (postfixed .opt) or bytecodes (no postfix)
# depending upon arch - unify names so we dont have to do
# special PLIST dances.
post-build:
	if [ -e ${WRKBUILD}/src/ocamleditor.opt ]; then \
		mv ${WRKBUILD}/src/ocamleditor.opt \
		${WRKBUILD}/src/ocamleditor; \
		mv ${WRKBUILD}/src/oebuild/oebuild.opt \
		${WRKBUILD}/src/oebuild/oebuild; fi

PIXMAP_DIR =	${PREFIX}/share/pixmaps/ocamleditor
do-install:
	${INSTALL_PROGRAM} ${WRKBUILD}/src/ocamleditor ${PREFIX}/bin/
	${INSTALL_PROGRAM} ${WRKBUILD}/src/oebuild/oebuild ${PREFIX}/bin/
	${INSTALL_DATA_DIR} ${PIXMAP_DIR}
	cp -r ${WRKBUILD}/pixmaps/* ${PIXMAP_DIR}
	chown -R ${SHAREOWN}:${SHAREGRP} ${PIXMAP_DIR}

.include <bsd.port.mk>
