#!/usr/bin/perl
use strict;
use warnings;
use utf8;
use 5.010;
use FindBin;
use lib "$FindBin::Bin/../lib";    # t/lib
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

my $s = MT::Test::Selenium->new($test_env, {rebootable => 1});

MT->model('content_type')->remove();

my $objs = MT::Test::Fixture->prepare({
    website => [
        #{ name     => 'First Website' }, # fixture preset
        { id => 2, name => 'parent1' },
        { id => 3, name => 'parent2' },
    ],
    blog => [
        { id => 4, name => 'child1-1', parent_id => 1 },
        { id => 5, name => 'child1-2', parent_id => 1 },
        { id => 6, name => 'child2-1', parent_id => 2 },
    ],
});
my $ct2  = MT::Test::Permission->make_content_type(name => 'ct2',   blog_id => 2);
my $ct4  = MT::Test::Permission->make_content_type(name => 'ct4',   blog_id => 4);
my $ct5  = MT::Test::Permission->make_content_type(name => 'ct5',   blog_id => 5);
my $ct52 = MT::Test::Permission->make_content_type(name => 'ct5-2', blog_id => 5);

my $author = MT->model('author')->load(1);
$author->set_password('Nelson');
$author->save;
$s->login($author);

# Single scenarios contains multiple panels in array ref and single panel has two values.
# For instance [7, 3] indicates the panel has 7 options and instructs to click on the 3rd one.
my $scenarios_full = [
    [[7, 1], [1, 1], [], [3, 1], [1, 1]],
    [[7, 1], [1, 1], [], [3, 2], [1, 1]],
    [[7, 1], [1, 1], [], [3, 3], [1, 1]],
    [[7, 2], [1, 1], [], [3, 1], [1, 1]],
    [[7, 2], [1, 1], [], [3, 2], [1, 1]],
    [[7, 2], [1, 1], [], [3, 3], [1, 1]],
    [[7, 3], [2, 1], [], [3, 1], [1, 1]],
    [[7, 3], [2, 1], [], [3, 2], [1, 1]],
    [[7, 3], [2, 1], [], [3, 3], [1, 1]],
    [[7, 3], [2, 2], [1, 1], [3, 1], [1, 1]],
    [[7, 3], [2, 2], [1, 1], [3, 2], [1, 1]],
    [[7, 3], [2, 2], [1, 1], [3, 3], [1, 1]],
    [[7, 4], [2, 1], [],     [3, 1], [1, 1]],
    [[7, 4], [2, 1], [],     [3, 2], [1, 1]],
    [[7, 4], [2, 1], [],     [3, 3], [1, 1]],
    [[7, 4], [2, 2], [2, 1], [3, 1], [1, 1]],
    [[7, 4], [2, 2], [2, 1], [3, 2], [1, 1]],
    [[7, 4], [2, 2], [2, 1], [3, 3], [1, 1]],
    [[7, 4], [2, 2], [2, 2], [3, 1], [1, 1]],
    [[7, 4], [2, 2], [2, 2], [3, 2], [1, 1]],
    [[7, 4], [2, 2], [2, 2], [3, 3], [1, 1]],
    [[7, 5], [1, 1], [],     [3, 1], [1, 1]],
    [[7, 5], [1, 1], [],     [3, 2], [1, 1]],
    [[7, 5], [1, 1], [],     [3, 3], [1, 1]],
    [[7, 6], [2, 1], [],     [3, 1], [1, 1]],
    [[7, 6], [2, 1], [],     [3, 2], [1, 1]],
    [[7, 6], [2, 1], [],     [3, 3], [1, 1]],
    [[7, 6], [2, 2], [1, 1], [3, 1], [1, 1]],
    [[7, 6], [2, 2], [1, 1], [3, 2], [1, 1]],
    [[7, 6], [2, 2], [1, 1], [3, 3], [1, 1]],
    [[7, 7], [1, 1], [],     [3, 1], [1, 1]],
    [[7, 7], [1, 1], [],     [3, 2], [1, 1]],
    [[7, 7], [1, 1], [],     [3, 3], [1, 1]],
];

