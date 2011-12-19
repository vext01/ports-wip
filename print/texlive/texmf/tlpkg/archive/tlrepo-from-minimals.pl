#!/usr/bin/env perl
#
# tlrepo-from-minimals.pl
# Copyright 2008, 2009 Norbert Preining
# Licensed under GPLv2 or higher

my $mydir; 

BEGIN {
  $^W = 1;
  chomp ($mydir = `dirname $0`);
  unshift (@INC, "$mydir/..");
}

use strict;

use Cwd qw/abs_path/;
use TeXLive::TLConfig;
use TeXLive::TLPSRC;
use TeXLive::TLPOBJ;
use TeXLive::TLPDB;
use TeXLive::TLTREE;
use TeXLive::TLUtils;
use Getopt::Long;
use Pod::Usage;

my %min_to_tl_arch = qw/freebsd         i386-freebsd
                        freebsd-amd64   amd64-freebsd
                        linux           i386-linux
                        linux-64        x86_64-linux
                        linux-ppc       powerpc-linux
                        osx-universal   universal-darwin
                        mswin           win32
                        solaris-intel   i386-solaris
                        solaris-sparc   sparc-solaris/;

my @scripts_to_link = qw/luatools mtxrun/;

my $help = 0;
my $dist = "current";
my $dest = "web";
my $opt_luatex = 0;
my $opt_context = 1;
my $opt_all = 0;
my $opt_dontclean = 0;
my $source = ".";
my $opt_recreate = 0;
my $opt_nocontainers = 0;
my $texliveminimals = abs_path("$mydir/../../..");
my $upstreamsource = "$texliveminimals/upstream";
my $upstreamoverride = "$texliveminimals/override";
my $upstreamaddons = "$texliveminimals/addons";

TeXLive::TLUtils::process_logging_options();
GetOptions(
    "source=s" => \$source,
    "dist=s" => \$dist,
    "dest=s" => \$dest,
    "luatex" => \$opt_luatex,
    "context" => \$opt_context,
    "all" => \$opt_all,
    "dont-clean" => \$opt_dontclean,
    "recreate" => \$opt_recreate,
    "nocontainers" => \$opt_nocontainers,
    "upstream-source" => \$upstreamsource,
    "upstream-override" => \$upstreamoverride,
    "upstream-addons" => \$upstreamaddons,
    "help|?" => \$help) or pod2usage(1);
pod2usage(-exitstatus => 0, -verbose => 2) if $help;

print "location of context minimals: ", abs_path($source), "\n";
print "location of upstream code: ", abs_path($upstreamsource), "\n";
print "location of upstream overides: ", abs_path($upstreamoverride), "\n";
print "location of upstream addons: ", abs_path($upstreamaddons), "\n";

#
if ($opt_all) {
  $opt_luatex = $opt_context = 1;
}

#
# create a temporary directory for storage of the various files
my $tmp = `mktemp -d`;
chomp($tmp);

info("Using tmp dir $tmp\n");

