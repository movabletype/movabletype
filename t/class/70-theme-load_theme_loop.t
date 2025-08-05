#!/usr/bin/perl
use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";    # t/lib
use Test::More;
use Test::Deep;
use MT::Test::Env;
our $test_env;
BEGIN {
    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;

    $test_env->save_file('themes/invalid_class_theme/theme.yaml', <<'YAML');
id: invalid_theme
name: Invalid Class Theme
label: Invalid Class theme
class: invalid
required_components:
    core: 1.0
optional_components:
    commercial: 2.0
YAML
}

use MT::Test;
use MT;
use MT::Theme;

my $all_themes = MT::Theme->load_all_themes;

subtest "load_theme_loop('website')" => sub {
    my $theme_loop     = MT::Theme->load_theme_loop('website');
    my @theme_loop_ids = map { $_->{value} } @{$theme_loop};

    my @expected = keys %{$all_themes};
    cmp_bag(\@theme_loop_ids, \@expected, 'returns all themes');

    ok scalar(grep { !$all_themes->{$_}{class} } @theme_loop_ids) > 0, 'returns some themes without class';
};

subtest "load_theme_loop('blog')" => sub {
    my $theme_loop     = MT::Theme->load_theme_loop('blog');
    my @theme_loop_ids = map { $_->{value} } @{$theme_loop};

    my @expected = grep { ($all_themes->{$_}{class} || '') ne 'website' } keys %{$all_themes};
    cmp_bag(\@theme_loop_ids, \@expected, 'returns themes other than website one');

    ok scalar(grep { !$all_themes->{$_}{class} } @theme_loop_ids) > 0, 'returns some themes without class';
};

done_testing;

