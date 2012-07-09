# $OpenBSD: Makefile.template,v 1.61 2012/03/29 13:41:58 sthen Exp $

COMMENT =		MIDI sequencer 

DISTNAME =		dino-0.2.8

#SHARED_LIBS =		???

CATEGORIES =		audio

HOMEPAGE =		http://dino.nongnu.org/

MAINTAINER =		Edd Barrett <edd@openbsd.org>

# XXX
PERMIT_PACKAGE_CDROM =	Yes
PERMIT_PACKAGE_FTP =	Yes
PERMIT_DISTFILES_CDROM =Yes
PERMIT_DISTFILES_FTP =	Yes

#WANTLIB =		???

MASTER_SITES =		${MASTER_SITE_SAVANNAH:=dino/}

#MODULES =		???
#BUILD_DEPENDS =	???
#RUN_DEPENDS =		???
LIB_DEPENDS =		audio/jack \
			audio/lash \
			devel/libglademm \
			textproc/libxml++

WANTLIB += GL X11 Xcomposite Xcursor Xdamage Xext Xfixes Xi Xinerama
WANTLIB += Xrandr Xrender atk-1.0 atkmm-1.6 c cairo cairomm-1.0
WANTLIB += e2fs-uuid expat ffi fontconfig freetype gdk-x11-2.0
WANTLIB += gdk_pixbuf-2.0 gdkmm-2.4 gio-2.0 giomm-2.4 glade-2.0
WANTLIB += glademm-2.4 glib-2.0 glibmm-2.4 gmodule-2.0 gobject-2.0
WANTLIB += gthread-2.0 gtk-x11-2.0 gtkmm-2.4 iconv intl jack lash
WANTLIB += m pango-1.0 pangocairo-1.0 pangoft2-1.0 pangomm-1.4
WANTLIB += pcre pixman-1 png pthread pthread-stubs readline sigc-2.0
WANTLIB += stdc++ termcap xcb xcb-render xcb-shm xml++-2.6 xml2
WANTLIB += z

#REGRESS_DEPENDS =	???

#USE_GMAKE =		Yes
#USE_GROFF =		Yes
#USE_LIBTOOL =		Yes

CONFIGURE_STYLE =	gnu

#NO_REGRESS =		Yes

.include <bsd.port.mk>
