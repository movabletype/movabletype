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

use MT;
use MT::Test;
use MT::Test::Fixture;
use MT::Test::App qw(MT::Test::Role::CMS::GrantRole);
use Test::Deep    qw'cmp_bag cmp_deeply superhashof';
use MT::App::CMS;

$test_env->prepare_fixture('db');

my @authors;
push @authors, MT->model('author')->load(1);

my $limit = 3;
$MT::App::CMS::LIST_PREF_DEFAULT_ROW = $limit;
$test_env->update_config(CMSSearchLimit   => $limit);

for my $number (2 .. 10) {
    my $name = 'author-' . $number;
    push @authors, MT::Test::Permission->make_author(name => $name, nickname => $name);
}

my $blog1 = MT->model('blog')->load(1);

for my $number (2 .. 10) {
    MT::Test::Permission->make_website(name => 'site-' . $number);
}
for my $number (1 .. 3) {
    MT::Test::Permission->make_blog(parent_id => 1, name => 'blog-1-' . $number);
}

$test_env->update_config(GrantRoleSitesView => 'list');

for my $blog_id (0, $blog1->id) {

    subtest 'unit tests for user panel on blog_id:' . $blog_id => sub {

        my $app = MT::Test::App->new('MT::App::CMS');
        $app->login($authors[0]);
        $app->open_dialog($blog_id);

        subtest 'pager page 1' => sub {
            $app->get_json();
            my ($names, $pager) = $app->get_names_and_pager;
            is_deeply($names, ['author-9', 'author-8', 'author-7'], 'right authors');
            cmp_deeply($pager, superhashof({ limit => 3, listTotal => 10, offset => 0, rows => 3 }), 'right pager');
        };

        subtest 'pager page 2' => sub {
            my $offset = 1 * $limit;
            $app->get_json({ offset => $offset });
            my ($names, $pager) = $app->get_names_and_pager;
            is_deeply($names, ['author-6', 'author-5', 'author-4'], 'right authors');
            cmp_deeply($pager, superhashof({ limit => 3, listTotal => 10, offset => $offset, rows => 3 }), 'right pager');
        };

        subtest 'pager page 3' => sub {
            my $offset = 2 * $limit;
            $app->get_json({ offset => $offset });
            my ($names, $pager) = $app->get_names_and_pager;
            is_deeply($names, ['author-3', 'author-2', 'author-10'], 'right authors');
            cmp_deeply($pager, superhashof({ limit => 3, listTotal => 10, offset => $offset, rows => 3 }), 'right pager');
        };

        subtest 'pager page 4' => sub {
            my $offset = 3 * $limit;
            $app->get_json({ offset => $offset });
            my ($names, $pager) = $app->get_names_and_pager;
            is_deeply($names, ['Melody'], 'right authors');
            cmp_deeply($pager, superhashof({ limit => 3, listTotal => 10, offset => $offset, rows => 1 }), 'right pager');
        };

        subtest 'search' => sub {
            $app->get_json({ search => 'o' });
            my ($names, $pager) = $app->get_names_and_pager;
            is_deeply($names, ['author-3', 'author-2', 'author-10'], 'right authors');
            cmp_deeply($pager, superhashof({ limit => 3, listTotal => 3, offset => 0, rows => 3 }), 'right pager');
        };
    };
}

