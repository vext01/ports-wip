# $OpenBSD: Makefile,v 1.23 2011/04/05 16:37:59 ajacoutot Exp $

COMMENT=	MAME front-end for GNOME

GNOME_PROJECT=	gnome-video-arcade
GNOME_VERSION=	0.7.1

CATEGORIES=	emulators games

HOMEPAGE=	http://mbarnes.github.com/gnome-video-arcade/

# GPLv3
PERMIT_PACKAGE_CDROM=	Yes
PERMIT_PACKAGE_FTP=	Yes
PERMIT_DISTFILES_CDROM= Yes
PERMIT_DISTFILES_FTP=	Yes

# ICE.9 SM.8 xcb-atom.1 xcb-event.1 xcb-render-util.0

WANTLIB += ORBit-2 X11 XRes Xau Xcomposite Xcursor Xdamage
WANTLIB += Xdmcp Xext Xfixes Xi Xinerama Xrandr Xrender atk-1.0
WANTLIB += c cairo dbus-1 dbus-glib-1 execinfo expat fontconfig
WANTLIB += freetype gdk-x11-2.0 gdk_pixbuf-2.0 gio-2.0 glib-2.0
WANTLIB += gmodule-2.0 gobject-2.0 gthread-2.0 gtk-x11-2.0
WANTLIB += m pango-1.0 pangocairo-1.0 pangoft2-1.0 pcre pixman-1
WANTLIB += png pthread pthread-stubs sqlite3 startup-notification-1
WANTLIB += xcb xcb-aux z
WANTLIB += xcb-render sqlite3 wnck-1
WANTLIB += GL X11-xcb Xxf86vm drm unique-1.0 xcb-shm xml2 gstreamer-0.10
# XXX sort

MODULES=	devel/gettext \
		x11/gnome \
		devel/gconf2

BUILD_DEPENDS=	${RUN_DEPENDS} \
		x11/gnome/icon-theme
RUN_DEPENDS=	emulators/sdlmame,-main>=0.132p2
LIB_DEPENDS=	databases/sqlite3 \
		devel/libwnck \
		devel/libunique \
		multimedia/gstreamer-0.10/core
# XXX check if we can explicitely turn gst on/off

DESKTOP_FILES=		Yes
MODGNOME_HELP_FILES=	Yes
MODGCONF2_SCHEMAS_DIR=  gnome-video-arcade

CONFIGURE_ENV=	CPPFLAGS="-I${LOCALBASE}/include" \
		LDFLAGS="-L${LOCALBASE}/lib"
CONFIGURE_ARGS=	${CONFIGURE_SHARED} \
		--disable-gtk-doc \
		--with-gnome \
		--with-wnck \
		--with-history-file="${LOCALBASE}/share/sdlmame/history.dat"
USE_GROFF =	Yes

.include <bsd.port.mk>
