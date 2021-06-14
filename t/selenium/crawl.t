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
        PluginSwitch   => [
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

my $s      = MT::Test::Selenium->new($test_env);
my $author = MT->model('author')->load(1);
$author->set_password('Nelson');
$author->save;
$s->login($author);

my $max = $ENV{MAX_CRAWLING} || 0;

my @queue;

add_queue(['/cgi-bin/mt.cgi'], undef);

while (my $job = shift @queue) {
    state $num = 1;
    $s->visit($job->url);
    my @urls = map { $_->get_attribute('href') } $s->driver->find_elements('a[href^="/cgi-bin/"]', 'css');
    add_queue(\@urls, $job->url);
    my $title = $s->driver->get_title;
    assert_no_errors($job, $num, 'Visit ' . $job->url, { title => $title, referrer => ${ $job->referrer } });

    $num++;
    last                                 if $max && $num > $max;
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
        next if $url                               =~ /__mode=tools/;    # skip for now
        push @queue, MT::Test::Selenium::Crawler::Job->new($url, $referrer ? \$referrer : ());
        $once_queued{$url} = 1;
        shift(@queue) if $max && scalar(@queue) > $max;
    }
}

sub assert_no_errors {
    my ($job, $num, $summary, $extra) = @_;
    my @logs = $s->get_browser_error_log();
    @logs = grep {
        $_->{message} !~ /Scripts may close only the windows that were opened by them/ &&
        $_->{message} !~ /Blocked attempt to show a 'beforeunload' confirmation panel for a frame that never had a user gesture since its load./
    } @logs;

    ok(!scalar(@logs), 'no browser error occurs');
    $summary = 'test_number_' . $num . ': ' . $summary;
    if (@logs) {
        diag($summary);
        diag((' ' x 8) . sprintf('%s: %s', $_, $extra->{$_})) for (sort keys %$extra);
        diag sprintf("<%s> %s", $_->{source}, $_->{message})  for grep { $_->{source} } @logs;
        $s->screenshot_full('test_number_' . $num) if $ENV{MT_TEST_CAPTURE_SCREENSHOT};
    } else {
        note($summary);
        note((' ' x 8) . sprintf('%s: %s', $_, $extra->{$_})) for (sort keys %$extra);
    }
}

# make sure to shut down chromedriver
undef $s;

done_testing;

package MT::Test::Selenium::Crawler::Job;
use strict;
use warnings;

sub url      { shift->[0] }
sub referrer { shift->[1] || \'null' }

sub new {
    my ($class, $url, $referrer) = @_;
    $url || die 'url is missing';
    return bless [$url, $referrer], $class;
}
