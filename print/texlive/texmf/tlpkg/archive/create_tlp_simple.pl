#!/usr/bin/env perl

$^W = 1
use strict;

use TLSRC;
use TLP;
use TLTREE;
use Data::Dumper;

#our $opt_debug=1;

my $tltree = TLTREE->new( 'svnroot' => "/src/TeX/texlive-svn/Master" );
print "Initializing tltree start: ", `date`;
$tltree->init_from_statusfile("/src/TeX/texlive-svn/Master/svn.status");
print "Initializing tltree stop: ", `date`;

foreach my $f (@ARGV) {
	my $tlsrc = new TLSRC;
	$tlsrc->from_file($f);
	print "WORKING ON $f\n";
	my $tlp = $tlsrc->make_tlp($tltree);
	my $name = $tlp->name;
	open(FOO,">tlp/$name.tlp");
	$tlp->writeout_simple(\*FOO);
	close(FOO);
}
		

print "End of operation: ", `date`;
