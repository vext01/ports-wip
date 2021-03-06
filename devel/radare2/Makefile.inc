# $OpenBSD: Makefile.inc,v 1.2 2011/11/07 22:06:46 edd Exp $

# Arches suggested by upstream, unsure which work on OpenBSD for sure.
ONLY_FOR_ARCHS ?=	amd64 i386
# We need to figure out which of the following arches work and fix ones
# that don't. We know powerpc is busted.
#ONLY_FOR_ARCHS ?=	arm mips64 mips64el powerpc sparc sparc64

V ?=			20120614
SUBST_VARS +=		V

DISTNAME ?=		radare2-${V}

CATEGORIES ?=		devel
HOMEPAGE ?=		http://radare.nopcode.org/
MAINTAINER ?=		Edd Barrett <edd@openbsd.org>

# LGPLv3
PERMIT_PACKAGE_CDROM ?=		Yes
PERMIT_PACKAGE_FTP ?=		Yes
PERMIT_DISTFILES_CDROM ?=	Yes
PERMIT_DISTFILES_FTP ?=		Yes

#MASTER_SITES ?=		${HOMEPAGE}/get/
MASTER_SITES ?=			http://theunixzoo.co.uk/files/

USE_GMAKE ?=		Yes
CONFIGURE_STYLE ?=	simple # acr

NO_REGRESS ?=		Yes
