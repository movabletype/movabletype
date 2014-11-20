#!/usr/bin/perl

use strict;
use warnings;

use FindBin;

BEGIN {
    $ENV{MT_CONFIG} = 'mysql-test.cfg';
}

BEGIN {
    use Test::More;
    eval { require Test::MockModule }
        or plan skip_all => 'Test::MockModule is not installed';
}

use File::Spec;

use lib qw(lib extlib t/lib);

eval(
    $ENV{SKIP_REINITIALIZE_DATABASE}
    ? "use MT::Test qw(:app);"
    : "use MT::Test qw(:app :db :data);"
);

use MT::App::DataAPI;
my $app    = MT::App::DataAPI->new;
my $author = MT->model('author')->load(1);
$author->email('melody@example.com');
$author->save;

my $is_superuser = 0;
my $mock_author  = Test::MockModule->new('MT::Author');
$mock_author->mock( 'is_superuser', sub {$is_superuser} );

my $mock_app_api = Test::MockModule->new('MT::App::DataAPI');
my $version;
$mock_app_api->mock( 'current_api_version',
    sub { $version = $_[1] if $_[1]; $version } );

# Oops, sitepath is not absolute.
my $website = $app->model('website')->load(2);
$website->site_path($FindBin::Bin);
$website->save or die $website->errstr;

# TODO: Avoid an error when installing GoogleAnalytics plugin.
my $mock_cms_common = Test::MockModule->new('MT::CMS::Common');
$mock_cms_common->mock( 'run_web_services_save_config_callbacks', sub { } );

# $blog->use_revision is always 0 when TrackRevisions is 0.
$app->config->TrackRevisions(1);

my %callbacks = ();

