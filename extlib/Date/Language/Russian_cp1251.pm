##
## Russian cp1251 (CP1251 byte encoding)
##

package Date::Language::Russian_cp1251;

use strict;
use warnings;

use Date::Language ();

use base 'Date::Language';

our $VERSION = '2.35'; # VERSION: generated
# ABSTRACT: Russian localization for Date::Format (CP1251)

our (@DoW, @DoWs, @MoY, @MoYs, @AMPM, @Dsuf, %MoY, %DoW);

@DoW = (
    "\xc2\xee\xf1\xea\xf0\xe5\xf1\xe5\xed\xfc\xe5",    # Воскресенье
    "\xcf\xee\xed\xe5\xe4\xe5\xeb\xfc\xed\xe8\xea",      # Понедельник
    "\xc2\xf2\xee\xf0\xed\xe8\xea",                        # Вторник
    "\xd1\xf0\xe5\xe4\xe0",                                # Среда
    "\xd7\xe5\xf2\xe2\xe5\xf0\xe3",                        # Четверг
    "\xcf\xff\xf2\xed\xe8\xf6\xe0",                        # Пятница
    "\xd1\xf3\xe1\xe1\xee\xf2\xe0",                        # Суббота
);

@MoY = (
    "\xdf\xed\xe2\xe0\xf0\xfc",               # Январь
    "\xd4\xe5\xe2\xf0\xe0\xeb\xfc",           # Февраль
    "\xcc\xe0\xf0\xf2",                        # Март
    "\xc0\xef\xf0\xe5\xeb\xfc",               # Апрель
    "\xcc\xe0\xe9",                             # Май
    "\xc8\xfe\xed\xfc",                         # Июнь
    "\xc8\xfe\xeb\xfc",                         # Июль
    "\xc0\xe2\xe3\xf3\xf1\xf2",               # Август
    "\xd1\xe5\xed\xf2\xff\xe1\xf0\xfc",       # Сентябрь
    "\xce\xea\xf2\xff\xe1\xf0\xfc",           # Октябрь
    "\xcd\xee\xff\xe1\xf0\xfc",               # Ноябрь
    "\xc4\xe5\xea\xe0\xe1\xf0\xfc",           # Декабрь
);

@DoWs = (
    "\xc2\xf1\xea",  # Вск
    "\xcf\xed\xe4",  # Пнд
    "\xc2\xf2\xf0",  # Втр
    "\xd1\xf0\xe4",  # Срд
    "\xd7\xf2\xe2",  # Чтв
    "\xcf\xf2\xed",  # Птн
    "\xd1\xe1\xf2",  # Сбт
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

Date::Language::Russian_cp1251 - Russian localization for Date::Format (CP1251)

=head1 VERSION

version 2.35

=head1 AUTHOR

Graham <gbarr@pobox.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2020 by Graham Barr.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
