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
use Test::Deep 'cmp_bag';

$test_env->prepare_fixture('db');

my $admin = MT::Author->load(1);

subtest 'unit test for iters' => sub {
    my $site = MT::Test::Permission->make_website(name => 'iter_for_replace');
    my @ids;
    for (1 .. 14) {
        my $entry = MT::Test::Permission->make_entry(blog_id => $site->id, title => 'Verse ' . $_);
        push @ids, $entry->id;
    }
    my $entry_not_interested = MT::Test::Permission->make_entry(blog_id => $site->id, title => 'NOT INTERESTED');
    push @ids, $entry_not_interested->id;

    require MT::CMS::Search;

    subtest 'unit test for iter_for_replace' => sub {
        for my $capa (1, 2, scalar(@ids) - 1, scalar(@ids) + 1) {
            MT->config('BulkLoadMetaObjectsLimit', $capa);
            subtest 'capacity is ' . $capa => sub {
                my $iter = MT::CMS::Search::iter_for_replace(MT->model('entry'), [@ids]);
                my @got;
                while (my $obj = $iter->()) {
                    push @got, $obj->id;
                }
                is_deeply(\@got, [reverse(@ids)], 'all ids included');
            }
        }
    };

    subtest 'unit test for incremental_iter' => sub {
        my $cms_search_limit_org = MT->config('CMSSearchLimit');
        for my $limit (1, 2, 125) {
            MT->config('CMSSearchLimit', $limit);

            subtest 'get all' => sub {
                my $iter = MT::CMS::Search::incremental_iter('MT::Entry', { blog_id => $site->id }, {});
                my @got;
                while (my $obj = $iter->()) {
                    push @got, $obj->id;
                }
                is_deeply(\@got, \@ids);
            };

            subtest 'get with term' => sub {
                my $terms    = { blog_id => $site->id, title => ['Verse 2', 'Verse 3'] };
                my @entries  = MT::Entry->load($terms);
                my @expected = map { $_->id } @entries;
                my $iter     = MT::CMS::Search::incremental_iter('MT::Entry', $terms, {});
                my @got;
                while (my $obj = $iter->()) {
                    push @got, $obj->id;
                }
                is_deeply(\@got, \@expected);
            };

            subtest 'multiple iters called alternately' => sub {
                my @class1    = MT::Entry->load();
                my @class2    = MT::Author->load();
                my @expected1 = map { $_->id } @class1;
                my @expected2 = map { $_->id } @class2;
                my $iter1     = MT::CMS::Search::incremental_iter('MT::Entry',  {}, {});
                my $iter2     = MT::CMS::Search::incremental_iter('MT::Author', {}, {});
                my (@got1, @got2);
                push @got1, $iter1->()->id;
                push @got2, $iter2->()->id;

                while (my $obj1 = $iter1->()) {
                    push @got1, $obj1->id if $obj1;
                }
                while (my $obj2 = $iter2->()) {
                    push @got2, $obj2->id if $obj2;
                }
                is_deeply(\@got1, \@expected1);
                is_deeply(\@got2, \@expected2);
            };
        }

        subtest 'iter shuts down after right number of excutions' => sub {
            require Test::MockModule;
            my $mock = Test::MockModule->new('MT::Object');
            my $query_count;
            $mock->redefine('load_iter', sub { $query_count++; $mock->original('load_iter')->(@_) });

            my @entries  = MT::Entry->load({ blog_id => $site->id });
            my @expected = map { $_->id } @entries;
            is scalar(@expected), 15, '15 entries found';

            my $iter;

            $query_count = 0;
            MT->config('CMSSearchLimit', 16);
            $iter = MT::CMS::Search::incremental_iter('MT::Entry', { blog_id => $site->id }, {});
            while ($iter->()) { }
            is $query_count, 1, 'right number of occurance';

            $query_count = 0;
            MT->config('CMSSearchLimit', 6);
            $iter = MT::CMS::Search::incremental_iter('MT::Entry', { blog_id => $site->id }, {});
            while ($iter->()) { }
            is $query_count, 3, 'right number of occurance';

            $query_count = 0;
            MT->config('CMSSearchLimit', 5);
            $iter = MT::CMS::Search::incremental_iter('MT::Entry', { blog_id => $site->id }, {});
            while ($iter->()) { }
            # last query returns 0 results and iter considers it as the end of search
            is $query_count, 4, 'right number of occurance';

            $query_count = 0;
            MT->config('CMSSearchLimit', 12);
            $iter = MT::CMS::Search::incremental_iter(
                'MT::Entry',
                { blog_id => $site->id, title => ['NOT EXIST'] }, {});
            while ($iter->()) { }
            is $query_count, 1, 'right number of occurance';
        };

        subtest 'with do_search_replace mock' => sub {

            my $terms = {
                blog_id => $site->id,
                title   => ['Verse 1', 'Verse 2', 'Verse 3', 'Verse 4', 'Verse 5'],
            };
            my $handler;
            my $limit = 2;
            MT->config('CMSSearchLimit', $limit);

            my $mock = sub {
                my $iter = MT::CMS::Search::incremental_iter('MT::Entry', $terms, {});
                my @got;
                while (my $obj = $iter->()) {
                    push @got, $obj->title if $handler->($obj);
                    if (@got > $limit) {
                        pop @got;
                        last;
                    }
                }
                return \@got;
            };

            subtest 'normal' => sub {
                $handler = sub { 1 };
                is_deeply($mock->(), ['Verse 1', 'Verse 2']);
            };

            subtest 'reduce by search_handler' => sub {
                $handler = sub { $_[0]->title !~ /Verse 2/ };
                is_deeply($mock->(), ['Verse 1', 'Verse 3']);
                $handler = sub { $_[0]->title !~ /Verse 1/ };
                is_deeply($mock->(), ['Verse 2', 'Verse 3']);
                $handler = sub { $_[0]->title !~ /Verse (1|2)/ };
                is_deeply($mock->(), ['Verse 3', 'Verse 4']);
                $handler = sub { $_[0]->title !~ /Verse (1|2|3)/ };
                is_deeply($mock->(), ['Verse 4', 'Verse 5']);
                $handler = sub { $_[0]->title !~ /Verse (1|2|3|4)/ };
                is_deeply($mock->(), ['Verse 5']);
                $handler = sub { $_[0]->title !~ /Verse (2|3|4|5)/ };
                is_deeply($mock->(), ['Verse 1']);
            };
        };

        MT->config('CMSSearchLimit', $cms_search_limit_org);
    };

    $site->remove;
};