subtest 'system context' => sub {
    $s->visit('/cgi-bin/mt.cgi?__mode=cfg_rebuild_trigger&blog_id=0');
    assert_no_browser_errors();
    $s->driver->find_element('.mt-mainContent button.save', 'css')->click;
    is(@{ $s->driver->find_elements('.alert-success', 'css') }, 1, 'save success indicated');
    assert_no_browser_errors();
};

subtest 'site context' => sub {

    set_up();

    my $scenarios = $scenarios_full;

    if (!$ENV{EXTENDED_TESTING}) {
        # Only tests random 15 cases to save time. Do not randomize on runtime because it's confusing.
        $scenarios = [@$scenarios_full[5, 6, 7, 11, 13, 14, 16, 18, 21, 22, 25, 31, 32]];
    }

    $s->visit('/cgi-bin/mt.cgi?__mode=cfg_rebuild_trigger&blog_id=1');
    $s->wait_until_ready;
    assert_no_browser_errors();

    my $added_count = 0;

    for (my $i = 0; $i < scalar @$scenarios; $i++) {
        note "scenarios: " . stringify_scenarios($scenarios->[$i]);
        process_scenarios($scenarios->[$i]);
        assert_no_browser_errors();
        my @trs = $s->driver->find_elements('#multiblog_blog_list table tbody tr', 'css');
        is(scalar @trs, ++$added_count, 'trigger added');
        $s->screenshot_full("scenarios$i-added") if $ENV{MT_TEST_CAPTURE_SCREENSHOT};
        wait_until { $s->driver->find_element('.mt-mainContent button.save', 'css')->is_displayed };
        assert_no_browser_errors();
        $s->scroll_and_click('.mt-mainContent button.save');
        $s->wait_until_ready;
        assert_no_browser_errors();
        my @trs2 = $s->driver->find_elements('#multiblog_blog_list table tbody tr', 'css');
        is(scalar @trs2, $added_count, 'trigger added');
        $s->screenshot_full("scenarios$i-saved") if $ENV{MT_TEST_CAPTURE_SCREENSHOT};
    }
};

subtest 'duplication' => sub {

    set_up();

    my $scenarios = [@$scenarios_full[1, 1]];

    $s->visit('/cgi-bin/mt.cgi?__mode=cfg_rebuild_trigger&blog_id=1');
    $s->wait_until_ready;
    assert_no_browser_errors();

    my $added_count = 0;

    for (my $i = 0; $i < scalar @$scenarios; $i++) {
        note "scenarios: " . stringify_scenarios($scenarios->[$i]);

        # same scenarios twice
        process_scenarios($scenarios->[$i]) for (1, 2);

        assert_no_browser_errors();
        my @trs = $s->driver->find_elements('#multiblog_blog_list table tbody tr', 'css');
        is(scalar @trs, $added_count + 2, 'trigger added');
        $s->screenshot_full("scenarios$i-added") if $ENV{MT_TEST_CAPTURE_SCREENSHOT};
        wait_until { $s->driver->find_element('.mt-mainContent button.save', 'css')->is_displayed };
        assert_no_browser_errors();
        $s->scroll_and_click('.mt-mainContent button.save');
        $s->wait_until_ready;
        assert_no_browser_errors();
        my @trs2 = $s->driver->find_elements('#multiblog_blog_list table tbody tr', 'css');
        is(scalar @trs2, 1, 'duplication is not added');
        $s->screenshot_full("scenarios$i-saved") if $ENV{MT_TEST_CAPTURE_SCREENSHOT};
        $added_count = 1;
    }
};

