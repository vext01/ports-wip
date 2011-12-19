#!/usr/bin/perl

use warnings;
use strict;

# flush an output stream
# argument: a filehandle reference
sub flush {
  my ($fh) = @_;

  my $prev_fh = select($fh);
  my $prev_autoflush = $|;
  $| = 1; # force a flush and turn on autoflush
  $| = $prev_autoflush; # restore the previous autoflush status for this fh
  select($prev_fh);
}

# run a command with (optional) redirections, without a shell
#
# arguments: input filename, output filename, error filename
#   (undef for a filename means no redirection)
# return value: exit status from the child
#
# usage:
#   my $status = sys_redir('foo.tar.xz', 'foo.tar', 'undef', 'xzdec', '-q')
# equivalent to
#   system('xzdec -q <foo.tar.xz >foo.tar');
#   my $status = $? >> 8;
# execpt it never runs a shell and does some additional error checking
sub sys_redir {
  my $in = shift;
  my $out = shift;
  my $err = shift;

  # description for error messages
  my $desc = "@_";
  $desc .= " <$in"  if defined $in;
  $desc .= " <$out" if defined $out;
  $desc .= " <$err" if defined $err;

  # log what we're about to do
  ddebug("Preparing to run: $desc\n");

  # flush stdout and stderr for tydiness
  flush \*STDOUT;
  flush \*STDERR;

  # duplicate file handles
  open(my $stdin,  '<&', \*STDIN)   || die "$desc: failed to dup stdin: $!\n";
  open(my $stdout, '>&', \*STDOUT)  || die "$desc: failed to dup stdout: $!\n";
  open(my $stderr, '>&', \*STDERR)  || die "$desc: failed to dup stderr: $!\n";

  # possibly tweak the file handles
  if (defined $in) {
    open(STDIN,  '<', $in)      || die "$desc: failed to read from $in: $!\n";
  }
  if (defined $out) {
    open(STDOUT, '>', $out)     || die "$desc: failed to write to $out: $!\n"
  }
  if (defined $err) {
    open(STDERR, '>', $err)     || die "$desc: failed to write to $err: $!\n"
  }

  # run the command
  system { $_[0] } @_;

  # check common errors and get actual exit value
  # (taken from perldoc -f system)
  my $ret;
  if ($? == -1) {
    die "failed to execute $desc: $!\n";
  } elsif ($? & 127) {
    die sprintf("child $desc died with signal %d, %s coredump\n",
      ($? & 127), ($? & 128) ? 'with' : 'without');
  } else {
    $ret = $? >> 8;
  }

  # flush stdout and stderr again for tydiness
  flush \*STDOUT;
  flush \*STDERR;

  # restore handles
  open(STDIN,  '<&', $stdin)    || die "$desc: failed to restore stdin: $!\n";
  open(STDOUT, '>&', $stdout)   || die "$desc: failed to restore stdout: $!\n";
  open(STDERR, '>&', $stderr)   || die "$desc: failed to restore stderr: $!\n";

  # log the return value
  ddebug("Child '$desc' returned: $ret\n")

  # done
  return $ret;
}

my $i;

sub test {
  $i++;
  print STDERR "\n";
  print "\n===> BEGIN $i <===\n";
  print "$i Child expects input, please type something\n" if !defined $_[0];
  print "$i Unflushed sdtout from parent"; # no \n
  print STDERR "$i Unflushed sdterr from parent"; # no \n
  my $status = sys_redir @_;
  print "$i Parent writing to stdout (please type something)\n";
  print "$i Parent reading from stdin: ", scalar <>;
  warn "$i Parent writing to stderr\n";
}

test('Cin', 'Cout1', undef, 'perl', '-ne',
    'print "C in-out1 $_"; warn "W in-out1\n"');
test('Cin', undef, undef, 'perl', '-ne',
    'print "C in- $_"; warn "W in-\n"');
test(undef, 'Cout2', undef, 'perl', '-e',
    'print "C -out2 ", scalar <>; warn "W -out2\n"');
test(undef, undef, undef, 'perl', '-e',
    'print "C - ", scalar <>; warn "W -\n"');

# vim: ts=2 sw=2 et
