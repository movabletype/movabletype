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
    my $egawa = MT::Test::Permission->make_author(
        name     => 'egawa',
        nickname => 'Shiro Egawa',
    );
    my $admin = MT::Author->load(1);

    my $website = MT::Website->load(2);
    my $website1 = MT::Test::Permission->make_website(name => 'Website Search Test1');
    my $website2 = MT::Test::Permission->make_website(name => 'Website Search Test2');
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
    MT::Association->link($ichikawa, $edit_all_posts, $website1);
    MT::Association->link($ichikawa, $edit_all_posts, $website2);
    MT::Association->link($ukawa,    $designer,       $website);
    MT::Association->link($egawa,    $edit_all_posts, $website2);

    $ichikawa->can_edit_templates(1);
    $ichikawa->save;

    my $blog_1 = MT::Blog->load(1);
    MT::Association->link($egawa, $designer, $blog_1);
    $egawa->can_edit_templates(1);
    $egawa->can_manage_users_groups(1);
    $egawa->save;
});

my $aikawa   = MT::Author->load({ name => 'aikawa' });
my $ichikawa = MT::Author->load({ name => 'ichikawa' });
my $ukawa    = MT::Author->load({ name => 'ukawa' });
my $egawa    = MT::Author->load({ name => 'egawa' });
my $website  = MT::Website->load(2);
my $blog     = $website->blogs->[0];
my $admin    = MT::Author->load(1);
my $blog_id  = $blog->id;

my $website_entry = MT::Entry->load({ title => 'A Sunny Day' });

my %entries = ();
for my $e (MT::Entry->load) {
    $entries{ $e->id } = $e;
}

