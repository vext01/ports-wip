#!/usr/bin/env perl
#
# tpm2deb-source.pl
# machinery to create debian packages from TeX Live depot
# (c) 2005, 2006 Norbert Preining
#
# $Id: tpm2deb-source.pl 2691 2007-04-16 09:42:22Z frank $
#
# configuration is done via the file tpm2deb.cfg
# 

use strict;
no strict 'refs';
# use warnings;
# no warnings 'uninitialized';

my $_tmp;

my $opt_master;
our $opt_nosrcpkg;
our $opt_noremove;
my $globalreclevel;
my $oldsrcdir;
my $datadump ;

BEGIN {
	my $upstream_modules = "/usr/share/tex-common/";
	unshift (@INC, "./all/debian");
	unshift (@INC, $upstream_modules);
}

my ($mydir,$mmydir);
($mydir = $0) =~ s,/[^/]*$,,;
if ($mydir eq $0) { $mydir = `pwd` ; chomp($mydir); }
if (!($mydir =~ m,/.*,,)) { $mmydir = `pwd`; chomp($mmydir); $mydir = "$mmydir/$mydir" ; }


# $opt_master = "./LocalTPM";
my $opt_debug = 0;
$opt_nosrcpkg = 0;
$opt_noremove = 0;
$globalreclevel = 1;
$oldsrcdir = "./src";
$datadump = "tpm.data";

use Getopt::Long;
# use Data::Dumper;

#use Strict;
use File::Basename;
use File::Copy;
use File::Path;
use File::Temp qw/ tempfile tempdir /;
use Storable;
## not needed, atm we are calling eperl binary use Parse::ePerl;
#use XML::DOM;
use Cwd;
#use FileUtils qw(canon_dir cleandir make_link newpath member
#		 normalize substitute_var_val dirname diff_list remove_list
#		 rec_rmdir sync_dir walk_dir start_redirection stop_redirection);
#use Tpm;
#
# Configuration for destination of files
# DONT USER DOUBLE QUOTES; THESE VARIABLES HAVE TO GET REEVALUATED
# AFTER $tmpdir IS SET!!
#
my $changelog = "";
my $changelogversion = "";
my $changelogextraversion = "";
my $changelogrevision = "";
my $changelogdistribution = "";
my $allowed_dists = "(unstable|UNRELEASED|sarge-backports|etch-backports|stable-security|experimental)";


our $Master;

$Master = `pwd`;
chomp($Master);
my $TpmGlobalPath = $Master;
my $DataGlobalPath = $Master;

unshift (@INC, "$Master/../Build/tools");
File::Basename::fileparse_set_fstype('unix');


use Getopt::Long;
use File::Basename;
use File::Copy;
use File::Path;
use File::Temp qw/ tempfile tempdir /;
use Storable;
use Cwd;
use Tpm;

our (%TeXLive);
our (%Config,%TpmData);
our %TexmfTreeOfType = ( "TLCore" => "texmf",
 						"Documentation" => "texmf-doc",
 						"Package" => "texmf-dist");
our @TpmCategories = keys %TexmfTreeOfType;
our %TypeOfTexmfTree = reverse %TexmfTreeOfType;

# pre set $opt_master to ./LocalTPM which contains also the Tools dir
# this is set in the main script, and changed with commandline option.
# should it maybe be deleted here?

my $opt_onlyscripts;

sub populate_TpmData_from_dump {
  my $datafile = $_[0];
  my $tpmdataref = retrieve($datafile);
  %TpmData = %{$tpmdataref};
}