subtest 'buttons' => sub {
    my $app = MT::Test::App->new;
    $app->login($admin);

    my $site  = MT::Test::Permission->make_blog();
    my $entry = MT::Test::Permission->make_entry(blog_id => $site->id, title => 'rain');

    subtest 'global context' => sub {
        $app->get_ok({ __mode => 'search_replace' });

        subtest 'template' => sub {
            $app->change_tab('template');
            $app->search('movable');
            $app->content_unlike(
                qr/Publish selected templates/i,
                "Publish templates button isn't present for global template search"
            );
            $app->content_like(qr/Delete selected templates/i, "Delete templates button is present");
            $app->content_like(qr/Refresh template\(s\)/i,     "Refresh templates dropdown is present");
            $app->content_like(qr/Clone template\(s\)/i,       "Clone templates dropdown is present");
        };

        subtest 'entry' => sub {
            $app->change_tab('entry');
            $app->search('rain');
            $app->content_like(qr/Republish selected entries/i, "Publish entries button is present");
            $app->content_like(qr/Delete selected entries/i,    "Delete entries button is present");
            $app->content_like(qr/Add tags/i,                   "Add tags dropdown is present");
            $app->content_like(qr/Remove tags/i,                "Remove tags dropdown is present");
        };

        subtest 'comment' => sub {
            $test_env->skip_unless_plugin_exists('Comments');
            $app->change_tab('comment');
            $app->search('comment');
        };

        subtest 'group' => sub {
            my $group = new MT::Group;
            $group->name('Test Group');
            $group->save;
            $app->change_tab('group');
            $app->search('Test Group');
            $app->content_like(qr/Test Group/i, "Test group is present");
            $group->remove;
        };
    };

    subtest 'blog context' => sub {
        $app->get_ok({ __mode => 'search_replace', blog_id => $site->id });

        subtest 'template' => sub {
            $app->change_tab('template');
            $app->search('index');
            $app->content_like(qr/Publish selected templates/i, "Publish templates button is present");
            $app->content_like(qr/Delete selected templates/i,  "Delete templates button is present");
            $app->content_like(qr/Refresh template\(s\)/i,      "Refresh templates dropdown is present");
            $app->content_like(qr/Clone template\(s\)/i,        "Clone templates dropdown is present");
        };

        subtest 'entry' => sub {
            $app->change_tab('entry');
            $app->search('rain');
            $app->content_like(qr/Republish selected entries/i, "Publish entries button is present");
            $app->content_like(qr/Delete selected entries/i,    "Delete entries button is present");
            $app->content_like(qr/Unpublish entries/i,          "Unpublish entries dropdown is present");
            $app->content_like(qr/Add tags/i,                   "Add tags dropdown is present");
            $app->content_like(qr/Remove tags/i,                "Remove tags dropdown is present");
            $app->content_like(qr/Batch edit entries/i,         "Batch edit entries dropdown is present");
        };

        subtest 'comment' => sub {
            $app->change_tab('comment');
            $app->search('comment');
        };
    };

    $site->remove;
};

