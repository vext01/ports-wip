# $OpenBSD: Makefile,v 1.17 2012/02/21 22:34:19 sthen Exp $

COMMENT =	poppler pdf plugin for zathura
DISTNAME =	zathura-pdf-poppler-0.2.0

HOMEPAGE =	http://pwmt.org/projects/zathura/plugins/zathura-pdf-poppler/

WANTLIB += GL X11 Xcomposite Xcursor Xdamage Xext Xfixes Xi Xinerama
WANTLIB += Xrandr Xrender atk-1.0 cairo expat fontconfig freetype
WANTLIB += gdk-x11-2.0 gdk_pixbuf-2.0 gio-2.0 girara-gtk2 glib-2.0
WANTLIB += gobject-2.0 gtk-x11-2.0 iconv intl m pango-1.0 pangocairo-1.0
WANTLIB += pangoft2-1.0 pixman-1 png poppler-glib pthread-stubs
WANTLIB += xcb xcb-render xcb-shm z

MASTER_SITES =	${MASTER_SITES_PLUGINS}

LIB_DEPENDS =	print/poppler
RUN_DEPENDS =	textproc/zathura/core

.include <bsd.port.mk>

