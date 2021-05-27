#!/usr/bin/perl
use strict;
use warnings;
use utf8;
use 5.010;
use FindBin;
use lib "$FindBin::Bin/../lib";    # t/lib
use List::Util;
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

my $s = MT::Test::Selenium->new($test_env);

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

# Single senario contains multiple panels in array ref and single panel has two values.
# For instance [7, 3] indicates the panel has 7 options and instructs to click the 3rd option.
my $senareos = [
    [[7, 1], [1, 1], [], [3, 1], [2, 1]], [[7, 1], [1, 1], [], [3, 1], [2, 2]],
    [[7, 1], [1, 1], [], [3, 2], [2, 1]], [[7, 1], [1, 1], [], [3, 2], [2, 2]],
    [[7, 1], [1, 1], [], [3, 3], [2, 1]], [[7, 1], [1, 1], [], [3, 3], [2, 2]],
    [[7, 2], [1, 1], [], [3, 1], [2, 1]], [[7, 2], [1, 1], [], [3, 1], [2, 2]],
    [[7, 2], [1, 1], [], [3, 2], [2, 1]], [[7, 2], [1, 1], [], [3, 2], [2, 2]],
    [[7, 2], [1, 1], [], [3, 3], [2, 1]], [[7, 2], [1, 1], [], [3, 3], [2, 2]],
    [[7, 3], [2, 1], [], [3, 1], [2, 1]], [[7, 3], [2, 1], [], [3, 1], [2, 2]],
    [[7, 3], [2, 1], [], [3, 2], [2, 1]], [[7, 3], [2, 1], [], [3, 2], [2, 2]],
    [[7, 3], [2, 1], [], [3, 3], [2, 1]], [[7, 3], [2, 1], [], [3, 3], [2, 2]],
    [[7, 3], [2, 2], [1, 1], [3, 1], [2, 1]], [[7, 3], [2, 2], [1, 1], [3, 1], [2, 2]],
    [[7, 3], [2, 2], [1, 1], [3, 2], [2, 1]], [[7, 3], [2, 2], [1, 1], [3, 2], [2, 2]],
    [[7, 3], [2, 2], [1, 1], [3, 3], [2, 1]], [[7, 3], [2, 2], [1, 1], [3, 3], [2, 2]],
    [[7, 4], [2, 1], [],     [3, 1], [2, 1]], [[7, 4], [2, 1], [],     [3, 1], [2, 2]],
    [[7, 4], [2, 1], [],     [3, 2], [2, 1]], [[7, 4], [2, 1], [],     [3, 2], [2, 2]],
    [[7, 4], [2, 1], [],     [3, 3], [2, 1]], [[7, 4], [2, 1], [],     [3, 3], [2, 2]],
    [[7, 4], [2, 2], [2, 1], [3, 1], [2, 1]], [[7, 4], [2, 2], [2, 1], [3, 1], [2, 2]],
    [[7, 4], [2, 2], [2, 1], [3, 2], [2, 1]], [[7, 4], [2, 2], [2, 1], [3, 2], [2, 2]],
    [[7, 4], [2, 2], [2, 1], [3, 3], [2, 1]], [[7, 4], [2, 2], [2, 1], [3, 3], [2, 2]],
    [[7, 4], [2, 2], [2, 2], [3, 1], [2, 1]], [[7, 4], [2, 2], [2, 2], [3, 1], [2, 2]],
    [[7, 4], [2, 2], [2, 2], [3, 2], [2, 1]], [[7, 4], [2, 2], [2, 2], [3, 2], [2, 2]],
    [[7, 4], [2, 2], [2, 2], [3, 3], [2, 1]], [[7, 4], [2, 2], [2, 2], [3, 3], [2, 2]],
    [[7, 5], [1, 1], [],     [3, 1], [2, 1]], [[7, 5], [1, 1], [],     [3, 1], [2, 2]],
    [[7, 5], [1, 1], [],     [3, 2], [2, 1]], [[7, 5], [1, 1], [],     [3, 2], [2, 2]],
    [[7, 5], [1, 1], [],     [3, 3], [2, 1]], [[7, 5], [1, 1], [],     [3, 3], [2, 2]],
    [[7, 6], [2, 1], [],     [3, 1], [2, 1]], [[7, 6], [2, 1], [],     [3, 1], [2, 2]],
    [[7, 6], [2, 1], [],     [3, 2], [2, 1]], [[7, 6], [2, 1], [],     [3, 2], [2, 2]],
    [[7, 6], [2, 1], [],     [3, 3], [2, 1]], [[7, 6], [2, 1], [],     [3, 3], [2, 2]],
    [[7, 6], [2, 2], [1, 1], [3, 1], [2, 1]], [[7, 6], [2, 2], [1, 1], [3, 1], [2, 2]],
    [[7, 6], [2, 2], [1, 1], [3, 2], [2, 1]], [[7, 6], [2, 2], [1, 1], [3, 2], [2, 2]],
    [[7, 6], [2, 2], [1, 1], [3, 3], [2, 1]], [[7, 6], [2, 2], [1, 1], [3, 3], [2, 2]],
    [[7, 7], [1, 1], [],     [3, 1], [2, 1]], [[7, 7], [1, 1], [],     [3, 1], [2, 2]],
    [[7, 7], [1, 1], [],     [3, 2], [2, 1]], [[7, 7], [1, 1], [],     [3, 2], [2, 2]],
    [[7, 7], [1, 1], [],     [3, 3], [2, 1]], [[7, 7], [1, 1], [],     [3, 3], [2, 2]],
];

