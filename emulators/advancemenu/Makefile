# $OpenBSD: Makefile.template,v 1.60 2010/10/24 20:41:23 ajacoutot Exp $

COMMENT =		mame frontend for SDL

#http://prdownloads.sourceforge.net/advancemame/advancemenu-2.5.0.tar.gz?download
DISTNAME =		advancemenu-2.5.0

CATEGORIES =		emulators x11

HOMEPAGE =		http://advancemame.sourceforge.net/menu-readme.html

MAINTAINER =		Edd Barrett <edd@openbsd.org>

#XXX
PERMIT_PACKAGE_CDROM =	Yes
PERMIT_PACKAGE_FTP =	Yes
PERMIT_DISTFILES_CDROM =Yes
PERMIT_DISTFILES_FTP =	Yes

#WANTLIB =		???

MASTER_SITES =		${MASTER_SITE_SOURCEFORGE:=advancemame/}

#MODULES =		???
#BUILD_DEPENDS =	???
#RUN_DEPENDS =		???
LIB_DEPENDS =		devel/sdl
#REGRESS_DEPENDS =	???

#MAKE_FLAGS =		???
#MAKE_ENV =		???
#FAKE_FLAGS =		???
#REGRESS_FLAGS =	???

USE_GMAKE =		Yes
#USE_GROFF =		Yes
CONFIGURE_STYLE =	gnu dest

#NO_REGRESS =		Yes

.include <bsd.port.mk>
