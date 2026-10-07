##
## Norwegian tables
##

package Date::Language::Norwegian;

use strict;
use warnings;
use utf8;
use Date::Language ();

use base 'Date::Language';
use Date::Language::English ();

our $VERSION = '2.35'; # VERSION: generated
# ABSTRACT: Norwegian localization for Date::Format

our @MoY  = qw(Januar Februar Mars April Mai Juni
       Juli August September Oktober November Desember);
our @MoYs = qw(Jan Feb Mar Apr Mai Jun Jul Aug Sep Okt Nov Des);
our @DoW  = qw(Søndag Mandag Tirsdag Onsdag Torsdag Fredag Lørdag);
our @DoWs = qw(Søn Man Tir Ons Tor Fre Lør);

our @AMPM =   @{Date::Language::English::AMPM};
our @Dsuf =   @{Date::Language::English::Dsuf};

our ( %MoY, %DoW );
Date::Language::_build_lookups();

# Formatting routines

sub format_a { $DoWs[$_[0]->[6]] }
sub format_A { $DoW[$_[0]->[6]] }
sub format_b { $MoYs[$_[0]->[4]] }
sub format_B { $MoY[$_[0]->[4]] }
sub format_h { $MoYs[$_[0]->[4]] }
sub format_p { $_[0]->[2] >= 12 ?  $AMPM[1] : $AMPM[0] }

1;

__END__

=pod

=encoding UTF-8

=head1 NAME

Date::Language::Norwegian - Norwegian localization for Date::Format

=head1 VERSION

version 2.35

=head1 AUTHOR

Graham <gbarr@pobox.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2020 by Graham Barr.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
