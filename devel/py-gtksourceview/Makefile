# $OpenBSD: Makefile.template,v 1.60 2010/10/24 20:41:23 ajacoutot Exp $

COMMENT =		Python bindings for GTKSourceView

DISTNAME =		pygtksourceview-2.10.1

CATEGORIES =		devel x11

HOMEPAGE =		http://projects.gnome.org/gtksourceview/pygtksourceview.html
MASTER_SITES =		http://ftp.gnome.org/pub/gnome/sources/pygtksourceview/2.10/

MAINTAINER =		Edd Barrett <edd@openbsd.org>

# LGPL-2.1
PERMIT_PACKAGE_CDROM =	Yes
PERMIT_PACKAGE_FTP =	Yes
PERMIT_DISTFILES_CDROM =Yes
PERMIT_DISTFILES_FTP =	Yes

WANTLIB += GL X11 Xcomposite Xcursor Xdamage Xext Xfixes Xi Xinerama
WANTLIB += Xrandr Xrender atk-1.0 cairo expat ffi fontconfig freetype
WANTLIB += gdk-x11-2.0 gdk_pixbuf-2.0 gio-2.0 glib-2.0 gmodule-2.0
WANTLIB += gobject-2.0 gthread-2.0 gtk-x11-2.0 gtksourceview-2.0
WANTLIB += iconv intl m pango-1.0 pangocairo-1.0 pangoft2-1.0
WANTLIB += pcre pixman-1 png pthread-stubs xcb xcb-render xcb-shm
WANTLIB += xml2 z

MODULES =		lang/python
LIB_DEPENDS =		x11/gtksourceview \
			x11/py-gtk2

CONFIGURE_STYLE =	gnu

.include <bsd.port.mk>
