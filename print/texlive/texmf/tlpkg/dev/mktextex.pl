#!/usr/bin/env perl
# $Id: mktextex.pl 12269 2009-03-01 16:55:53Z trzeciak $
#
# Copyright 2009 Norbert Preining
# This file is licensed under the GNU General Public License version 2
# or any later version.
#
#

my $svnrev = '$Revision: 12269 $';
my $datrev = '$Date: 2009-03-01 17:55:53 +0100 (Sun, 01 Mar 2009) $';

our $Master;

BEGIN {
  $^W = 1;
  # make subprograms (including kpsewhich) have the right path:
  $mydir = $0;
  $mydir =~ s,/[^/]*$,,;
  if (!$^O=~/^MSWin(32|64)$/i) {
    $ENV{"PATH"} = "$mydir:$ENV{PATH}";
  }
  #
  chomp($Master = `kpsewhich -var-value=SELFAUTOPARENT`);
  #
  # make Perl find our packages first:
  unshift (@INC, "$Master/tlpkg");
  unshift (@INC, "$Master/texmf/scripts/texlive");
}

use Cwd qw/abs_path/;
use strict;

use TeXLive::TLConfig;
use TeXLive::TLPDB;

my $localtlpdb = TeXLive::TLPDB->new ("root" => $Master);
die("cannot find tlpdb in $Master") unless (defined($localtlpdb));
my $instloc = $localtlpdb->option_location;
my $mediatlpdb = TeXLive::TLPDB->new ("root" => $instloc);
die("cannot find tlpdb in $instloc.") unless defined($mediatlpdb);


my $fn = shift @ARGV;

printf STDERR "searching tlpdb fof $fn\n";

my @found = $mediatlpdb->find_file($fn);

if ($#found == 0) {
  # we found only one package, so install it
  my ($pkg,$file) = split ":", $found[0];
  printf STDERR "installing $pkg for $file\n";
  system("tlmgr install $pkg >&2");
  print "$Master/$file\n";
} elsif ($#found >= 0) {
  # too many packages found:
  printf STDERR "too many packages provide $fn:\n";
  for my $f (@found) {
    printf STDERR "$f\n";
  }
} else {
  printf STDERR "$fn not found in tlpdb\n";
}

exit 1;

### Local Variables:
### perl-indent-level: 2
### tab-width: 2
### indent-tabs-mode: nil
### End:
# vim:set tabstop=2 expandtab: #