subtest 'unit test for iter_for_replace' => sub {
    my @entries = MT::Entry->load();
    my @ids     = map { $_->id } @entries;
    require MT::CMS::Search;

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

    require MT::CMS::Search;

    for my $limit (1, 2, 125) {
        MT->config('CMSSearchLimit', $limit);

        subtest 'get all' => sub {
            my @entries  = MT::Entry->load();
            my @expected = map { $_->id } @entries;
            my $iter     = MT::CMS::Search::incremental_iter('MT::Entry', {}, {});
            my @got;
            while (my $obj = $iter->()) {
                push @got, $obj->id;
            }
            is_deeply(\@got, \@expected);
        };

        subtest 'get with term' => sub {
            my $terms    = { title => ['Verse 2', 'Verse 3'] };
            my @entries  = MT::Entry->load($terms);
            my @expected = map { $_->id } @entries;
            my $iter     = MT::CMS::Search::incremental_iter('MT::Entry', $terms, {});
            my @got;
            while (my $obj = $iter->()) {
                push @got, $obj->id;
            }
            is_deeply(\@got, \@expected);
        };

        subtest 'multiple classes at once' => sub {
            my @class1  = MT::Entry->load();
            my @class2  = MT::Author->load();
            my @expected1 = map { $_->id } @class1;
            my @expected2 = map { $_->id } @class2;
            my $iter1 = MT::CMS::Search::incremental_iter('MT::Entry', {}, {});
            my $iter2 = MT::CMS::Search::incremental_iter('MT::Author', {}, {});
            my (@got1, @got2);
            while (my ($obj1, $obj2) = ($iter1->(), $iter2->())) {
                push @got1, $obj1->id if $obj1;
                push @got2, $obj2->id if $obj2;
            }
            is_deeply(\@got1, \@expected1);
            is_deeply(\@got2, \@expected2);
        };
    }

    subtest 'useless last query is prevented' => sub {
        require Test::MockModule;
        my $mock = Test::MockModule->new('MT::Object');
        my $query_count;
        $mock->redefine('load_iter', sub { $query_count++; $mock->original('load_iter')->(@_) });

        my @entries  = MT::Entry->load();
        my @expected = map { $_->id } @entries;
        is scalar(@expected), 9, '9 entries are existing';

        my $iter;

        $query_count = 0;
        MT->config('CMSSearchLimit', 12);    # records are not divided
        $iter = MT::CMS::Search::incremental_iter('MT::Entry', {}, {});
        while ($iter->()) { }
        is $query_count, 1, 'no useless last query';

        $query_count = 0;
        MT->config('CMSSearchLimit', 4);    # records are divided into 4, 4, 1
        $iter = MT::CMS::Search::incremental_iter('MT::Entry', {}, {});
        while ($iter->()) { }
        is $query_count, 3, 'no useless last query';

        $query_count = 0;
        MT->config('CMSSearchLimit', 3);    # records are divided into 3, 3, 3, 0
        $iter = MT::CMS::Search::incremental_iter('MT::Entry', {}, {});
        while ($iter->()) { }
        is $query_count, 4, 'no useless last query';

        $query_count = 0;
        MT->config('CMSSearchLimit', 12);    # records are not divided
        $iter = MT::CMS::Search::incremental_iter('MT::Entry', { title => ['NOT EXIST'] }, {});
        while ($iter->()) { }
        is $query_count, 1, 'no useless last query';
    };

    subtest 'with do_search_replace mock' => sub {

        my $terms = { title => ['Verse 1', 'Verse 2', 'Verse 3', 'Verse 4', 'Verse 5'] };
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

    subtest 'regex search for asset on system context by non-superuser (MTC-30084)' => sub {

        MT::Test::Permission->make_asset(class => 'image', blog_id => 1, file_name => 'MTC30084-1.jpg', label => 'MTC30084-1');
        MT::Test::Permission->make_asset(class => 'image', blog_id => 1, file_name => 'MTC30084-2.jpg', label => 'MTC30084-2');
        MT::Test::Permission->make_asset(class => 'image', blog_id => 1, file_name => 'MTC30084-3.jpg', label => 'MTC30084-3');

        my $app = MT::Test::App->new('MT::App::CMS');
        $app->login($egawa);
        $app->get_ok({__mode  => 'search_replace'});
        $app->change_tab('asset');

        $app->search('MTC30084-3');
        is_deeply($app->found_titles, ['MTC30084-3'], 'without regex');

        $app->search('MTC30084-[12]', {is_regex => 1});
        is_deeply($app->found_titles, ['MTC30084-1', 'MTC30084-2'], 'with regex');
    };

    subtest 'regex search for author on system context by non-superuser (MTC-30084)' => sub {
        my $app = MT::Test::App->new('MT::App::CMS');
        $app->login($egawa);
        $app->get_ok({__mode  => 'search_replace'});
        $app->change_tab('author');

        $app->search('ichikawa');
        is_deeply($app->found_titles, ['ichikawa'], 'without regex');

        $app->search('.+kawa', {is_regex => 1});
        is_deeply($app->found_titles, ['ukawa', 'ichikawa', 'aikawa'], 'with regex');
    };

    subtest 'regex search for website on system context by non-superuser (MTC-30084)' => sub {
        my $app = MT::Test::App->new('MT::App::CMS');
        $app->login($ichikawa);
        $app->get_ok({__mode  => 'search_replace'});
        $app->change_tab('website');

        $app->search('Website Search Test');
        is_deeply($app->found_titles, ['Website Search Test2', 'Website Search Test1'], 'without regex');

        $app->search('Website Search Test[12]', {is_regex => 1});
        is_deeply($app->found_titles, ['Website Search Test2', 'Website Search Test1'], 'with regex');

        $app->search('Website Search Test[1]', {is_regex => 1});
        is_deeply($app->found_titles, ['Website Search Test1'], 'less result');
    };

    subtest 'limit' => sub {
        my $cms_search_limit_org = MT->config('CMSSearchLimit');
        $test_env->update_config(CMSSearchLimit => 3);

        my $app = MT::Test::App->new('MT::App::CMS');
        $app->login($admin);
        $app->get_ok({ __mode => 'search_replace', blog_id => $blog_id });

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

        $app->get_ok({ __mode => 'search_replace', blog_id => $blog_id });

        subtest 'regex search does not miss old entries' => sub {
            $app->search('Verse 1', { is_regex => 1 });
            is_deeply($app->found_titles, ['Verse 1']);
            ok !$app->have_more_link_exists;
        };

        $test_env->update_config(CMSSearchLimit => $cms_search_limit_org);
    };

    subtest 'with daterange' => sub {
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
                blog_id     => $website->id,
                author_id   => $admin->id,
                authored_on => $timestamp,
                created_on  => '20300101232323',
                modified_on => '20300101232323',
                title       => 'daterangetest-' . $date,
            );
            ($date => $entry);
        } List::Util::shuffle @dates;

        my $app = MT::Test::App->new('MT::App::CMS');
        $app->login($admin);
        $app->get_ok({ __mode => 'search_replace', blog_id => $website->id });

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

        $_->remove for values %entries;
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
    my $app       = MT::Test::App->new('MT::App::CMS');
    my $entry_id1 = 1;

    subtest 'search admin' => sub {
        $app->login($admin);
        $app->get_ok({ __mode => 'search_replace', blog_id => $website->id });
        $app->search('Day');
        is_deeply($app->found_ids, [$entry_id1, $website_entry->id], 'id found');
        is_deeply($app->found_titles, ['A Rainy Day', 'A Sunny Day'], 'titles found');
    };

    subtest 'search site editr' => sub {
        $app->login($aikawa);
        $app->get_ok({ __mode => 'search_replace', blog_id => $website->id });
        $app->search('Day');
        is_deeply($app->found_ids,    [$website_entry->id], 'id found');
        is_deeply($app->found_titles, ['A Sunny Day'],      'titles found');
    };

    subtest 'search by child site editor' => sub {
        $app->login($ichikawa);
        $app->get_ok({ __mode => 'search_replace', blog_id => $blog_id });
        $app->search('Day');
        is_deeply($app->found_ids,    [$entry_id1],    'id found');
        is_deeply($app->found_titles, ['A Rainy Day'], 'titles found');
    };

    subtest 'search by site designer' => sub {
        $app->login($ukawa);
        $app->get_ok({ __mode => 'search_replace', blog_id => $blog_id });
        $app->search('Day');
        $app->has_permission_error();
    };
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

        my $rev = MT->model('entry:revision')->load({ 'entry_id' => $reloaded[0]->id });
        is($rev->description, q{Searched for: 'ReplaceTest' Replaced with: 'ReplaceTest-mod'}, 'right revision note');
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

    subtest 'handwritten change_note' => sub {
        $app->get_ok({ __mode => 'search_replace', blog_id => $website->id });

        $app->search('ReplaceTest');
        is_deeply($app->found_ids, [@entry_ids[0, 1, 2]], 'found all');
        $app->replace('ReplaceTest-mod', [$entry_ids[0]], { change_note => 'Foo bar baz' });
        is_deeply($app->found_ids,    [$entry_ids[0]],           'selected ones are replaced');
        is_deeply($app->found_titles, ['ReplaceTest-mod-mod 1'], 'selected ones are replaced');
        note $app->{cgi}->query_string;

        my $rev = MT->model('entry:revision')->load(
            { 'entry_id' => $entry_ids[0] },
            { sort => 'id', direction => 'descend', limit => 1 });
        is($rev->description, 'Foo bar baz', 'right revision note');
    };

    $_->remove for @entries;
};

