##
## Russian koi8r (KOI8-R byte encoding)
##

package Date::Language::Russian_koi8r;

use strict;
use warnings;

use Date::Language ();

use base 'Date::Language';

our $VERSION = '2.35'; # VERSION: generated
# ABSTRACT: Russian localization for Date::Format (KOI8-R variant)

our (@DoW, @DoWs, @MoY, @MoYs, @AMPM, @Dsuf, %MoY, %DoW);

@DoW = (
    "\xf7\xcf\xd3\xcb\xd2\xc5\xd3\xc5\xce\xd8\xc5",    # Воскресенье
    "\xf0\xcf\xce\xc5\xc4\xc5\xcc\xd8\xce\xc9\xcb",      # Понедельник
    "\xf7\xd4\xcf\xd2\xce\xc9\xcb",                        # Вторник
    "\xf3\xd2\xc5\xc4\xc1",                                # Среда
    "\xfe\xc5\xd4\xd7\xc5\xd2\xc7",                        # Четверг
    "\xf0\xd1\xd4\xce\xc9\xc3\xc1",                        # Пятница
    "\xf3\xd5\xc2\xc2\xcf\xd4\xc1",                        # Суббота
);

@MoY = (
    "\xf1\xce\xd7\xc1\xd2\xd8",              # Январь
    "\xe6\xc5\xd7\xd2\xc1\xcc\xd8",          # Февраль
    "\xed\xc1\xd2\xd4",                        # Март
    "\xe1\xd0\xd2\xc5\xcc\xd8",               # Апрель
    "\xed\xc1\xca",                             # Май
    "\xe9\xc0\xce\xd8",                         # Июнь
    "\xe9\xc0\xcc\xd8",                         # Июль
    "\xe1\xd7\xc7\xd5\xd3\xd4",               # Август
    "\xf3\xc5\xce\xd4\xd1\xc2\xd2\xd8",      # Сентябрь
    "\xef\xcb\xd4\xd1\xc2\xd2\xd8",          # Октябрь
    "\xee\xcf\xd1\xc2\xd2\xd8",               # Ноябрь
    "\xe4\xc5\xcb\xc1\xc2\xd2\xd8",          # Декабрь
);

@DoWs = (
    "\xf7\xd3\xcb",  # Вск
    "\xf0\xce\xc4",  # Пнд
    "\xf7\xd4\xd2",  # Втр
    "\xf3\xd2\xc4",  # Срд
    "\xfe\xd4\xd7",  # Чтв
    "\xf0\xd4\xce",  # Птн
    "\xf3\xc2\xd4",  # Сбт
);

@MoYs = map { substr($_,0,3) } @MoY;
@AMPM = qw(AM PM);

@Dsuf = ('e') x 31;

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

Date::Language::Russian_koi8r - Russian localization for Date::Format (KOI8-R variant)

=head1 VERSION

version 2.35

=head1 AUTHOR

Graham <gbarr@pobox.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2020 by Graham Barr.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
