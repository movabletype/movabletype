# Copyright (c) 1995-2009 Graham Barr. This program is free
# software; you can redistribute it and/or modify it under the same terms
# as Perl itself.

package Date::Parse;

require 5.000;
use strict;
use Time::Local;
use Carp;
use Time::Zone;
use Exporter;

our @ISA = qw(Exporter);
our @EXPORT = qw(&strtotime &str2time &strptime);

our $VERSION = '2.35'; # VERSION: generated
# ABSTRACT: Parse date strings into time values

my %month = (
    january   => 0,
    february  => 1,
    march     => 2,
    april     => 3,
    may       => 4,
    june      => 5,
    july      => 6,
    august    => 7,
    september => 8,
    sept      => 8,
    october   => 9,
    november  => 10,
    december  => 11,
    );

my %day = (
    sunday    => 0,
    monday    => 1,
    tuesday   => 2,
    tues      => 2,
    wednesday => 3,
    wednes    => 3,
    thursday  => 4,
    thur      => 4,
    thurs     => 4,
    friday    => 5,
    saturday  => 6,
    );

my @suf = (qw(th st nd rd th th th th th th)) x 3;
@suf[11,12,13] = qw(th th th);

#Abbreviations

map { $month{substr($_,0,3)} = $month{$_} } keys %month;
map { $day{substr($_,0,3)}   = $day{$_} }   keys %day;

my $strptime = <<'ESQ';
 my %month = map { lc $_ } %$mon_ref;
 my $daypat = join("|", map { lc $_ } reverse sort keys %$day_ref);
 my $monpat = join("|", reverse sort keys %month);
 my $sufpat = join("|", reverse sort map { lc $_ } @$suf_ref);

 my %ampm = (
    'a' => 0,  # AM
    'p' => 12, # PM
    );

 my($AM, $PM) = (0,12);

