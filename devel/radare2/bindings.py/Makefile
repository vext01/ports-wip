# $OpenBSD: Makefile,v 1.1.1.1 2011/07/21 01:35:51 edd Exp $
#
# XXX needs MULTI_PACKAGES

COMMENT =		Vala bindings for Radare2

DISTNAME =		r2-bindings-${V}
PKGNAME =		radare-bindings2-${V}

BUILD_DEPENDS =		devel/radare2/main>=${V} \
			devel/swig
RUN_DEPENDS =		lang/vala \
			devel/radare2/main>=${V}
MODULES =		lang/python

WANTLIB += m python2.7 r_anal r_asm r_bin r_bp r_cmd r_config
WANTLIB += r_cons r_core r_debug r_diff r_egg r_flags r_fs r_hash
WANTLIB += r_io r_lang r_lib r_line r_magic r_parse r_print r_reg
WANTLIB += r_search r_sign r_socket r_syscall r_util stdc++ util

CONFIGURE_STYLE =	simple
CONFUGURE_ARGS +=	--enable=python

MAKE_FLAGS =		PYTHON_VERSION=${MODPY_VERSION}

.include <bsd.port.mk>