$senareos = [ (List::Util::shuffle(@$senareos))[0..14] ]; # picking up 15 random senarios to test

plan tests => ((scalar @$senareos) * 2) + (scalar(grep { @$_} map { @$_ } @$senareos) * 4); # per scenario + per panel

$s->driver->{is_wd3} = 0;
my $author = MT->model('author')->load(1);
$author->set_password('Nelson');
$author->save;
$s->login($author);
$s->visit('/cgi-bin/mt.cgi?__mode=cfg_rebuild_trigger&blog_id=1');
wait_until { $s->driver->execute_script("document.readyState !== 'loading'") };

my $added_count = 0;

for (my $i = 0; $i < scalar @$senareos; $i++) {
    note "senario: ". stringify_senario($senareos->[$i]);
    my $pages = $senareos->[$i];
    $s->driver->find_element('#rebuild_triggers-field .mt-open-dialog', 'css')->click;
    my $iframe = wait_until { $s->driver->find_element('iframe', 'css') };
    wait_until { $s->driver->switch_to_frame($iframe); };
    my @panels = (
        $s->driver->find_element('#site-panel',         'css'),
        $s->driver->find_element('#object-panel',       'css'),
        $s->driver->find_element('#content_type-panel', 'css'),
        $s->driver->find_element('#event-panel',        'css'),
        $s->driver->find_element('#action-panel',       'css'),
    );
    for (my $j = 0; $j < scalar @{$pages}; $j++) {
        if (!scalar @{ $pages->[$j] }) { # content type skipping
            note "senario $i page $j is skipping";
            next;
        }
        note "senario $i page $j";
        $s->screenshot_full("senario$i-page$j", 1200, 900) if $ENV{MT_TEST_CAPTURE_SCREENSHOT};
        my $next_button = $panels[$j]->child('.modal-footer button.btn-primary', 'css');
        ok($next_button->get_attribute('disabled') ne '', 'button is not active yet');
        my @current_panel = grep { $_->is_displayed } @panels;
        is($current_panel[0],     $panels[$j], 'panel is visible');
        is(scalar @current_panel, 1,           'other panels are hidden');
        my @selections = grep { $_->is_displayed } $panels[$j]->children('.mt-table tbody tr');
        is(scalar @selections, $pages->[$j]->[0], 'right number of selections');
        $selections[$pages->[$j]->[1] - 1]->click();
        $next_button->click();
    }
    $s->driver->switch_to_frame;
    my @trs = $s->driver->find_elements('#multiblog_blog_list table tbody tr', 'css');
    is(scalar @trs, ++$added_count, 'trigger added');
    $s->screenshot_full("senario$i-added") if $ENV{MT_TEST_CAPTURE_SCREENSHOT};
    $s->driver->find_element('.mt-mainContent button.save', 'css')->click;
    my @trs2 = $s->driver->find_elements('#multiblog_blog_list table tbody tr', 'css');
    is(scalar @trs2, $added_count, 'trigger added');
    $s->screenshot_full("senario$i-saved") if $ENV{MT_TEST_CAPTURE_SCREENSHOT};
}

sub stringify_senario {
    my $ref = shift;
    my $string = Dumper($ref);
    $string =~ s{\s}{}g;
    return (split(/=/, $string, 2))[1];
}