sub {

  my $dtstr = lc shift;
  my $merid = 24;

  my($century,$year,$month,$day,$hh,$mm,$ss,$zone,$dst,$frac);

  $zone = tz_offset(shift) if @_;

  1 while $dtstr =~ s#\([^\(\)]*\)# #o;

  $dtstr =~ s#(\A|\n|\Z)# #sog;

  # ignore day names
  $dtstr =~ s#([\d\w\s])[\.\,]\s#$1 #sog;
  $dtstr =~ s/(?<!\d),|,(?!\d)/ /g;
  $dtstr =~ s#($daypat)\s*(den\s)?\b# #o;
  # Time: 12:00 or 12:00:00 with optional am/pm

  return unless $dtstr =~ /\S/;

  # ISO compact: YYYYMMDD without delimiter (month and day must be exactly 2 digits)
  if ($dtstr =~ s/\s(\d{4})(\d\d)(\d\d)(?:[-Tt ](\d\d?)(?:([-:]?)(\d\d?)(?:\5(\d\d?)(?:[.,](\d+))?)?)?)?(?=\D)/ /) {
    ($year,$month,$day,$hh,$mm,$ss,$frac) = ($1,$2-1,$3,$4,$6,$7,$8);
  }
  # Date with explicit delimiter: YYYY[-:]MM[-:]DD
  elsif ($dtstr =~ s/\s(\d{4})([-:])(\d\d?)\2(\d\d?)(?:[-Tt ](\d\d?)(?:([-:]?)(\d\d?)(?:\6(\d\d?)(?:[.,](\d+))?)?)?)?(?=\D)/ /) {
    ($year,$month,$day,$hh,$mm,$ss,$frac) = ($1,$3-1,$4,$5,$7,$8,$9);
  }

  # default C++ boost timestamp is effectively %Y-%b-%d %H:%M:%S.%f
  # details: https://svn.boost.org/trac/boost/ticket/8839
  if ($dtstr =~ s/\s(\d{4})([-:]?)(\w{3,})\2(\d\d?)(?:[-Tt ](\d\d?)(?:([-:]?)(\d\d?)(?:\6(\d\d?)(?:[.,](\d+))?)?)?)?(?=\D)/ /) {
    ($year,$month,$day,$hh,$mm,$ss,$frac) = ($1,$month{$3},$4,$5,$7,$8,$9);
  }

  unless (defined $hh) {
    if ($dtstr =~ s#[:\s](\d\d?):(\d\d?)(:(\d\d?)(?:\.\d+)?)?(z)?\s*(?:([ap])\.?m?\.?)?\s# #o) {
      ($hh,$mm,$ss) = ($1,$2,$4);
      $zone = 0 if $5;
      $merid = $ampm{$6} if $6;
    }

    # Time: 12 am

    elsif ($dtstr =~ s#\s(\d\d?)\s*([ap])\.?m?\.?\s# #o) {
      ($hh,$mm,$ss) = ($1,0,0);
      $merid = $ampm{$2};
    }
  }

  if (defined $hh and $hh <= 12 and $dtstr =~ s# ([ap])\.?m?\.?\s# #o) {
    $merid = $ampm{$1};
  }


  unless (defined $year) {
    # Date: 12-June-96 (using - . or /)

    if ($dtstr =~ s#\s(\d\d?)([\-\./])($monpat)(\2(\d\d+))?\s# #o) {
      ($month,$day) = ($month{$3},$1);
      $year = $5 if $5;
    }

    # Date: 12-12-96 (using '-', '.' or '/' )

    elsif ($dtstr =~ s#\s(\d+)([\-\./])(\d\d?)(\2(\d+))?\s# #o) {
      ($month,$day) = ($1 - 1,$3);

      if ($5) {
    $year = $5;
    # Possible match for 1995-01-24 (short mainframe date format);
    ($year,$month,$day) = ($1, $3 - 1, $5) if $month > 12;
    return if length($year) > 2 and $year < 1901;
      }
    }
    elsif ($dtstr =~ s#\s(\d+)\s*($sufpat)?\s*($monpat)# #o) {
      ($month,$day) = ($month{$3},$1);
    }
    elsif ($dtstr =~ s#($monpat)\s*(\d+)\s*($sufpat)?\s# #o) {
      $month = $month{$1};
      if ($2 > 31) { $year = $2 } else { $day = $2 }
    }
    elsif ($dtstr =~ s#($monpat)([\/-])(\d+)[\/-]# #o) {
      ($month,$day) = ($month{$1},$3);
    }

    # Date: 961212 (YYMMDD — only consume if month is in range 1-12)

    elsif ($dtstr =~ /\s(\d\d)(\d\d)(\d\d)\s/o && $2 >= 1 && $2 <= 12) {
      $dtstr =~ s/\s(\d\d)(\d\d)(\d\d)\s/ /;
      ($year,$month,$day) = ($1,$2-1,$3);
    }

    $year = $1 if !defined($year) and $dtstr =~ s#\s(\d{2}(\d{2})?)[\s\.,]# #o;

  }

  # Zone

  $dst = 1 if $dtstr =~ s#\bdst\b##o;

  if ($dtstr =~ s#\s"?([a-z]{3,4})(dst|\d+[a-z]*|_[a-z]+)?"?\s# #o) {
    $dst = 1 if $2 and $2 eq 'dst';
    $zone = tz_offset($1);
    return unless defined $zone;
  }
  elsif ($dtstr =~ s#\s([a-z]{3,4})?([\-\+]?)-?(\d\d?):?(\d\d)?(00)?\s# #o) {
    my $m = defined($4) ? "$2$4" : 0;
    my $h = "$2$3";
    $zone = defined($1) ? tz_offset($1) : 0;
    return unless defined $zone;
    $zone += 60 * ($m + (60 * $h));
  }

  if ($dtstr =~ /\S/) {
    # now for some dumb dates
    if ($dtstr =~ s/^\s*(ut?|z)\s*$//) {
      $zone = 0;
    }
    elsif ($dtstr =~ s#\s([a-z]{3,4})?([\-\+]?)-?(\d\d?)(\d\d)?(00)?\s# #o) {
      my $m = defined($4) ? "$2$4" : 0;
      my $h = "$2$3";
      $zone = defined($1) ? tz_offset($1) : 0;
      return unless defined $zone;
      $zone += 60 * ($m + (60 * $h));
    }

    return if $dtstr =~ /\S/o;
  }

  if (defined $hh) {
    if ($hh == 12) {
      $hh = 0 if $merid == $AM;
    }
    elsif ($merid == $PM) {
      $hh += 12;
    }
  }

  if (defined $year && $year >= 100) {
    $century = int($year / 100);
    $year -= 1900;
  }

  $zone += 3600 if defined $zone && $dst;
  $ss += "0.$frac" if $frac;

  # Reject inputs that produced only a timezone with no date/time components.
  # A bare number like '1' or '+0500' gets consumed by the timezone regex,
  # leaving no meaningful date or time information — these are not valid dates.
  return unless defined $hh || defined $mm || defined $ss
             || defined $day || defined $month || defined $year;

  return ($ss,$mm,$hh,$day,$month,$year,$zone,$century);
}
ESQ

