# $OpenBSD: Makefile.template,v 1.60 2010/10/24 20:41:23 ajacoutot Exp $

COMMENT =		reverse engineers disassembler and debugger

DISTNAME =		radare2-${V}

# In radare, all libs have the same version
LIBV =			0.0	# 0.8
.for _lib in r_anal r_asm r_bin r_bp r_cmd r_config r_cons r_core r_debug \
	r_diff r_flags r_fs r_hash r_io r_lang r_lib r_line r_parse r_print \
	r_reg r_search r_sign r_socket r_syscall r_util
SHARED_LIBS+=		${_lib} ${LIBV}
.endfor

WANTLIB =		c crypto m pthread ssl
RUN_DEPENDS =		devel/nasm

CONFIGURE_ARGS +=	--with-libversion=${LIBV}

MAKE_FLAGS +=		EXT_SO=so RADARE_LIBV=${LIBV}
CFLAGS +=		-D__UNIX__

.include <bsd.port.mk>
