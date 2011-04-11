# $OpenBSD: Makefile.template,v 1.60 2010/10/24 20:41:23 ajacoutot Exp $

#ONLY_FOR_ARCHS =	???
#NOT_FOR_ARCHS =	???
#SHARED_ONLY =		???
#COMES_WITH =		???
#BROKEN =		reason

#
# Very short description of the package, 60 chars max
#
COMMENT =		XXX

DISTNAME =		radare2-0.7

# In the radare build, all libs are given a unified version.
LIBV =		0.0 # 0.7
SHARED_LIBS +=  r_anal		${LIBV}
SHARED_LIBS +=  r_asm		${LIBV}
SHARED_LIBS +=  r_bin		${LIBV}
SHARED_LIBS +=  r_bp                      ${LIBV}
SHARED_LIBS +=  r_cmd                     ${LIBV}
SHARED_LIBS +=  r_config                  ${LIBV}
SHARED_LIBS +=  r_cons                    ${LIBV}
SHARED_LIBS +=  r_core                    ${LIBV}
SHARED_LIBS +=  r_crypto                  ${LIBV}
SHARED_LIBS +=  r_db                      ${LIBV}
SHARED_LIBS +=  r_debug                   ${LIBV}
SHARED_LIBS +=  r_diff                    ${LIBV}
SHARED_LIBS +=  r_flags                   ${LIBV}
SHARED_LIBS +=  r_fs                      ${LIBV}
SHARED_LIBS +=  r_hash                    ${LIBV}
SHARED_LIBS +=  r_io                      ${LIBV}
SHARED_LIBS +=  r_lang                    ${LIBV}
SHARED_LIBS +=  r_lib                     ${LIBV}
SHARED_LIBS +=  r_line                    ${LIBV}
SHARED_LIBS +=  r_parse                   ${LIBV}
SHARED_LIBS +=  r_print                   ${LIBV}
SHARED_LIBS +=  r_reg                     ${LIBV}
SHARED_LIBS +=  r_search                  ${LIBV}
SHARED_LIBS +=  r_sign                    ${LIBV}
SHARED_LIBS +=  r_socket                  ${LIBV}
SHARED_LIBS +=  r_syscall                 ${LIBV}
SHARED_LIBS +=  r_th                      ${LIBV}
SHARED_LIBS +=  r_util                    ${LIBV}

CATEGORIES =		devel

HOMEPAGE =		http://radare.nopcode.org/

MAINTAINER =		Edd Barrett <edd@openbsd.org>

# XXX
PERMIT_PACKAGE_CDROM =	Yes
PERMIT_PACKAGE_FTP =	Yes
PERMIT_DISTFILES_CDROM =Yes
PERMIT_DISTFILES_FTP =	Yes

WANTLIB +=		c pthread

MASTER_SITES =		${HOMEPAGE}/get/

USE_GMAKE =		Yes
#USE_GROFF =		Yes
USE_LIBTOOL =		Yes
CONFIGURE_STYLE =	gnu

# May not be needed in next version
CONFIGURE_ARGS +=	--with-ostype=linux

#NO_REGRESS =		Yes

# May not be needed in next version
MAKE_FLAGS +=		EXT_SO=so RADARE_LIBV=${LIBV}
FAKE_FLAGS +=		RADARE_LIBV=${LIBV}
CFLAGS +=		-D__UNIX__

.include <bsd.port.mk>
