#!/usr/bin/perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/lib"; # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;
BEGIN {
    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;
}


use lib qw(lib extlib t/lib);

use FindBin;
use Test::More;
use MT::Test::DataAPI;

use MT::App::DataAPI;
my $app = MT::App::DataAPI->new;

my $author = MT->model('author')->load(1);
$author->email('melody@example.com');
$author->save;

# Oops, sitepath is not absolute.
my $website = $app->model('website')->load(2);
$website->site_path($FindBin::Bin);
$website->save or die $website->errstr;

# TODO: Avoid an error when installing GoogleAnalytics plugin.
my $mock_cms_common = Test::MockModule->new('MT::CMS::Common');
$mock_cms_common->mock( 'run_web_services_save_config_callbacks', sub { } );

# $blog->use_revision is always 0 when TrackRevisions is 0.
$app->config->TrackRevisions( 1, 1 );

my $suite = suite();
test_data_api($suite);

done_testing;

sub suite {
    return +[

        # version 1.
        {   path      => '/v1/users/me/sites',
            method    => 'GET',
            callbacks => [
                {   name  => 'data_api_pre_load_filtered_list.blog',
                    count => 2,
                },
            ],
            result => sub {
                +{  'totalResults' => '2',
                    'items'        => MT::DataAPI::Resource->from_object(
                        [   MT->model('blog')
                                ->load( { class => '*', }, { sort => 'id' } )
                        ]
                    ),
                };
            },
        },
        {   path   => '/v1/users/4/sites',
            method => 'GET',
            result => sub {
                +{  'totalResults' => '0',
                    'items'        => [],
                };
            },
        },
        {   path   => '/v1/users/9999/sites',
            method => 'GET',
            code   => 404,
        },
        {   path      => '/v1/sites/1',
            method    => 'GET',
            callbacks => [
                {   name =>
                        'MT::App::DataAPI::data_api_view_permission_filter.blog',
                    count => 1,
                },
            ],
            result => sub {
                MT->model('blog')->load(1);
            },
        },
        {   path      => '/v1/sites/2',
            method    => 'GET',
            callbacks => [
                {   name =>
                        'MT::App::DataAPI::data_api_view_permission_filter.blog',
                    count => 1,
                },
            ],
            result => sub {
                MT->model('blog')->load(2);
            },
        },

        # version 2.

        # list_sites - normal tests
        {   path      => '/v2/sites',
            method    => 'GET',
            callbacks => [
                {   name  => 'data_api_pre_load_filtered_list.blog',
                    count => 2,
                },
            ],
            complete => sub {
                my ( $data, $body ) = @_;

                my $result = MT::Util::from_json($body);
                my @result_ids = map { $_->{id} } @{ $result->{items} };

                my @sites = MT->model('blog')
                    ->load( { class => '*' }, { sort => 'name' } );
                my @site_ids = map { $_->id } @sites;

                is_deeply( \@result_ids, \@site_ids );
            },
        },
        {
            # not logged in
            path      => '/v2/sites',
            method    => 'GET',
            callbacks => [
                {   name  => 'data_api_pre_load_filtered_list.blog',
                    count => 2,
                },
            ],
            author_id => 0,
            complete  => sub {
                my ( $data, $body ) = @_;

                my $result = MT::Util::from_json($body);
                my @result_ids = map { $_->{id} } @{ $result->{items} };

                my @sites = MT->model('blog')
                    ->load( { class => '*' }, { sort => 'name' } );
                my @site_ids = map { $_->id } @sites;

                is_deeply( \@result_ids, \@site_ids );
            },
        },
        {    # search
            path      => '/v2/sites',
            method    => 'GET',
            params    => { search => 'Test' },
            callbacks => [
                {   name  => 'data_api_pre_load_filtered_list.blog',
                    count => 2,
                },
            ],
            result => sub {
                my @sites = $app->model('blog')
                    ->load( { class => '*', name => { like => '%Test%' }, } );
                return +{
                    totalResults => scalar(@sites),
                    items => MT::DataAPI::Resource->from_object( \@sites ),
                };
            },
        },
        {    # search (no hits)
            path      => '/v2/sites',
            method    => 'GET',
            params    => { search => 'No hits' },
            callbacks => [
                {   name  => 'data_api_pre_load_filtered_list.blog',
                    count => 1,
                },
            ],
            result => sub {
                return +{
                    totalResults => 0,
                    items        => [],
                };
            },
        },

        # list_sites_by_parent - irregular tests
        {    # Non-existent website.
            path   => '/v2/sites/3/children',
            method => 'GET',
            code   => 404,
            result => sub {
                +{  error => {
                        code    => 404,
                        message => 'Site not found',
                    },
                };
            },
        },

        # list_sites_by_parent - normal tests
        {    # website.
            path      => '/v2/sites/2/children',
            method    => 'GET',
            callbacks => [
                {   name  => 'data_api_pre_load_filtered_list.blog',
                    count => 2,
                },
            ],
            complete => sub {
                my ( $data, $body ) = @_;

                my $result = MT::Util::from_json($body);
                my @result_ids = map { $_->{id} } @{ $result->{items} };

                my @sites = MT->model('blog')
                    ->load( { parent_id => 2 }, { sort => 'name' } );
                my @site_ids = map { $_->id } @sites;

                is_deeply( \@result_ids, \@site_ids );
            },
        },
        {
            # blog.
            path      => '/v2/sites/1/children',
            method    => 'GET',
            callbacks => [
                {   name  => 'data_api_pre_load_filtered_list.blog',
                    count => 1,
                },
            ],
            result => sub {
                +{  totalResults => 0,
                    items        => [],
                };
            },
        },
        {    # System.
            path      => '/v2/sites/0/children',
            method    => 'GET',
            callbacks => [
                {   name  => 'data_api_pre_load_filtered_list.blog',
                    count => 1,
                },
            ],
            result => sub {
                +{  totalResults => 0,
                    items        => [],
                };
            },
        },

        # insert_new_website - irregular tests
        {    # No resource.
            path   => '/v2/sites',
            method => 'POST',
            code   => 400,
            error  => 'A resource "website" is required.',
        },
        {    # No name.
            path   => '/v2/sites',
            method => 'POST',
            params => { website => {}, },
            code   => 409,
            error  => "A parameter \"name\" is required.\n",
        },
        {    # No url.
            path   => '/v2/sites',
            method => 'POST',
            params =>
                { website => { name => 'test-api-permission-website', }, },
            code  => 409,
            error => "A parameter \"url\" is required.\n",
        },
        {    # No sitePath.
            path   => '/v2/sites',
            method => 'POST',
            params => {
                website => {
                    name => 'test-api-permission-website',
                    url  => 'http://narnia2.na/',
                },
            },
            is_superuser => 1,
            code         => 409,
            error        => "A parameter \"sitePath\" is required.\n",
        },
        {    # Invalid theme_id.
            path   => '/v2/sites',
            method => 'POST',
            params => {
                website => {
                    name     => 'test-api-permission-website',
                    url      => 'http://narnia2.na/',
                    sitePath => $FindBin::Bin,
                    themeId  => 'dummy',
                },
            },
            is_superuser => 1,
            code         => 409,
            error        => "Invalid theme_id: dummy\n",
        },
        {    # sitePath is not absolute.
            path   => '/v2/sites',
            method => 'POST',
            params => {
                website => {
                    name     => 'test-api-permission-website',
                    url      => 'http://narnia2.na/',
                    sitePath => 'relative/path',
                    themeId  => 'classic_website',
                },
            },
            is_superuser => 1,
            code         => 409,
            error =>
                "The website root directory must be an absolute path: relative\/path\n",
        },
        {    # Not logged in.
            path   => '/v2/sites',
            method => 'POST',
            params => {
                website => {
                    name     => 'test-api-permission-website',
                    url      => 'http://narnia2.na/',
                    sitePath => $FindBin::Bin,
                },
            },
            author_id => 0,
            code      => 401,
            error     => 'Unauthorized',
        },
        {    # No permissions.
            path   => '/v2/sites',
            method => 'POST',
            params => {
                website => {
                    name     => 'test-api-permission-website',
                    url      => 'http://narnia2.na/',
                    sitePath => $FindBin::Bin,
                },
            },
            restrictions => { 0 => [qw/ create_new_website /], },
            code         => 403,
            error => 'Do not have permission to create a website.',
        },

        #   insert_new_website - normal tests
        {    # Minimal parameters.
            path         => '/v2/sites',
            method       => 'POST',
            is_superuser => 1,
            callbacks    => [

                # save_permission_filter callback is not executed,
                # because superuser accesses.
                {   name  => 'MT::App::DataAPI::data_api_save_filter.website',
                    count => 1,
                },
                {   name  => 'MT::App::DataAPI::data_api_pre_save.website',
                    count => 1,
                },
                {   name  => 'MT::App::DataAPI::data_api_post_save.website',
                    count => 1,
                },
            ],
            params => {
                website => {
                    name     => 'test-api-permission-website',
                    url      => 'http://narnia2.na/',
                    sitePath => $FindBin::Bin,
                },
            },
        },
        {    # SitePath ends with slash.
            path         => '/v2/sites',
            method       => 'POST',
            is_superuser => 1,
            callbacks    => [

                # save_permission_filter callback is not executed,
                # because superuser accesses.
                {   name  => 'MT::App::DataAPI::data_api_save_filter.website',
                    count => 1,
                },
                {   name  => 'MT::App::DataAPI::data_api_pre_save.website',
                    count => 1,
                },
                {   name  => 'MT::App::DataAPI::data_api_post_save.website',
                    count => 1,
                },
            ],
            params => {
                website => {
                    name     => 'SitePath ends with slash',
                    url      => 'http://narnia2.na/',
                    sitePath => $FindBin::Bin . '/',
                },
            },
        },
        {    # ArchivePath.
            path         => '/v2/sites',
            method       => 'POST',
            is_superuser => 1,
            callbacks    => [

                # save_permission_filter callback is not executed,
                # because superuser accesses.
                {   name  => 'MT::App::DataAPI::data_api_save_filter.website',
                    count => 1,
                },
                {   name  => 'MT::App::DataAPI::data_api_pre_save.website',
                    count => 1,
                },
                {   name  => 'MT::App::DataAPI::data_api_post_save.website',
                    count => 1,
                },
            ],
            params => {
                website => {
                    name     => 'test-api-permission-website',
                    url      => 'http://narnia2.na/',
                    sitePath => $FindBin::Bin,
                    archivePath => $FindBin::Bin . '/archives',
                    archiveUrl  => 'http://narnia2.na/archives/',
                },
            },
        },
        {    # ArchivePath - Ends with slash.
            path         => '/v2/sites',
            method       => 'POST',
            is_superuser => 1,
            callbacks    => [

                # save_permission_filter callback is not executed,
                # because superuser accesses.
                {   name  => 'MT::App::DataAPI::data_api_save_filter.website',
                    count => 1,
                },
                {   name  => 'MT::App::DataAPI::data_api_pre_save.website',
                    count => 1,
                },
                {   name  => 'MT::App::DataAPI::data_api_post_save.website',
                    count => 1,
                },
            ],
            params => {
                website => {
                    name     => 'test-api-permission-website',
                    url      => 'http://narnia2.na/',
                    sitePath => $FindBin::Bin,
                    archivePath => $FindBin::Bin . '/archives/',
                    archiveUrl => 'http://narnia2.na/archives/',
                },
            },
        },
        {   path         => '/v2/sites',
            method       => 'POST',
            is_superuser => 1,
            params       => {
                website => {
                    name         => 'test-api-permission-website-2',
                    url          => 'http://narnia2.na/',
                    sitePath     => $FindBin::Bin,
                    themeId      => 'classic_website',
                    serverOffset => -5.5,
                    language     => 'de',
                },
            },
            callbacks => [

                # save_permission_filter callback is not executed,
                # because superuser accesses.
                {   name  => 'MT::App::DataAPI::data_api_save_filter.website',
                    count => 1,
                },
                {   name  => 'MT::App::DataAPI::data_api_pre_save.website',
                    count => 1,
                },
                {   name  => 'MT::App::DataAPI::data_api_post_save.website',
                    count => 1,
                },
            ],
            result => sub {
                $app->model('website')
                    ->load( { name => 'test-api-permission-website-2' } );
            },
            complete => sub {
                my ( $data, $body ) = @_;

                my $got = $app->current_format->{unserialize}->($body);

                is( $got->{name}, 'test-api-permission-website-2', 'name' ),
                    is( $got->{url}, 'http://narnia2.na/', 'url' );
                is( $got->{sitePath},     $FindBin::Bin,     'sitePath' );
                is( $got->{themeId},      'classic_website', 'themeId' );
                is( $got->{serverOffset}, -5.5,              'serverOffset' );
                is( $got->{language},     'de',              'language' );
            },
        },

        # site_path website
        {   path         => '/v2/sites',
            method       => 'POST',
            is_superuser => 1,
            params       => {
                website => {
                    name     => 'test-api-website-3',
                    url      => 'http://narnia2.na/',
                    sitePath => $FindBin::Bin . '/',
                    themeId  => 'classic_website',
                },
            },
            result => sub {
                $app->model('website')
                    ->load( { name => 'test-api-website-3' } );
            },
            complete => sub {
                my ( $data, $body ) = @_;

                my $got = $app->current_format->{unserialize}->($body);

                # is( $got->{sitePath},     $FindBin::Bin,     'sitePath' );
                ok( ( $got->{sitePath} !~ m{(/|\\)$} ), 'sitePath' );
            },
        },

        # insert_new_blog - irregular tests
        {    # website
            path   => '/v2/sites/1',
            method => 'POST',
            code   => 400,
            error  => "Cannot create a blog under blog (ID:1).",
        },
        {    # No resource.
            path   => '/v2/sites/2',
            method => 'POST',
            code   => 400,
            error  => "A resource \"blog\" is required.",
        },
        {    # No url or subdomain.
            path   => '/v2/sites/2',
            method => 'POST',
            params => { blog => {}, },
            code   => 400,
            error =>
                "Either parameter of \"url\" or \"subdomain\" is required.",
        },
        {    # No name.
            path   => '/v2/sites/2',
            method => 'POST',
            params => { blog => { url => 'blog', }, },
            code   => 409,
            error  => "A parameter \"name\" is required.\n",
        },
        {    # No sitePath.
            path   => '/v2/sites/2',
            method => 'POST',
            params => {
                blog => {
                    url  => 'blog',
                    name => 'blog',
                },
            },
            code  => 409,
            error => "A parameter \"sitePath\" is required.\n",
        },
        {    # Invalid theme_id.
            path   => '/v2/sites/2',
            method => 'POST',
            params => {
                blog => {
                    url      => 'blog',
                    name     => 'blog',
                    sitePath => 'blog',
                    themeId  => 'invalid_theme',
                },
            },
            is_superuser => 1,
            code         => 409,
            error        => "Invalid theme_id: invalid_theme\n",
        },
        {    # Website theme_id.
            path   => '/v2/sites/2',
            method => 'POST',
            params => {
                blog => {
                    url      => 'blog',
                    name     => 'blog',
                    sitePath => 'blog',
                    themeId  => 'classic_website',
                },
            },
            is_superuser => 1,
            code         => 409,
            result       => sub {
                +{  error => {
                        code => 409,
                        message =>
                            "Cannot apply website theme to blog: classic_website\n",
                    },
                };
            },
        },
        {    # Not logged in.
            path   => '/v2/sites/2',
            method => 'POST',
            params => {
                blog => {
                    url      => 'blog',
                    name     => 'blog',
                    sitePath => 'blog',
                    themeId  => 'classic_blog',
                },
            },
            author_id => 0,
            code      => 401,
            error     => 'Unauthorized',
        },
        {    # No permisionss.
            path   => '/v2/sites/2',
            method => 'POST',
            params => {
                blog => {
                    url      => 'blog',
                    name     => 'blog',
                    sitePath => 'blog',
                    themeId  => 'classic_blog',
                },
            },
            restrictions => { 0 => [qw/ create_blog /], },
            code         => 403,
            error => 'Do not have permission to create a blog.',
        },

        # insert_new_blog - normal tests
        {    # Minimal pameters.
            path   => '/v2/sites/2',
            method => 'POST',
            params => {
                blog => {
                    url      => 'blog',
                    name     => 'blog',
                    sitePath => 'blog',
                    themeId  => 'classic_blog',
                },
            },
            is_superuser => 1,
            callbacks    => [

                # save_permission_filter callback is not executed,
                # because superuser accesses.
                {   name  => 'MT::App::DataAPI::data_api_save_filter.blog',
                    count => 1,
                },
                {   name  => 'MT::App::DataAPI::data_api_pre_save.blog',
                    count => 1,
                },
                {   name  => 'MT::App::DataAPI::data_api_post_save.blog',
                    count => 1,
                },
            ],
            result => sub { $app->model('blog')->load( { name => 'blog' } ) },
        },
        {   path   => '/v2/sites/2',
            method => 'POST',
            params => {
                blog => {
                    themeId      => 'pico',
                    name         => 'blog-2 name',
                    url          => 'blog-2',
                    sitePath     => 'blog-2',
                    serverOffset => +8,
                    language     => 'nl',
                },
            },
            is_superuser => 1,
            callbacks    => [

                # save_permission_filter callback is not executed,
                # because superuser accesses.
                {   name  => 'MT::App::DataAPI::data_api_save_filter.blog',
                    count => 1,
                },
                {   name  => 'MT::App::DataAPI::data_api_pre_save.blog',
                    count => 1,
                },
                {   name  => 'MT::App::DataAPI::data_api_post_save.blog',
                    count => 1,
                },
            ],
            result =>
                sub { $app->model('blog')->load( { name => 'blog-2 name' } ) }
            ,
            complete => sub {
                my ( $data, $body ) = @_;

                my $website = $app->model('website')->load(2);

                my $got = $app->current_format->{unserialize}->($body);

                is( $got->{themeId}, 'pico',        'themeId' );
                is( $got->{name},    'blog-2 name', 'name' );

                my $url = $website->site_url;
                $url .= '/' if $url !~ m/\/$/;
                $url .= 'blog-2/';
                is( $got->{url}, $url, 'url' );

                is( $got->{sitePath},
                    File::Spec->catfile( $website->site_path, 'blog-2' ),
                    'sitePath' );
                is( $got->{serverOffset}, 8,    'serverOffset' );
                is( $got->{language},     'nl', 'language' );
            },
        },
        {    # Set siteSubDomain, and sitePath is absolute.
            path   => '/v2/sites/2',
            method => 'POST',
            params => {
                blog => {
                    themeId       => 'classic_blog',
                    name          => 'blog-3 name',
                    url           => 'blog-3',
                    siteSubdomain => 'www',
                    sitePath      => $FindBin::Bin,    # absolute.
                    serverOffset  => +8,
                    language      => 'nl',
                },
            },
            is_superuser => 1,
            callbacks    => [

                # save_permission_filter callback is not executed,
                # because superuser accesses.
                {   name  => 'MT::App::DataAPI::data_api_save_filter.blog',
                    count => 1,
                },
                {   name  => 'MT::App::DataAPI::data_api_pre_save.blog',
                    count => 1,
                },
                {   name  => 'MT::App::DataAPI::data_api_post_save.blog',
                    count => 1,
                },
            ],
            result =>
                sub { $app->model('blog')->load( { name => 'blog-3 name' } ) }
            ,
            complete => sub {
                my ( $data, $body ) = @_;

                my $blog
                    = $app->model('blog')->load( { name => 'blog-3 name' } );
                my $website = $blog->website or die;

                my $got = $app->current_format->{unserialize}->($body);

                is( $got->{themeId}, 'classic_blog', 'themeId' );
                is( $got->{name},    'blog-3 name',  'name' ),
                    is( $got->{url}, 'http://www.narnia.na/blog-3/', 'url' );
                is( $got->{sitePath},     $FindBin::Bin, 'sitePath' );
                is( $got->{serverOffset}, 8,             'serverOffset' );
                is( $got->{language},     'nl',          'language' );
            },
        },

        # site_path blog
        {   path         => '/v2/sites/2',
            method       => 'POST',
            is_superuser => 1,
            params       => {
                blog => {
                    name     => 'test-api-blog-3',
                    url      => 'http://narnia2.na/',
                    sitePath => $FindBin::Bin . '/',
                    themeId  => 'classic_blog',
                },
            },
            result => sub {
                $app->model('blog')->load( { name => 'test-api-blog-3' } );
            },
            complete => sub {
                my ( $data, $body ) = @_;

                my $got = $app->current_format->{unserialize}->($body);

                # is( $got->{sitePath},     $FindBin::Bin,     'sitePath' );
                ok( ( $got->{sitePath} !~ m{(/|\\)$} ), 'sitePath' );
            },
        },

        # update_site - irregular tests
        {    # Non-existent site.
            path   => '/v2/sites/20',
            method => 'PUT',
            code   => 404,
            result => sub {
                +{  error => {
                        code    => 404,
                        message => 'Site not found',
                    },
                };
            },
        },
        {    # System.
            path   => '/v2/sites/0',
            method => 'PUT',
            code   => 404,
            result => sub {
                +{  error => {
                        code    => 404,
                        message => 'Site not found',
                    },
                };
            },
        },
        {    # No blog resource.
            path   => '/v2/sites/1',
            method => 'PUT',
            code   => 400,
            result => sub {
                +{  error => {
                        code    => 400,
                        message => 'A resource "blog" is required.',
                    },
                };
            },
        },
        {    # No website resource.
            path   => '/v2/sites/2',
            method => 'PUT',
            code   => 400,
            result => sub {
                +{  error => {
                        code    => 400,
                        message => 'A resource "website" is required.',
                    },
                };
            },
        },
        {    # Not logged in.
            path      => '/v2/sites/2',
            method    => 'PUT',
            params    => { website => {} },
            author_id => 0,
            code      => 401,
            error     => 'Unauthorized',
        },
        {    # No permissions (blog).
            path         => '/v2/sites/1',
            method       => 'PUT',
            params       => { blog => {} },
            restrictions => { 1 => [qw/ edit_blog_config /], },
            code         => 403,
            error        => 'Do not have permission to update a site.',
        },
        {    # No permissions (website).
            path         => '/v2/sites/2',
            method       => 'PUT',
            params       => { website => {} },
            restrictions => {
                0 => [qw/ edit_blog_config /],
                2 => [qw/ edit_blog_config /],
            },
            code  => 403,
            error => 'Do not have permission to update a site.',
        },

        # update_site - normal tests
        {    # website.
            path   => '/v2/sites/2',
            method => 'PUT',
            params => {
                website => {

                    # General Settings scrren.
                    name         => 'update site',
                    description  => 'update description',
                    serverOffset => 3,
                    language     => 'fr',
                    url          => 'http://www.sixapart.com',
                    sitePath =>
                        File::Spec->catfile( $FindBin::Bin, 'update' ),
                    archiveUrl => 'http://www.sixapart.com/archive/',
                    archivePath =>
                        File::Spec->catfile( $FindBin::Bin, 'archive' ),

                    fileExtension        => 'pl',
                    archiveTypePreferred => 'Category',
                    publishEmptyArchive  => 1,            # true.
                    includeSystem        => 'php',
                    useRevision          => 1,            # true.
                    maxRevisionsEntry    => 100,
                    maxRevisionsTemplate => 200,

                    # Compose Settings screen.
                    listOnIndex          => 10,
                    daysOrPosts          => 'posts',
                    sortOrderPosts       => 'ascend',
                    wordsInExcerpt       => 100,
                    basenameLimit        => 50,
                    statusDefault        => 'Draft',
                    convertParas         => '__default__',
                    allowCommentsDefault => 1,               # true.
                    allowPingsDefault    => 1,               # true.
                    contentCss           => 'css dummy',
                    smartReplace         => 1,
                    smartReplaceFields   => [qw/ text /],

                    # Feedback Settings screen.
                    junkFolderExpiry       => 10,
                    junkScoreThreshold     => -5,
                    nofollowUrls           => 1,             # true.
                    followAuthLinks        => 1,             # true.
                    allowComments          => 1,             # true.
                    moderateComments       => 2,
                    allowCommentHtml       => 1,             # true.
                    sanitizeSpec           => 'b,p',
                    emailNewComments       => 2,
                    sortOrderComments      => 'descend',
                    autolinkUrls           => 1,             # true.
                    convertParasComments   => 'markdown',
                    useCommentConfirmation => 1,             # true.
                    allowPings             => 1,             # true.
                    moderatePings          => 1,             # true.
                    emailNewPings          => 2,
                    autodiscoverLinks      => 1,             # true.
                    internalAutodiscovery  => 1,             # true.

                    # Registration Settings screen.
                    allowCommenterRegist => 1,                  # true.
                    newCreatedUserRoles  => [ { id => 6 } ],    # Webmaster.
                    allowUnregComments   => 1,                  # true.
                    requireCommentEmails => 1,                  # true.
                    commenterAuthenticators => [qw/ WordPress Hatena /],

                    # Web Services Settings screen.
                    pingGoogle  => 1,                           # true.
                    pingWeblogs => 1,                           # true.
                    pingOthers  => [qw/ dummy_a dummy_b /],

                    # Template tags.
                    dateLanguage => 'fr',

                    # Publishing Profile screen.
                    customDynamicTemplates => 'all',
                },
            },
            is_superuser => 1,
            callbacks    => [

                # save_permission_filter callback is not executed,
                # because superuser accesses.
                {   name  => 'MT::App::DataAPI::data_api_save_filter.website',
                    count => 1,
                },
                {   name  => 'MT::App::DataAPI::data_api_pre_save.website',
                    count => 1,
                },
                {   name  => 'MT::App::DataAPI::data_api_post_save.website',
                    count => 1,
                },
            ],
            result   => sub { $app->model('website')->load(2) },
            complete => sub {
                my ( $data, $body ) = @_;

                my $blog = $app->model('website')->load(2);

                my $got = $app->current_format->{unserialize}->($body);

                # General Settings scrren.
                is( $got->{name}, 'update site', 'name' );
                is( $got->{description}, 'update description',
                    'description' );
                is( $got->{serverOffset}, 3,    'serverOffset' );
                is( $got->{language},     'fr', 'language' );
                is( $got->{url}, 'http://www.sixapart.com/', 'url' );
                is( $got->{sitePath},
                    File::Spec->catfile( $FindBin::Bin, 'update' ),
                    'sitePath' );
                is( $got->{archiveUrl}, 'http://www.sixapart.com/archive/',
                    'archiveUrl' );
                is( $got->{archivePath},
                    File::Spec->catfile( $FindBin::Bin, 'archive' ),
                    'archivePath' );

                is( $got->{fileExtension}, 'pl', 'fileExtension' );
                is( $got->{archiveTypePreferred},
                    'Category', 'archiveTypePreferred' );
                is( $got->{publishEmptyArchive}, 1, 'publishEmptyArchive' )
                    ;    # true.
                is( $got->{useRevision}, 1, 'useRevision' );    # true.
                is( $got->{maxRevisionsEntry}, 100, 'maxRevisionsEntry' );
                is( $got->{maxRevisionsTemplate},
                    200, 'maxRevisionsTemplate' );

                # Compose Settings screen.
                is( $got->{listOnIndex},    10,            'listOnIndex' );
                is( $got->{daysOrPosts},    'posts',       'daysOrPosts' );
                is( $got->{sortOrderPosts}, 'ascend',      'sortOrderPosts' );
                is( $got->{wordsInExcerpt}, 100,           'wordsInExcerpt' );
                is( $got->{basenameLimit},  50,            'basenameLimit' );
                is( $got->{statusDefault},  'Draft',       'statusDefault' );
                is( $got->{convertParas},   '__default__', 'convertParas' );
                is( $got->{allowCommentsDefault}, 1, 'allowCommentsDefault' )
                    ;    # true.
                is( $got->{allowPingsDefault}, 1, 'allowPingsDefault' )
                    ;    # true.
                is( $got->{contentCss},   'css dummy', 'contentCss' );
                is( $got->{smartReplace}, 1,           'smartReplace' );
                is_deeply( $got->{smartReplaceFields},
                    ['text'], 'smartReplaceFields' );

                # Feedback Settings screen.
                is( $got->{junkFolderExpiry},   10, 'junkfolderExpiry' );
                is( $got->{junkScoreThreshold}, -5, 'junkScoreThreshold' );
                is( $got->{nofollowUrls},     1, 'nofollowUrls' );     # true.
                is( $got->{followAuthLinks},  1, 'followAuthLinks' );  # true.
                is( $got->{allowComments},    1, 'allowComments' );    # true.
                is( $got->{moderateComments}, 2, 'moderateComments' );
                is( $got->{allowCommentHtml}, 1, 'allowCommentHtml' ); # true.
                is( $got->{sanitizeSpec},     'b,p', 'sanitizeSpec' );
                is( $got->{emailNewComments}, 2,     'emailNewComments' );
                is( $got->{sortOrderComments},
                    'descend', 'sortOrderComments' );
                is( $got->{autolinkUrls}, 1, 'autolinkUrls' );         # true.
                is( $got->{convertParasComments},
                    'markdown', 'convertParasComments' );
                is( $got->{useCommentConfirmation},
                    1, 'useCommentConfirmation' );                     # true.
                is( $got->{allowPings},        1, 'allowPings' );      # true.
                is( $got->{moderatePings},     1, 'moderatePings' );   # true.
                is( $got->{emailNewPings},     2, 'emailNewPings' );
                is( $got->{autodiscoverLinks}, 1, 'autodiscoverLinks' )
                    ;                                                  # true.
                is( $got->{internalAutodiscovery},
                    1, 'internalAutodiscovery' );                      # true.
                is( $got->{allowUnregComments}, 1, 'allowUnregComments' )
                    ;                                                  # true.

                # Registration Settings screen.
                is( $got->{allowCommenterRegist}, 1, 'allowCommenterRegist' )
                    ;                                                  # true.

                my $webmaster_role
                    = $app->model('role')->load(6);    # Webmaster.
                is_deeply(
                    $got->{newCreatedUserRoles},
                    MT::DataAPI::Resource->from_object(
                        [$webmaster_role], [qw/ id name /]
                    ),
                    'newCreatedUserRoles'
                );

                is( $got->{allowUnregComments}, 1, 'allowUnregComments' )
                    ;                                  # true.
                is( $got->{requireCommentEmails}, 1, 'requireCommentEmails' )
                    ;                                  # true.
                is_deeply(
                    $got->{commenterAuthenticators},
                    [qw/ WordPress Hatena /],
                    'commenterAuthenticators'
                );

                # Web Services Settings screen.
                is( $got->{pingGoogle},  1, 'pingGoogles' );    # true.
                is( $got->{pingWeblogs}, 1, 'pingWeblogs' );    # true.
                is_deeply( $got->{pingOthers}, [qw/ dummy_a dummy_b /],
                    'pingOthers' );

                # Template tags.
                is( $got->{dateLanguage}, 'fr', 'dateLanguage' );

                # Publishing Profile screen.
                is( $got->{customDynamicTemplates},
                    'all', 'customDynamicTemplates' );
            },
        },
        {                                                       # website
                # set 'days' todaysOrPosts field.
                # check whether boolean fields can have false.
            path   => '/v2/sites/2',
            method => 'PUT',
            params => {
                website => {

                    # General Settings scrren.
                    publishEmptyArchive => 0,    # false.
                    useRevision         => 0,    # false.

                    # Compose Settings screen.
                    listOnIndex          => 20,
                    daysOrPosts          => 'days',
                    convertParas         => 'markdown',
                    allowCommentsDefault => 0,            # false.
                    allowPingsDefault    => 0,            # false.

                    # Feedback Settings screen.
                    nofollowUrls           => 0,          # false.
                    followAuthLinks        => 0,          # false.
                    allowComments          => 0,          # false.
                    allowCommentHtml       => 0,          # false.
                    autolinkUrls           => 0,          # false.
                    useCommentConfirmation => 0,          # false.
                    allowPings             => 0,          # false.
                    moderatePings          => 0,          # false.
                    autodiscoverLinks      => 0,          # false.
                    internalAutodiscovery  => 0,          # false.

                    # Registration Settings screen.
                    allowCommenterRegist => 0,            # false.
                    allowUnregComments   => 0,            # false.
                    requireCommentEmails => 0,            # false.

                    # Web Services Settings screen.
                    pingGoogle  => 0,                     # false.
                    pingWeblogs => 0,                     # false.

                },
            },
            is_superuser => 1,
            callbacks    => [

                # save_permission_filter callback is not executed,
                # because superuser accesses.
                {   name  => 'MT::App::DataAPI::data_api_save_filter.website',
                    count => 1,
                },
                {   name  => 'MT::App::DataAPI::data_api_pre_save.website',
                    count => 1,
                },
                {   name  => 'MT::App::DataAPI::data_api_post_save.website',
                    count => 1,
                },
            ],
            result   => sub { $app->model('website')->load(2) },
            complete => sub {
                my ( $data, $body ) = @_;

                my $blog = $app->model('website')->load(2);

                my $got = $app->current_format->{unserialize}->($body);

                # General Settings scrren.
                is( $got->{publishEmptyArchive}, 0, 'publishEmptyArchive' )
                    ;    # false.
                is( $got->{useRevision}, 0, 'useRevision' );    # false.

                # Compose Settings screen.
                is( $got->{listOnIndex},  20,         'listOnIndex' );
                is( $got->{daysOrPosts},  'days',     'daysOrPosts' );
                is( $got->{convertParas}, 'markdown', 'convertParas' );
                is( $got->{allowCommentsDefault}, 0, 'allowCommentsDefault' )
                    ;                                           # false.
                is( $got->{allowPingsDefault}, 0, 'allowPingsDefault' )
                    ;                                           # false.

                # Feedback Settings screen.
                is( $got->{nofollowUrls},     0, 'nofollowUrls' );    # false.
                is( $got->{followAuthLinks},  0, 'followAuthLinks' ); # false.
                is( $got->{allowComments},    0, 'allowComments' );   # false.
                is( $got->{allowCommentHtml}, 0, 'allowCommentsHtml' )
                    ;                                                 # false.
                is( $got->{autolinkUrls}, 0, 'autolinkUrls' );        # false.
                is( $got->{useCommentConfirmation},
                    0, 'useCommentConfirmation' );                    # false.
                is( $got->{allowPings},    0, 'allowPings' );         # false.
                is( $got->{moderatePings}, 0, 'moderatePings' );      # false.
                is( $got->{autodiscoverLinks}, 0, 'autodiscoverLinks' )
                    ;                                                 # false.
                is( $got->{internalAutodiscovery},
                    0, 'internalAutodiscovery' );                     # false.

                # Registration Settings screen.
                is( $got->{allowCommenterRegist}, 0, 'allowCommenterRegist' )
                    ;                                                 # false.
                is( $got->{allowUnregComments}, 0, 'allowUnregComments' )
                    ;                                                 # false.
                is( $got->{requireCommentEmails}, 0, 'requireCommentEmails' )
                    ;                                                 # false.

                # Web Services Settings screen.
                is( $got->{pingGoogle},  0, 'pingGoogles' );          # false.
                is( $got->{pingWeblogs}, 0, 'pingWeblogs' );          # false.
            },
        },

        # site_path website
        {   path         => '/v2/sites/3',
            method       => 'PUT',
            is_superuser => 1,
            params       => {
                website => {
                    name     => 'test-api-website-3-update',
                    url      => 'http://narnia2.na/update/',
                    sitePath => File::Spec->catfile( $FindBin::Bin, 'update' )
                        . '/',
                },
            },
            result => sub {
                $app->model('website')->load(3);
            },
            complete => sub {
                my ( $data, $body ) = @_;

                my $blog = $app->model('website')->load(3);

                my $got = $app->current_format->{unserialize}->($body);

                # is( $got->{sitePath},     $FindBin::Bin,     'sitePath' );
                ok( ( $got->{sitePath} !~ m{(/|\\)$} ), 'sitePath' );
            },
        },

        # delete_site - irregular tests
        {   path   => '/v2/sites/2',
            method => 'DELETE',
            code   => 403,
            result => sub {
                +{  error => {
                        code => 403,
                        message =>
                            'Website "update site" (ID:2) was not deleted. You need to delete the blogs under the website first.',
                    },
                };
            },
        },
        {    # Non-existent site.
            path   => '/v2/sites/20',
            method => 'DELETE',
            code   => 404,
            result => sub {
                +{  error => {
                        code    => 404,
                        message => 'Site not found',
                    },
                };
            },
        },
        {    # System.
            path   => '/v2/sites/0',
            method => 'DELETE',
            code   => 404,
            result => sub {
                +{  error => {
                        code    => 404,
                        message => 'Site not found',
                    },
                };
            },
        },
        {    # Not logged in.
            path      => '/v2/sites/1',
            method    => 'DELETE',
            author_id => 0,
            code      => 401,
            error     => 'Unauthorized',
        },
        {    # No permissions (blog).
            path         => '/v2/sites/1',
            method       => 'DELETE',
            restrictions => { 1 => [qw/ delete_blog /], },
            code         => 403,
            error        => 'Do not have permission to delete a site.',
        },

        # delete_site - normal tests
        {
            # blog
            path   => '/v2/sites/1',
            method => 'DELETE',
            setup  => sub {
                my $blog = $app->model('blog')->load(1);
                die if !( $blog && $blog->is_blog );
            },
            callbacks => [
                {   name =>
                        'MT::App::DataAPI::data_api_delete_permission_filter.blog',
                    count => 1,
                },
                {   name  => 'MT::App::DataAPI::data_api_post_delete.blog',
                    count => 1,
                },
                {   name  => 'MT::App::DataAPI::rebuild',
                    count => 1,
                },
            ],
            complete => sub {
                my $blog = MT->model('blog')->load(1);
                is( $blog, undef, 'Blog (ID:1) was deleted.' );
            },
        },

        # delete_site - irregular tests
        {    # No permissions (website).
            path         => '/v2/sites/2',
            method       => 'DELETE',
            restrictions => {
                2 => [qw/ delete_website /],
                0 => [qw/ delete_website /],
            },
            setup => sub {
                my $website = $app->model('website')->load(2);
                die if !( $website && !$website->is_blog );
                for my $b ( $app->model('blog')->load( { parent_id => 2 } ) )
                {
                    $b->remove or die $b->errstr;
                }
            },
            code  => 403,
            error => 'Do not have permission to delete a site.',
        },

        # delete_site - normal tests
        {
            # website
            path      => '/v2/sites/2',
            method    => 'DELETE',
            callbacks => [
                {   name =>
                        'MT::App::DataAPI::data_api_delete_permission_filter.website',
                    count => 1,
                },
                {   name  => 'MT::App::DataAPI::data_api_post_delete.website',
                    count => 1,
                },
                {   name  => 'MT::App::DataAPI::rebuild',
                    count => 1,
                },
            ],
            complete => sub {
                my $website = MT->model('website')->load(2);
                is( $website, undef, 'Website (ID:2) was deleted.' );
            },
        },
    ];
}

