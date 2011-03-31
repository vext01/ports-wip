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

#SHARED_LIBS +=  r_anal                    0.0 # 0.7
#SHARED_LIBS +=  r_asm                     0.0 # 0.7
#SHARED_LIBS +=  r_bin                     0.0 # 0.7
#SHARED_LIBS +=  r_bp                      0.0 # 0.7
#SHARED_LIBS +=  r_cmd                     0.0 # 0.7
#SHARED_LIBS +=  r_config                  0.0 # 0.7
#SHARED_LIBS +=  r_cons                    0.0 # 0.7
#SHARED_LIBS +=  r_core                    0.0 # 0.7
#SHARED_LIBS +=  r_crypto                  0.0 # 0.7
#SHARED_LIBS +=  r_db                      0.0 # 0.7
#SHARED_LIBS +=  r_debug                   0.0 # 0.7
#SHARED_LIBS +=  r_diff                    0.0 # 0.7
#SHARED_LIBS +=  r_flags                   0.0 # 0.7
#SHARED_LIBS +=  r_fs                      0.0 # 0.7
#SHARED_LIBS +=  r_hash                    0.0 # 0.7
#SHARED_LIBS +=  r_io                      0.0 # 0.7
#SHARED_LIBS +=  r_lang                    0.0 # 0.7
#SHARED_LIBS +=  r_lib                     0.0 # 0.7
#SHARED_LIBS +=  r_line                    0.0 # 0.7
#SHARED_LIBS +=  r_parse                   0.0 # 0.7
#SHARED_LIBS +=  r_print                   0.0 # 0.7
#SHARED_LIBS +=  r_reg                     0.0 # 0.7
#SHARED_LIBS +=  r_search                  0.0 # 0.7
#SHARED_LIBS +=  r_sign                    0.0 # 0.7
#SHARED_LIBS +=  r_socket                  0.0 # 0.7
#SHARED_LIBS +=  r_syscall                 0.0 # 0.7
#SHARED_LIBS +=  r_th                      0.0 # 0.7
#SHARED_LIBS +=  r_util                    0.0 # 0.7

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

CONFIGURE_ARGS +=	--with-ostype=linux

#NO_REGRESS =		Yes

MAKE_FLAGS +=		EXT_SO=so
CFLAGS +=		-D__UNIX__

.include <bsd.port.mk>
