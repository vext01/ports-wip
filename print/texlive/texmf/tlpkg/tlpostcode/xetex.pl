# $Id: xetex.pl 24091 2011-09-26 00:01:09Z karl $
# post action for xetex to handle system font stuff.
# Copyright 2008, 2009, 2011 Norbert Preining
# This file is licensed under the GNU General Public License version 2
# or any later version.
#
# We create the fontconfig configuration file.  On Windows,
# we also run fc-cache to make the fonts available.
# http://www.tug.org/texlive/doc/texlive-en/texlive-en.html#xetexfontconfig

my $texdir;
my $mode;

BEGIN {
  $^W = 1;
  $mode = lc($ARGV[0]);
  $texdir = $ARGV[1];
  # make Perl find our packages first:
  unshift (@INC, "$texdir/tlpkg");
}
use TeXLive::TLUtils qw(win32 mkdirhier conv_to_w32_path log info);

if ($mode eq 'install') {
  do_install();
} elsif ($mode eq 'remove') {
  do_remove();
} else {
  die("unknown mode: $mode\n");
}

sub do_remove {
  # do nothing
}

sub do_install {
  # bin-installs font-config related stuff
  chomp( my $fcache = `kpsewhich -var-value=FC_CACHEDIR` ) ;
  chomp( my $fconf = `kpsewhich -var-value=FONTCONFIG_PATH` ) ;
  if (-r "$texdir/bin/win32/xetex.exe") {
    # we have installed w32, so put it into texmfsysvar
    mkdirhier($fcache);
    mkdirhier($fconf);
    TeXLive::TLUtils::rmtree($fcache);
    TeXLive::TLUtils::rmtree($fconf);
    my @cpycmd;
    if (win32()) {
      push @cpycmd, "xcopy", "/e", "/i", "/q", "/y";
    } else {
      push @cpycmd, "cp", "-R";
    }
    system(@cpycmd,
             (win32() ? conv_to_w32_path("$texdir/tlpkg/tlpostcode/xetex/conf") :
                       "$texdir/tlpkg/tlpostcode/xetex/conf"),
             (win32() ? conv_to_w32_path($fconf) : $fconf));
    system(@cpycmd,
             (win32() ? conv_to_w32_path("$texdir/tlpkg/tlpostcode/xetex/cache") :
                       "$texdir/tlpkg/tlpostcode/xetex/cache"),
             (win32() ? conv_to_w32_path($fcache) : $fcache));
    if (open(FONTSCONF, "<$texdir/tlpkg/tlpostcode/xetex/conf/fonts.conf")) {
      my @lines = <FONTSCONF>;
      close(FONTSCONF);
      if (open(FONTSCONF, ">$fconf/fonts.conf")) {
        my $winfontdir;
        if (win32()) {
          $winfontdir = $ENV{'SystemRoot'}.'/fonts';
          $winfontdir =~ s!\\!/!g;
        }
        foreach (@lines) {
          $_ =~ s!c:/Program Files/texlive/YYYY!$texdir!;
          $_ =~ s!c:/windows/fonts!$winfontdir! if win32();
          print FONTSCONF;
        }
        close(FONTSCONF);
      } else {
        warn("Cannot open $fconf/fonts.conf for writing\n");
      }
    } else {
      warn("Cannot open $texdir/tlpkg/tlpostcode/xetex/conf/fonts.conf\n");
    }
  }
  # call fc-cache but only when we install on w32!
  if (win32()) {
    info("Running fc-cache -v -r\n");
    log(`fc-cache -v -r 2>&1`);
    #system("fc-cache","-v", "-r");
  } else {
    # create a texlive-fontconfig.conf file in $texmfsysvar
    mkdirhier("$fconf/conf");
    if (!open(FONTSCONF, ">$fconf/texlive-fontconfig.conf")) {
      warn("Cannot open $fconf/texlive-fontconfig.conf for writing\n");
    } else {
      print FONTSCONF '<?xml version="1.0"?>
<!DOCTYPE fontconfig SYSTEM "fonts.dtd">
<fontconfig>
';
      for my $t (qw/opentype truetype type1/) {
        print FONTSCONF "  <dir>$texdir/texmf-dist/fonts/$t</dir>\n";
      }
      print FONTSCONF "</fontconfig>\n";
      close(FONTSCONF) || tlwarn("Cannot close filehandle for texmfsysvar/fonts/conf/texlive-fontconfig.conf\n");
    }
    # cygwin specific warning
    # we don't have platform available ...
    chomp(my $un = `uname`);
    if ($un =~ m/cygwin/i) {
      if (! -r "/usr/bin/cygfontconfig-1.dll") {
        printf STDERR "\nXeTeX on Cygwin requires fontconfig.\nPlease run cygwin's setup program and install the fontconfig package.\n";
      }
    }
  }
}

### Local Variables:
### perl-indent-level: 2
### tab-width: 2
### indent-tabs-mode: nil
### End:
# vim:set tabstop=2 expandtab: #
