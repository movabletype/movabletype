##
## Tigrinya-Eritrean tables
##

package Date::Language::TigrinyaEritrean;

use strict;
use warnings;
use base 'Date::Language';

our $VERSION = '2.35'; # VERSION: generated
# ABSTRACT: TigrinyaEritrean localization for Date::Format

our (@DoW, @DoWs, @MoY, @MoYs, @AMPM, @Dsuf, %MoY, %DoW);

if ( $] >= 5.006 ) {
@DoW = (
"\x{1230}\x{1295}\x{1260}\x{1275}",
"\x{1230}\x{1291}\x{12ed}",
"\x{1230}\x{1209}\x{1235}",
"\x{1228}\x{1261}\x{12d5}",
"\x{1213}\x{1219}\x{1235}",
"\x{12d3}\x{122d}\x{1262}",
"\x{1240}\x{12f3}\x{121d}"
);
@MoY = (
"\x{1303}\x{1295}\x{12e9}\x{12c8}\x{122a}",
"\x{134c}\x{1265}\x{1229}\x{12c8}\x{122a}",
"\x{121b}\x{122d}\x{127d}",
"\x{12a4}\x{1355}\x{1228}\x{120d}",
"\x{121c}\x{12ed}",
"\x{1301}\x{1295}",
"\x{1301}\x{120b}\x{12ed}",
"\x{12a6}\x{1308}\x{1235}\x{1275}",
"\x{1234}\x{1355}\x{1274}\x{121d}\x{1260}\x{122d}",
"\x{12a6}\x{12ad}\x{1270}\x{12cd}\x{1260}\x{122d}",
"\x{1296}\x{126c}\x{121d}\x{1260}\x{122d}",
"\x{12f2}\x{1234}\x{121d}\x{1260}\x{122d}"
);
@DoWs = map { substr($_,0,3) } @DoW;
@MoYs = map { substr($_,0,3) } @MoY;
@AMPM = (
"\x{1295}/\x{1230}",
"\x{12F5}/\x{1230}"
);

@Dsuf = ("\x{12ed}" x 31);
}
else {
@DoW = (
"ሰንበት",
"ሰኑይ",
"ሰሉስ",
"ረቡዕ",
"ሓሙስ",
"ዓርቢ",
"ቀዳም"
);
@MoY = (
"ጥሪ",
"ለካቲት",
"መጋቢት",
"ሚያዝያ",
"ግንቦት",
"ሰነ",
"ሓምለ",
"ነሓሰ",
"መስከረም",
"ጥቅምቲ",
"ሕዳር",
"ታሕሳስ"
);
@DoWs = map { substr($_,0,9) } @DoW;
@MoYs = map { substr($_,0,9) } @MoY;
@AMPM = (
"ን/ሰ",
"ድ/ሰ"
);

@Dsuf = ("ይ" x 31);
}

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

Date::Language::TigrinyaEritrean - TigrinyaEritrean localization for Date::Format

=head1 VERSION

version 2.35

=head1 AUTHOR

Graham <gbarr@pobox.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2020 by Graham Barr.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
