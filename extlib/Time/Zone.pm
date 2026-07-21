
package Time::Zone;


require 5.006;

require Exporter;
use Carp;
use strict;
use POSIX qw(tzset tzname);

our $VERSION = '2.35'; # VERSION: generated
# ABSTRACT: miscellaneous timezone manipulations routines
our @ISA = qw(Exporter);
our @EXPORT = qw(tz2zone tz_local_offset tz_offset tz_name);

# Parts stolen from code by Paul Foley <paul@ascent.com>

my %tzn_cache;
sub tz2zone (;$$$)
{
    my($TZ, $time, $isdst) = @_;

    $TZ = defined($ENV{'TZ'}) ? ( $ENV{'TZ'} ? $ENV{'TZ'} : 'GMT' ) : ''
        unless $TZ;

    # Hack to deal with 'PST8PDT' format of TZ
    # Note that this can't deal with all the esoteric forms, but it
    # does recognize the most common: [:]STDoff[DST[off][,rule]]

    if (! defined $isdst) {
        my $j;
        $time = time() unless $time;
        ($j, $j, $j, $j, $j, $j, $j, $j, $isdst) = localtime($time);
    }

    if (defined $tzn_cache{$TZ}->[$isdst]) {
        return $tzn_cache{$TZ}->[$isdst];
    }

    # Handle IANA timezone names (e.g., "America/Chicago", "Europe/Paris")
    if ($TZ =~ m{/}) {
        my ($std, $dst_name) = _iana_tzname($TZ);
        $tzn_cache{$TZ} = [ $std, $dst_name ];
        return $isdst ? $dst_name : $std;
    }

    if ($TZ =~ /^
            ( [^:\d+\-,] {3,} )
            ( [+-] ?
              \d {1,2}
              ( : \d {1,2} ) {0,2}
            )
            ( [^\d+\-,] {3,} )?
            /x
        ) {
        my $dsttz = defined($4) ? $4 : $1;
        $TZ = $isdst ? $dsttz : $1;
        $tzn_cache{$TZ} = [ $1, $dsttz ];
    } else {
        $tzn_cache{$TZ} = [ $TZ, $TZ ];
    }
    return $TZ;
}

my @tz_local;
sub tz_local_offset (;$)
{
    my ($time) = @_;

    $time = time() unless $time;
    my (@l) = localtime($time);
    my $isdst = $l[8];

    if (defined($tz_local[$isdst])) {
        return $tz_local[$isdst];
    }

    $tz_local[$isdst] = &calc_off($time);

    return $tz_local[$isdst];
}

sub calc_off
{
    my ($time) = @_;

    my (@l) = localtime($time);
    my (@g) = gmtime($time);

    my $off;

    $off =     $l[0] - $g[0]
        + ($l[1] - $g[1]) * 60
        + ($l[2] - $g[2]) * 3600;

    # subscript 7 is yday.

    if ($l[7] == $g[7]) {
        # done
    } elsif ($l[7] == $g[7] + 1) {
        $off += 86400;
    } elsif ($l[7] == $g[7] - 1) {
        $off -= 86400;
    } elsif ($l[7] < $g[7]) {
        # crossed over a year boundary!
        # localtime is beginning of year, gmt is end
        # therefore local is ahead
        $off += 86400;
    } else {
        $off -= 86400;
    }

    return $off;
}

# Helper: temporarily set TZ to an IANA name, run a block, restore original TZ.
sub _with_iana_tz (&$) {
    my ($code, $tz) = @_;
    my $had_tz  = exists $ENV{TZ};
    my $saved   = $ENV{TZ};
    $ENV{TZ} = $tz;
    tzset();
    my @result = $code->();
    if ($had_tz) { $ENV{TZ} = $saved } else { delete $ENV{TZ} }
    tzset();
    return @result;
}

# Return (std_name, dst_name) for an IANA timezone string.
sub _iana_tzname {
    my ($tz) = @_;
    my ($std, $dst) = _with_iana_tz { tzname() } $tz;
    $dst = $std unless defined $dst;
    return ($std, $dst);
}

# Return the UTC offset in seconds for an IANA timezone string at a given time.
sub _iana_offset {
    my ($tz, $time) = @_;
    $time = time() unless $time;
    my ($off) = _with_iana_tz { calc_off($time) } $tz;
    return $off;
}

# constants

my (%dstZone, %zoneOff, %dstZoneOff, %Zone);

