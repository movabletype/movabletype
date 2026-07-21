##
## Swedish tables
## Contributed by Matthew Musgrove <muskrat@mindless.com>
## Corrected by dempa
##

package Date::Language::Swedish;

use strict;
use warnings;
use base 'Date::Language';
use Date::Language::English ();

our $VERSION = '2.35'; # VERSION: generated
# ABSTRACT: Swedish localization for Date::Format

our @MoY  = qw(januari februari mars april maj juni juli augusti september oktober november december);
our @MoYs = map { substr($_,0,3) } @MoY;
our @DoW  = map($_ . "dagen", qw(sön mån tis ons tors fre lör));
our @DoWs = map { substr($_,0,2) } @DoW;

# the ordinals are not typically used in modern times
our @Dsuf = ('a' x 2, 'e' x 29);

our @AMPM =   @{Date::Language::English::AMPM};

our ( %MoY, %DoW );
Date::Language::_build_lookups();

# Formatting routines

sub format_a { $DoWs[$_[0]->[6]] }
sub format_A { $DoW[$_[0]->[6]] }
sub format_b { $MoYs[$_[0]->[4]] }
sub format_B { $MoY[$_[0]->[4]] }
sub format_h { $MoYs[$_[0]->[4]] }
sub format_p { $_[0]->[2] >= 12 ?  $AMPM[1] : $AMPM[0] }
sub format_o { sprintf("%2de",$_[0]->[3]) }

1;

__END__

=pod

=encoding UTF-8

=head1 NAME

Date::Language::Swedish - Swedish localization for Date::Format

=head1 VERSION

version 2.35

=head1 AUTHOR

Graham <gbarr@pobox.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2020 by Graham Barr.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
