##
## Italian tables
##

package Date::Language::Italian;

use strict;
use warnings;
use Date::Language ();
use base 'Date::Language';

our $VERSION = '2.35'; # VERSION: generated
# ABSTRACT: Italian localization for Date::Format

our (@DoW, @DoWs, @MoY, @MoYs, @AMPM, @Dsuf, %MoY, %DoW);

@MoY  = qw(Gennaio Febbraio Marzo Aprile Maggio Giugno
       Luglio Agosto Settembre Ottobre Novembre Dicembre);
@MoYs = qw(Gen Feb Mar Apr Mag Giu Lug Ago Set Ott Nov Dic);
@DoW  = qw(Domenica Lunedi Martedi Mercoledi Giovedi Venerdi Sabato);
@DoWs = qw(Dom Lun Mar Mer Gio Ven Sab);

use Date::Language::English ();
@AMPM =   @{Date::Language::English::AMPM};
@Dsuf =   @{Date::Language::English::Dsuf};

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

Date::Language::Italian - Italian localization for Date::Format

=head1 VERSION

version 2.35

=head1 AUTHOR

Graham <gbarr@pobox.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2020 by Graham Barr.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