subtest 'multiple site search' => sub {

    my $newblog = MT::Test::Permission->make_blog(parent_id => $website->id);

    my $ogawa          = MT::Test::Permission->make_author(name => 'ogawa', nickname => 'Shiro Ogawa');
    my $edit_all_posts = MT::Test::Permission->make_role(name => 'Edit All Posts', permissions => "'edit_all_posts'");
    MT::Association->link($ogawa, $edit_all_posts, $website);
    MT::Association->link($ogawa, $edit_all_posts, $blog);
    my $perm = $ogawa->permissions(0);
    $perm->add_permissions(MT::Test::Permission->make_role(name => 'Designer'));
    $perm->save;

    my @entries;
    for my $site ($website, $blog, $newblog) {
        push @entries, MT::Test::Permission->make_entry(
            blog_id   => $site->id,
            author_id => $admin->id,
            title     => "system-search-test",
            text      => "text",
            basename  => "basename",
        );
    }

    subtest 'Search in system scope by non super user' => sub {

        my $app = MT::Test::App->new('MT::App::CMS');
        $app->login($ogawa);
        $app->get_ok({
            __mode  => 'search_replace',
            blog_id => 0,
        });
        $app->search('system-search-test');
        is_deeply($app->found_site_ids, [$website->id, $blog->id], 'found from multiple sites');
    };

    subtest 'Super user recursive search without administer_site permission for child' => sub {

        my $app = MT::Test::App->new('MT::App::CMS');
        $app->login($admin);
        $app->get_ok({
            __mode  => 'search_replace',
            blog_id => $website->id,
        });
        $app->search('system-search-test');
        is_deeply(
            $app->found_site_ids, [$website->id, $blog->id, $newblog->id],
            'found child site without administer_site permission'
        );
    };

    $_->remove for @entries, $newblog;
};

done_testing();