our ($day_ref, $mon_ref, $suf_ref, $obj);

sub gen_parser
{
 local($day_ref,$mon_ref,$suf_ref,$obj) = @_;

 if($obj)
  {
   my $obj_strptime = $strptime;
   substr($obj_strptime,index($strptime,"sub")+6,0) = <<'ESQ';
 shift; # package
ESQ
   my $sub = eval "$obj_strptime" or die $@;
   return $sub;
  }

 eval "$strptime" or die $@;

}

*strptime = gen_parser(\%day,\%month,\@suf);

sub str2time
{
 my $now = @_ > 2 ? splice(@_, 2, 1) : time;
 my @t = strptime(@_);

 return undef
    unless @t;

 my($ss,$mm,$hh,$day,$month,$year,$zone, $century) = @t;
 my @lt  = localtime($now);

 $hh    ||= 0;
 $mm    ||= 0;
 $ss    ||= 0;

 my $frac = $ss - int($ss);
 $ss = int $ss;

 $month = $lt[4]
    unless(defined $month);

 $day  = $lt[3]
    unless(defined $day);

 unless (defined $year) {
   my $is_future = $month > $lt[4]
                || ($month == $lt[4] && $day > $lt[3]);
   $year = $is_future ? ($lt[5] - 1) : $lt[5];
 }

 # we were given a 4 digit year, so let's keep using those
 $year += 1900 if defined $century;

 # Normalize two-digit years to 4-digit before passing to Time::Local.
 # Time::Local's own windowing varies across versions, so we do it ourselves.
 # Convention: 69-99 -> 1969-1999, 0-68 -> 2000-2068 (POSIX strptime behavior).
 # Note: first-century dates (years 1-99 AD) are not representable through
 # str2time — same limitation as POSIX strptime.
 $year += ($year >= 69 ? 1900 : 2000) if $year < 100;

 return undef
    unless($month <= 11 && $day >= 1 && $day <= 31
        && $hh <= 23 && $mm <= 59 && $ss <= 59);

 my $result;

 if (defined $zone) {
   $result = eval {
     local $SIG{__DIE__} = sub {}; # Ick!
     timegm($ss,$mm,$hh,$day,$month,$year);
   };
   return undef
     if !defined $result
        or $result == -1
           && join("",$ss,$mm,$hh,$day,$month,$year)
                ne "595923311169";
   # Detect integer overflow: post-1970 dates must produce a non-negative epoch
   return undef if $result < 0 && $year >= 1970;
   $result -= $zone;
 }
 else {
   $result = eval {
     local $SIG{__DIE__} = sub {}; # Ick!
     timelocal($ss,$mm,$hh,$day,$month,$year);
   };
   return undef
     if !defined $result
        or $result == -1
           && join("",$ss,$mm,$hh,$day,$month,$year)
                ne join("",(localtime(-1))[0..5]);
   # Detect integer overflow: post-1970 dates must produce a non-negative epoch
   # Use 1971 to avoid false positives from timezone offsets near epoch 0
   return undef if $result < 0 && $year >= 1971;
 }

 return $result + $frac;
}

