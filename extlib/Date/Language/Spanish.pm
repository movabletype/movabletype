##
## Spanish tables
##

package Date::Language::Spanish;

use strict;
use warnings;
use utf8;
use Date::Language ();

use base 'Date::Language';

our $VERSION = '2.35'; # VERSION: generated
# ABSTRACT: Spanish localization for Date::Format

our @DoW = qw(domingo lunes martes miércoles jueves viernes sábado);
our @MoY = qw(enero febrero marzo abril mayo junio
      julio agosto septiembre octubre noviembre diciembre);
our @DoWs = map { substr($_,0,3) } @DoW;
our @MoYs = map { substr($_,0,3) } @MoY;
our @AMPM = qw(AM PM);

our @Dsuf = ((qw(ro do ro to to to mo vo no mo)) x 3, 'ro');

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

Date::Language::Spanish - Spanish localization for Date::Format

=head1 VERSION

version 2.35

=head1 AUTHOR

Graham <gbarr@pobox.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2020 by Graham Barr.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