CONFIG: {
    my @dstZone = (
        "ndt"  =>   -2*3600-1800,    # Newfoundland Daylight
        "brst" =>   -2*3600,         # Brazil Summer Time (East Daylight)
        "adt"  =>   -3*3600,     # Atlantic Daylight
        "edt"  =>   -4*3600,     # Eastern Daylight
        "cdt"  =>   -5*3600,     # Central Daylight
        "mdt"  =>   -6*3600,     # Mountain Daylight
        "pdt"  =>   -7*3600,     # Pacific Daylight
        "akdt" =>   -8*3600,         # Alaska Daylight
        "ydt"  =>   -8*3600,     # Yukon Daylight
        "hdt"  =>   -9*3600,     # Hawaii Daylight
        "bst"  =>   +1*3600,     # British Summer
        "cest" =>   +2*3600,     # Central European Summer (preferred)
        "mest" =>   +2*3600,     # Middle European Summer (alias, kept for compat)
        "metdst" => +2*3600,     # Middle European DST
        "sst"  =>   +2*3600,     # Swedish Summer
        "fst"  =>   +2*3600,     # French Summer
        "eest" =>   +3*3600,     # Eastern European Summer
        "msd"  =>   +4*3600,     # Moscow Daylight (historical; Russia abolished DST permanently in Oct 2014)
        "wadt" =>   +8*3600,     # West Australian Daylight
        "kdt"  =>  +10*3600,     # Korean Daylight
    #   "cadt" =>  +10*3600+1800,    # Central Australian Daylight
        "aedt" =>  +11*3600,     # Eastern Australian Daylight
        "eadt" =>  +11*3600,     # Eastern Australian Daylight
        "nzd"  =>  +13*3600,     # New Zealand Daylight
        "nzdt" =>  +13*3600,     # New Zealand Daylight
    );

    my @Zone = (
        "gmt"   =>   0,      # Greenwich Mean
        "ut"        =>   0,      # Universal (Coordinated)
        "utc"       =>   0,
        "wet"       =>   0,      # Western European
        "wat"       =>  -1*3600,     # West Africa
        "at"        =>  -2*3600,     # Azores
        "fnt"   =>  -2*3600,     # Brazil Time (Extreme East - Fernando Noronha)
        "brt"   =>  -3*3600,     # Brazil Time (East Standard - Brasilia)
    # For completeness.  BST is also British Summer, and GST is also Guam Standard.
    #   "bst"       =>  -3*3600,     # Brazil Standard
    #   "gst"       =>  -3*3600,     # Greenland Standard
        "nft"       =>  -3*3600-1800,# Newfoundland
        "nst"       =>  -3*3600-1800,# Newfoundland Standard
        "mnt"   =>  -4*3600,     # Brazil Time (West Standard - Manaus)
        "ewt"       =>  -4*3600,     # U.S. Eastern War Time
        "ast"       =>  -4*3600,     # Atlantic Standard
        "est"       =>  -5*3600,     # Eastern Standard
        "act"   =>  -5*3600,     # Brazil Time (Extreme West - Acre)
        "cst"       =>  -6*3600,     # Central Standard
        "mst"       =>  -7*3600,     # Mountain Standard
        "pst"       =>  -8*3600,     # Pacific Standard
        "akst"      =>  -9*3600,     # Alaska Standard
        "yst"   =>  -9*3600,     # Yukon Standard
        "hst"   => -10*3600,     # Hawaii Standard
        "cat"   => -10*3600,     # Central Alaska
        "ahst"  => -10*3600,     # Alaska-Hawaii Standard
        "nt"    => -11*3600,     # Nome
        "idlw"  => -12*3600,     # International Date Line West
        "cet"   =>  +1*3600,     # Central European
        "mez"   =>  +1*3600,     # Central European (German)
        "ect"   =>  +1*3600,     # Central European (French)
        "met"   =>  +1*3600,     # Middle European
        "mewt"  =>  +1*3600,     # Middle European Winter
        "swt"   =>  +1*3600,     # Swedish Winter
        "set"   =>  +1*3600,     # Seychelles
        "fwt"   =>  +1*3600,     # French Winter
        "eet"   =>  +2*3600,     # Eastern Europe, USSR Zone 1
        "ukr"   =>  +2*3600,     # Ukraine
        "bt"    =>  +3*3600,     # Baghdad, USSR Zone 2
        "msk"   =>  +3*3600,     # Moscow (UTC+3; was UTC+4 in 2011-2014 when Russia used permanent DST, reverted Oct 2014)
    #   "it"    =>  +3*3600+1800,# Iran
        "zp4"   =>  +4*3600,     # USSR Zone 3
        "zp5"   =>  +5*3600,     # USSR Zone 4
        "ist"   =>  +5*3600+1800,# Indian Standard
        "zp6"   =>  +6*3600,     # USSR Zone 5
    # For completeness.  NST is also Newfoundland Stanard, and SST is also Swedish Summer.
    #   "nst"   =>  +6*3600+1800,# North Sumatra
    #   "sst"   =>  +7*3600,     # South Sumatra, USSR Zone 6
        "ict"   =>  +7*3600,     # Indochina
    #   "jt"    =>  +7*3600+1800,# Java (3pm in Cronusland!)
        "ict"   =>  +7*3600,     # Indochina Time
        "wst"   =>  +8*3600,     # West Australian Standard
        "pht"   =>  +8*3600,     # Philippine
        "hkt"   =>  +8*3600,     # Hong Kong
        "pht"   =>  +8*3600,     # Philippine Time
        "cct"   =>  +8*3600,     # China Coast, USSR Zone 7
        "jst"   =>  +9*3600,     # Japan Standard, USSR Zone 8
        "kst"   =>  +9*3600,     # Korean Standard
    #   "cast"  =>  +9*3600+1800,# Central Australian Standard
        "aest"  => +10*3600,     # Eastern Australian Standard
        "east"  => +10*3600,     # Eastern Australian Standard
        "gst"   => +10*3600,     # Guam Standard, USSR Zone 9
        "nzt"   => +12*3600,     # New Zealand
        "nzst"  => +12*3600,     # New Zealand Standard
        "idle"  => +12*3600,     # International Date Line East
    );

    %Zone = @Zone;
    %dstZone = @dstZone;
    %zoneOff = reverse(@Zone);
    %dstZoneOff = reverse(@dstZone);

}