1;

__END__

=pod

=encoding UTF-8

=head1 NAME

Date::Parse - Parse date strings into time values

=head1 VERSION

version 2.35

=head1 SYNOPSIS

    use Date::Parse;

    my $date = "Wed, 16 Jun 94 07:29:35 CST";
    my $time = str2time($date);

    my ($ss,$mm,$hh,$day,$month,$year,$zone) = strptime($date);

=head1 DESCRIPTION

C<Date::Parse> provides two routines for parsing date strings into time values.

=over 4

=item str2time(DATE [, ZONE [, EPOCH]])

C<str2time> parses C<DATE> and returns a unix time value, or undef upon failure.
C<ZONE>, if given, specifies the timezone to assume when parsing if the
date string does not specify a timezone.
C<EPOCH>, if given, is a unix epoch value used as the reference time when
filling in missing date components (month, day, or year).  Defaults to
C<time()>.  Useful when the current system clock cannot be trusted or when
parsing dates relative to a known reference point.

=item strptime(DATE [, ZONE])

C<strptime> takes the same arguments as str2time but returns an array of
values C<($ss,$mm,$hh,$day,$month,$year,$zone,$century)>. Elements are only
defined if they could be extracted from the date string. An empty array is
returned upon failure.

The return values follow the same conventions as Perl's built-in C<localtime>
and C<gmtime> functions:

=over 4

=item C<$month>

0-indexed: 0 = January, 1 = February, ..., 11 = December.

=item C<$year>

Years since 1900. For example, the year 2015 is returned as C<115>, and 1995
is returned as C<95>. To recover the full 4-digit year: C<$year + 1900>.

=item C<$zone>

Timezone offset in seconds from UTC, or C<undef> if no timezone was specified
in the input string.

=item C<$century>

Defined only when a 4-digit year was present in the input. Its value is
C<int($full_year / 100)> (e.g. C<20> for the year 2015). When C<$century> is
defined, C<$year + 1900> gives the original 4-digit year.

=back

For example, C<strptime("2015-01-24T09:08:17")> returns:

    ($ss, $mm, $hh, $day, $month, $year, $zone, $century)
    ( 17,   8,   9,   24,      0,   115,  undef,     20 )
    #                          ^--- January (0-indexed)
    #                               ^--- 2015 - 1900
    #                                          ^--- not in input
    #                                                 ^--- int(2015/100)

=back

=head1 NAME

Date::Parse - Parse date strings into time values

=head1 MULTI-LANGUAGE SUPPORT

Date::Parse is capable of parsing dates in several languages, these include
English, French, German and Italian.

    $lang = Date::Language->new('German');
    $lang->str2time("25 Jun 1996 21:09:55 +0100");

=head1 EXAMPLE DATES

Below is a sample list of dates that are known to be parsable with Date::Parse

 1995-01-24T09:08:17.1823213           ISO-8601
 Wed, 16 Jun 94 07:29:35 CST           Comma and day name are optional
 Thu, 13 Oct 94 10:13:13 -0700
 Wed, 9 Nov 1994 09:50:32 -0500 (EST)  Text in ()'s will be ignored.
 21 dec 17:05                          Will be parsed in the current time zone
 21-dec 17:05
 21/dec 17:05
 21/dec/93 17:05
 1999 10:02:18 "GMT"
 16 Nov 94 22:28:20 PST

=head1 BUGS

When both the month and the date are specified in the date as numbers
they are always parsed assuming that the month number comes before the
date. This is the usual format used in American dates.

The reason why it is like this and not dynamic is that it must be
deterministic. Several people have suggested using the current locale,
but this will not work as the date being parsed may not be in the format
of the current locale.

My plans to address this, which will be in a future release, is to allow
the programmer to state what order they want these values parsed in.

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