subtest 'system context by non-superuser (MTC-30084)' => sub {
    plan skip_all => 'skip for now (MTC-29012)' if MT->config->DisableRegexpSearch;

    my $aikawa   = MT::Test::Permission->make_author(name => 'aikawa',   nickname => 'Ichiro Aikawa');
    my $ichikawa = MT::Test::Permission->make_author(name => 'ichikawa', nickname => 'Jiro Ichikawa');
    my $ukawa    = MT::Test::Permission->make_author(name => 'ukawa',    nickname => 'Saburo Ukawa');
    my $egawa    = MT::Test::Permission->make_author(name => 'egawa',    nickname => 'Shiro Egawa');

    my $site     = MT::Test::Permission->make_website(name => 'My Site');
    my $blog     = MT::Test::Permission->make_blog(parent_id => $site->id);
    my $website1 = MT::Test::Permission->make_website(name => 'Website Search Test1');
    my $website2 = MT::Test::Permission->make_website(name => 'Website Search Test2');

    my $edit_all_posts = MT::Test::Permission->make_role(name => 'Edit All Posts', permissions => "'edit_all_posts'");
    my $designer       = MT::Role->load({ name => MT->translate('Designer') });

    require MT::Association;
    MT::Association->link($aikawa,   $edit_all_posts, $site);
    MT::Association->link($ichikawa, $edit_all_posts, $site->blogs->[0]);
    MT::Association->link($ichikawa, $edit_all_posts, $website1);
    MT::Association->link($ichikawa, $edit_all_posts, $website2);
    MT::Association->link($ukawa,    $designer,       $site);
    MT::Association->link($egawa,    $edit_all_posts, $website2);

    $ichikawa->can_edit_templates($site->id);
    $ichikawa->save;

    my $blog_1 = MT::Blog->load($site->id);
    MT::Association->link($egawa, $designer, $blog_1);
    $egawa->can_edit_templates($site->id);
    $egawa->can_manage_users_groups($site->id);
    $egawa->save;

    subtest 'regex search for asset' => sub {
        MT::Test::Permission->make_asset(class => 'image', blog_id => $site->id, file_name => 'MTC30084-1.jpg', label => 'MTC30084-1');
        MT::Test::Permission->make_asset(class => 'image', blog_id => $site->id, file_name => 'MTC30084-2.jpg', label => 'MTC30084-2');
        MT::Test::Permission->make_asset(class => 'image', blog_id => $site->id, file_name => 'MTC30084-3.jpg', label => 'MTC30084-3');

        my $app = MT::Test::App->new;
        $app->login($egawa);
        $app->get_ok({ __mode => 'search_replace' });
        $app->change_tab('asset');
        $app->search('MTC30084-3');
        is_deeply($app->found_titles, ['MTC30084-3'], 'without regex');

        $app->search('MTC30084-[12]', { is_regex => 1 });
        is_deeply($app->found_titles, ['MTC30084-1', 'MTC30084-2'], 'with regex');
    };

    subtest 'regex search for author' => sub {
        my $app = MT::Test::App->new;
        $app->login($egawa);
        $app->get_ok({ __mode => 'search_replace' });
        $app->change_tab('author');
        $app->search('ichikawa');
        is_deeply($app->found_titles, ['ichikawa'], 'without regex');

        $app->search('.+kawa', { is_regex => 1 });
        is_deeply($app->found_titles, ['ukawa', 'ichikawa', 'aikawa'], 'with regex');
    };

    subtest 'regex search for website' => sub {
        my $app = MT::Test::App->new;
        $app->login($ichikawa);
        $app->get_ok({ __mode => 'search_replace' });
        $app->change_tab('website');
        $app->search('Website Search Test');
        is_deeply($app->found_titles, ['Website Search Test2', 'Website Search Test1'], 'without regex');

        $app->search('Website Search Test[12]', { is_regex => 1 });
        is_deeply($app->found_titles, ['Website Search Test2', 'Website Search Test1'], 'with regex');

        $app->search('Website Search Test[1]', { is_regex => 1 });
        is_deeply($app->found_titles, ['Website Search Test1'], 'less result');
    };

    $_->remove for $aikawa, $ichikawa, $ukawa, $egawa, $site, $blog, $website1, $website2, $edit_all_posts, $designer;
};

