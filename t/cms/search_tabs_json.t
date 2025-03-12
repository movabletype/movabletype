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
use MT::Test::Permission;
use MT::Test::App;

$test_env->prepare_fixture(
    sub {
        MT::Test->init_db;

        # Website
        my $website =
          MT::Test::Permission->make_website( name => 'my website', );

        # Blog
        my $blog = MT::Test::Permission->make_blog(
            parent_id => $website->id,
            name      => 'my blog',
        );

        # ContentType
        my $ct = MT::Test::Permission->make_content_type(
            blog_id => $website->id,
            name    => 'test content type',
        );

        # User
        my $user = MT::Test::Permission->make_author( name => 'test user', );

    }
);

my $admin   = MT->model('author')->load(1);
my $website = MT->model('website')->load( { name => 'my website' } );
my $author  = MT->model('author')->load( { name => 'test user' } );

subtest 'search_tabs_json' => sub {
    local $ENV{HTTP_X_REQUESTED_WITH} = 'XMLHttpRequest';
    my $app = MT::Test::App->new('MT::App::CMS');

    subtest 'successfully with an administrator user' => sub {
        $app->login($admin);
        $app->post_ok(
            {
                __mode  => 'search_tabs_json',
                blog_id => $website->id,
            },
            "post succeeded with blog_id"
        );
        my $json = $app->json->{result};
        is( $json->{success}, 1, 'have a success with blog_id' );

        is( scalar @{ $json->{data} }, 8, 'data count is 8 with blog_id' );
        is_deeply(
            [ map { $_->{key} } @{ $json->{data} } ],
            [
                qw/content_data entry page template asset log author blog/
            ],
            'should validate data keys with blog_id'
        );

        $app->post_ok(
            {
                __mode  => 'search_tabs_json',
                blog_id => 0,
            },
            "post succeeded with blog_id 0"
        );
        $json = $app->json->{result};
        is( $json->{success}, 1, 'have a success with blog_id 0' );

        is( scalar @{ $json->{data} }, 10, 'data count is 10 with blog_id 0' );

        is_deeply(
            [ map { $_->{key} } @{ $json->{data} } ],
            [
                qw/content_data entry page template asset log author group blog website/
            ],
            'should validate data keys with blog_id 0'
        );

    };

    subtest 'error with a non-permitted user' => sub {
        $app->login($author);
        $app->post_ok(
            {
                __mode  => 'search_tabs_json',
                blog_id => $website->id,
            },
            "post succeeded with blog_id"
        );
        my $error = $app->json->{error};
        $error =~ s/(\r\n|\r|\n)+\z//g;
        is( $error, "Permission denied", 'have a error with blog_id' );

        $app->login($author);
        $app->post_ok(
            {
                __mode  => 'search_tabs_json',
                blog_id => 0,
            },
            "post succeeded with blog_id 0"

        );
        $error = $app->json->{error};
        $error =~ s/(\r\n|\r|\n)+\z//g;

        is(
            $error,
            "Permission denied",
            'error is Permission denied with blog_id 0'
        );
    };

    subtest 'successfully with a permitted user' => sub {
        my $blog = MT->model('blog')->load( { name => 'my blog' } );
        my $author_role =
          MT::Role->load( { name => MT->translate('Site Administrator') } );
        require MT::Association;
        MT::Association->link( $author => $author_role => $blog );

        $app->login($author);
        $app->post_ok(
            {
                __mode  => 'search_tabs_json',
                blog_id => $blog->id,
            },
            "post succeeded with blog_id"

        );
        my $json = $app->json->{result};
        is( $json->{success}, 1, 'have a success with blog_id' );

        is( scalar @{ $json->{data} }, 6, 'data count is 6 with blog_id' );

        is_deeply(
            [ map { $_->{key} } @{ $json->{data} } ],
            [qw/entry page template asset log author/],
            'should validate data keys with blog_id'
        );

    };
};

done_testing;
