##
## German tables
##

package Date::Language::German;

use strict;
use warnings;
use utf8;

use Date::Language::English ();

use base 'Date::Language';

our $VERSION = '2.35'; # VERSION: generated
# ABSTRACT: German localization for Date::Format

our @MoY  = qw(Januar Februar März April Mai Juni
       Juli August September Oktober November Dezember);
our @MoYs = qw(Jan Feb Mär Apr Mai Jun Jul Aug Sep Okt Nov Dez);
our @DoW  = qw(Sonntag Montag Dienstag Mittwoch Donnerstag Freitag Samstag);
our @DoWs = qw(So Mo Di Mi Do Fr Sa);

our @AMPM =   @{Date::Language::English::AMPM};
our @Dsuf =   @{Date::Language::English::Dsuf};

our ( %MoY, %DoW );
Date::Language::_build_lookups();

# Timezone abbreviation translations (English → German)
our %TZ = (
    'CET'  => 'MEZ',    # Mitteleuropäische Zeit
    'CEST' => 'MESZ',   # Mitteleuropäische Sommerzeit
    'WET'  => 'WEZ',    # Westeuropäische Zeit
    'WEST' => 'WESZ',   # Westeuropäische Sommerzeit
    'EET'  => 'OEZ',    # Osteuropäische Zeit
    'EEST' => 'OESZ',   # Osteuropäische Sommerzeit
);

# Formatting routines

sub format_a { $DoWs[$_[0]->[6]] }
sub format_A { $DoW[$_[0]->[6]] }
sub format_b { $MoYs[$_[0]->[4]] }
sub format_B { $MoY[$_[0]->[4]] }
sub format_h { $MoYs[$_[0]->[4]] }
sub format_p { $_[0]->[2] >= 12 ?  $AMPM[1] : $AMPM[0] }
sub format_o { sprintf("%2d.",$_[0]->[3]) }

1;

__END__

=pod

=encoding UTF-8

=head1 NAME

Date::Language::German - German localization for Date::Format

=head1 VERSION

version 2.35

=head1 AUTHOR

Graham <gbarr@pobox.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2020 by Graham Barr.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
