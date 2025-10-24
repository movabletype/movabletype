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

subtest 'create new entry' => sub {
    $s->visit('/cgi-bin/mt.cgi?__mode=view&_type=entry&blog_id=' . $blog->id);
    $s->wait_until_ready;
    assert_no_browser_errors();

    $s->set_value('#title', 'Create Entry Test');

    wait_until { $s->driver->find_element('.tox-toolbar svg') };

    my $iframe = $s->driver->find_element('#editor-input-content_ifr');
    $iframe->click;
    $s->driver->send_keys_to_active_element('Hello');
    $s->screenshot('enter-content-to-rich-editor');

    my $format_none = $s->driver->find_element('#convert_breaks option[value="0"]');
    $format_none->set_selected();

    my $textarea = $s->driver->find_element('#editor-input-content');
    wait_until { $textarea->is_displayed };
    $textarea->click;
    $s->driver->send_keys_to_active_element("<p>Movable</p>");
    $s->screenshot('enter-content-to-textarea');

    my $format_richtext = $s->driver->find_element('#convert_breaks option[value="richtext"]');
    $format_richtext->set_selected();
    wait_until { $s->driver->get_alert_text };
    $s->driver->accept_alert;

    $iframe = wait_until { $s->driver->find_element('#editor-input-content_ifr') };
    wait_until { $iframe->is_displayed };
    $iframe->click;
    $s->driver->send_keys_to_active_element(KEYS->{enter});
    $s->driver->send_keys_to_active_element('Type!');
    $s->screenshot('enter-content-to-rich-editor-2');

    $s->scroll_and_click('#entry-publishing-widget .btn-primary');
    $s->wait_until_ready;

    $s->screenshot('create-entry');

    my $entry = MT->model('entry')->load({ blog_id => $blog->id });
    is($entry->title, 'Create Entry Test');
    is($entry->text,  "<p>Hello</p>\n<p>Movable</p>\n<p>Type!</p>");
};

sub assert_no_browser_errors {
    # mt_[lang].js may not exist depending on the env
    my @logs = grep { $_->{message} !~ /\bmt_\w+\.js\b.+Failed to load/ } $s->get_browser_error_log();
    is(scalar @logs, 0, 'no unknown browser error occured');
    note sprintf("<%s> %s", $_->{source}, $_->{message}) for @logs;
}

undef $s;

done_testing();
