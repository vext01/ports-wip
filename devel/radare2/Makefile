# $OpenBSD: Makefile.template,v 1.60 2010/10/24 20:41:23 ajacoutot Exp $

ONLY_FOR_ARCHS =	i386 amd64 armish zaurus mips ppc sparc sparc64

MULTI_PACKAGES =	-main -vala

COMMENT-main =		reverse engineers disassembler and debugger
COMMENT-vala =		vala extensions for radare2

# hg snaps until release is made
V =			20110705
DISTNAME =		radare2-c0d29691eeba
PKGNAME-main =		radare2-${V}
PKGNAME-vala =		radare2-${V}-vala

# In radare, all libs have the same version
LIBV =	0.0	# 0.7.1

SHARED_LIBS += r_anal		${LIBV}
SHARED_LIBS += r_asm		${LIBV}
SHARED_LIBS += r_bin		${LIBV}
SHARED_LIBS += r_bp		${LIBV}
SHARED_LIBS += r_cmd		${LIBV}
SHARED_LIBS += r_config		${LIBV}
SHARED_LIBS += r_cons		${LIBV}
SHARED_LIBS += r_core		${LIBV}
SHARED_LIBS += r_debug		${LIBV}
SHARED_LIBS += r_diff		${LIBV}
SHARED_LIBS += r_flags		${LIBV}
SHARED_LIBS += r_fs		${LIBV}
SHARED_LIBS += r_hash		${LIBV}
SHARED_LIBS += r_io		${LIBV}
SHARED_LIBS += r_lang		${LIBV}
SHARED_LIBS += r_lib		${LIBV}
SHARED_LIBS += r_line		${LIBV}
SHARED_LIBS += r_parse		${LIBV}
SHARED_LIBS += r_print		${LIBV}
SHARED_LIBS += r_reg		${LIBV}
SHARED_LIBS += r_search		${LIBV}
SHARED_LIBS += r_sign		${LIBV}
SHARED_LIBS += r_socket		${LIBV}
SHARED_LIBS += r_syscall	${LIBV}
SHARED_LIBS += r_util		${LIBV}

CATEGORIES =		devel
HOMEPAGE =		http://radare.nopcode.org/
MAINTAINER =		Edd Barrett <edd@openbsd.org>

# LGPLv3
PERMIT_PACKAGE_CDROM =	Yes
PERMIT_PACKAGE_FTP =	Yes
PERMIT_DISTFILES_CDROM =Yes
PERMIT_DISTFILES_FTP =	Yes

WANTLIB-main +=		c m pthread
LIB_DEPENDS-vala =	devel/radare2,-main \
			lang/vala

#MASTER_SITES =		${HOMEPAGE}/get/
MASTER_SITES =		http://devio.us/~vext01/distfiles/

USE_GMAKE =		Yes
USE_LIBTOOL =		Yes
CONFIGURE_STYLE =	gnu

CONFIGURE_ARGS +=	--with-libversion=${LIBV}

NO_REGRESS =		Yes

# These not needed outside ports, so figure out why needed in ports.
MAKE_FLAGS +=		EXT_SO=so RADARE_LIBV=${LIBV}
CFLAGS +=		-D__UNIX__

# separate configure/install 
post-configure:
	cd ${WRKSRC}/r2-bindings && ./${CONFIGURE_SCRIPT}

post-install:
	cd ${WRKSRC}/r2-bindings && ${MAKE_PROGRAM} install-vapi

.include <bsd.port.mk>