subtest 'basic search' => sub {

    my $site      = MT::Test::Permission->make_website;
    my $timestamp = '20250615000000';                     # 2025-06-15 00:00:00
    for my $num (1 .. 5) {
        MT::Test::Permission->make_entry(
            blog_id     => $site->id,
            author_id   => $admin->id,
            title       => 'Verse ' . $num,
            authored_on => $timestamp++,
        );
    }
    MT::Test::Permission->make_entry(blog_id => $site->id, author_id => $admin->id, title => 'NOT INTERESTED');

    my $app = MT::Test::App->new;
    $app->login($admin);
    $app->get_ok({ __mode => 'search_replace', blog_id => $site->id });
    $app->change_tab('entry');

    subtest 'all' => sub {
        $app->search('Verse');
        is_deeply($app->found_titles, ['Verse 5', 'Verse 4', 'Verse 3', 'Verse 2', 'Verse 1'], 'basic 2');
    };

    subtest 'limit' => sub {
        my $cms_search_limit_org = MT->config('CMSSearchLimit');
        $test_env->update_config(CMSSearchLimit => 3);

        my $app = MT::Test::App->new;
        $app->login($admin);
        $app->get_ok({ __mode => 'search_replace', blog_id => $site->id });
        $app->change_tab('entry');
        subtest 'first search' => sub {
            $app->search('Verse');
            is_deeply($app->found_titles, ['Verse 5', 'Verse 4', 'Verse 3']);
            ok $app->have_more_link_exists;
        };

        subtest 'click "Show all matches"' => sub {
            $app->search('Verse', { limit => 'all' });
            is_deeply($app->found_titles, ['Verse 5', 'Verse 4', 'Verse 3', 'Verse 2', 'Verse 1']);
            ok !$app->have_more_link_exists;
        };

        $app->get_ok({ __mode => 'search_replace', blog_id => $site->id });
        $app->change_tab('entry');
        subtest 'regex search does not miss old entries' => sub {
            $app->search('Verse 1', { is_regex => 1 });
            is_deeply($app->found_titles, ['Verse 1']);
            ok !$app->have_more_link_exists;
        };

        $test_env->update_config(CMSSearchLimit => $cms_search_limit_org);
    };

    $site->remove;
};

