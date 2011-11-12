# $OpenBSD: Makefile.template,v 1.60 2010/10/24 20:41:23 ajacoutot Exp $

COMMENT =		interface with Texas instruments calculators

DISTNAME =		tilp2-1.15

CATEGORIES =		devel

HOMEPAGE =		http://lpg.ticalc.org/prj_tilp/

MAINTAINER =		Edd Barrett <edd@openbsd.org>

# GPLv2
PERMIT_PACKAGE_CDROM =	Yes
PERMIT_PACKAGE_FTP =	Yes
PERMIT_DISTFILES_CDROM =Yes
PERMIT_DISTFILES_FTP =	Yes

MASTER_SITES =		XXX

LIB_DEPENDS =		devel/glib2 \
			devel/libticables2 \
			devel/libticonv \
			devel/libticalcs2 \
			devel/libtifiles2 \
			x11/gtk+2 \
#			devel/glade

WANTLIB += GL X11 Xcomposite Xcursor Xdamage Xext Xfixes Xi Xinerama
WANTLIB += Xrandr Xrender atk-1.0 c cairo expat ffi fontconfig
WANTLIB += freetype gdk-x11-2.0 gdk_pixbuf-2.0 gio-2.0 glib-2.0
WANTLIB += gmodule-2.0 gobject-2.0 gthread-2.0 gtk-x11-2.0 iconv
WANTLIB += intl m pango-1.0 pangocairo-1.0 pangoft2-1.0 pcre pixman-1
WANTLIB += png pthread pthread-stubs stdc++ ticables2 ticalcs2
WANTLIB += ticonv tifiles2 usb xcb xcb-render xcb-shm xml2 z

CONFIGURE_STYLE =	gnu

.include <bsd.port.mk>
