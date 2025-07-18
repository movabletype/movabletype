#!/usr/bin/perl
use strict;
use warnings;
use utf8;
use 5.010;
use FindBin;
use lib "$FindBin::Bin/../../../lib";    # t/lib
use Test::More;
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
$s->login($author);

subtest 'create new dashboard widget template' => sub {
    $s->visit('/cgi-bin/mt.cgi?__mode=list_template&blog_id=0');
    $s->wait_until_ready;
    assert_no_browser_errors();

    $s->set_value('#new-template-type', 'dashboard_widget');
    $s->driver->find_element('#create-template')->click;
    $s->wait_until_ready;
    assert_no_browser_errors();

    is($s->get_current_value('#template-listing-form input[name="type"]') => 'dashboard_widget', "type input should be dashboard_widget");
    like($s->get_current_value('#useful-links a[href$="#system"]', 'class'), qr/d-none/);

    $s->driver->find_element('label[for="code-highlight-switch"]')->click;
    $s->set_value('#title', 'Dashboard Widget Test');
    $s->set_value('#text', '<form>Dashboard Widget Test</form>');
    $s->scroll_and_click('.actions-bar .btn-primary');
    $s->wait_until_ready;

    $s->screenshot('create-template');

    like($s->driver->get_current_url,                       qr/saved_added=1/);
    like($s->get_current_value('.plugin-actions', 'class'), qr/d-none/);
};

subtest 'list dashboard widget templates' => sub {
    $s->visit('/cgi-bin/mt.cgi?__mode=list_template&blog_id=0');
    $s->wait_until_ready;
    assert_no_browser_errors();

    $s->driver->find_element('#quickfilters #dashboard_widget-tab')->click;
    $s->wait_until_ready;
    assert_no_browser_errors();

    $s->screenshot('list-template');

    is($s->get_text_content('#dashboard_widget-listing-table a'),                                                                      'Dashboard Widget Test');
    is(scalar @{ $s->driver->find_elements('#actions-bar-top-dashboard_widget-listing-form option[value="refresh_tmpl_templates"]') }, 0);
};

subtest 'show dashboard widget' => sub {
    $s->visit('/cgi-bin/mt.cgi?__mode=dashboard');
    $s->wait_until_ready;
    assert_no_browser_errors();

    $s->screenshot('show-template');

    is($s->get_current_value('.dashboard-widget-template form', 'action'), $s->mt_url);
};

sub assert_no_browser_errors {
    # mt_[lang].js may not exist depending on the env
    my @logs = grep { $_->{message} !~ /\bmt_\w+\.js\b.+Failed to load/ } $s->get_browser_error_log();
    is(scalar @logs, 0, 'no unknown browser error occured');
    note sprintf("<%s> %s", $_->{source}, $_->{message}) for @logs;
}

undef $s;

done_testing();