sub tz_offset (;$$)
{
    my ($zone, $time) = @_;

    return &tz_local_offset($time) unless($zone);

    $time = time() unless $time;
    my(@l) = localtime($time);
    my $dst = $l[8];

    # Handle IANA timezone names (e.g., "America/Chicago") before lowercasing
    if ($zone =~ m{/}) {
        return _iana_offset($zone, $time);
    }

    $zone = lc $zone;

    if($zone =~ /^(([\-\+])\d\d?)(\d\d)$/) {
        my $v = $2 . $3;
        return $1 * 3600 + $v * 60;
    } elsif (exists $dstZone{$zone} && ($dst || !exists $Zone{$zone})) {
        return $dstZone{$zone};
    } elsif(exists $Zone{$zone}) {
        return $Zone{$zone};
    }
    undef;
}

sub tz_name (;$$)
{
    my ($off, $dst) = @_;

    $off = tz_offset()
        unless(defined $off);

    $dst = (localtime(time))[8]
        unless(defined $dst);

    if (exists $dstZoneOff{$off} && ($dst || !exists $zoneOff{$off})) {
        return $dstZoneOff{$off};
    } elsif (exists $zoneOff{$off}) {
        return $zoneOff{$off};
    }
    # $off is in seconds; format as +HHMM / -HHMM.
    # Using abs() for the minutes component handles negative fractional-hour
    # offsets correctly (e.g. -9000s = -2h30m → "-0230", not "-02-30").
    sprintf("%+03d%02d", int($off / 3600), abs(int($off / 60)) % 60);
}

1;

__END__

=pod

=encoding UTF-8

=head1 NAME

Time::Zone - miscellaneous timezone manipulations routines

=head1 VERSION

version 2.35

=head1 SYNOPSIS

    use Time::Zone;
    print tz2zone();
    print tz2zone($ENV{'TZ'});
    print tz2zone($ENV{'TZ'}, time());
    my $isdst = 0;
    print tz2zone($ENV{'TZ'}, undef, $isdst);
    my $offset = tz_local_offset();
    my $TZ = "EST";
    $offset = tz_offset($TZ);

=head1 DESCRIPTION

This is a collection of miscellaneous timezone manipulation routines.

C<tz2zone()> parses the TZ environment variable and returns a timezone
string suitable for inclusion in L<date(1)>-like output.  It optionally takes
a timezone string, a time, and a is-dst flag.

C<tz_local_offset()> determines the offset from GMT time in seconds.  It
only does the calculation once.

C<tz_offset()> determines the offset from GMT in seconds of a specified
timezone.

C<tz_name()> determines the name of the timezone based on its offset

=head1 NAME

Time::Zone -- miscellaneous timezone manipulations routines

=head1 AUTHORS

Graham Barr <gbarr@pobox.com>
David Muir Sharnoff <muir@idiom.com>
Paul Foley <paul@ascent.com>

=head1 AUTHOR

Graham <gbarr@pobox.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2020 by Graham Barr.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
