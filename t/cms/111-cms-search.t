#!/usr/bin/perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";    # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;
BEGIN {
    $test_env = MT::Test::Env->new(
        DefaultLanguage => 'en_US',    ## for now
    );
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT::Test;
use MT::Test::Permission;
use MT::Test::App qw(MT::Test::Role::CMS::Search);

$test_env->prepare_fixture(sub {
    MT::Test->init_db;
    MT::Test->init_data;

    my $aikawa = MT::Test::Permission->make_author(
        name     => 'aikawa',
        nickname => 'Ichiro Aikawa',
    );
    my $ichikawa = MT::Test::Permission->make_author(
        name     => 'ichikawa',
        nickname => 'Jiro Ichikawa',
    );
    my $ukawa = MT::Test::Permission->make_author(
        name     => 'ukawa',
        nickname => 'Saburo Ukawa',
    );
    my $admin = MT::Author->load(1);

    my $website = MT::Website->load(2);
    my $blog    = $website->blogs;

    my %entries = ();
    for my $e (MT::Entry->load) {
        $entries{ $e->id } = $e;
    }
    my $website_entry = MT::Test::Permission->make_entry(
        blog_id   => $website->id,
        author_id => $admin->id,
        title     => 'A Sunny Day',
    );

    my $edit_all_posts = MT::Test::Permission->make_role(
        name        => 'Edit All Posts',
        permissions => "'edit_all_posts'",
    );
    my $designer = MT::Role->load({ name => MT->translate('Designer') });

    require MT::Association;
    MT::Association->link($aikawa,   $edit_all_posts, $website);
    MT::Association->link($ichikawa, $edit_all_posts, $blog->[0]);
    MT::Association->link($ukawa,    $designer,       $website);
});

my $aikawa   = MT::Author->load({ name => 'aikawa' });
my $ichikawa = MT::Author->load({ name => 'ichikawa' });
my $ukawa    = MT::Author->load({ name => 'ukawa' });
my $website  = MT::Website->load(2);
my $blog     = $website->blogs->[0];
my $admin    = MT::Author->load(1);
my $blog_id  = $blog->id;

my $website_entry = MT::Entry->load({ title => 'A Sunny Day' });

my %entries = ();
for my $e (MT::Entry->load) {
    $entries{ $e->id } = $e;
}

subtest 'search_replace' => sub {
    subtest search => sub {
        my $app = MT::Test::App->new('MT::App::CMS');
        $app->login($admin);
        $app->get_ok({
            __mode  => 'search_replace',
            blog_id => $blog_id,
        });
        $app->search($entries{1}->title);
        my $ids = $app->found_ids;
        is_deeply($ids, [1]);
    };

    subtest 'Column name in each scopes' => sub {

        # child site scope
        my $app = MT::Test::App->new('MT::App::CMS');
        $app->login($admin);
        $app->get_ok({
            __mode  => 'search_replace',
            blog_id => $blog_id,
        });
        $app->search('A Rainy Day');

        my $no_results = quotemeta 'No entries were found that match the given criteria.';
        $app->content_unlike(qr/$no_results/, 'There are some search results.');

        my $col_website_blog = quotemeta('<span class="col-label">Website/Blog</span>');
        $col_website_blog = qr/$col_website_blog/;
        $app->content_unlike(
            $col_website_blog,
            'Does not have a colomn "Website/Blog" in child site scope'
        );

        my $col_site_child_site = quotemeta('<span class="col-label">Site/Child Site</span>');
        $col_site_child_site = qr/$col_site_child_site/;
        $app->content_unlike(
            $col_site_child_site,
            'Does not have a column "Site/Child Site" in child site scope'
        );

        # site scope
        $app->get_ok({
            __mode     => 'search_replace',
            blog_id    => $website->id,
        });
        $app->search('A Rainy Day');

        $app->content_unlike(qr/$no_results/, 'There are some search results.');

        $app->content_unlike(
            $col_website_blog,
            'Does not have a colomn "Website/Blog" in site scope'
        );

        $app->content_like(
            $col_site_child_site,
            'Has a column "Site/Child Site" in site scope'
        );

        # system scope
        $app->get_ok({
            __mode  => 'search_replace',
            blog_id => 0,
        });
        $app->search('A Sunny Day');

        $app->content_unlike(qr/$no_results/, 'There are some search results.');

        $app->content_unlike(
            $col_website_blog,
            'Does not have a colomn "Website/Blog" in system scope'
        );
        $app->content_like(
            $col_site_child_site,
            'Has a column "Site/Child Site" in system scope'
        );
    };

    subtest 'Search in site scope' => sub {
        my $app = MT::Test::App->new('MT::App::CMS');
        $app->login($admin);
        $app->get_ok({
            __mode     => 'search_replace',
            blog_id    => $website->id,
        });
        $app->search('Day');

        my $a_sunny_day = quotemeta('<a href="' . $app->_app->mt_uri . '?__mode=view&amp;_type=entry&amp;id=' . $website_entry->id . '&amp;blog_id=' . $website->id . '">' . $website_entry->title . '</a>');
        $app->content_like(
            qr/$a_sunny_day/,
            'Search results have "A Sunny Day" entry by admin'
        );

        my $blog_entry  = MT::Entry->load(1);
        my $a_rainy_day = quotemeta('<a href="' . $app->_app->mt_uri . '?__mode=view&amp;_type=entry&amp;id=' . $blog_entry->id . '&amp;blog_id=' . $blog_id . '">' . $blog_entry->title . '</a>');
        $app->content_like(
            qr/$a_rainy_day/,
            'Search results have "A Rainy Day" entry by admin'
        );

        $app->login($aikawa);
        $app->get_ok({
            __mode  => 'search_replace',
            blog_id => $website->id,
        });
        $app->search('Day');
        $app->content_like(
            qr/$a_sunny_day/,
            'Search results have "A Sunny Day" entry by permitted user in a site'
        );
        $app->content_unlike(
            qr/$a_rainy_day/,
            'Search results do not have "A Rainy Day" entry by permitted user in a site'
        );

        $app->login($ichikawa);
        $app->get_ok({
            __mode  => 'search_replace',
            blog_id => $blog_id,
        });
        $app->search('Day');
        $app->content_unlike(
            qr/$a_sunny_day/,
            'Search results do not have "A Sunny Day" entry by permitted user in a child site'
        );
        $app->content_like(
            qr/$a_rainy_day/,
            'Search results have "A Rainy Day" entry by permitted user in a child site'
        );

        $app->login($ukawa);
        $app->get_ok({
            __mode  => 'search_replace',
            blog_id => $blog_id,
        });
        $app->search('Day');
        $app->has_permission_error();
    };
};

done_testing();
