##
## Greek tables
##
## Traditional date format is: DoW DD{eta} MoY Year (%A %o %B %Y)
##
## Matthew Musgrove <muskrat@mindless.com>
## Translations graciously provided by Menelaos Stamatelos <men@kwsn.net>
## This module returns unicode (utf8) encoded characters.  You will need to
## take the necessary steps for this to display correctly.
##

package Date::Language::Greek;

use strict;
use warnings;
use utf8;

use Date::Language ();

use base 'Date::Language';

our $VERSION = '2.35'; # VERSION: generated
# ABSTRACT: Greek localization for Date::Format

our (@DoW, @DoWs, @MoY, @MoYs, @AMPM, @Dsuf, %MoY, %DoW);

@DoW = (
"Κυριακή",
"Δευτέρα",
"Τρίτη",
"Τετάρτη",
"Πέμπτη",
"Παρασκευή",
"Σάββατο",
);

@MoY = (
"Ιανουαρίου",
"Φεβρουαρίου",
"Μαρτίου",
"Απριλίου",
"Μαΐου",
"Ιουνίου",
"Ιουλίου",
"Αυγούστου",
"Σεπτεμτου",
"Οκτωβρίου",
"Νοεμβρίου",
"Δεκεμβρίου",
);

@DoWs = (
"Κυ",
"Δε",
"Τρ",
"Τε",
"Πε",
"Πα",
"Σα",
);
@MoYs = (
"Ιαν",
"Φε",
"Μαρ",
"Απρ",
"Μα",
"Ιουν",
"Ιουλ",
"Αυγ",
"Σεπ",
"Οκ",
"Νο",
"Δε",
);

@AMPM = ("πμ", "μμ");

@Dsuf = ("η" x 31);

Date::Language::_build_lookups();

# Formatting routines

sub format_a { $DoWs[$_[0]->[6]] }
sub format_A { $DoW[$_[0]->[6]] }
sub format_b { $MoYs[$_[0]->[4]] }
sub format_B { $MoY[$_[0]->[4]] }
sub format_h { $MoYs[$_[0]->[4]] }
sub format_o { sprintf("%2d%s",$_[0]->[3],"η") }
sub format_p { $_[0]->[2] >= 12 ?  $AMPM[1] : $AMPM[0] }

1;

__END__

=pod

=encoding UTF-8

=head1 NAME

Date::Language::Greek - Greek localization for Date::Format

=head1 VERSION

version 2.35

=head1 AUTHOR

Graham <gbarr@pobox.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2020 by Graham Barr.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
