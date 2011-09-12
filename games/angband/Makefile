# $OpenBSD: Makefile,v 1.21 2011/05/11 06:56:42 ajacoutot Exp $
# Original from: Robert Ruehlmann

COMMENT=		rogue-like game with X11 support
COMMENT-no_x11=		rogue-like game

V =			3.3.0
V_DLDIR =		${V:C/\.[0-9]$//}
DISTNAME=		angband-v${V}
PKGNAME=		angband-${V}
CATEGORIES=     	games

HOMEPAGE=		http://rephial.org

MAINTAINER=		Niall O Higgins <niallo@openbsd.org>

PERMIT_PACKAGE_CDROM=	unclear license
PERMIT_PACKAGE_FTP=	Yes
PERMIT_DISTFILES_CDROM= unclear license
PERMIT_DISTFILES_FTP=	Yes
WANTLIB=		c m ncurses

MASTER_SITES =		${HOMEPAGE}/downloads/${V_DLDIR}/
			
CONFIGURE_STYLE=	gnu
CONFIGURE_ARGS+=	--with-setgid=games \
			--with-varpath=/var/games/angband/ \
			--with-configpath=${PREFIX}/share/angband \
			--bindir=${PREFIX}/bin \
			--disable-sdl-mixer	# defaults to ON

CONFIGURE_ENV=          TRUEPREFIX="${TRUEPREFIX}"
USE_GMAKE =		Yes

FLAVORS=		no_x11 # eventually add SDL
FLAVOR?=

.if ${FLAVOR:L:Mno_x11}
CONFIGURE_ARGS+=	--without-x
.else
CONFIGURE_ARGS+=	--with-x
WANTLIB+=		ICE SM X11
.endif

# DEBUG=-g does not work, do this for debug symbols
#CFLAGS += -g

.include <bsd.port.mk>