my @suite = (

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
        setup => sub {
            $mock_app_api->mock( 'user', sub { MT->model('author')->new } );
        },
        complete => sub {
            my ( $data, $body ) = @_;

            my $result = MT::Util::from_json($body);
            my @result_ids = map { $_->{id} } @{ $result->{items} };

            my @sites = MT->model('blog')
                ->load( { class => '*' }, { sort => 'name' } );
            my @site_ids = map { $_->id } @sites;

            is_deeply( \@result_ids, \@site_ids );

            $mock_app_api->unmock('user');
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
        path     => '/v2/sites',
        method   => 'POST',
        code     => 400,
        complete => sub {
            my ( $data, $body ) = @_;
            check_error_message( $body, 'A resource "website" is required.' );
        },
    },
    {    # No name.
        path     => '/v2/sites',
        method   => 'POST',
        params   => { website => {}, },
        code     => 409,
        complete => sub {
            my ( $data, $body ) = @_;
            check_error_message( $body,
                "A parameter \"name\" is required.\n" );
        },
    },
    {    # No url.
        path   => '/v2/sites',
        method => 'POST',
        params => { website => { name => 'test-api-permission-website', }, },
        code   => 409,
        complete => sub {
            my ( $data, $body ) = @_;
            check_error_message( $body,
                "A parameter \"url\" is required.\n" );
        },
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
        setup => sub { $is_superuser = 1 },
        code => 409,
        complete => sub {
            my ( $data, $body ) = @_;
            check_error_message( $body,
                "A parameter \"sitePath\" is required.\n" );
            $is_superuser = 0;
        },
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
        setup => sub { $is_superuser = 1 },
        code => 409,
        complete => sub {
            my ( $data, $body ) = @_;
            check_error_message( $body, "Invalid theme_id: dummy\n" );
            $is_superuser = 0;
        },
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
        setup => sub { $is_superuser = 1 },
        code => 409,
        complete => sub {
            my ( $data, $body ) = @_;
            check_error_message( $body,
                "The website root directory must be absolute: relative\/path\n"
            );
            $is_superuser = 0;
        },
    },

    #   insert_new_website - normal tests
    {    # Minimal parameters.
        path      => '/v2/sites',
        method    => 'POST',
        setup     => sub { $is_superuser = 1 },
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
        params => {
            website => {
                name     => 'test-api-permission-website',
                url      => 'http://narnia2.na/',
                sitePath => $FindBin::Bin,
            },
        },
        complete => sub { $is_superuser = 0 },
    },
    {   path   => '/v2/sites',
        method => 'POST',
        setup  => sub { $is_superuser = 1 },
        params => {
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

            $is_superuser = 0;
        },
    },

    # insert_new_blog - irregular tests
    {    # website
        path     => '/v2/sites/1',
        method   => 'POST',
        code     => 400,
        complete => sub {
            my ( $data, $body ) = @_;
            check_error_message( $body,
                "Cannot create a blog under blog (ID:1)." );
        },
    },
    {    # No resource.
        path     => '/v2/sites/2',
        method   => 'POST',
        code     => 400,
        complete => sub {
            my ( $data, $body ) = @_;
            check_error_message( $body, "A resource \"blog\" is required." );
        },
    },
    {    # No url or subdomain.
        path     => '/v2/sites/2',
        method   => 'POST',
        params   => { blog => {}, },
        code     => 400,
        complete => sub {
            my ( $data, $body ) = @_;
            check_error_message( $body,
                "Either parameter of \"url\" or \"subdomain\" is required." );
        },
    },
    {    # No name.
        path     => '/v2/sites/2',
        method   => 'POST',
        params   => { blog => { url => 'blog', }, },
        code     => 409,
        complete => sub {
            my ( $data, $body ) = @_;
            check_error_message( $body,
                "A parameter \"name\" is required.\n" );
        },
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
        code     => 409,
        complete => sub {
            my ( $data, $body ) = @_;
            check_error_message( $body,
                "A parameter \"sitePath\" is required.\n" );
        },
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
        setup => sub { $is_superuser = 1 },
        code => 409,
        complete => sub {
            my ( $data, $body ) = @_;
            check_error_message( $body, "Invalid theme_id: invalid_theme\n" );
            $is_superuser = 0;
        },
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
        setup => sub { $is_superuser = 1 },
        code => 409,
        result => sub {
            +{  error => {
                    code => 409,
                    message =>
                        "Cannot apply website theme to blog: classic_website\n",
                },
            };
        },
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
        setup => sub { $is_superuser = 1 },
        callbacks => [

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
        complete => sub { $is_superuser = 0 },
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
        setup => sub { $is_superuser = 1 },
        callbacks => [

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
            sub { $app->model('blog')->load( { name => 'blog-2 name' } ) },
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

            $is_superuser = 0;
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
        setup => sub { $is_superuser = 1 },
        callbacks => [

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
            sub { $app->model('blog')->load( { name => 'blog-3 name' } ) },
        complete => sub {
            my ( $data, $body ) = @_;

            my $blog = $app->model('blog')->load( { name => 'blog-3 name' } );
            my $website = $blog->website or die;

            my $got = $app->current_format->{unserialize}->($body);

            is( $got->{themeId}, 'classic_blog', 'themeId' );
            is( $got->{name},    'blog-3 name',  'name' ),
                is( $got->{url}, 'http://www.narnia.na/blog-3/', 'url' );
            is( $got->{sitePath},     $FindBin::Bin, 'sitePath' );
            is( $got->{serverOffset}, 8,             'serverOffset' );
            is( $got->{language},     'nl',          'language' );

            $is_superuser = 0;
        },
    },

    # update_site - irregular tests
    {    # Non-existent site.
        path   => '/v2/sites/10',
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
                sitePath   => File::Spec->catfile( $FindBin::Bin, 'update' ),
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
        setup => sub { $is_superuser = 1 },
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
        result   => sub { $app->model('website')->load(2) },
        complete => sub {
            my ( $data, $body ) = @_;

            my $blog = $app->model('website')->load(2);

            my $got = $app->current_format->{unserialize}->($body);

            # General Settings scrren.
            is( $got->{name},         'update site',        'name' );
            is( $got->{description},  'update description', 'description' );
            is( $got->{serverOffset}, 3,                    'serverOffset' );
            is( $got->{language},     'fr',                 'language' );
            is( $got->{url}, 'http://www.sixapart.com/', 'url' );
            is( $got->{sitePath},
                File::Spec->catfile( $FindBin::Bin, 'update' ), 'sitePath' );
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
            is( $got->{useRevision},       1,   'useRevision' );       # true.
            is( $got->{maxRevisionsEntry}, 100, 'maxRevisionsEntry' );
            is( $got->{maxRevisionsTemplate}, 200, 'maxRevisionsTemplate' );

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
            is( $got->{allowPingsDefault}, 1, 'allowPingsDefault' );   # true.
            is( $got->{contentCss},   'css dummy', 'contentCss' );
            is( $got->{smartReplace}, 1,           'smartReplace' );
            is_deeply( $got->{smartReplaceFields},
                ['text'], 'smartReplaceFields' );

            # Feedback Settings screen.
            is( $got->{junkFolderExpiry},   10, 'junkfolderExpiry' );
            is( $got->{junkScoreThreshold}, -5, 'junkScoreThreshold' );
            is( $got->{nofollowUrls},       1,  'nofollowUrls' );      # true.
            is( $got->{followAuthLinks},    1,  'followAuthLinks' );   # true.
            is( $got->{allowComments},      1,  'allowComments' );     # true.
            is( $got->{moderateComments},   2,  'moderateComments' );
            is( $got->{allowCommentHtml},   1,  'allowCommentHtml' );  # true.
            is( $got->{sanitizeSpec},      'b,p',     'sanitizeSpec' );
            is( $got->{emailNewComments},  2,         'emailNewComments' );
            is( $got->{sortOrderComments}, 'descend', 'sortOrderComments' );
            is( $got->{autolinkUrls}, 1, 'autolinkUrls' );             # true.
            is( $got->{convertParasComments},
                'markdown', 'convertParasComments' );
            is( $got->{useCommentConfirmation}, 1, 'useCommentConfirmation' )
                ;                                                      # true.
            is( $got->{allowPings},        1, 'allowPings' );          # true.
            is( $got->{moderatePings},     1, 'moderatePings' );       # true.
            is( $got->{emailNewPings},     2, 'emailNewPings' );
            is( $got->{autodiscoverLinks}, 1, 'autodiscoverLinks' );   # true.
            is( $got->{internalAutodiscovery}, 1, 'internalAutodiscovery' )
                ;                                                      # true.
            is( $got->{allowUnregComments}, 1, 'allowUnregComments' ); # true.

            # Registration Settings screen.
            is( $got->{allowCommenterRegist}, 1, 'allowCommenterRegist' )
                ;                                                      # true.

            my $webmaster_role = $app->model('role')->load(6);    # Webmaster.
            is_deeply(
                $got->{newCreatedUserRoles},
                MT::DataAPI::Resource->from_object(
                    [$webmaster_role], [qw/ id name /]
                ),
                'newCreatedUserRoles'
            );

            is( $got->{allowUnregComments}, 1, 'allowUnregComments' ); # true.
            is( $got->{requireCommentEmails}, 1, 'requireCommentEmails' )
                ;                                                      # true.
            is_deeply( $got->{commenterAuthenticators},
                [qw/ WordPress Hatena /], 'commenterAuthenticators' );

            # Web Services Settings screen.
            is( $got->{pingGoogle},  1, 'pingGoogles' );               # true.
            is( $got->{pingWeblogs}, 1, 'pingWeblogs' );               # true.
            is_deeply( $got->{pingOthers}, [qw/ dummy_a dummy_b /],
                'pingOthers' );

            # Template tags.
            is( $got->{dateLanguage}, 'fr', 'dateLanguage' );

            # Publishing Profile screen.
            is( $got->{customDynamicTemplates},
                'all', 'customDynamicTemplates' );

            $is_superuser = 0;
        },
    },
    {    # website
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
        setup => sub { $is_superuser = 1 },
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
            is( $got->{allowPingsDefault}, 0, 'allowPingsDefault' );  # false.

            # Feedback Settings screen.
            is( $got->{nofollowUrls},     0, 'nofollowUrls' );        # false.
            is( $got->{followAuthLinks},  0, 'followAuthLinks' );     # false.
            is( $got->{allowComments},    0, 'allowComments' );       # false.
            is( $got->{allowCommentHtml}, 0, 'allowCommentsHtml' );   # false.
            is( $got->{autolinkUrls},     0, 'autolinkUrls' );        # false.
            is( $got->{useCommentConfirmation}, 0, 'useCommentConfirmation' )
                ;                                                     # false.
            is( $got->{allowPings},        0, 'allowPings' );         # false.
            is( $got->{moderatePings},     0, 'moderatePings' );      # false.
            is( $got->{autodiscoverLinks}, 0, 'autodiscoverLinks' );  # false.
            is( $got->{internalAutodiscovery}, 0, 'internalAutodiscovery' )
                ;                                                     # false.

            # Registration Settings screen.
            is( $got->{allowCommenterRegist}, 0, 'allowCommenterRegist' )
                ;                                                     # false.
            is( $got->{allowUnregComments}, 0, 'allowUnregComments' )
                ;                                                     # false.
            is( $got->{requireCommentEmails}, 0, 'requireCommentEmails' )
                ;                                                     # false.

            # Web Services Settings screen.
            is( $got->{pingGoogle},  0, 'pingGoogles' );              # false.
            is( $got->{pingWeblogs}, 0, 'pingWeblogs' );              # false.

            $is_superuser = 0;
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
                        'Website "update site" (ID:2) were not deleted. You need to delete blogs under the website first.',
                },
            };
        },
    },
    {    # Non-existent site.
        path   => '/v2/sites/10',
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
    {
        # website
        path   => '/v2/sites/2',
        method => 'DELETE',
        setup  => sub {
            my $website = $app->model('website')->load(2);
            die if !( $website && !$website->is_blog );
            for my $b ( $app->model('blog')->load( { parent_id => 2 } ) ) {
                $b->remove or die $b->errstr;
            }
        },
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
);

my $mock_mt = Test::MockModule->new('MT');
$mock_mt->mock(
    'run_callbacks',
    sub {
        my ( $app, $meth, @param ) = @_;
        $callbacks{$meth} ||= [];
        push @{ $callbacks{$meth} }, \@param;
        $mock_mt->original('run_callbacks')->(@_);
    }
);

my $format = MT::DataAPI::Format->find_format('json');

for my $data (@suite) {
    $data->{setup}->($data) if $data->{setup};

    my $path = $data->{path};
    $path
        =~ s/:(?:(\w+)_id)|:(\w+)/ref $data->{$1} ? $data->{$1}->id : $data->{$2}/ge;

    my $params
        = ref $data->{params} eq 'CODE'
        ? $data->{params}->($data)
        : $data->{params};

    my $note = $path;
    if ( lc $data->{method} eq 'get' && $data->{params} ) {
        $note .= '?'
            . join( '&',
            map { $_ . '=' . $data->{params}{$_} }
                keys %{ $data->{params} } );
    }
    $note .= ' ' . $data->{method};
    $note .= ' ' . $data->{note} if $data->{note};
    note($note);

    my $user = $data->{user} || $author;
    $user = $app->model('author')->load($user) unless ref $user;
    my $mock_app_api = Test::MockModule->new('MT::App::DataAPI');
    $mock_app_api->mock( 'authenticate', $user );

    %callbacks = ();
    _run_app(
        'MT::App::DataAPI',
        {   __path_info      => $path,
            __request_method => $data->{method},
            ( $data->{upload} ? ( __test_upload => $data->{upload} ) : () ),
            (   $params
                ? map {
                    $_ => ref $params->{$_}
                        ? MT::Util::to_json( $params->{$_} )
                        : $params->{$_};
                    }
                    keys %{$params}
                : ()
            ),
        }
    );
    my $out = delete $app->{__test_output};
    my ( $headers, $body ) = split /^\s*$/m, $out, 2;
    my %headers = map {
        my ( $k, $v ) = split /\s*:\s*/, $_, 2;
        $v =~ s/(\r\n|\r|\n)\z//;
        lc $k => $v
        }
        split /\n/, $headers;
    my $expected_status = $data->{code} || 200;
    is( $headers{status}, $expected_status, 'Status ' . $expected_status );
    if ( $data->{next_phase_url} ) {
        like(
            $headers{'x-mt-next-phase-url'},
            $data->{next_phase_url},
            'X-MT-Next-Phase-URL'
        );
    }

    foreach my $cb ( @{ $data->{callbacks} } ) {
        my $params_list = $callbacks{ $cb->{name} } || [];
        if ( my $params = $cb->{params} ) {
            for ( my $i = 0; $i < scalar(@$params); $i++ ) {
                is_deeply( $params_list->[$i], $cb->{params}[$i] );
            }
        }

        if ( my $c = $cb->{count} ) {
            is( @$params_list, $c,
                $cb->{name} . ' was called ' . $c . ' time(s)' );
        }
    }

    if ( my $expected_result = $data->{result} ) {
        $expected_result = $expected_result->( $data, $body )
            if ref $expected_result eq 'CODE';
        if ( UNIVERSAL::isa( $expected_result, 'MT::Object' ) ) {
            MT->instance->user($author);
            $expected_result = $format->{unserialize}->(
                $format->{serialize}->(
                    MT::DataAPI::Resource->from_object($expected_result)
                )
            );
        }

        my $result = $format->{unserialize}->($body);
        is_deeply( $result, $expected_result, 'result' );
    }

    if ( my $complete = $data->{complete} ) {
        $complete->( $data, $body );
    }
}

done_testing();

sub check_error_message {
    my ( $body, $error ) = @_;
    my $result = MT::Util::from_json($body);
    is( $result->{error}{message}, $error, 'Error message: ' . $error );
}
