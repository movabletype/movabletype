#!/usr/bin/perl
use strict;
use warnings;
use utf8;
use 5.010;
use FindBin;
use lib "$FindBin::Bin/../lib";    # t/lib
use File::Path;
use Test::More;
use MT::Test::Env;
our $test_env;

BEGIN {
    $test_env = MT::Test::Env->new(StaticFilePath => 'MT_HOME/mt-static/');
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT::Test;
use MT;
use MT::Test::Fixture;
use MT::Test::Selenium;
use Selenium::Waiter;

$test_env->prepare_fixture('db_data');

my $s = MT::Test::Selenium->new($test_env);
$s->driver->{is_wd3} = 0;
my $author = MT->model('author')->load(1);
$author->set_password('Nelson');
$author->save;
$s->login($author);

my @queue;

add_queue(['/cgi-bin/mt.cgi']);

while (my $job_obj = shift @queue) {
    my ($url, $referrer);
    if (ref $job_obj eq 'ARRAY') {
        ($url, $referrer) = @$job_obj;
    } else {
        $url = $job_obj;
    }
    state $num = 1;
    note($num++ . ':' . $url);
    note '        refferrer: '. ($referrer ? $$referrer : 'null');
    $s->visit($url);
    my @urls = map { $_->get_attribute('href') } $s->driver->find_elements('a[href^="/cgi-bin/"]', 'css');
    add_queue(\@urls, $url);
    if (my @logs = get_filtered_log()) {
        ok(!scalar(@logs), 'no browser error occurs');
        note sprintf("<%s> %s", $_->{source}, $_->{message}) for @logs;
        screenshot_full($s->driver, $num) if $ENV{MT_TEST_CAPTURE_SCREENSHOT};
    }
    last if $num > 500;
    @queue = List::Util::shuffle(@queue) if $num % 10 == 0;
}

sub add_queue {
    my ($urls, $referrer) = @_;
    state $baseurl = $s->{base_url};
    state %once_queued;
    for my $url (@$urls) {
        next if $url =~ /^http/ && $url !~ /^$baseurl/;
        $url =~ s{^$baseurl}{};
        $url = (split(/#/, $url))[0];
        next if exists($once_queued{$url}) || $url =~ /__mode=logout/;
        next if $url =~ /__mode=tools/; # skip for now
        push @queue, ($referrer ? [$url, \$referrer] : $url);
        $once_queued{$url} = 1;
        shift(@queue) if scalar(@queue) > 500;
    }
}

sub get_filtered_log {
    state $ignore_hosts = join('|', ('narnia.na', 'example.com', 'creativecommons.org'));
    my $logs = $s->driver->get_log('browser');
    my @filtered;
    for my $log (@$logs) {
        if ($log->{source} eq 'network') {
            next if ($log->{message} =~ qr{^https?://($ignore_hosts)});
        }
        push(@filtered, $log);
    }
    return @filtered;
}

sub screenshot {
    my ($driver, $id) = @_;
    state $evidence_dir = sprintf("%s/evidence/%s/%s", $FindBin::Bin, time, $FindBin::Script);
    File::Path::make_path("$evidence_dir");
    $driver->capture_screenshot("$evidence_dir/$id.png");
}

sub screenshot_full {
    my ($driver, $id, $width, $height) = @_;
    my $size_org = $driver->get_window_size();
    $width  = $width  || $driver->execute_script('return document.body.scrollWidth / (top === self ? 1 : 0.8)');
    $height = $height || $driver->execute_script('return document.body.scrollHeight / (top === self ? 1 : 0.8)');
    $driver->set_window_size($height, $width);
    my $name = screenshot($driver, $id);
    $driver->set_window_size($size_org->{'height'}, $size_org->{'width'});
    return $name;
}

done_testing;
