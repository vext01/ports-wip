# $OpenBSD: Makefile.template,v 1.61 2012/03/29 13:41:58 sthen Exp $

COMMENT =		XXX

DISTNAME =		non-sequencer-20120611
EXTRACT_SUFX =		.tgz
WRKDIST =		${WRKDIR}/sequencer

#SHARED_LIBS =		???

CATEGORIES =		audio

HOMEPAGE =		http://non-sequencer.tuxfamily.org/

#MAINTAINER =		???

# XXX
PERMIT_PACKAGE_CDROM =	Yes
PERMIT_PACKAGE_FTP =	Yes
PERMIT_DISTFILES_CDROM =Yes
PERMIT_DISTFILES_FTP =	Yes

WANTLIB += X11 Xau Xdmcp Xext Xpm c fltk fltk_images jack jpeg
WANTLIB += lo m png pthread sigc-2.0 stdc++ z

MASTER_SITES =		http://theunixzoo.co.uk/files/

#MODULES =		???
#BUILD_DEPENDS =	???
#RUN_DEPENDS =		???
LIB_DEPENDS =		audio/fluidsynth \
			audio/liblo \
			x11/fltk \
			audio/jack \
			devel/libsigc++-2

#REGRESS_DEPENDS =	???

USE_GMAKE =		Yes
#USE_GROFF =		Yes
#USE_LIBTOOL =		Yes
CONFIGURE_STYLE =	simple
CONFIGURE_ARGS +=	--prefix=${PREFIX}
PORTHOME =		${WRKDIR}

# XXX
CONFIGURE_ENV +=	TERM=wsvt25
MAKE_ENV +=		TERM=wsvt25

#NO_REGRESS =		Yes

.include <bsd.port.mk>
