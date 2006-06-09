# $Id$

use strict;
use Test;
use MT::DateTime;
use DateTime;
use DateTime::TimeZone;
use Time::Local qw(timegm);

my @dates;

foreach my $year ( 2000..2001 ) {
    foreach my $month (1..12) {
        foreach my $day (1..28) {
            my $zone = int(rand 10) - 5 + ( int(rand 1) / 2 );
            my $tz = ($zone < 0 ? '-' : '+') . sprintf("%02d", int(abs($zone))) . ':' . sprintf("%02d", (abs($zone) - int(abs($zone))) * 60);
            push @dates, { year => $year, month => $month, day => $day,
                hour => int(rand 24), minute => int(rand 60), second => int(rand 60), time_zone => $tz };
        }
    }
}

my $num_tests = 3;
plan tests => (scalar @dates) * $num_tests;

foreach my $dh (@dates) {
    my $mt_dt = MT::DateTime->new( %$dh );
    my $dt = DateTime->new( %$dh );
    my $the_date = sprintf("%04d-%02d-%02d %02d:%02d:%02d %s", $dh->{year}, $dh->{month}, $dh->{day}, $dh->{hour}, $dh->{minute}, $dh->{second}, $dh->{time_zone});

    # testing week number calculation
    ok($mt_dt->week_number == $dt->week_number) or
        print "week # is ", $mt_dt->week_number, "; expecting ",$dt->week_number,"\n";

    # testing timezone offset to seconds calculation
    ok($mt_dt->tz_offset_as_seconds == DateTime::TimeZone::offset_as_seconds($mt_dt->time_zone)) or
        print "timezone seconds is ", $mt_dt->tz_offset_as_seconds, "; expecting ",DateTime::TimeZone::offset_as_seconds($mt_dt->time_zone),"; for time zone ",$mt_dt->time_zone,"\n";

    # testing timezone translation (dt -> ts)
    my $mt_ts = timegm( $dh->{second}, $dh->{minute}, $dh->{hour}, $dh->{day}, $dh->{month} - 1, $dh->{year} - 1900 );
    my $dt_tz_secs = DateTime::TimeZone::offset_as_seconds($dh->{time_zone});
    my $mt_tz_secs = $mt_dt->tz_offset_as_seconds;
    $mt_ts -= $mt_tz_secs;
    my ($s, $m, $h, $d, $mo, $y) = gmtime($mt_ts);
    $y += 1900; $mo++;
    my $mt_iso_date = sprintf("%04d%02d%02d%02d%02d%02d", $y, $mo, $d, $h, $m, $s);

    $dt->subtract(seconds => $dt_tz_secs);
    ($y, $mo, $d, $h, $m, $s) = (split('-', $dt->ymd), split(':', $dt->hms));
    my $dt_iso_date = "$y$mo$d$h$m$s";
    ok($mt_iso_date eq $dt_iso_date) or
        print "date is $the_date\n\tmt iso date: $mt_iso_date\n\tdt iso date: $dt_iso_date\n";
}

