#!/usr/bin/perl
use strict;
use warnings;
use utf8;
use 5.010;
use FindBin;
use lib "$FindBin::Bin/../../../lib";    # t/lib
use Test::More;
use Selenium::Remote::WDKeys;
use MT::Test::Env;
use Data::Dumper;
our $test_env;

BEGIN {
    $test_env = MT::Test::Env->new();
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT::Test;
use MT;
use MT::Test::Fixture;
use MT::Test::Selenium;
use MT::RebuildTrigger;
use Selenium::Waiter;

$test_env->prepare_fixture('db');

my $s = MT::Test::Selenium->new($test_env, { rebootable => 1 });

my $author = MT->model('author')->load(1);
$author->set_password('Nelson');
$author->save;
my $blog = MT->model('blog')->load(1);
$s->login($author);

subtest 'list template' => sub {
    subtest 'quick filter' => sub {
        my @modules = qw(module email system dashboard_widget widget-set widget);
        $s->visit('/cgi-bin/mt.cgi?__mode=list_template');
        $s->wait_until_ready;
        assert_no_browser_errors();

        for my $id (@modules) {
            ok $s->driver->find_element("#$id-listing");
        }

        for my $active_id (@modules) {
            $s->driver->find_element("#${active_id}-tab a")->click;
            $s->screenshot('list-template-filter-' . $active_id);
            for my $id (@modules) {
                my $should_display = $id eq $active_id ? 1 : 0;
                is $s->driver->find_element("#$id-listing")->is_displayed(), $should_display, "tab switch to $active_id, $id listing display is $should_display";
            }
        }

        $s->driver->find_element("#all-tab a")->click;
        $s->screenshot('list-template-filter-all');
        for my $id (@modules) {
            ok $s->driver->find_element("#$id-listing");
        }
    };
};

sub assert_no_browser_errors {
    # mt_[lang].js may not exist depending on the env
    my @logs = grep { $_->{message} !~ /\bmt_\w+\.js\b.+Failed to load/ } $s->get_browser_error_log();
    is(scalar @logs, 0, 'no unknown browser error occured');
    note sprintf("<%s> %s", $_->{source}, $_->{message}) for @logs;
}

undef $s;

done_testing();
