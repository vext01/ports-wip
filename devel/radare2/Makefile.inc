# $OpenBSD: Makefile.template,v 1.60 2010/10/24 20:41:23 ajacoutot Exp $

# Arches suggested by upstream, unsure which work on OpenBSD for sure.
ONLY_FOR_ARCHS ?=	i386 amd64 armish zaurus mips ppc sparc sparc64

V ?=			0.8

CATEGORIES ?=		devel
HOMEPAGE ?=		http://radare.nopcode.org/
MAINTAINER ?=		Edd Barrett <edd@openbsd.org>

# LGPLv3
PERMIT_PACKAGE_CDROM ?=		Yes
PERMIT_PACKAGE_FTP ?=		Yes
PERMIT_DISTFILES_CDROM ?=	Yes
PERMIT_DISTFILES_FTP ?=		Yes

MASTER_SITES ?=		${HOMEPAGE}/get/

USE_GMAKE ?=		Yes
CONFIGURE_STYLE ?=	gnu

NO_REGRESS ?=		Yes