subtest 'unit tests for site panel on blog_id:0' => sub {

    plan skip_all => 'not for nameless admin theme'
        if defined($ENV{MT_TEST_ADMIN_THEME_ID}) && $ENV{MT_TEST_ADMIN_THEME_ID} eq '0';

    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($authors[0]);
    $app->open_dialog(0);
    $app->set_panel('site');

    subtest 'pager page 1' => sub {
        $app->get_json();
        my ($names, $pager) = $app->get_names_and_pager;
        is_deeply($names, ['blog-1-3', 'blog-1-2', 'blog-1-1'], 'right sites');
        cmp_deeply($pager, superhashof({ limit => 3, listTotal => 13, offset => 0, rows => 3 }), 'right pager');
    };

    subtest 'pager page 2' => sub {
        my $offset = 1 * $limit;
        $app->get_json({ offset => $offset });
        my ($names, $pager) = $app->get_names_and_pager;
        is_deeply($names, ['site-10', 'site-9', 'site-8'], 'right sites');
        cmp_deeply($pager, superhashof({ limit => 3, listTotal => 13, offset => $offset, rows => 3 }), 'right pager');
    };

    subtest 'pager page 3' => sub {
        my $offset = 2 * $limit;
        $app->get_json({ offset => $offset });
        my ($names, $pager) = $app->get_names_and_pager;
        is_deeply($names, ['site-7', 'site-6', 'site-5'], 'right sites');
        cmp_deeply($pager, superhashof({ limit => 3, listTotal => 13, offset => $offset, rows => 3 }), 'right pager');
    };

    subtest 'pager page 4' => sub {
        my $offset = 3 * $limit;
        $app->get_json({ offset => $offset });
        my ($names, $pager) = $app->get_names_and_pager;
        is_deeply($names, ['site-4', 'site-3', 'site-2'], 'right sites');
        cmp_deeply($pager, superhashof({ limit => 3, listTotal => 13, offset => $offset, rows => 3 }), 'right pager');
    };

    subtest 'pager page 5' => sub {
        my $offset = 4 * $limit;
        $app->get_json({ offset => $offset });
        my ($names, $pager) = $app->get_names_and_pager;
        is_deeply($names, ['First Website'], 'right sites');
        cmp_deeply($pager, superhashof({ limit => 3, listTotal => 13, offset => $offset, rows => 1 }), 'right pager');
    };

    subtest 'search' => sub {
        $app->get_json({ search => 'First' });
        my ($names, $pager) = $app->get_names_and_pager;
        is_deeply($names, ['First Website'], 'right sites');
        is($pager, undef, 'right pager');
    };

    subtest 'search' => sub {
        $app->get_json({ search => 'site-' });
        my ($names, $pager) = $app->get_names_and_pager;
        is_deeply($names, ['site-8', 'site-9', 'site-10'], 'right sites');
        is($pager, undef, 'right pager');
    };
};

# Note that the expectations of the subtest are possibly wrong.
subtest 'tree view(deprecated)' => sub {
    $test_env->update_config(GrantRoleSitesView => 'tree');

    plan skip_all => 'not for nameless admin theme'
        if defined($ENV{MT_TEST_ADMIN_THEME_ID}) && $ENV{MT_TEST_ADMIN_THEME_ID} eq '0';

    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($authors[0]);
    $app->open_dialog(0);
    $app->set_panel('site');

    subtest 'pager page 1' => sub {
        $app->get_json();
        my ($names, $pager) = $app->get_site_tree_and_pager;
        is_deeply($names, ['First Website', 'blog-1-3'], 'right sites');
        cmp_deeply($pager, superhashof({ limit => 3, listTotal => 13, offset => 0, rows => 3 }), 'right pager');
    };

    subtest 'pager page 2' => sub {
        my $offset = 1 * $limit;
        $app->get_json({ offset => $offset });
        my ($names, $pager) = $app->get_site_tree_and_pager;
        is_deeply($names, ['site-10', 'site-9', 'site-8'], 'right sites');
        cmp_deeply($pager, superhashof({ limit => 3, listTotal => 13, offset => $offset, rows => 3 }), 'right pager');
    };

    subtest 'pager page 3' => sub {
        my $offset = 2 * $limit;
        $app->get_json({ offset => $offset });
        my ($names, $pager) = $app->get_site_tree_and_pager;
        is_deeply($names, ['site-7', 'site-6', 'site-5'], 'right sites');
        cmp_deeply($pager, superhashof({ limit => 3, listTotal => 13, offset => $offset, rows => 3 }), 'right pager');
    };

    subtest 'pager page 4' => sub {
        my $offset = 3 * $limit;
        $app->get_json({ offset => $offset });
        my ($names, $pager) = $app->get_site_tree_and_pager;
        is_deeply($names, ['site-4', 'site-3', 'site-2'], 'right sites');
        cmp_deeply($pager, superhashof({ limit => 3, listTotal => 13, offset => $offset, rows => 3 }), 'right pager');
    };

    subtest 'pager page 5' => sub {
        my $offset = 4 * $limit;
        $app->get_json({ offset => $offset });
        my ($names, $pager) = $app->get_site_tree_and_pager;
        is_deeply($names, ['First Website', 'blog-1-1', 'blog-1-2', 'blog-1-3'], 'right sites');
        cmp_deeply($pager, superhashof({ limit => 3, listTotal => 13, offset => $offset, rows => 1 }), 'right pager');
    };

    subtest 'search' => sub {
        $app->get_json({ search => 'First' });
        my ($names, $pager) = $app->get_site_tree_and_pager;
        is_deeply($names, ['First Website'], 'right sites');
        is($pager, undef, 'right pager');
    };

    subtest 'search' => sub {
        $app->get_json({ search => 'site-' });
        my ($names, $pager) = $app->get_site_tree_and_pager;
        is_deeply($names, ['site-8', 'site-9', 'site-10'], 'right sites');
        is($pager, undef, 'right pager');
    };
};

done_testing;