# copy context files
if ($opt_context) {
  info("Copying files for ConTeXt ... ");
  system("mkdir -p $tmp/texmf-dist");
  system("cp -a $source/current/context/$dist/* $tmp/texmf-dist");
  system("mkdir -p $tmp/tlpkg/tlpsrc");
  get_from_ups("tlpkg/tlpsrc/context.tlpsrc", "$tmp/tlpkg/tlpsrc");
  get_from_ups("tlpkg/tlpsrc/bin-context.tlpsrc", "$tmp/tlpkg/tlpsrc");
  for my $i (keys %min_to_tl_arch) {
    system("mkdir -p $tmp/bin/$min_to_tl_arch{$i}");
    system("cp -a $source/current/bin/context/$i/bin/* $tmp/bin/$min_to_tl_arch{$i}");
    # we have to fix the scripts to be links on unix systems
    if ($i ne "mswin") {
      for my $s (@scripts_to_link) {
        system("ln -sf ../../texmf-dist/scripts/context/lua/$s.lua $tmp/bin/$min_to_tl_arch{$i}/$s");
        system("chmod 0755 $tmp/bin/$min_to_tl_arch{$i}/$s");
      }
    }
    # metafun is not needed anymore, according to Mojca on the train
    # to BachoTeX 2009
    #if ($i eq "mswin") {
    #  system("cp -a $tmp/bin/$min_to_tl_arch{$i}/mpost.exe  $tmp/bin/$min_to_tl_arch{$i}/metafun.exe");
    #} else {
    #  system("ln -s mpost $tmp/bin/$min_to_tl_arch{$i}/metafun");
    #}
    # that is needed otherwise the dangling symlink is ignored
    #system("touch $tmp/bin/$min_to_tl_arch{$i}/mpost");
  }
  get_from_ups("texmf-dist/tex/mptopdf/config/mptopdf.ini",
               "$tmp/texmf-dist/tex/mptopdf/config/mptopdf.ini");
  get_from_ups("texmf/fmtutil/format.context.cnf",
               "$tmp/texmf/fmtutil/format.context.cnf");
  #
  # we want to create the .ini files for the used languages. We could
  # just copy from tug the files there, but some have been renamed, so
  # we create them on the spot.
  #
  # Copying would be:
  #for my $l (qw/cz de en fr it nl ro uk/) {
  # get_from_ups("texmf-dist/tex/context/config/cont-$l.ini"
  #               "$tmp/texmf-dist/tex/context/config/cont-$l.ini");
  #}
  for my $l (glob "$source/current/context/$dist/tex/context/base/cont-??.tex") {
    my $bn = TeXLive::TLUtils::basename($l);
    my $ll = $bn;
    $ll =~ s/cont-(..)\.tex/$1/;
    system('printf \'\\\\input ' . "$bn" . '\n\\\\endinput\n\' > ' . "$tmp/texmf-dist/tex/context/config/cont-$ll.ini");
  }
  if (-d $upstreamaddons) {
    if (-d "$upstreamaddons/context") {
      system("cp -a $upstreamaddons/context/* $tmp");
    }
  }
  info("done\n");
}

if ($opt_luatex) {
  info("Copying files for luatex ... ");
  for my $i (keys %min_to_tl_arch) {
    system("mkdir -p $tmp/bin/$min_to_tl_arch{$i}");
    system("cp -a $source/current/bin/luatex/$i/bin/* $tmp/bin/$min_to_tl_arch{$i}");
    if ($i eq "mswin") {
      system("cp -a $tmp/bin/$min_to_tl_arch{$i}/luatex.exe $tmp/bin/$min_to_tl_arch{$i}/pdfluatex.exe");
    } else {
      system("ln -s luatex $tmp/bin/$min_to_tl_arch{$i}/pdfluatex");
    }
  }
  system("mkdir -p $tmp/tlpkg/tlpsrc");
  get_from_ups("tlpkg/tlpsrc/luatex.tlpsrc", "$tmp/tlpkg/tlpsrc");
  get_from_ups("texmf/fmtutil/format.luatex.cnf",
               "$tmp/texmf/fmtutil/format.luatex.cnf");
  if (-d $upstreamaddons) {
    if (-d "$upstreamaddons/luatex") {
      system("cp -a $upstreamaddons/luatex/* $tmp");
    }
  }
  info("done\n");
}

# copy the tlpkg stuff
info("Copying files for infrastructure ... ");

get_from_ups("tlpkg/TeXLive", "$tmp/tlpkg/TeXLive");
get_from_ups("tlpkg/bin", "$tmp/tlpkg/bin");
get_from_ups("tlpkg/tlpsrc/00texlive.config.tlpsrc", "$tmp/tlpkg/tlpsrc");
# should we get that from TUG, too?
get_from_ups("tlpkg/tlpsrc/00texlive.autopatterns.tlpsrc",
             "$tmp/tlpkg/tlpsrc/00texlive.autopatterns.tlpsrc");
info("done\n");

# create new tlpdb
info("Creating the texlive.tlpdb ... \n");
system("perl $tmp/tlpkg/bin/tlpsrc2tlpdb -from-files -with-win-pattern-warning -all");
info("done\n");

# get the current texlive.tlpdb from the tug server
get_from_ups("tlpkg/texlive.tlpdb", "$tmp/texlive-dist.tlpdb");
my $tltlpdb = TeXLive::TLPDB->new;
$tltlpdb->from_file("$tmp/texlive-dist.tlpdb");
die("Cannot read original tlpdb from $tmp/texlive-dist.tlpdb") unless defined($tltlpdb);

my $mitlpdb = TeXLive::TLPDB->new(root => "$tmp");
die("Cannot read minimals tlpdb from $tmp/tlpkg/texlive.tlpdb") unless defined($mitlpdb);

my $webtlpdb;
if (!$opt_recreate) {
  $webtlpdb = TeXLive::TLPDB->new(root => "$dest");
}
$webtlpdb = $mitlpdb unless defined($webtlpdb);

