# $Id$

use strict;
use lib 't/lib', 'extlib', 'lib', '../lib', '../extlib';
use Test::More;
use MT::DateTime;
use DateTime;
use DateTime::TimeZone;
use Time::Local qw(timegm);
use MT::Util qw(week2ymd);

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
plan tests => 9 + (scalar @dates) * $num_tests;

foreach my $dh (@dates) {
    my $mt_dt = MT::DateTime->new( %$dh );
    my $dt = DateTime->new( %$dh );
    my $the_date = sprintf("%04d-%02d-%02d %02d:%02d:%02d %s", $dh->{year}, $dh->{month}, $dh->{day}, $dh->{hour}, $dh->{minute}, $dh->{second}, $dh->{time_zone});

    # testing week number calculation
    # bchoate -- THESE NO LONGER MATCH; we calculate week number
    # where Sunday is the start of the week.
    # ok($mt_dt->week_number == $dt->week_number) or
    #     print "week # is ", $mt_dt->week_number, "; expecting ",$dt->week_number,"\n";

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

    my ($mt_yr, $mt_wk) = $mt_dt->week;
    my ($wk_y, $wk_m, $wk_d) = week2ymd($mt_yr, $mt_wk);
    my $wk_ymd = sprintf("%04d%02d%02d", $wk_y, $wk_m, $wk_d);
    my $mt_wk_dt = MT::DateTime->new( year => substr($wk_ymd, 0, 4),
        month => substr($wk_ymd, 4, 2),
        day => substr($wk_ymd, 6, 2) );
    my ($wk_yr, $wk_wk) = $mt_wk_dt->week;
    ok(($wk_yr == $mt_yr) && ($wk_wk == $mt_wk))
        or print "$wk_ymd :: $the_date -> $mt_yr/$mt_wk -> $wk_ymd -> $wk_yr/$wk_wk does not equate\n";
}

# compare tests
my $t = time();
ok( (MT::DateTime->compare( a => '20080401123456', b => '20080401123456' ) == 0), 'the same time is equal to each other');
ok( (MT::DateTime->compare( a => '20080401123457', b => '20080401123456' ) > 0), 'a > b returns positive');
ok( (MT::DateTime->compare( a => '20080401123456', b => '20080501123456' ) < 0), 'a < b returns negative');
ok( (MT::DateTime->compare( a => { value => $t, type => 'epoch' }, b => { value => $t, type => 'epoch' } ) == 0), 'the same time is equal to each other');
ok( (MT::DateTime->compare( b => { value => $t, type => 'epoch' }, a => { value => $t, type => 'epoch' } ) == 0), 'the same time is equal to each other');
ok( (MT::DateTime->compare( b => { value => time(), type => 'epoch' }, a => '20080101235959' ) < 0), 'today is larger than Jan 1st 23:59:59, 2008');
ok( (MT::DateTime->compare( a => { value => time(), type => 'epoch' }, b => '20080101235959' ) > 0), 'today is larger than Jan 1st 23:59:59, 2008');
my $dt1 = MT::DateTime->new( %{$dates[0]} );
my $dt2 = MT::DateTime->new( %{$dates[$#dates]} );
ok( ($dt1->compare(a => { value => $dt2, type => 'datetime' }) > 0),
    sprintf("%04d-%02d-%02d %02d:%02d:%02d %s", $dates[$#dates]{year}, $dates[$#dates]{month}, $dates[$#dates]{day}, $dates[$#dates]{hour}, $dates[$#dates]{minute}, $dates[$#dates]{second}, $dates[$#dates]{time_zone}) .
    ' is the future from ' .
    sprintf("%04d-%02d-%02d %02d:%02d:%02d %s", $dates[0]{year}, $dates[0]{month}, $dates[0]{day}, $dates[0]{hour}, $dates[0]{minute}, $dates[0]{second}, $dates[0]{time_zone})
);
ok( ($dt1->compare(b => { value => $dt2, type => 'datetime' }) < 0),
    sprintf("%04d-%02d-%02d %02d:%02d:%02d %s", $dates[0]{year}, $dates[0]{month}, $dates[0]{day}, $dates[0]{hour}, $dates[0]{minute}, $dates[0]{second}, $dates[0]{time_zone}) .
    ' is the past from ' .
    sprintf("%04d-%02d-%02d %02d:%02d:%02d %s", $dates[$#dates]{year}, $dates[$#dates]{month}, $dates[$#dates]{day}, $dates[$#dates]{hour}, $dates[$#dates]{minute}, $dates[$#dates]{second}, $dates[$#dates]{time_zone})
);