subtest 'with daterange' => sub {
    my $site1 = MT::Test::Permission->make_website(name => 'replace_test');

    my @dates = (
        '2010-05-15 15:30:30',
        '2011-06-15 16:20:30',
        '2011-06-15 16:30:30',    # daterange1
        '2011-06-15 16:40:30',
        '2012-07-15 17:30:30',
        '2013-08-15 18:20:30',
        '2013-08-15 18:30:30',    # daterange2
        '2013-08-15 18:40:30',
        '2014-09-15 19:30:30',
    );
    my ($date2, $time2) = split(/ /, $dates[2]);
    my ($date6, $time6) = split(/ /, $dates[6]);
    my %entries = map {
        my $date      = $_;
        my $timestamp = $date;
        $timestamp =~ s{[^\d]}{}g;
        my $entry = MT::Test::Permission->make_entry(
            blog_id     => $site1->id,
            author_id   => $admin->id,
            authored_on => $timestamp,
            created_on  => '20300101232323',
            modified_on => '20300101232323',
            title       => 'daterangetest-' . $date,
        );
        ($date => $entry);
    } List::Util::shuffle @dates;

    my $app = MT::Test::App->new;
    $app->login($admin);
    $app->get_ok({ __mode => 'search_replace', blog_id => $site1->id });
    $app->change_tab('entry');

    my $search = sub {
        my ($from, $to) = @_;
        note join(', ', $from, $to);
        $app->search('daterangetest-', { is_dateranged => 1, from => $from, to => $to });
        return $app->found_titles;
    };
    my $date_id_to_title = sub {
        return [map { $_->title } @entries{ @dates[@_] }];
    };

    cmp_bag($search->($date2, $date6), $date_id_to_title->(1 .. 7), 'normal');
    cmp_bag($search->($date6, $date2), $date_id_to_title->(1 .. 7), 'negative range');

    subtest 'unset or half set daterange' => sub {
        plan skip_all => 'incomplete daterange';
        cmp_bag($search->('',     $date2), $date_id_to_title->(0 .. 3), 'to only');
        cmp_bag($search->($date2, ''),     $date_id_to_title->(1 .. 8), 'from only');
        cmp_bag($search->('',     $date6), $date_id_to_title->(0 .. 7), 'to only2');
        cmp_bag($search->($date6, ''),     $date_id_to_title->(5 .. 8), 'from only2');
        cmp_bag($search->('',     ''),     $date_id_to_title->(0 .. 8), 'no params');
    };

    $site1->remove;
};

subtest 'Column name in each scopes' => sub {

    my $no_results          = quotemeta('No entries were found that match the given criteria.');
    my $col_website_blog    = quotemeta('<span class="col-label">Website/Blog</span>');
    my $col_site_child_site = quotemeta('<span class="col-label">Site/Child Site</span>');

    my $parent = MT::Test::Permission->make_website(name => 'parent');
    my $child  = MT::Test::Permission->make_blog(name => 'child', parent_id => $parent->id);
    for my $site ($parent, $child) {
        MT::Test::Permission->make_entry(blog_id => $site->id, author_id => $admin->id, title => 'A Rainy Day');
        MT::Test::Permission->make_entry(blog_id => $site->id, author_id => $admin->id, title => 'A Sunny Day');
    }

    my $app = MT::Test::App->new;
    $app->login($admin);

    subtest 'child site scope' => sub {
        $app->get_ok({ __mode => 'search_replace', blog_id => $child->id });
        $app->change_tab('entry');
        $app->search('A Rainy Day');
        $app->content_unlike(qr/$no_results/,          'There are some search results.');
        $app->content_unlike(qr/$col_website_blog/,    'Does not have a colomn "Website/Blog" in child site scope');
        $app->content_unlike(qr/$col_site_child_site/, 'Does not have a column "Site/Child Site" in child site scope');
    };

    subtest 'site scope' => sub {
        $app->get_ok({ __mode => 'search_replace', blog_id => $parent->id });
        $app->change_tab('entry');
        $app->search('A Rainy Day');
        $app->content_unlike(qr/$no_results/,       'There are some search results.');
        $app->content_unlike(qr/$col_website_blog/, 'Does not have a colomn "Website/Blog" in site scope');
        $app->content_like(qr/$col_site_child_site/, 'Has a column "Site/Child Site" in site scope');
    };

    subtest 'system scope' => sub {
        $app->get_ok({ __mode => 'search_replace', blog_id => 0 });
        $app->change_tab('entry');
        $app->search('A Sunny Day');
        $app->content_unlike(qr/$no_results/,       'There are some search results.');
        $app->content_unlike(qr/$col_website_blog/, 'Does not have a colomn "Website/Blog" in system scope');
        $app->content_like(qr/$col_site_child_site/, 'Has a column "Site/Child Site" in system scope');
    };

    $_->remove for ($parent, $child);
};

