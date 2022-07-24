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

subtest search => sub {
    subtest basic => sub {
        my $app = MT::Test::App->new('MT::App::CMS');
        $app->login($admin);
        $app->get_ok({__mode  => 'search_replace', blog_id => $blog_id});

        $app->search($entries{1}->title);
        is_deeply($app->found_ids, [$entries{1}->id], 'basic');

        $app->search('Verse');
        is_deeply($app->found_titles, ['Verse 5', 'Verse 4', 'Verse 3', 'Verse 2', 'Verse 1'], 'basic 2');
    };

    subtest 'with daterange' => sub {
        my ($entry1, $entry2) = map {
            my $date      = $_;
            my $timestamp = $date;
            $timestamp =~ s{[^\d]}{}g;
            MT::Test::Permission->make_entry(
                blog_id     => $website->id,
                author_id   => $admin->id,
                authored_on => $timestamp,
                title       => 'daterangetest-' . $date,
            );
        } ('2017-05-30 16:36:00', '2017-06-01 23:23:23');

        my $app = MT::Test::App->new('MT::App::CMS');
        $app->login($admin);
        $app->get_ok({ __mode => 'search_replace', blog_id => $website->id });

        require JSON;
        my $json = JSON->new;

        my $test = sub {
            my ($from, $to, $expected, $skip) = @_;
            subtest $json->encode([$from, $to]) => sub {
                plan skip_all => 'XXX ' . $skip if $skip;
                $app->search('daterangetest-', { is_dateranged => 1, from => $from, to => $to });
                is_deeply($app->found_titles, [map { $_->title } @$expected]);
            };
        };

        # --[Date1]--[entry1]--[Date2]--[entry2]--
        my $date1 = '2017-05-29';
        my $date2 = '2017-05-31';

        #       from,   to,     expected,           skip
        $test->($date1, $date2, [$entry1]);
        $test->($date2, $date1, [$entry1]);
        $test->('',     '',     [$entry2, $entry1], 'imcomplete-daterange');
        $test->($date1, '',     [$entry2, $entry1], 'imcomplete-daterange');
        $test->('',     $date1, [],                 'imcomplete-daterange');
        $test->('',     $date2, [$entry1],          'imcomplete-daterange');
        $test->($date2, '',     [$entry2],          'imcomplete-daterange');

        $_->remove for ($entry1, $entry2);
    };
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
        __mode  => 'search_replace',
        blog_id => $website->id,
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
        __mode  => 'search_replace',
        blog_id => $website->id,
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

subtest 'replace' => sub {

    my @entries;
    for my $num (1 .. 3) {
        push @entries, MT::Test::Permission->make_entry(
            blog_id   => $website->id,
            author_id => $admin->id,
            title     => "ReplaceTest $num",
            text      => "ReplaceTest $num text",
            basename  => "ReplaceTest $num basename",
        );
    }
    my @entry_ids = map { $_->id } @entries;

    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);

    subtest 'basic' => sub {
        $app->get_ok({ __mode => 'search_replace', blog_id => $website->id });

        $app->search('ReplaceTest');
        is_deeply($app->found_ids, [@entry_ids[0, 1, 2]], 'found all');
        $app->replace('ReplaceTest-mod', [@entry_ids[0, 1]]);
        is_deeply($app->found_ids, [@entry_ids[1, 0]], 'selected ones are replaced');
        is_deeply($app->found_titles, ['ReplaceTest-mod 2', 'ReplaceTest-mod 1',], 'selected ones are replaced');

        my @reloaded = MT::Entry->load({ id => \@entry_ids });
        is($reloaded[0]->text,     'ReplaceTest-mod 1 text', 'replaced');
        is($reloaded[1]->text,     'ReplaceTest-mod 2 text', 'replaced');
        is($reloaded[2]->text,     'ReplaceTest 3 text',     'unchecked one is not replaced');
        is($reloaded[0]->basename, 'ReplaceTest 1 basename', 'basename is not replaced');
        is($reloaded[1]->basename, 'ReplaceTest 2 basename', 'basename is not replaced');
        is($reloaded[2]->basename, 'ReplaceTest 3 basename', 'basename is not replaced');
    };

    subtest 'is_limited' => sub {
        $app->get_ok({ __mode => 'search_replace', blog_id => $website->id });

        $app->search('ReplaceTest', { is_limited => 1, search_cols => ['text'] });
        is_deeply($app->found_ids, [@entry_ids[0, 1, 2]], 'found all');
        $app->replace('ReplaceTest-mod', [@entry_ids[0, 1]]);
        is_deeply($app->found_ids, [@entry_ids[1, 0]], 'selected ones are replaced');
        is_deeply($app->found_titles, ['ReplaceTest-mod 2', 'ReplaceTest-mod 1',], 'selected ones are replaced');

        my @reloaded = MT::Entry->load({ id => \@entry_ids });
        is($reloaded[0]->text, 'ReplaceTest-mod-mod 1 text', 'replaced');
        is($reloaded[1]->text, 'ReplaceTest-mod-mod 2 text', 'replaced');
        is($reloaded[2]->text, 'ReplaceTest 3 text',         'unchecked one is not replaced');
    };

    $_->remove for @entries;
};

done_testing();