for my $p ($mitlpdb->list_packages) {
  next if ($p =~ m/^00texlive/);
  my $mitlp = $mitlpdb->get_package($p);
  die "Cannot get $p from minimals tlpdb" unless defined($mitlp);
  my $tltlp = $tltlpdb->get_package($p);
  die "Cannot get $p from original tlpdb" unless defined($tltlp);
  my $webtlp = $webtlpdb->get_package($p);
  die "Cannot get $p from web tlpdb" unless defined($webtlp);
  # fix the revision by adding 1 to the revision as currently shipped by TL
  # or my increasing the version from the minimals tlpdb
  if ($webtlp->revision > $tltlp->revision) {
    $mitlp->revision($webtlp->revision + 1);
  } else {
    $mitlp->revision($tltlp->revision + 1);
  }
  # the following is actually replacing the original tlpobj
  $mitlpdb->add_tlpobj($mitlp);

  # now make basic comparision of the file lists
  my @tlrun = $tltlp->runfiles;
  my @mirun = $mitlp->runfiles;
  my @diffrun = compare_lists(\@tlrun, \@mirun);
  my @tlsrc = $tltlp->srcfiles;
  my @misrc = $mitlp->srcfiles;
  my @diffsrc = compare_lists(\@tlsrc, \@misrc);
  my @tldoc = $tltlp->docfiles;
  my @midoc = $mitlp->docfiles;
  my @diffdoc = compare_lists(\@tldoc, \@midoc);
  my %tlbin = %{$tltlp->binfiles};
  my %mibin = %{$mitlp->binfiles};
  my @tlbin = ();
  my @mibin = ();
  for my $a (values %min_to_tl_arch) {
    push @tlbin, @{$tlbin{$a}} if defined($tlbin{$a});
    push @mibin, @{$mibin{$a}} if defined($mibin{$a});
  }
  my @diffbin = compare_lists(\@tlbin, \@mibin);
  if (@diffrun || @diffbin || @diffdoc || @diffsrc) {
    print "\nDifferences for $p found:\n(- removed from texlive for minimals)\n(+ added to minimals (not present in texlive))\n";
    print "runfiles:\n" if (@diffrun);
    for my $l (@diffrun) {
      print "$l\n";
    }
    print "binfiles:\n" if (@diffbin);
    for my $l (@diffbin) {
      print "$l\n";
    }
    print "docfiles:\n" if (@diffdoc);
    for my $l (@diffdoc) {
      print "$l\n";
    }
    print "srcfiles:\n" if (@diffsrc);
    for my $l (@diffsrc) {
      print "$l\n";
    }
    print "\n";
  }
}

$mitlpdb->save;

if (!$opt_nocontainers) {
  # create the containers
  info("Creating containers ... ");
  my $cmd = "perl $tmp/tlpkg/bin/tl-update-containers -location $dest -no-setup";
  $cmd .= " -recreate" if $opt_recreate;
  system($cmd);
  info("done\ņ");
  if (!$opt_dontclean) {
    info("Cleaning tmp directory (probably dangerous!!!) ... ");
    system("rm -rf \"$tmp\"");
    info ("done\n");
  }
}

info("Finished!\n");


sub compare_lists {
  my ($aref, $bref) = @_;
  my @aa = @$aref;
  my @bb = @$bref;
  my @added = ();
  my @removed = ();
  my @diff = ();
  AA: for my $a (@aa) {
    for my $b (@bb) {
      next AA if ($a eq $b);
    }
    # next AA was not called, so it was not found under $b, thus it is removed
    push @removed, $a;
  }
  BB: for my $b (@bb) {
    for my $a (@aa) {
      next BB if ($a eq $b);
    }
    # next BB was not called, so it was not found under $a, thus it is added
    push @added, $b;
  }
  for my $a (sort @removed) {
    push @diff, "-$a";
  }
  for my $a (sort @added) {
    push @diff, "+$a";
  }
  return(@diff);
}

sub get_from_ups {
  my ($what, $dest) = @_;
  my $dn = TeXLive::TLUtils::dirname($dest);
  system("mkdir -p $dn");
  if (-r "$upstreamoverride/$what") {
    system("cp -a $upstreamoverride/$what $dest");
  } else {
    system("cp -a $upstreamsource/$what $dest");
  }
}

### Local Variables:
### perl-indent-level: 2
### tab-width: 2
### indent-tabs-mode: nil
### End:
# vim:set tabstop=2 expandtab: #
