##
## Portuguese tables
##

package Date::Language::Portuguese;

use strict;
use warnings;
use utf8;

use Date::Language ();

use base 'Date::Language';

our $VERSION = '2.35'; # VERSION: generated
# ABSTRACT: Portuguese localization for Date::Format

our @DoW  = qw(domingo segunda-feira terça-feira quarta-feira quinta-feira sexta-feira sábado);
our @MoY  = qw(janeiro fevereiro março abril maio junho
               julho agosto setembro outubro novembro dezembro);
our @DoWs = map { substr($_,0,3) } @DoW;
our @MoYs = map { substr($_,0,3) } @MoY;
our @AMPM = qw(AM PM);

our @Dsuf = ('º') x 32;

our ( %MoY, %DoW );
Date::Language::_build_lookups();

# Formatting routines

sub format_a { $DoWs[$_[0]->[6]] }
sub format_A { $DoW[$_[0]->[6]] }
sub format_b { $MoYs[$_[0]->[4]] }
sub format_B { $MoY[$_[0]->[4]] }
sub format_h { $MoYs[$_[0]->[4]] }
sub format_o { sprintf("%2d%s",$_[0]->[3],$Dsuf[$_[0]->[3]]) }
sub format_p { $_[0]->[2] >= 12 ?  $AMPM[1] : $AMPM[0] }

1;

__END__

=pod

=encoding UTF-8

=head1 NAME

Date::Language::Portuguese - Portuguese localization for Date::Format

=head1 VERSION

version 2.35

=head1 AUTHOR

Graham <gbarr@pobox.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2020 by Graham Barr.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
