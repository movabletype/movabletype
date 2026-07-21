##
## Hungarian tables based on English
##
#
# This is a just-because-I-stumbled-across-it
# -and-my-wife-is-Hungarian release: if Graham or
# someone adds to docs to Date::Format, I'd be
# glad to correct bugs and extend as needed.
#

package Date::Language::Hungarian;


use strict;
use warnings;
use utf8;
use Date::Language ();

use base 'Date::Language';

our $VERSION = '2.35'; # VERSION: generated
# ABSTRACT: Hungarian localization for Date::Format

our @DoW = qw(Vasárnap Hétfő Kedd Szerda Csütörtök Péntek Szombat);
our @MoY = qw(Január Február Március Április Május Június
      Július Augusztus Szeptember Október November December);
our @DoWs = map { substr($_,0,3) } @DoW;
our @MoYs = map { substr($_,0,3) } @MoY;
our @AMPM = qw(DE. DU.);

# There is no 'th or 'nd in Hungarian, just a dot
our @Dsuf = (".") x 31;

our ( %MoY, %DoW );
Date::Language::_build_lookups();

# Formatting routines

sub format_a { $DoWs[$_[0]->[6]] }
sub format_A { $DoW[$_[0]->[6]] }
sub format_b { $MoYs[$_[0]->[4]] }
sub format_B { $MoY[$_[0]->[4]] }
sub format_h { $MoYs[$_[0]->[4]] }
sub format_p { $_[0]->[2] >= 12 ?  $AMPM[1] : $AMPM[0] }
sub format_P { lc($_[0]->[2] >= 12 ?  $AMPM[1] : $AMPM[0]) }
sub format_o { $_[0]->[3].'.' }

sub format_D { &format_y . "." . &format_m . "." . &format_d  }

sub format_y { sprintf("%02d",$_[0]->[5] % 100) }
sub format_d { sprintf("%02d",$_[0]->[3]) }
sub format_m { sprintf("%02d",$_[0]->[4] + 1) }


1;

__END__

=pod

=encoding UTF-8

=head1 NAME

Date::Language::Hungarian - Hungarian localization for Date::Format

=head1 VERSION

version 2.35

=head1 SYNOPSIS

    my $lang = Date::Language->new('Hungarian');
    print $lang->time2str("%a %b %e %T %Y", time);

    my @lt = localtime(time);
    my $template = "%a %b %e %T %Y";
    print $lang->time2str($template, time);
    print $lang->strftime($template, @lt);

    my $zone = "EST";
    print $lang->time2str($template, time, $zone);
    print $lang->strftime($template, @lt, $zone);

    print $lang->ctime(time);
    print $lang->asctime(@lt);

    print $lang->ctime(time, $zone);
    print $lang->asctime(@lt, $zone);

See L<Date::Format>.

=head1 NAME

Date::Language::Hungarian - Magyar format for Date::Format

=head1 AUTHOR

Paula Goddard (paula -at- paulacska -dot- com)

=head1 LICENCE

Made available under the same terms as Perl itself.

=head1 AUTHOR

Graham <gbarr@pobox.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2020 by Graham Barr.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
