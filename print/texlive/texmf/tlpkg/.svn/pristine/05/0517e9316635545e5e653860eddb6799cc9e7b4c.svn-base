#!/bin/sh
# Updater for tlmgr and infrastructure on Unix.
# Runs in unpacked archive directory.

ROOT=`kpsewhich --var-value=SELFAUTOPARENT`

if test -r "$ROOT/tlpkg/texlive.tlpdb"; then
  # nothing to do here
  answer=0
else
  answer=x
  echo "No installation found, please select from the following options:"
  echo "[1] make new installation"
  echo "[2] enter path to an existing installation"
  echo "[x] exit (default)"
  echo -n "Your selection: "
  read answer
fi

case "X$answer" in
  X0) NEWINST=0
      ;;
  X1) echo -n "Enter destination folder: "
      read newpath
      if [ -z "$newpath" ] ; then
        echo "No destination folder given, exiting."
	exit 1
      fi
      ROOT="$newpath"
      NEWINST=1
      set -e
      mkdir -p "$ROOT/tlpkg/tlpobj"
      mkdir -p "$ROOT/bin"
      ;;
  X2) echo -n "Path to an existing installation: "
      read oldpath
      notgood=1
      if [ -d $oldpath ] ; then
        if [ -r "$oldpath/tlpkg/texlive.tlpdb" ] ; then
	  notgood=0;
	fi
      fi
      if [ $notgood = 1 ] ; then
        echo "Cannot find TeX Live root in $oldpath, exiting."
        exit 1
      fi
      ;;
  *) exit 0;;
esac

#
if [ $NEWINST = 1 ] ; then
  echo "$0: installing to $ROOT..."
else
  echo "$0: updating in $ROOT..."
fi
  
# move the architecture-specific files to the top level.
mv ./master/bin .
mv ./master/tlpkg/installer .
mv ./master/tlpkg/tlpobj .
  
# install the architecture-independent files.
(cd master && tar cf - *) | (cd $ROOT && tar xf -)
  
# try to get the list of installed architectures by listing the
# directories in $ROOT/bin.
t_objdir=$ROOT/tlpkg/tlpobj      # target tlpobj directory
t_instdir=$ROOT/tlpkg/installer  # target installer dir
  
# ensure these target directories exist.
mkdir -p $t_instdir/lzma
mkdir -p $t_instdir/wget

# start the list of tlpobjs we will install
tlpobjs="$t_objdir/bin-texlive.tlpobj $t_objdir/texlive.infra.tlpobj"

if [ $NEWINST = 1 ] ; then
  # use config.guess and platform code to get the current platform
  archs=`perl installer/platform.pl installer/config.guess`
else
  archs=`ls -d $ROOT/bin/*`
fi
echo "archs = $archs"

cp tlpobj/bin-texlive.tlpobj tlpobj/texlive.infra.tlpobj $t_objdir
for a in $archs; do
  if [ $NEWINST = 0 ] ; then
    test -d "$a" || continue  # skip any cruft files
    b=`basename $a`           # just the architecture name
  else
    b=$a
  fi
  
  cp tlpobj/bin-texlive.$b.tlpobj tlpobj/texlive.infra.$b.tlpobj $t_objdir
  # add the tlpobjs for this platform t the list.
  tlpobjs="$tlpobjs $t_objdir/bin-texlive.$b.tlpobj"
  tlpobjs="$tlpobjs $t_objdir/texlive.infra.$b.tlpobj"

  # install the bin dir for this platform.
  (cd bin && tar cf - $b) | (cd $ROOT/bin && tar xf -)
  
  # copy the installer binaries.
  cp installer/lzma/lzmadec.$b $t_instdir/lzma/
  cp installer/lzma/lzma.$b $t_instdir/lzma/
  test -r installer/wget/wget.$b \
  && cp installer/wget/wget.$b $t_instdir/wget
done

# move the architecture-specific files back to the right place
mv bin ./master/
mv installer ./master/tlpkg/
mv tlpobj ./master/tlpkg/

#
if [ $NEWINST = 1 ] ; then
  # if we are installing a new we have to create a minimal tlpdb 
  echo "name 00texlive-installation.config
category TLCore
depend platform:$archs
depend location:http://mirror.ctan.org/systems/texlive/tlnet/2008
depend opt_paper:a4
depend opt_create_formats:0
depend opt_create_symlinks:0
depend opt_sys_bin:/usr/local/bin
depend opt_sys_info:/usr/local/info
depend opt_sys_man:/usr/local/man
depend opt_install_docfiles:1
depend opt_install_srcfiles:1
depend available_architectures:$archs
" > $ROOT/tlpkg/texlive.tlpdb
fi

# invoke secret tlmgr action with the tlpobjs we found.
# Hopefully the result will be a clean tlpdb state.
if [ $NEWINST = 1 ] ; then
  export PATH="$ROOT/bin/$archs:$PATH"
  echo "PATH = $PATH\n";
fi
tlmgr -v _include_tlpobj $tlpobjs

if [ $NEWINST = 1 ] ; then
  mkdir -p $ROOT/texmf-config/web2c
  mkdir -p $ROOT/texmf-var/tex/generic/config
  mkdir -p $ROOT/texmf-var/web2c
  tlmgr option location /var/www/norbert/tlnet/2008
  tlmgr install bin-kpathsea
  tlmgr install hyphen-base
  tlmgr install bin-tetex
  tlmgr install bin-texconfig
  tlmgr generate updmap
  tlmgr generate language
  tlmgr generate fmtutil
  mktexlsr
  updmap-sys
  fmtutil-sys --all		# should not do anything!
  #
  # should we install collection-basic now???
  # otherwise we don't have pdftex etc etc?!?!
  #tlmgr install collection-basic
fi
echo "$0: done."

