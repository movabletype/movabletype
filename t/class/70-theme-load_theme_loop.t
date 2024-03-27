#!/usr/bin/perl
use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";    # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;
BEGIN {
    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT::Test;
use MT;
use MT::Theme;

subtest "load_theme_loop('website')" => sub {
    my $theme_loop = MT::Theme->load_theme_loop('website');

    is scalar @{$theme_loop}, 4, 'got 4 theme data';

    subtest '$theme_loop->[0]' => sub {
        is $theme_loop->[0]->{value}, 'classic_website', 'classic_website';
        ok !exists $theme_loop->[0]->{t_selected}, 'not selected';
    };

    subtest '$theme_loop->[1]' => sub {
        is $theme_loop->[1]->{value}, 'classic_blog', 'classic_blog';
        ok !exists $theme_loop->[1]->{t_selected}, 'not selected';
    };

    subtest '$theme_loop->[2]' => sub {
        is $theme_loop->[2]->{value},      'mont-blanc', 'mont-blanc';
        is $theme_loop->[2]->{t_selected}, 1,            'selected';
    };

    subtest '$theme_loop->[3]' => sub {
        is $theme_loop->[3]->{value}, 'other_theme', 'other_theme';
        ok !exists $theme_loop->[3]->{t_selected}, 'not selected';
    };
};

subtest "load_theme_loop('website', 'classic_website')" => sub {
    my $theme_loop = MT::Theme->load_theme_loop('website', 'classic_website');

    is scalar @{$theme_loop}, 4, 'got 4 theme data';

    subtest '$theme_loop->[0]' => sub {
        is $theme_loop->[0]->{value},      'classic_website', 'classic_website';
        is $theme_loop->[0]->{t_selected}, 1,                 'selected';
    };

    subtest '$theme_loop->[1]' => sub {
        is $theme_loop->[1]->{value}, 'classic_blog', 'classic_blog';
        ok !exists $theme_loop->[1]->{t_selected}, 'not selected';
    };

    subtest '$theme_loop->[2]' => sub {
        is $theme_loop->[2]->{value}, 'mont-blanc', 'mont-blanc';
        ok !exists $theme_loop->[2]->{t_selected}, 'not selected';
    };

    subtest '$theme_loop->[3]' => sub {
        is $theme_loop->[3]->{value}, 'other_theme', 'other_theme';
        ok !exists $theme_loop->[3]->{t_selected}, 'not selected';
    };
};

subtest "load_theme_loop('blog')" => sub {
    my $theme_loop = MT::Theme->load_theme_loop('blog');

    is scalar @{$theme_loop}, 3, 'got 3 theme data';

    subtest '$theme_loop->[0]' => sub {
        is $theme_loop->[0]->{value}, 'classic_blog', 'classic_blog';
        ok !exists $theme_loop->[0]->{t_selected}, 'not selected';
    };

    subtest '$theme_loop->[1]' => sub {
        is $theme_loop->[1]->{value},      'mont-blanc', 'mont-blanc';
        is $theme_loop->[1]->{t_selected}, 1,            'selected';
    };

    subtest '$theme_loop->[2]' => sub {
        is $theme_loop->[2]->{value}, 'other_theme', 'other_theme';
        ok !exists $theme_loop->[2]->{t_selected}, 'not selected';
    };
};

subtest "load_theme_loop('blog', 'classic_blog')" => sub {
    my $theme_loop = MT::Theme->load_theme_loop('blog', 'classic_blog');

    is scalar @{$theme_loop}, 3, 'got 3 theme data';

    subtest '$theme_loop->[0]' => sub {
        is $theme_loop->[0]->{value},      'classic_blog', 'classic_blog';
        is $theme_loop->[0]->{t_selected}, 1,              'selected';
    };

    subtest '$theme_loop->[1]' => sub {
        is $theme_loop->[1]->{value}, 'mont-blanc', 'mont-blanc';
        ok !exists $theme_loop->[1]->{t_selected}, 'not selected';
    };

    subtest '$theme_loop->[2]' => sub {
        is $theme_loop->[2]->{value}, 'other_theme', 'other_theme';
        ok !exists $theme_loop->[2]->{t_selected}, 'not selected';
    };
};

done_testing;

