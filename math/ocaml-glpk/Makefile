# $OpenBSD: Makefile.template,v 1.60 2010/10/24 20:41:23 ajacoutot Exp $

COMMENT =		glpk bindings for OCaml

V =			0.1.6
DISTNAME =		ocaml-glpk-${V}

CATEGORIES =		math

HOMEPAGE =		http://ocaml-glpk.sourceforge.net/

MAINTAINER =		Edd Barrett <edd@openbsd.org>

# GPLv2
PERMIT_PACKAGE_CDROM =	Yes
PERMIT_PACKAGE_FTP =	Yes
PERMIT_DISTFILES_CDROM =Yes
PERMIT_DISTFILES_FTP =	Yes

WANTLIB =		glpk

MASTER_SITES =		${MASTER_SITE_SOURCEFORGE:=ocaml-glpk/}

MODULES =		lang/ocaml
LIB_DEPENDS =		devel/glpk
BUILD_DEPENDS =		sysutils/findlib

USE_GMAKE =		Yes

MAKE_ENV +=		"CPPFLAGS=-I${LOCALBASE}/include LDFLAGS=-L${LOCALBASE}/lib"

# Can only build native pkg on arches that support ocamlopt
ALL_TARGET =		${MODOCAML_NATIVE:S,Yes,byte opt,:S,No,byte,}

# name and version number incorrect in META
pre-configure:
	@perl -pi -e "s,version=\".*\",version=\"${V}\"," ${WRKSRC}/src/META
	@perl -pi -e "s,name=\".*\",name=\"Glpk\"," ${WRKSRC}/src/META

pre-install:
	touch ${WRKBUILD}/src/ld.conf.dummy
	${INSTALL_DATA_DIR} ${PREFIX}/lib/ocaml/site-lib/glpk/

# installs stub so in the wrong place
post-install:
	${INSTALL_DATA_DIR} ${PREFIX}/lib/ocaml/stublibs
	mv ${PREFIX}/lib/ocaml/site-lib/glpk/dllglpk_stubs.so \
		${PREFIX}/lib/ocaml/stublibs
	cp -r ${WRKSRC}/doc/html ${PREFIX}/share/doc/ocaml-glpk
	chown -R ${SHAREOWN}:${SHAREGRP} ${PREFIX}/share/doc/ocaml-glpk
	${INSTALL_DATA_DIR} ${PREFIX}/share/examples/ocaml-glpk/
	${INSTALL_DATA} ${WRKSRC}/examples/example.ml ${PREFIX}/share/examples/ocaml-glpk/

REGRESS_DEPENDS =	math/ocaml-glpk
# build a bytecode example program
do-regress:
	cd ${WRKDIR} &&  ocamlfind ocamlc -package glpk -linkpkg \
		${WRKSRC}/examples/example.ml -o example && \
		./example | grep -e '^Z: ' > example.actual && \
		test -z "`diff -u ${FILESDIR}/example.expected example.actual`" || \
		echo "Test failed: "; diff -u ${FILESDIR}/example.expected example.actual
		
.include <bsd.port.mk>
