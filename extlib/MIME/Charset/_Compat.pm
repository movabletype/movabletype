
package MIME::Charset::_Compat;
use 5.004;

use strict;

use vars qw($VERSION);

$VERSION = "0.04";

sub FB_CROAK { 1; }
sub FB_PERLQQ { 100; }
sub FB_HTMLCREF { 200; }
sub FB_XMLCREF { 400; }
sub encode { $_[1]; }
sub decode { $_[1]; }
sub from_to {
    if ((lc($_[2]) eq "us-ascii" or lc($_[1]) eq "us-ascii") and
	$_[0] =~ s/[^\x01-\x7e]/?/g and $_[3] == 1) {
	die "Non-ASCII characters";
    }
    $_[0];
}
sub is_utf8 { 0; }
sub resolve_alias {
    my $cset = lc(shift);
    if ($cset eq "8bit" or $cset !~ /\S/) {
	return undef;
    } else {
	return $cset;
    }
}

1;

