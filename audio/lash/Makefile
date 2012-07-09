# $OpenBSD: Makefile.template,v 1.61 2012/03/29 13:41:58 sthen Exp $

COMMENT =		session management system for audio applications
DISTNAME =		lash-0.5.4

SHARED_LIBS +=		lash	0.0 # 2.1

CATEGORIES =		audio

HOMEPAGE =		http://lash.nongnu.org/

# GPLv2
PERMIT_PACKAGE_CDROM =	Yes
PERMIT_PACKAGE_FTP =	Yes
PERMIT_DISTFILES_CDROM =Yes
PERMIT_DISTFILES_FTP =	Yes

MASTER_SITES =		${MASTER_SITE_SAVANNAH:=lash/}

CONFIGURE_ENV +=	CPPFLAGS=-I${LOCALBASE}/include LDFLAGS=-L${LOCALBASE}/lib
CONFIGURE_ARGS +=	--disable-pylash

#MODULES =		???
#BUILD_DEPENDS =	???
#RUN_DEPENDS =		???
LIB_DEPENDS =		sysutils/e2fsprogs \
			audio/jack \
			x11/gtk+2
#REGRESS_DEPENDS =	???

WANTLIB += GL X11 Xau Xcomposite Xcursor Xdamage Xdmcp Xext Xfixes
WANTLIB += Xi Xinerama Xrandr Xrender Xxf86vm atk-1.0 c cairo
WANTLIB += drm e2fs-uuid expat ffi fontconfig freetype gdk-x11-2.0
WANTLIB += gdk_pixbuf-2.0 gio-2.0 glib-2.0 gmodule-2.0 gobject-2.0
WANTLIB += gthread-2.0 gtk-x11-2.0 iconv intl jack m pango-1.0
WANTLIB += pangocairo-1.0 pangoft2-1.0 pcre pixman-1 png pthread
WANTLIB += pthread-stubs readline stdc++ termcap xcb xcb-render
WANTLIB += xcb-shm xml2 z

#USE_GMAKE =		Yes
#USE_GROFF =		Yes
USE_LIBTOOL =		Yes
CONFIGURE_STYLE =	gnu

#NO_REGRESS =		Yes

.include <bsd.port.mk>
