##
## Russian tables (KOI8-R byte encoding)
##
## Contributed by Danil Pismenny <dapi@mail.ru>

package Date::Language::Russian;

use strict;
use warnings;

use Date::Language ();

use base 'Date::Language';

our $VERSION = '2.35'; # VERSION: generated
# ABSTRACT: Russian localization for Date::Format (KOI8-R)

our (@DoW, @DoWs, @MoY, @MoYs, @MoY2, @DoWs2, @AMPM, @Dsuf, %MoY, %DoW);

@MoY = (
    "\xf1\xce\xd7\xc1\xd2\xd1",              # Января
    "\xe6\xc5\xd7\xd2\xc1\xcc\xd1",          # Февраля
    "\xed\xc1\xd2\xd4\xc1",                    # Марта
    "\xe1\xd0\xd2\xc5\xcc\xd1",               # Апреля
    "\xed\xc1\xd1",                             # Мая
    "\xe9\xc0\xce\xd1",                         # Июня
    "\xe9\xc0\xcc\xd1",                         # Июля
    "\xe1\xd7\xc7\xd5\xd3\xd4\xc1",          # Августа
    "\xf3\xc5\xce\xd4\xd1\xc2\xd2\xd1",      # Сентября
    "\xef\xcb\xd4\xd1\xc2\xd2\xd1",          # Октября
    "\xee\xcf\xd1\xc2\xd2\xd1",               # Ноября
    "\xe4\xc5\xcb\xc1\xc2\xd2\xd1",          # Декабря
);

@MoY2 = (
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

@MoYs = (
    "\xf1\xce\xd7",  # Янв
    "\xe6\xc5\xd7",  # Фев
    "\xed\xd2\xd4",  # Мрт
    "\xe1\xd0\xd2",  # Апр
    "\xed\xc1\xca",  # Май
    "\xe9\xc0\xce",  # Июн
    "\xe9\xc0\xcc",  # Июл
    "\xe1\xd7\xc7",  # Авг
    "\xf3\xc5\xce",  # Сен
    "\xef\xcb\xd4",  # Окт
    "\xee\xcf\xd1",  # Ноя
    "\xe4\xc5\xcb",  # Дек
);

@DoW = (
    "\xf0\xcf\xce\xc5\xc4\xc5\xcc\xd8\xce\xc9\xcb",  # Понедельник
    "\xf7\xd4\xcf\xd2\xce\xc9\xcb",                      # Вторник
    "\xf3\xd2\xc5\xc4\xc1",                                # Среда
    "\xfe\xc5\xd4\xd7\xc5\xd2\xc7",                      # Четверг
    "\xf0\xd1\xd4\xce\xc9\xc3\xc1",                      # Пятница
    "\xf3\xd5\xc2\xc2\xcf\xd4\xc1",                      # Суббота
    "\xf7\xcf\xd3\xcb\xd2\xc5\xd3\xc5\xce\xd8\xc5",    # Воскресенье
);

@DoWs = (
    "\xf0\xce",  # Пн
    "\xf7\xd4",  # Вт
    "\xf3\xd2",  # Ср
    "\xfe\xd4",  # Чт
    "\xf0\xd4",  # Пт
    "\xf3\xc2",  # Сб
    "\xf7\xd3",  # Вс
);

@DoWs2 = (
    "\xf0\xce\xc4",  # Пнд
    "\xf7\xd4\xd2",  # Втр
    "\xf3\xd2\xc4",  # Срд
    "\xfe\xd4\xd7",  # Чтв
    "\xf0\xd4\xce",  # Птн
    "\xf3\xc2\xd4",  # Сбт
    "\xf7\xd3\xcb",  # Вск
);

@AMPM = (
    "\xc4\xd0",  # дп
    "\xd0\xd0",  # пп
);

Date::Language::_build_lookups();

# Formatting routines

sub format_a { $DoWs[$_[0]->[6]] }
sub format_A { $DoW[$_[0]->[6]] }
sub format_b { $MoYs[$_[0]->[4]] }
sub format_B { $MoY[$_[0]->[4]] }
sub format_h { $MoYs[$_[0]->[4]] }
sub format_p { $_[0]->[2] >= 12 ?  $AMPM[1] : $AMPM[0] }

sub format_d { $_[0]->[3] }
sub format_m { $_[0]->[4] + 1 }
sub format_o { $_[0]->[3] . '.' }

sub format_Q { $MoY2[$_[0]->[4]] }

sub str2time {
  my ($self,$value) = @_;
  map {$value=~s/(\s|^)$DoWs2[$_](\s)/$DoWs[$_]$2/ig} (0..6);
  $value=~s/(\s+|^)\xed\xc1\xd2(\s+)/$1\xed\xd2\xd4$2/;
  return $self->SUPER::str2time($value);
}

1;

__END__

=pod

=encoding UTF-8

=head1 NAME

Date::Language::Russian - Russian localization for Date::Format (KOI8-R)

=head1 VERSION

version 2.35

=head1 AUTHOR

Graham <gbarr@pobox.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2020 by Graham Barr.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