subtest 'duplication with content type' => sub {

    set_up();

    my $scenarios = [@$scenarios_full[9, 9]];

    $s->visit('/cgi-bin/mt.cgi?__mode=cfg_rebuild_trigger&blog_id=1');
    $s->wait_until_ready;
    assert_no_browser_errors();

    my $added_count = 0;

    for (my $i = 0; $i < scalar @$scenarios; $i++) {
        note "scenarios: " . stringify_scenarios($scenarios->[$i]);

        # same scenarios twice
        process_scenarios($scenarios->[$i]) for (1, 2);

        assert_no_browser_errors();
        my @trs = $s->driver->find_elements('#multiblog_blog_list table tbody tr', 'css');
        is(scalar @trs, $added_count + 2, 'triggers are added');
        $s->screenshot_full("scenarios$i-added") if $ENV{MT_TEST_CAPTURE_SCREENSHOT};
        wait_until { $s->driver->find_element('.mt-mainContent button.save', 'css')->is_displayed };
        assert_no_browser_errors();
        $s->scroll_and_click('.mt-mainContent button.save');
        $s->wait_until_ready;
        assert_no_browser_errors();
        my @trs2 = $s->driver->find_elements('#multiblog_blog_list table tbody tr', 'css');
        is(scalar @trs2, 1, 'duplication is not added');
        $s->screenshot_full("scenarios$i-saved") if $ENV{MT_TEST_CAPTURE_SCREENSHOT};
        $added_count = 1;
    }
};

subtest 'two cases saved at once' => sub {

    set_up();

    my $scenarios = [@$scenarios_full[9, 10]];

    $s->visit('/cgi-bin/mt.cgi?__mode=cfg_rebuild_trigger&blog_id=1');
    $s->wait_until_ready;
    assert_no_browser_errors();

    for (my $i = 0; $i < scalar @$scenarios; $i++) {
        note "scenarios: " . stringify_scenarios($scenarios->[$i]);
        process_scenarios($scenarios->[$i]);
    }

    my @trs = $s->driver->find_elements('#multiblog_blog_list table tbody tr', 'css');
    is(scalar @trs, 2, 'triggers are added');
    $s->screenshot_full("added") if $ENV{MT_TEST_CAPTURE_SCREENSHOT};
    wait_until { $s->driver->find_element('.mt-mainContent button.save', 'css')->is_displayed };
    assert_no_browser_errors();
    $s->scroll_and_click('.mt-mainContent button.save');
    $s->wait_until_ready;
    assert_no_browser_errors();
    my @trs2 = $s->driver->find_elements('#multiblog_blog_list table tbody tr', 'css');
    is(scalar @trs2, 2, 'triggers are saved');
    $s->screenshot_full("saved") if $ENV{MT_TEST_CAPTURE_SCREENSHOT};
};

subtest 'remove' => sub {

    set_up();

    my $scenarios = [@$scenarios_full[9, 10]];

    $s->visit('/cgi-bin/mt.cgi?__mode=cfg_rebuild_trigger&blog_id=1');
    $s->wait_until_ready;
    assert_no_browser_errors();

    for (my $i = 0; $i < scalar @$scenarios; $i++) {
        note "scenarios: " . stringify_scenarios($scenarios->[$i]);
        process_scenarios($scenarios->[$i]);
    }

    wait_until { $s->driver->find_element('.mt-mainContent button.save', 'css')->is_displayed };
    $s->scroll_and_click('.mt-mainContent button.save');
    $s->wait_until_ready;
    my @trs = $s->driver->find_elements('#multiblog_blog_list table tbody tr', 'css');
    is(scalar @trs, 2, 'triggers are added');

    # find_elements is needed repeatedly because the table is rebuilt everytime after operation.
    while (my @button = $s->driver->find_elements('#multiblog_blog_list table tbody tr td:nth-child(5) a', 'css')) {
        $button[0]->click;
        assert_no_browser_errors();
    }

    my @trs2 = $s->driver->find_elements('#multiblog_blog_list table tbody tr', 'css');
    is(scalar @trs2, 0, 'triggers are removed');
    $s->screenshot_full("removed") if $ENV{MT_TEST_CAPTURE_SCREENSHOT};
    $s->scroll_and_click('.mt-mainContent button.save');
    $s->wait_until_ready;
    my @trs3 = $s->driver->find_elements('#multiblog_blog_list table tbody tr', 'css');
    is(scalar @trs3, 0, 'triggers are removed and saved');
    $s->screenshot_full("removed-saved") if $ENV{MT_TEST_CAPTURE_SCREENSHOT};
};