subtest 'Search in site scope' => sub {
    my $site1  = MT::Test::Permission->make_website(name => 'replace_test');
    my $site2  = MT::Test::Permission->make_website(name => 'Website Search Test1');
    my $site3  = MT::Test::Permission->make_website(name => 'Website Search Test2');
    my $child1 = MT::Test::Permission->make_blog(parent_id => $site1->id);

    my $aikawa   = MT::Test::Permission->make_author(name => 'aikawa',   nickname => 'Ichiro Aikawa');
    my $ichikawa = MT::Test::Permission->make_author(name => 'ichikawa', nickname => 'Jiro Ichikawa');
    my $ukawa    = MT::Test::Permission->make_author(name => 'ukawa',    nickname => 'Saburo Ukawa');

    my $edit_all_posts = MT::Test::Permission->make_role(name => 'Edit All Posts', permissions => "'edit_all_posts'");
    my $designer       = MT::Role->load({ name => MT->translate('Designer') });

    require MT::Association;
    MT::Association->link($aikawa,   $edit_all_posts, $site1);
    MT::Association->link($ichikawa, $edit_all_posts, $site1->blogs->[0]);
    MT::Association->link($ichikawa, $edit_all_posts, $site2);
    MT::Association->link($ichikawa, $edit_all_posts, $site3);
    MT::Association->link($ukawa,    $designer,       $site1);

    my $timestamp = '20250615000000';    # 2025-06-15 00:00:00
    my $entry1    = MT::Test::Permission->make_entry(blog_id => $site1->id,  title => 'A Sunny Day', authored_on => $timestamp);
    my $entry2    = MT::Test::Permission->make_entry(blog_id => $child1->id, title => 'A Rainy Day', authored_on => $timestamp + 1);

    my $app = MT::Test::App->new;

    subtest 'search by admin' => sub {
        $app->login($admin);
        $app->get_ok({ __mode => 'search_replace', blog_id => $site1->id });
        $app->change_tab('entry');
        $app->search('Day');
        is_deeply($app->found_ids, [$entry2->id, $entry1->id], 'id found');
        is_deeply($app->found_titles, ['A Rainy Day', 'A Sunny Day'], 'titles found');
    };

    subtest 'search by site editor' => sub {
        $app->login($aikawa);
        $app->get_ok({ __mode => 'search_replace', blog_id => $site1->id });
        $app->change_tab('entry');
        $app->search('Day');
        is_deeply($app->found_ids,    [$entry1->id],   'id found');
        is_deeply($app->found_titles, ['A Sunny Day'], 'titles found');
    };

    subtest 'search by child site editor' => sub {
        $app->login($ichikawa);
        $app->get_ok({ __mode => 'search_replace', blog_id => $child1->id });
        $app->change_tab('entry');
        $app->search('Day');
        is_deeply($app->found_ids,    [$entry2->id],   'id found');
        is_deeply($app->found_titles, ['A Rainy Day'], 'titles found');
    };

    subtest 'search by site designer' => sub {
        $app->login($ukawa);
        $app->get_ok({ __mode => 'search_replace', blog_id => $child1->id });
        $app->change_tab('entry');
        $app->search('Day');
        $app->has_permission_error();
    };

    $_->remove for ($aikawa, $ichikawa, $ukawa, $entry1, $child1, $site1, $site2, $site3);
};

