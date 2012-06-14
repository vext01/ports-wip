# $OpenBSD: Makefile,v 1.1.1.1 2011/07/21 01:35:51 edd Exp $

COMMENT =		language bindings for Radare2

PKGNAME =		radare-bindings2-${V}

# XXX multipackage this
MODULES =		lang/python
LIB_DEPENDS =		devel/radare2/main>=${V}
BUILD_DEPENDS =		devel/radare2/main>=${V} \
			devel/valabind # XXX not for release
RUN_DEPENDS =		lang/vala		# vala bindings only

WANTLIB += m python2.7 r_anal r_asm r_bin r_bp r_cmd r_config
WANTLIB += r_cons r_core r_db r_debug r_diff r_egg r_flags r_fs
WANTLIB += r_hash r_io r_lang r_lib r_line r_magic r_parse r_print
WANTLIB += r_reg r_search r_sign r_socket r_syscall r_util stdc++
WANTLIB += util

WRKDIST =		${WRKDIR}/radare2-${V}/r2-bindings
SUBST_VARS =		${MODPY_VERSION}

PYTHON_CONFIG =		python${MODPY_VERSION}-config
CONFIGURE_ENV +=	PYTHON_CONFIG=${PYTHON_CONFIG}
CONFIGURE_ARGS =	--enable-devel --enable=python,vala

do-build:
	cd ${WRKSRC}/python && PYTHON_CONFIG=${PYTHON_CONFIG} ${MAKE_PROGRAM}

.include <bsd.port.mk>
