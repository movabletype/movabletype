# Copyright (c) 1995-2009 Graham Barr. This program is free
# software; you can redistribute it and/or modify it under the same terms
# as Perl itself.

package Date::Format;

use     strict;
require Exporter;

our $VERSION = '2.35'; # VERSION: generated
# ABSTRACT: Date formatting subroutines

use Date::Format::Generic;

our @ISA     = qw(Exporter);
our @EXPORT  = qw(time2str strftime ctime asctime);

sub time2str ($;$$$)
{
 my ($fmt, $time, $zone, $lang) = @_;
 my $pkg = defined $lang
    ? do { require Date::Language; Date::Language->new($lang) }
    : 'Date::Format::Generic';
 $pkg->time2str($fmt, $time, $zone);
}

sub strftime ($\@;$)
{
 Date::Format::Generic->strftime(@_);
}

sub ctime ($;$)
{
 my ($t,$tz) = @_;
 Date::Format::Generic->time2str("%a %b %e %T %Y\n", $t, $tz);
}

sub asctime (\@;$)
{
 my ($t,$tz) = @_;
 Date::Format::Generic->strftime("%a %b %e %T %Y\n", $t, $tz);
}

1;

__END__

=pod

=encoding UTF-8

=head1 NAME

Date::Format - Date formatting subroutines

=head1 VERSION

version 2.35

=head1 SYNOPSIS

	use Date::Format;

	my @lt = localtime(time);

	my $template = "....";

	print time2str($template, time);
	print strftime($template, @lt);

	my $zone;
	print time2str($template, time, $zone);
	print strftime($template, @lt, $zone);

	print ctime(time);
	print asctime(@lt);

	print ctime(time, $zone);
	print asctime(@lt, $zone);

=head1 DESCRIPTION

This module provides routines to format dates into ASCII strings. They
correspond to the C library routines C<strftime> and C<ctime>.

=over 4

=item time2str(TEMPLATE, TIME [, ZONE [, LANGUAGE]])

C<time2str> converts C<TIME> into an ASCII string using the conversion
specification given in C<TEMPLATE>. C<ZONE> if given specifies the zone
which the output is required to be in, C<ZONE> defaults to your current zone.
C<LANGUAGE> if given specifies the language for day and month names
(e.g. C<'German'>, C<'French'>); defaults to C<'English'>.

=item strftime(TEMPLATE, TIME [, ZONE])

C<strftime> is similar to C<time2str> with the exception that the time is
passed as an array, such as the array returned by C<localtime>.

=item ctime(TIME [, ZONE])

C<ctime> calls C<time2str> with the given arguments using the
conversion specification C<"%a %b %e %T %Y\n">

=item asctime(TIME [, ZONE])

C<asctime> calls C<time2str> with the given arguments using the
conversion specification C<"%a %b %e %T %Y\n">

=back

=head1 NAME

Date::Format - Date formatting subroutines

=head1 MULTI-LANGUAGE SUPPORT

Date::Format is capable of formatting into several languages. You can
pass an optional language name directly to C<time2str>:

	time2str("%a %b %e %T %Y\n", time, undef, 'German');
	time2str("%a %b %e %T %Y\n", time, 'GMT',  'French');

Alternatively, create a language-specific object and call methods on it,
see L<Date::Language>:

	my $lang = Date::Language->new('German');
	$lang->time2str("%a %b %e %T %Y\n", time);

=head1 CONVERSION SPECIFICATION

Each conversion specification  is  replaced  by  appropriate
characters   as   described  in  the  following  list.   The
appropriate  characters  are  determined  by   the   LC_TIME
category of the program's locale.

	%%	PERCENT
	%a	day of the week abbr
	%A	day of the week
	%b	month abbr
	%B 	month
	%c	MM/DD/YY HH:MM:SS
	%C 	ctime format: Sat Nov 19 21:05:57 1994
	%d 	numeric day of the month, with leading zeros (eg 01..31)
	%e 	like %d, but a leading zero is replaced by a space (eg  1..32)
	%D 	MM/DD/YY
	%G	GPS week number (weeks since January 6, 1980)
	%h 	month abbr
	%H 	hour, 24 hour clock, leading 0's)
	%I 	hour, 12 hour clock, leading 0's)
	%j 	day of the year
	%k 	hour
	%l 	hour, 12 hour clock
	%L 	month number, starting with 1
	%m 	month number, starting with 01
	%M 	minute, leading 0's
	%n 	NEWLINE
	%o	ornate day of month -- "1st", "2nd", "25th", etc.
	%p 	AM or PM
	%P 	am or pm (Yes %p and %P are backwards :)
	%q	Quarter number, starting with 1
	%r 	time format: 09:05:57 PM
	%R 	time format: 21:05
	%s	seconds since the Epoch, UCT
	%S 	seconds, leading 0's
	%t 	TAB
	%T 	time format: 21:05:57
	%U 	week number, Sunday as first day of week
	%w 	day of the week, numerically, Sunday == 0
	%W 	week number, Monday as first day of week
	%x 	date format: 11/19/94
	%X 	time format: 21:05:57
	%y	year (2 digits)
	%Y	year (4 digits)
	%Z 	timezone in ascii. eg: PST
	%z	timezone in format -/+0000

C<%d>, C<%e>, C<%H>, C<%I>, C<%j>, C<%k>, C<%l>, C<%m>, C<%M>, C<%q>,
C<%y> and C<%Y> can be output in Roman numerals by prefixing the letter
with C<O>, e.g. C<%OY> will output the year as roman numerals.

=head1 LIMITATION

The functions in this module are limited to the time range that can be
represented by the time_t data type, i.e. 1901-12-13 20:45:53 GMT to
2038-01-19 03:14:07 GMT.

=head1 AUTHOR

Graham Barr <gbarr@pobox.com>

=head1 COPYRIGHT

Copyright (c) 1995-2009 Graham Barr. This program is free
software; you can redistribute it and/or modify it under the same terms
as Perl itself.

=head1 AUTHOR

Graham <gbarr@pobox.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2020 by Graham Barr.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
