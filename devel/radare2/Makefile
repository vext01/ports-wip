# $OpenBSD: Makefile.template,v 1.60 2010/10/24 20:41:23 ajacoutot Exp $

ONLY_FOR_ARCHS =	i386 amd64 armish zaurus mips ppc sparc sparc64

COMMENT =		reverse engineers disassembler and debugger

V =		0.8
DISTNAME =	radare2-${V}

# Bindings are broken at the moment and there is something iffy with the
# distfile extraction, so disabled for now. Upstream are aware.
#DISTFILES =	${DISTNAME}${EXTRACT_SUFX} r2-bindings-${V}${EXTRACT_SUFX}

# In radare, all libs have the same version
LIBV =	0.0	# 0.8
.for _lib in r_anal r_asm r_bin r_bp r_cmd r_config r_cons r_core r_debug \
	r_diff r_flags r_fs r_hash r_io r_lang r_lib r_line r_parse r_print \
	r_reg r_search r_sign r_socket r_syscall r_util
SHARED_LIBS+=		${_lib} ${LIBV}
.endfor

CATEGORIES =		devel
HOMEPAGE =		http://radare.nopcode.org/
MAINTAINER =		Edd Barrett <edd@openbsd.org>

# LGPLv3
PERMIT_PACKAGE_CDROM =	Yes
PERMIT_PACKAGE_FTP =	Yes
PERMIT_DISTFILES_CDROM =Yes
PERMIT_DISTFILES_FTP =	Yes

WANTLIB =		c crypto m pthread ssl
RUN_DEPENDS =		devel/nasm

MASTER_SITES =		${HOMEPAGE}/get/

USE_GMAKE =		Yes
CONFIGURE_STYLE =	gnu

CONFIGURE_ARGS +=	--with-libversion=${LIBV}

NO_REGRESS =		Yes

MAKE_FLAGS +=		EXT_SO=so RADARE_LIBV=${LIBV}
CFLAGS +=		-D__UNIX__

R2BIND = 		${WRKDIR}/r2-bindings-${V}

# More bindings stuff, disabled for now, see comment above

# just so we can patch r2-bindings
# post-extract:
# 	ln -s ${R2BIND} ${WRKSRC}/r2-bindings

# separate configure/install for vala stuff
# post-configure:
# 	cd ${R2BIND} && ./${CONFIGURE_SCRIPT}

# prefix has already been primed with DESTDIR already at this point
# post-install:
# 	cd ${R2BIND} && ${MAKE_PROGRAM} DESTDIR="" install

.include <bsd.port.mk>
