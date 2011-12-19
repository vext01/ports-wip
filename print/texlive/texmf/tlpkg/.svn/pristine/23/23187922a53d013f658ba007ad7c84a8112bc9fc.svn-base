
use strict;
$^W=1;

use Tk;
use Tk::Font;

my $mw = MainWindow->new();
my $l = $mw->Label(-text => "Hello");
$l->pack;

my $f = $l->Font();

my %fp = $f->configure();
print "preset settings:\n";
for my $k (keys %fp) {
  if (defined($fp{$k})) {
    print "$k -> $fp{$k}\n";
  } else {
    print "$k -> undefined\n";
  }
}

print "actually used settings:\n";
my %fp = $f->actual();
for my $k (keys %fp) {
  print "$k -> $fp{$k}\n";
}