sub load_collection_tpm_data {
	# local functions
	sub trim {
		my ($str) = @_;
		$str =~ s/^[\n\s]+//;
		$str =~ s/[\n\s]+$//;
		return $str;
	}
	sub get_requires {
		my ($tpm,$type) = @_;
		my %requires = $tpm->getHash("Requires");
		my @keylist = keys %requires;
		my @tlcorereqlist = (); 
		my @packagereqlist = ();
		if ($type eq '') { 
			$type = "all";
		}
		foreach my $k (keys %requires) {
			foreach my $e (@{$requires{$k}}) {
				# manually exclude Windows-only packages
				   if ($e eq "bin-bzip2") {}
				elsif ($e eq "bin-xpdf") {}
				elsif ($e eq "bin-chktex") {}
				elsif ($e eq "bin-ghostscript") {}
				elsif ($e eq "bin-gzip") {}
				elsif ($e eq "bin-jpeg2ps") {}
				elsif ($e eq "bin-perl") {}
				elsif ($e eq "bin-windvi") {}
				elsif ($e eq "lib-freetype2") {}
				elsif ($e eq "lib-gd") {}
				elsif ($e eq "lib-geturl") {}
				elsif ($e eq "lib-gnu") {}
				elsif ($e eq "lib-gs") {}
				elsif ($e eq "lib-jpeg") {}
				elsif ($e eq "lib-md5") {}
				elsif ($e eq "lib-png") {}
				elsif ($e eq "lib-regex") {}
				elsif ($e eq "lib-texmfmp") {}
				elsif ($e eq "lib-tiff") {}
				elsif ($e eq "lib-ttf") {}
				elsif ($e eq "lib-xpdf") {}
				elsif ($e eq "lib-xpm") {}
				elsif ($e eq "lib-zlib") {}
				elsif ($e  =~ /^bin-(.*)$/) {
					push @packagereqlist, "$k/$e";
				}
				elsif ($e  =~ /^hyphen-(.*)$/){
					push @packagereqlist, "$k/$e";
				}
				elsif ($k eq "TLCore") {
					push @tlcorereqlist, "$k/$e";
				} else {
					push @packagereqlist, "$k/$e";
				}
			}
		}
		if ($type eq '' || $type eq 'all') {
			my %foo;
			$foo{'TLCore'} = \@tlcorereqlist;
			$foo{'Package'} = \@packagereqlist;
			#my @foo=(@tlcorereqlist,@packagereqlist);
			#return(@foo);
			return(\%foo);
		} elsif ($type eq 'TLCore') {
			return(@tlcorereqlist);
		} elsif ($type eq 'Package') {
			return(@packagereqlist);
		} else {
			die("Don't know this type: $type!\n");
		}
	}
	# start of real function
	print "Start loading tpm data ... \n";
	foreach my $t ('TLCore', 'Documentation', 'Package') {
		my $subtree = ${TexmfTreeOfType}{$t};
		foreach my $f (<$Master/$subtree/tpm/*.tpm>) {
			print "Working on $f\n";
			my $shortn = basename($f);
			$shortn =~ s,\.tpm$,,;
			if ($shortn !~ m/^scheme-/) { next ; }
			my $tpm = Tpm->new("$subtree/tpm/$shortn.tpm");
			$TpmData{$t}{$shortn}{'BinPatterns'} = [ $tpm->getList("BinPatterns") ];
			$TpmData{$t}{$shortn}{'DocPatterns'} = [ $tpm->getList("DocPatterns") ];
			$TpmData{$t}{$shortn}{'RunPatterns'} = [ $tpm->getList("RunPatterns") ];
			$TpmData{$t}{$shortn}{'SourcePatterns'} = [ $tpm->getList("SourcePatterns") ];
			$TpmData{$t}{$shortn}{'BinFiles'} = [ $tpm->getFileList("BinFiles") ];
			$TpmData{$t}{$shortn}{'DocFiles'} = [ $tpm->getFileList("DocFiles") ];
			$TpmData{$t}{$shortn}{'RunFiles'} = [ $tpm->getFileList("RunFiles") ];
			$TpmData{$t}{$shortn}{'SourceFiles'} = [ $tpm->getFileList("SourceFiles") ];
			$TpmData{$t}{$shortn}{'RemoteFiles'} = [ $tpm->getFileList("RemoteFiles") ];
			$TpmData{$t}{$shortn}{'Title'} = trim($tpm->getAttribute("Title"));
			# print "got title $TpmData{$t}{$shortn}{'Title'}\n";
			$TpmData{$t}{$shortn}{'Description'} = trim($tpm->getAttribute("Description"));
			$TpmData{$t}{$shortn}{'License'} = trim($tpm->getAttribute("License"));
			my @foo = $tpm->getList("Installation");
			$TpmData{$t}{$shortn}{'Installation'} = \@foo ;
			my $alldeps = get_requires($tpm,'all');
			my @incs = @{$alldeps->{'Package'}};
			my @deps = @{$alldeps->{'TLCore'}};
			$TpmData{$t}{$shortn}{'Package'} = \@incs;
			$TpmData{$t}{$shortn}{'TLCore'} = \@deps;
		}
	}
	print " ... done\n";
}

sub create_tlsrc_files {
	print "Creating tlsrc files TpmData\n\n";
	#foreach my $t ('TLCore', 'Documentation', 'Package') {
	foreach my $t ('TLCore', 'Documentation') {
		print "Creating tlsrc for $t:\n";
		my %foo = %{$TpmData{$t}};
		foreach my $p (keys %foo) {
			open (FOO,">tlsrc/$p.tlsrc") || die("Cannot open tlsrc/$p.tlsrc!");
			print FOO "name $p\n";
			print FOO "category $t\n";
			if ($TpmData{$t}{$p}{'Title'} !~ /^[[:space:]]*$/) {
				print FOO "shortdesc $TpmData{$t}{$p}{'Title'}\n";
			}
			$_tmp = "$TpmData{$t}{$p}{'Description'}";
			if (defined($_tmp) && ($_tmp !~ /^[[:space:]]*$/)) {
				$_tmp = "longdesc $_tmp";
				write FOO;
			}
			#print FOO "longdesc $TpmData{$t}{$p}{'Description'}\n";
			foreach my $foo (@{$TpmData{$t}{$p}{'Package'}}) {
				print FOO "depend $foo\n";
			}
			foreach my $foo (@{$TpmData{$t}{$p}{'TLCore'}}) {
				print FOO "depend $foo\n";
			}
			foreach my $foo (@{$TpmData{$t}{$p}{'SourcePatterns'}}) {
				print FOO "SourcePatterns f $foo\n";
			}
			foreach my $foo (@{$TpmData{$t}{$p}{'BinPatterns'}}) {
				print FOO "binpatterns f $foo\n";
			}
			foreach my $foo (@{$TpmData{$t}{$p}{'DocPatterns'}}) {
				print FOO "docpatterns f $foo\n";
			}
			foreach my $foo (@{$TpmData{$t}{$p}{'RunPatterns'}}) {
				next if ($foo =~ /\.tpm$/);
				print FOO "runpatterns f $foo\n";
			}
			foreach my $ex (@{$TpmData{$t}{$p}{'Installation'}}) {
				my %foo = %{$ex};
				print FOO "execute $foo{'function'} $foo{'mode'} $foo{'parameter'}\n";
			}
			close(FOO);
		}
	}
	return (0);
	foreach my $t ('Package') {
		print "Creating tlsrc for $t:\n";
		my %foo = %{$TpmData{$t}};
		foreach my $p (keys %foo) {
			open (FOO,">tlsrc/$p.tlsrc") || die("Cannot open tlsrc/$p.tlsrc!");
			print FOO "name $p\n";
			foreach my $foo (@{$TpmData{$t}{$p}{'Package'}}) {
				print FOO "depend $foo\n";
			}
			foreach my $foo (@{$TpmData{$t}{$p}{'TLCore'}}) {
				print FOO "depend $foo\n";
			}
			foreach my $ex (@{$TpmData{$t}{$p}{'Installation'}}) {
				my %foo = %{$ex};
				print FOO "execute $foo{'function'} $foo{'mode'} $foo{'parameter'}\n";
			}
			close(FOO);
		}
	}
}


&main(@ARGV);

1;

# variables needed outside of main
my $version;
my $revision;
my $extraversion;
my $date;
my $arch;
my $shortl;

sub main {
	${Tpm::MasterDir} = $TeXLive{'all'}{'tpm_global_path'};
    $arch = "all";
    ${Tpm::CurrentArch} = "i386-linux";
	${Tpm::MasterDir} = $Master;
	load_collection_tpm_data();
	create_tlsrc_files();
}

#####################################
#
# Formats
#
format FOO =
^<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
$_tmp
 ^<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
$_tmp
.

### Local Variables:
### perl-indent-level: 4
### tab-width: 4
### indent-tabs-mode: t
### End:
# vim:set tabstop=4: #
