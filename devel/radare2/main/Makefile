# $OpenBSD: Makefile,v 1.2 2011/11/07 22:06:47 edd Exp $

COMMENT =		reverse engineers disassembler and debugger

# In radare, all libs have the same version
LIBV =			3.0	# 0.9.3
.for _lib in r_anal r_asm r_bin r_bp r_cmd r_config r_cons r_core r_db \
	r_debug r_diff r_egg r_flags r_fs r_hash r_io r_lang r_lib r_line \
	r_magic r_parse r_print r_reg r_search r_sign r_socket r_syscall \
	r_th r_util
SHARED_LIBS+=		${_lib} ${LIBV}
.endfor

WANTLIB =		c crypto m pthread ssl

# remember, this is acr, not GNU autotools.
CONFIGURE_ARGS +=	--with-libversion=${LIBV} \
			--mandir=${PREFIX}/man \
			--without-ewf

.include <bsd.port.mk>
