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
    $test_env = MT::Test::Env->new(
        StaticFilePath => 'MT_HOME/mt-static/',
        PluginSwitch => [
            'TinyMCE=0',
            'FormattedTextForTinyMCE=0',
        ],
    );
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT::Test;
use MT;
use MT::Test::Fixture;
use MT::Test::Selenium;
use Selenium::Waiter;

plan skip_all => "set EXTENDED_TESTING=1 to enable this test" unless $ENV{EXTENDED_TESTING};

$test_env->prepare_fixture('db_data');

my $s = MT::Test::Selenium->new($test_env);
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
    $s->visit($url);
    my @urls = map { $_->get_attribute('href') } $s->driver->find_elements('a[href^="/cgi-bin/"]', 'css');
    add_queue(\@urls, $url);
    my @logs = $s->get_browser_error_log();
    ok(!scalar(@logs), 'no browser error occurs');
    if (@logs) {
        diag('test_number_'. $num . ':' . $url);
        diag '        referrer: '. ($referrer ? $$referrer : 'null');
        diag sprintf("<%s> %s", $_->{source}, $_->{message}) for grep { $_->{source} } @logs;
        $s->screenshot_full('test_number_'. $num) if $ENV{MT_TEST_CAPTURE_SCREENSHOT};
    } else {
        note('test_number_'. $num . ':' . $url);
        note '        referrer: '. ($referrer ? $$referrer : 'null');
    }
    $num++;
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

done_testing;