sub process_scenarios {
    my $pages = shift;

    my $frame = $s->retry_until_success(
        task      => sub {
            $s->driver->find_element('#rebuild_triggers-field .mt-open-dialog', 'css')->click;
            my $frame;
            wait_until { # wait_until could silently timeout
                ($frame = $s->driver->find_element('iframe', 'css'))
                    && $frame->is_displayed
                    && $s->driver->execute_script(q{return top.jQuery(".modal").css("opacity") === "1"})
            };
            die 'iframe does not seem to displayed' unless $frame->is_displayed;
            return $frame;
        },
        teardown => sub {
            # chrome may be hanging up. Except some cases it's harmless to refresh the page.
            $s->driver->refresh();
            $s->wait_until_ready;
        },
    );
    if (!$frame) {
        diag "SKIP: frame is not found";
        return;
    }

    # make sure switch to frame succeeded
    wait_until { $s->driver->switch_to_frame($frame) && $s->driver->execute_script("return self !== top") };

    my @panels = (
        $s->driver->find_element('#site-panel',         'css'),
        $s->driver->find_element('#object-panel',       'css'),
        $s->driver->find_element('#content_type-panel', 'css'),
        $s->driver->find_element('#event-panel',        'css'),
        $s->driver->find_element('#action-panel',       'css'),
    );
    for (my $j = 0; $j < scalar @{$pages}; $j++) {
        if (!scalar @{ $pages->[$j] }) {    # content type skipping
            note "page $j is skipping";
            next;
        }
        note "page $j";
        my @visible_options;
        wait_until {
            $panels[$j]->is_displayed &&
            (@visible_options = grep { $_->is_displayed } $panels[$j]->children('.listing tbody tr', 'css'))
        };

        # Workarround for modal size initialization bug(MTC-28952)
        my $size_org = $s->driver->get_window_size();
        $s->driver->set_window_size(1, 1);
        $s->driver->set_window_size($size_org->{'height'}, $size_org->{'width'});

        $s->screenshot_full("page$j", 1200, 900) if $ENV{MT_TEST_CAPTURE_SCREENSHOT};
        assert_no_browser_errors();
        my $next_button = $panels[$j]->child('.modal-footer button.btn-primary', 'css');
        ok($next_button->get_attribute('disabled') ne '', 'button is not active yet');
        my @current_panel = grep { $_->is_displayed } @panels;
        is($current_panel[0],       $panels[$j],       'panel is visible');
        is(scalar @current_panel,   1,                 'other panels are hidden');
        is(scalar @visible_options, $pages->[$j]->[0], 'right number of options');
        $visible_options[$pages->[$j]->[1] - 1]->click();        
        $next_button->click();
        assert_no_browser_errors();
    }
    $s->driver->switch_to_frame;

    # make sure it's not in middle of modal fade out
    wait_until { $s->driver->execute_script(q{return top.frames.length}) == 0 };

    assert_no_browser_errors();
}

sub set_up {
    MT->model('rebuild_trigger')->remove();
}

sub stringify_scenarios {
    my $ref    = shift;
    my $string = Dumper($ref);
    $string =~ s{\s}{}g;
    return (split(/=/, $string, 2))[1];
}

sub assert_no_browser_errors {
    # mt_[lang].js may not exist depending on the env
    my @logs = grep { $_->{message} !~ /\bmt_\w+\.js\b.+Failed to load/ } $s->get_browser_error_log();
    is(scalar @logs, 0, 'no unknown browser error occured');
    note sprintf("<%s> %s", $_->{source}, $_->{message}) for @logs;
}

undef $s;

done_testing();
