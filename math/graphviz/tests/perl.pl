#!/usr/bin/perl
use gv ;

my $G = gv::graph( "G" ) ;
my $N = gv::protonode( $G ) ;

gv::setv( $N, 'shape', 'box' ) ;

my $a = gv::node( $G, "a" ) ;
my $b = gv::node( $G, "b" ) ;
my $c = gv::node( $G, "c" ) ;
my $d = gv::node( $G, "d" ) ;

gv::edge( $a, $b ) ;
gv::edge( $b, $c ) ;
gv::edge( $c, $d ) ;

gv::setv( $a, 'shape', 'box' ) ;

gv::layout( $G, 'dot' ) ;
gv::render( $G, 'xlib' ) ;

exit( 0 ) ;