subtest 'replace' => sub {
    my $site = MT::Test::Permission->make_website(name => 'replace_test');

    my @entries;
    for my $num (1 .. 3) {
        push @entries, MT::Test::Permission->make_entry(
            blog_id   => $site->id,
            author_id => $admin->id,
            title     => "ReplaceTest $num",
            text      => "ReplaceTest $num text",
            basename  => "ReplaceTest $num basename",
        );
    }
    my @entry_ids = map { $_->id } @entries;

    my $app = MT::Test::App->new;
    $app->login($admin);

    subtest 'basic' => sub {
        $app->get_ok({ __mode => 'search_replace', blog_id => $site->id });
        $app->change_tab('entry');
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

        my $rev = MT->model('entry:revision')->load({ 'entry_id' => $reloaded[0]->id });
        is($rev->description, q{Searched for: 'ReplaceTest' Replaced with: 'ReplaceTest-mod'}, 'right revision note');
    };

    subtest 'is_limited' => sub {
        $app->get_ok({ __mode => 'search_replace', blog_id => $site->id });
        $app->change_tab('entry');
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

    subtest 'handwritten change_note' => sub {
        $app->get_ok({ __mode => 'search_replace', blog_id => $site->id });
        $app->change_tab('entry');
        $app->search('ReplaceTest');
        is_deeply($app->found_ids, [@entry_ids[0, 1, 2]], 'found all');
        $app->replace('ReplaceTest-mod', [$entry_ids[0]], { change_note => 'Foo bar baz' });
        is_deeply($app->found_ids,    [$entry_ids[0]],           'selected ones are replaced');
        is_deeply($app->found_titles, ['ReplaceTest-mod-mod 1'], 'selected ones are replaced');
        note $app->{cgi}->query_string;

        my $rev = MT->model('entry:revision')->load(
            { 'entry_id' => $entry_ids[0] },
            { sort       => 'id', direction => 'descend', limit => 1 });
        is($rev->description, 'Foo bar baz', 'right revision note');
    };

    $site->remove;
};

subtest 'pre-save on replace' => sub {
    my $site = MT::Test::Permission->make_website(name => 'template attributes');

    subtest 'template attributes' => sub {

        my %params_to_test = (
            include_with_ssi      => 1,
            cache_path            => '/path/to/cache',
            cache_expire_type     => 1,
            cache_expire_interval => 30,
            build_interval        => 60,
            build_type            => MT::PublishOption::SCHEDULED(),
        );
        my $org = MT::Test::Permission->make_template(
            blog_id => $site->id,
            name    => 'template to replace',
            text    => 'Text to replace',
            type    => 'module',
            outfile => '',
            %params_to_test,
        );

        my $tmpl_id = $org->id;

        my $app = MT::Test::App->new;
        $app->login($admin);
        $app->get_ok({ __mode => 'search_replace', blog_id => $site->id });
        $app->change_tab('template');
        $app->search('replace');

        ok grep({ $_ == $tmpl_id } @{ $app->found_ids }), 'tmpl id is included';

        $app->replace('replaced', [$tmpl_id]);

        # $test_env->clear_mt_cache;

        my $tmpl = MT->model('template')->load($tmpl_id);
        for my $key (keys %params_to_test) {
            is $tmpl->$key => $params_to_test{$key}, "$key is intact";
        }
    };

    subtest 'blog attributes' => sub {

        my %params_to_test = (
            sanitize_spec => 1,
        );
        my $blog = MT::Test::Permission->make_blog(
            parent_id => $site->id,
            name      => 'Site to replace',
            %params_to_test,
        );

        my $app = MT::Test::App->new;
        $app->login($admin);
        $app->get_ok({ __mode => 'search_replace', blog_id => $site->id });
        $app->change_tab('blog');
        $app->search('replace');

        ok grep({ $_ == $blog->id } @{ $app->found_ids }), 'tmpl id is included';

        $app->replace('replaced', [$blog->id]);

        # $test_env->clear_mt_cache;

        my $blog_reloaded = MT->model('blog')->load($blog->id);
        for my $key (keys %params_to_test) {
            is $blog_reloaded->$key => $params_to_test{$key}, "$key is intact";
        }
    };

    $site->remove;
};

subtest 'multiple site search with and without permissions' => sub {

    my $parent = MT::Test::Permission->make_website;
    my $child1 = MT::Test::Permission->make_blog(parent_id => $parent->id);
    my $child2 = MT::Test::Permission->make_blog(parent_id => $parent->id);

    my $ogawa          = MT::Test::Permission->make_author(name => 'ogawa', nickname => 'Shiro Ogawa');
    my $edit_all_posts = MT::Test::Permission->make_role(name => 'Edit All Posts', permissions => "'edit_all_posts'");
    MT::Association->link($ogawa, $edit_all_posts, $parent);
    MT::Association->link($ogawa, $edit_all_posts, $child1);
    $ogawa->can_edit_templates($parent->id);
    $ogawa->save;

    for my $site ($parent, $child1, $child2) {
        MT::Test::Permission->make_entry(
            blog_id   => $site->id,
            author_id => $admin->id,
            title     => "system-search-test",
            text      => "text",
            basename  => "basename",
        );
    }

    my $app = MT::Test::App->new;

    subtest 'Search in system scope by non super user' => sub {
        $app->login($ogawa);
        $app->get_ok({ __mode => 'search_replace', blog_id => 0 });
        $app->change_tab('entry');
        $app->search('system-search-test');
        is_deeply($app->found_site_ids, [$parent->id, $child1->id], 'found from multiple sites');
    };

    subtest 'Super user recursive search without administer_site permission for child' => sub {
        $app->login($admin);
        $app->get_ok({ __mode => 'search_replace', blog_id => $parent->id });
        $app->change_tab('entry');
        $app->search('system-search-test');
        is_deeply(
            $app->found_site_ids, [$parent->id, $child1->id, $child2->id],
            'found child site without administer_site permission'
        );
    };

    $_->remove for ($parent, $child1, $child2, $ogawa, $edit_all_posts);
};

subtest 'wildcards in like condition are escaped' => sub {
    my $site = MT::Test::Permission->make_website;

    my $limit_org = MT->config->CMSSearchLimit;
    $test_env->update_config('CMSSearchLimit', 1);

    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);

    my @cases = (
        { name => 'underscore (MTC-26724)', titles => ['__',     'test',  'test'] },
        { name => 'percent',                titles => ['100%',   '1000%', '1000%'] },
        { name => 'backslash',              titles => ['b100!%', 'a100%', 'a100%'] },
    );

    for my $case (@cases) {
        subtest $case->{name} => sub {
            my @titles = @{ $case->{titles} };
            for my $index (0 .. $#titles) {
                MT::Test::Permission->make_entry(
                    blog_id     => $site->id,
                    author_id   => $admin->id,
                    title       => $titles[$index],
                    authored_on => '20010101120001' + $index,
                );
            }
            $app->get_ok({ __mode => 'search_replace', blog_id => $site->id });
            $app->change_tab('entry');
            $app->search($titles[0], {});
            ok !$app->generic_error, 'no error';
            is_deeply($app->found_titles, [$titles[0]], 'first one is only found');
        };
    }

    $site->remove;

    $test_env->update_config('CMSSearchLimit', $limit_org);
};

