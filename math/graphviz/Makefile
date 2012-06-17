# $OpenBSD: Makefile,v 1.46 2011/11/03 20:28:09 jasper Exp $

COMMENT-main=	graph drawing software

DISTNAME=	graphviz-2.28.0
PKGNAME-main=	${DISTNAME}
CATEGORIES=	math devel graphics
MULTI_PACKAGES=	-main

# to let update-patches work in a simpler way
PATCHORIG=	.orig2

MASTER_SITES=	${HOMEPAGE}pub/graphviz/ARCHIVE/

# XXX update upstream versions
SHARED_LIBS += gvplugin_core        1.0      # .3.0
SHARED_LIBS += gvplugin_gd          1.0      # .3.0
SHARED_LIBS += gvplugin_pango       1.0      # .3.0
SHARED_LIBS += gvplugin_dot_layout  1.0      # .3.0
SHARED_LIBS += gvplugin_neato_layout 1.0      # .3.0
SHARED_LIBS += gvplugin_xlib        1.0      # .3.0
SHARED_LIBS += gvplugin_gtk         1.0      # .3.0
SHARED_LIBS += gvplugin_dot_layout  1.0      # .3.0
SHARED_LIBS += gvplugin_neato_layout 1.0      # .3.0

SHARED_LIBS += cdt                  1.0      # .3.0
SHARED_LIBS += graph                2.0      # .3.0
SHARED_LIBS += pathplan             2.0      # .3.0
SHARED_LIBS += gvc                  1.0      # .3.0
SHARED_LIBS += gdtclft              2.0      # .0.0
SHARED_LIBS += tcldot               2.0      # .0.0
SHARED_LIBS += tcldot_builtin       2.0      # .0.0
SHARED_LIBS += tclplan              2.0      # .0.0
SHARED_LIBS += tkspline             2.0      # .0.0
SHARED_LIBS += graph                2.0      # .3.0
SHARED_LIBS += gvc                  2.0      # .3.0
SHARED_LIBS += tcldot               2.0      # .0.0
SHARED_LIBS += tclplan              2.0      # .0.0

# new XXX
SHARED_LIBS +=  gvplugin_gdk_pixbuf       0.0 # 6.0
SHARED_LIBS +=  gvplugin_rsvg             0.0 # 6.0
SHARED_LIBS +=  cgraph                    0.0 # 6.0
SHARED_LIBS +=  gvpr                      0.0 # 2.0
SHARED_LIBS +=  xdot                      0.0 # 4.0

HOMEPAGE=	http://www.graphviz.org/

MAINTAINER=	Marc Espie <espie@openbsd.org>

# Common public licence
PERMIT_DISTFILES_FTP=	Yes
PERMIT_DISTFILES_CDROM=	Yes
PERMIT_PACKAGE_FTP=	Yes
PERMIT_PACKAGE_CDROM=	Yes

#WANTLIB=	ICE SM X11 Xau Xaw Xcomposite Xcursor Xdamage Xdmcp \
#		Xext Xfixes Xi Xinerama Xmu Xpm Xrandr Xrender Xt \
#		c dbus-1 dbus-glib-1 expat fontconfig freetype m pcre \
#		pthread-stubs util xcb z jpeg tk84 gd ffi \
#		png ltdl pthread stdc++ xcb-render GL Xxf86vm drm xcb-shm

MODULES=	devel/gettext
LIB_DEPENDS=	graphics/jpeg \
		graphics/png \
		devel/libtool,-ltdl \
		tk->=8.4,<8.5:x11/tk/8.4 \
		graphics/gd>=2.0.34 \
		x11/gnome/libgnomeui \
		x11/gtk+2

RUN_DEPENDS=	tk->=8.4,<8.5:x11/tk/8.4 \
		tcl->=8.4.7p5,<8.5:lang/tcl/8.4 \
		lang/guile
BUILD_DEPENDS=	${RUN_DEPENDS} \
		devel/swig

WANTLIB +=	GL ICE SM X11 Xau Xaw Xcomposite Xcursor Xdamage Xdmcp
WANTLIB +=	Xext Xfixes Xi Xinerama Xmu Xpm Xrandr Xrender Xt Xxf86vm
WANTLIB +=	atk-1.0 c cairo drm expat ffi fontconfig freetype gd
WANTLIB +=	gdk-x11-2.0 gdk_pixbuf-2.0 gio-2.0 glib-2.0 gmodule-2.0
WANTLIB +=	gobject-2.0 gthread-2.0 gtk-x11-2.0 jpeg ltdl m pango-1.0
WANTLIB +=	pangocairo-1.0 pangoft2-1.0 pcre pixman-1 png pthread-stubs
WANTLIB +=	stdc++ tk84 xcb xcb-render xcb-shm z

USE_LIBTOOL=	Yes
USE_GROFF =	Yes
AUTOCONF_VERSION=2.59 # XXX required?
CONFIGURE_STYLE=gnu
CONFIGURE_ARGS=	${CONFIGURE_SHARED} \
		--disable-lua \
		--disable-io \
		--disable-java \
		--disable-ocaml \
		--disable-php \
		--disable-perl \
		--disable-python \
		--disable-ruby \
		--disable-rpath \
		--with-gd

CONFIGURE_ENV=	CPPFLAGS="-I${X11BASE}/include -I${LOCALBASE}/include" \
		LDFLAGS="-L${X11BASE}/lib -L${LOCALBASE}/lib" \
		TCLCONFIG=${LOCALBASE}/lib/tcl/tcl8.4/tclConfig.sh \
		TKCONFIG=${LOCALBASE}/lib/tcl/tk8.4/tkConfig.sh \
		PKG_CONFIG=/usr/bin/pkg-config

DOCBASE=	${PREFIX}/share/doc/graphviz
EXBASE=		${PREFIX}/share/examples/graphviz

MAKE_FLAGS=	TCL_STUB_LIB_SPEC='-L${LOCALBASE}/lib -ltclstub84_pic' \
		TK_STUB_LIB_SPEC='-L${LOCALBASE}/lib -ltkstub84_pic'

FAKE_FLAGS=	htmldir="${DOCBASE}/html" \
		pdfdir="${DOCBASE}/pdf" \
		txtdir="${DOCBASE}" \
		demodir="${EXBASE}/demo" \
		directeddir="${EXBASE}/graphs/directed" \
		leftydir="${EXBASE}/lefty" \
		pathplanexampledir="${EXBASE}/demo/pathplan_data" \
		undirecteddir="${EXBASE}/graphs/undirected"

#post-build:
#.for CMD in dotty lneato
#	echo "#! /bin/ksh" >${WRKBUILD}/cmd/${CMD}/${CMD}
#	echo ': $${LEFTYPATH:=$(LOCALBASE)/share/examples/graphviz/lefty}' >>${WRKBUILD}/cmd/${CMD}/${CMD}
#	echo 'export LEFTYPATH' >>${WRKBUILD}/cmd/${CMD}/${CMD}
#	cat ${WRKBUILD}/cmd/${CMD}/${CMD}.ksh >>${WRKBUILD}/cmd/${CMD}/${CMD}
#.endfor

#post-install:
#	cd ${PREFIX}/share/examples/graphviz/demo && \
#	    perl -pi -e 's/^exec tclsh/exec tclsh8.4/' entities gcat
#	cd ${PREFIX}/share/examples/graphviz/demo && \
#	    perl -pi -e 's/^exec wish/exec wish8.4/' doted pathplan spline

.include <bsd.port.mk>
