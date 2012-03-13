# $OpenBSD: Makefile.template,v 1.60 2010/10/24 20:41:23 ajacoutot Exp $

COMMENT =		user interface library from pwmt

# http://pwmt.org/projects/girara/download/girara-0.1.1.tar.gz
DISTNAME =		girara-0.1.1

SHARED_LIBS +=		girara-gtk2	0.0 # 0.0

CATEGORIES =		x11

HOMEPAGE =		http://pwmt.org/projects/girara/

# zlib
PERMIT_PACKAGE_CDROM =	Yes
PERMIT_PACKAGE_FTP =	Yes
PERMIT_DISTFILES_CDROM =Yes
PERMIT_DISTFILES_FTP =	Yes

WANTLIB += GL X11 Xcomposite Xcursor Xdamage Xext Xfixes Xi Xinerama
WANTLIB += Xrandr Xrender atk-1.0 cairo expat fontconfig freetype
WANTLIB += gdk-x11-2.0 gdk_pixbuf-2.0 gio-2.0 glib-2.0 gmodule-2.0
WANTLIB += gobject-2.0 gthread-2.0 gtk-x11-2.0 iconv intl m pango-1.0
WANTLIB += pangocairo-1.0 pangoft2-1.0 pixman-1 png pthread-stubs
WANTLIB += xcb xcb-render xcb-shm z

MASTER_SITES =		http://pwmt.org/projects/girara/download/

LIB_DEPENDS =		x11/gtk+2

USE_GMAKE =		Yes
MAKE_FLAGS +=		QUIET= CPPFLAGS="-I${LOCALBASE}/include -DGETTEXT_PACKAGE=\\\"girara\\\" -DLOCALEDIR=\\\"/usr/share/locale\\\""
FAKE_FLAGS +=		DESTDIR=

# XXX needs "check" test suite
REGRESS_TARGET =	test

.include <bsd.port.mk>