subtest 'asset tab' => sub {
    my $site = MT::Test::Permission->make_website;
    for my $num (1 .. 3) {
        MT::Test::Permission->make_asset(
            class     => 'image',
            blog_id   => $site->id,
            file_name => $num . '.jpg',
            label     => 'Sample Image ' . $num,
        );
    }
    MT::Test::Permission->make_asset(class => 'image', blog_id => $site->id, file_name => 'a.jpg', label => 'NOT INTERESTED');

    my $app = MT::Test::App->new;
    $app->login($admin);
    $app->get_ok({ __mode => 'search_replace', blog_id => $site->id });
    $app->change_tab('asset');

    $app->search('Sample', { is_limited => 1, search_cols => 'label' });
    is_deeply($app->found_titles, ['Sample Image 1', 'Sample Image 2', 'Sample Image 3']);

    $site->remove;
};

subtest 'blog tab' => sub {
    my (@sites, @blogs);
    push @sites, MT::Test::Permission->make_website(name => 'search-test');
    for my $num (1 .. 3) {
        push @blogs, MT::Test::Permission->make_blog(parent_id => $sites[0]->id, name => 'search-test-' . $num);
    }
    push @blogs, MT::Test::Permission->make_blog(parent_id => $sites[0]->id, name => 'NOT INTERESTED');

    my $app = MT::Test::App->new;
    $app->login($admin);
    $app->get_ok({ __mode => 'search_replace', blog_id => $sites[0]->id });
    $app->change_tab('blog');

    $app->search('search-test', { is_limited => 1, search_cols => 'name' });
    is_deeply($app->found_titles, ['search-test-3', 'search-test-2', 'search-test-1']);    # TODO: Is this right order?

    $app->get_ok({ __mode => 'search_replace', blog_id => $blogs[1]->id });
    ok !$app->tab_exists('blog'), 'blog tab is not available';

    $_->remove for @sites, @blogs;
};

subtest 'website tab' => sub {
    my (@sites, @blogs);
    for my $num (1 .. 3) {
        push @sites, MT::Test::Permission->make_website(name => 'search-test-' . $num);
    }
    push @sites, MT::Test::Permission->make_website(name => 'NOT INTERESTED');
    push @blogs, MT::Test::Permission->make_blog(parent_id => $sites[0]->id, name => 'search-test-NOT INTERESTED');

    my $app = MT::Test::App->new;
    $app->login($admin);
    $app->get_ok({ __mode => 'search_replace', blog_id => 0 });
    ok $app->tab_exists('website'), 'blog tab is available';
    $app->change_tab('website');
    $app->search('search-test', { is_limited => 1, search_cols => 'name' });
    is_deeply($app->found_titles, ['search-test-3', 'search-test-2', 'search-test-1']);    # TODO: Is this right order?

    $_->remove for @sites, @blogs;
};

done_testing();
