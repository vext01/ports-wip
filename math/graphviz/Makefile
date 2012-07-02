# $OpenBSD: Makefile,v 1.46 2011/11/03 20:28:09 jasper Exp $

COMMENT-main=	graph drawing software

DISTNAME=	graphviz-2.28.0
PKGNAME-main=	${DISTNAME}
CATEGORIES=	math devel graphics

# there is only one multi-package due to legacy, but maybe more
# will appear in the form of language bindings.
MULTI_PACKAGES=	-main

# to let update-patches work in a simpler way
PATCHORIG=	.orig2

MASTER_SITES=	${HOMEPAGE}pub/graphviz/ARCHIVE/

SHARED_LIBS += gvplugin_core		1.0 # 6.0
SHARED_LIBS += gvplugin_gd		1.0 # 6.0
SHARED_LIBS += gvplugin_pango		1.0 # 6.0
SHARED_LIBS += gvplugin_dot_layout	1.0 # 6.0
SHARED_LIBS += gvplugin_neato_layout	1.0 # 6.0
SHARED_LIBS += gvplugin_xlib		1.0 # 6.0
SHARED_LIBS += gvplugin_gtk		1.0 # 6.0
SHARED_LIBS += gvplugin_gdk_pixbuf	0.0 # 6.0
SHARED_LIBS += gvplugin_rsvg		0.0 # 6.0

SHARED_LIBS += cdt			1.0 # 5.0
SHARED_LIBS += graph			2.0 # 5.0
SHARED_LIBS += pathplan			2.0 # 4.0
SHARED_LIBS += gvc			1.0 # 6.0
SHARED_LIBS += cgraph			0.0 # 6.0
SHARED_LIBS += gvpr			0.0 # 2.0
SHARED_LIBS += xdot			0.0 # 4.0
SHARED_LIBS += gdtclft			2.0 # unknown
SHARED_LIBS += tcldot			2.0 # unknown
SHARED_LIBS += tcldot_builtin		2.0 # unknown
SHARED_LIBS += tclplan			2.0 # unknown
SHARED_LIBS += tkspline			2.0 # unknown


HOMEPAGE=	http://www.graphviz.org/

MAINTAINER=	Marc Espie <espie@openbsd.org>

# Common public licence
PERMIT_DISTFILES_FTP=	Yes
PERMIT_DISTFILES_CDROM=	Yes
PERMIT_PACKAGE_FTP=	Yes
PERMIT_PACKAGE_CDROM=	Yes

MODULES=	devel/gettext \
		lang/tcl \
		perl
LIB_DEPENDS=	graphics/jpeg \
		graphics/png \
		devel/libtool,-ltdl \
		graphics/gd>=2.0.34 \
		x11/gnome/libgnomeui \
		x11/gtk+2 \
		www/libcroco \
		x11/gnome/librsvg
RUN_DEPENDS=	lang/guile
BUILD_DEPENDS=	devel/swig

WANTLIB += GL ICE SM X11 Xau Xaw Xcomposite Xcursor Xdamage Xdmcp
WANTLIB += Xext Xfixes Xi Xinerama Xmu Xpm Xrandr Xrender Xt Xxf86vm
WANTLIB += atk-1.0 c cairo croco-0.6 drm expat ffi fontconfig
WANTLIB += freetype gd gdk-x11-2.0 gdk_pixbuf-2.0 gio-2.0 glib-2.0
WANTLIB += gmodule-2.0 gobject-2.0 gthread-2.0 gtk-x11-2.0 jpeg
WANTLIB += ltdl m pango-1.0 pangocairo-1.0 pangoft2-1.0 pcre pixman-1
WANTLIB += png pthread pthread-stubs rsvg-2 stdc++ xcb xcb-render
WANTLIB += xcb-shm xml2 z

USE_LIBTOOL=	Yes
USE_GROFF =	Yes
CONFIGURE_STYLE=gnu
CONFIGURE_ARGS=	${CONFIGURE_SHARED} \
		--enable-tcl=yes \
		--enable-perl \
		--enable-guile \
		--with-tcl=${MODTCL_BIN} \
		--disable-lua \
		--disable-io \
		--disable-java \
		--disable-ocaml \
		--disable-php \
		--disable-python \
		--disable-ruby \
		--disable-rpath \
		--disable-sharp \
		--disable-R \
		--disable-gts \
		--without-ghostscript \
		--without-devil \
		--without-lasi \
		--without-qt \
		--without-glut \
		--with-gd

# XXX perl version
# XXX perl hack should not be needed, should come from config/config_perl.pl
CONFIGURE_ENV=	CPPFLAGS="-I${X11BASE}/include -I${LOCALBASE}/include -I/usr/libdata/perl5/${MACHINE_ARCH}-openbsd/5.12.2/CORE/" \
		LDFLAGS="-L${X11BASE}/lib -L${LOCALBASE}/lib" \
		TCLCONFIG=${LOCALBASE}/lib/tcl/tcl${MODTCL_VERSION}/tclConfig.sh \
		TKCONFIG=${LOCALBASE}/lib/tcl/tk${MODTCL_VERSION}/tkConfig.sh

DOCBASE=	${PREFIX}/share/doc/graphviz
EXBASE=		${PREFIX}/share/examples/graphviz

FAKE_FLAGS=	htmldir="${DOCBASE}/html" \
		pdfdir="${DOCBASE}/pdf" \
		txtdir="${DOCBASE}" \
		demodir="${EXBASE}/demo" \
		directeddir="${EXBASE}/graphs/directed" \
		leftydir="${EXBASE}/lefty" \
		pathplanexampledir="${EXBASE}/demo/pathplan_data" \
		undirecteddir="${EXBASE}/graphs/undirected"

post-build:
.for CMD in dotty lneato
	echo "#! /bin/ksh" >${WRKBUILD}/cmd/${CMD}/${CMD}
	echo ': $${LEFTYPATH:=$(LOCALBASE)/share/examples/graphviz/lefty}' >>${WRKBUILD}/cmd/${CMD}/${CMD}
	echo 'export LEFTYPATH' >>${WRKBUILD}/cmd/${CMD}/${CMD}
	cat ${WRKBUILD}/cmd/${CMD}/${CMD}.ksh >>${WRKBUILD}/cmd/${CMD}/${CMD}
.endfor

.include <bsd.port.mk>