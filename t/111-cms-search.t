#!/usr/bin/perl

use strict;
use warnings;

BEGIN {
    $ENV{MT_CONFIG} = 'mysql-test.cfg';
}

use lib 't/lib', 'lib', 'extlib';
use MT::Test qw( :app :db :data);
use MT::Test::Permission;
use Test::More;

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
for my $e ( MT::Entry->load ) {
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
my $designer = MT::Role->load( { name => MT->translate('Designer') } );

require MT::Association;
MT::Association->link( $aikawa,   $edit_all_posts, $website );
MT::Association->link( $ichikawa, $edit_all_posts, $blog->[0] );
MT::Association->link( $ukawa,    $designer,       $website );

subtest 'search_replace' => sub {
    my @suite = (
        {   params => {
                is_limited => 0,
                blog_id    => 1,
                do_search  => 1,
                search     => $entries{1}->title,
            },
            founds     => [1],
            not_founds => [2],
        },
        {   params => {
                _type      => 'entry',
                is_limited => 0,
                blog_id    => 1,
                do_search  => 1,
                search     => $entries{1}->title,
            },
            founds     => [1],
            not_founds => [2],
        },
    );

    foreach my $data (@suite) {
        my $params = $data->{params};
        my $query
            = join( '&', map { $_ . '=' . $params->{$_} } keys %$params );
        subtest $query => sub {
            my $app = _run_app(
                'MT::App::CMS',
                {   __test_user      => $admin,
                    __request_method => 'POST',
                    __mode           => 'search_replace',
                    %$params,
                }
            );
            my $out = delete $app->{__test_output};

            for my $id ( @{ $data->{founds} } ) {
                like( $out, qr/name="id" value="$id"/, "Entry#$id is found" );
            }
            for my $id ( @{ $data->{not_founds} } ) {
                unlike(
                    $out,
                    qr/name="id" value="$id"/,
                    "Entry#$id is not found"
                );
            }

            done_testing();
        };
    }

    subtest 'Column name in website scope' => sub {
        my $app = _run_app(
            'MT::App::CMS',
            {   __test_user      => $admin,
                __request_method => 'POST',
                __mode           => 'search_replace',
                _type            => 'entry',
                is_limited       => 0,
                blog_id          => $website->id,
                do_search        => 1,
                search           => 'A Sunny Day',
            },
        );
        my $out = delete $app->{__test_output};
        ok( $out, 'Request: search_replace' );

        my $col_blog = quotemeta('<span class="col-label">Blog</span>');
        $col_blog = qr/$col_blog/;
        unlike( $out, $col_blog,
            'Does not have a colomn "Blog" in website scope' );

        my $col_website_blog
            = quotemeta('<span class="col-label">Website/Blog</span>');
        $col_website_blog = qr/$col_website_blog/;
        like( $out, $col_website_blog,
            'Has a column "Website/Blog" in website scope' );

        $app = _run_app(
            'MT::App::CMS',
            {   __test_user      => $admin,
                __request_method => 'POST',
                __mode           => 'search_replace',
                _type            => 'entry',
                is_limited       => 0,
                blog_id          => 0,
                do_search        => 1,
                search           => 'A Sunny Day',
            },
        );
        $out = delete $app->{__test_output};
        ok( $out, 'Request: search_replace' );

        unlike( $out, $col_blog,
            'Does not have a colomn "Blog" in system scope' );
        like( $out, $col_website_blog,
            'Has a column "Website/Blog" in system scope' );

        done_testing();
    };

    subtest 'Search in website scope' => sub {
        my $app = _run_app(
            'MT::App::CMS',
            {   __test_user      => $admin,
                __request_method => 'POST',
                __mode           => 'search_replace',
                _type            => 'entry',
                is_limited       => 0,
                blog_id          => $website->id,
                do_search        => 1,
                search           => 'Day',
            },
        );
        my $out = delete $app->{__test_output};
        ok( $out, 'Request: search_replace' );

        my $a_sunny_day
            = quotemeta( '<a href="'
                . $app->mt_uri
                . '?__mode=view&amp;_type=entry&amp;id='
                . $website_entry->id
                . '&amp;blog_id='
                . $website->id . '">'
                . $website_entry->title
                . '</a>' );
        like( $out, qr/$a_sunny_day/,
            'Search results have "A Sunny Day" entry by admin' );

        my $blog_entry = MT::Entry->load(1);
        my $a_rainy_day
            = quotemeta( '<a href="'
                . $app->mt_uri
                . '?__mode=view&amp;_type=entry&amp;id='
                . $blog_entry->id
                . '&amp;blog_id='
                . $blog->[0]->id . '">'
                . $blog_entry->title
                . '</a>' );
        like( $out, qr/$a_rainy_day/,
            'Search results have "A Rainy Day" entry by admin' );

        $app = _run_app(
            'MT::App::CMS',
            {   __test_user      => $aikawa,
                __request_method => 'POST',
                __mode           => 'search_replace',
                _type            => 'entry',
                is_limited       => 0,
                blog_id          => $website->id,
                do_search        => 1,
                search           => 'Day',
            },
        );
        $out = delete $app->{__test_output};
        ok( $out, 'Request: search_replace' );
        like( $out, qr/$a_sunny_day/,
            'Search results have "A Sunny Day" entry by permitted user in a website'
        );
        unlike( $out, qr/$a_rainy_day/,
            'Search results do not have "A Rainy Day" entry by permitted user in a website'
        );

        $app = _run_app(
            'MT::App::CMS',
            {   __test_user      => $ichikawa,
                __request_method => 'POST',
                __mode           => 'search_replace',
                _type            => 'entry',
                is_limited       => 0,
                blog_id          => $blog->[0]->id,
                do_search        => 1,
                search           => 'Day',
            },
        );
        $out = delete $app->{__test_output};
        ok( $out, 'Request: search_replace' );
        unlike( $out, qr/$a_sunny_day/,
            'Search results do not have "A Sunny Day" entry by permitted user in a blog'
        );
        like( $out, qr/$a_rainy_day/,
            'Search results have "A Rainy Day" entry by permitted user in a blog'
        );

        $app = _run_app(
            'MT::App::CMS',
            {   __test_user      => $ukawa,
                __request_method => 'POST',
                __mode           => 'search_replace',
                _type            => 'entry',
                is_limited       => 0,
                blog_id          => $blog->[0]->id,
                do_search        => 1,
                search           => 'Day',
            },
        );
        $out = delete $app->{__test_output};
        ok( $out, 'Request: search_replace' );
        like( $out, qr/permission=1/,
            'Cannot view search results by Not permtted user' );

        done_testing();
    };

    done_testing();
};

done_testing();
