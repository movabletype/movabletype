#!/usr/bin/perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";    # t/lib
use Test::More;
use Test::MockModule;
use MT::Test::Env;
our $test_env;

package MT::Test::DataAPI::Stats::Provider;

use base qw(MT::Stats::Provider);

sub is_ready {1}

sub pageviews_for_path {
    my $self = shift;
    my ( $app, $params ) = @_;

    my $fileinfo
        = $app->model('fileinfo')
        ->load( { blog_id => $app->blog->id }, { limit => 1 } );

    my $startdate = $fileinfo->startdate;
    $startdate =~ s/(\d{4})(\d{2})(\d{2}).*/$1-$2-$3/ if defined $startdate;

    my $item = {
        archiveType => $fileinfo->archive_type,
        path        => $fileinfo->url,
    };
    $item->{entry}{id}    = $fileinfo->entry_id    if $fileinfo->entry_id;
    $item->{category}{id} = $fileinfo->category_id if $fileinfo->category_id;
    $item->{author}{id}   = $fileinfo->author_id   if $fileinfo->author_id;

    return { 'items' => [$item] };
}

package main;

use constant REPEAT_1 =>
    '1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111';
use constant CYCLE_0_9 =>
    '0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789';
use constant INT32_MIN => -2147483648;
use constant INT32_MAX => 2147483647;
use constant INT64_MIN => -9223372036854775808;
use constant INT64_MAX => 9223372036854775807;

BEGIN {
    $test_env = MT::Test::Env->new(
        DefaultLanguage => 'en_US',  ## for now
    );
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT::Test::DataAPI;
use MT::Test::Permission;
use File::Path 'remove_tree';

$test_env->prepare_fixture('db_data');

use MT::App::DataAPI;
my $app = MT::App::DataAPI->new;

my $blog    = $app->model('blog')->load;
my $website = $app->model('website')->load;

my $website_category
    = MT::Test::Permission->make_category( blog_id => $website->id, );
my $cat = MT->model('category')->load(1);
my $folder = $app->model('folder')->load( { blog_id => $blog->id, } );

my $author = MT->model('author')->load(1);

my $mock_stats = Test::MockModule->new('MT::Stats');
$mock_stats->mock( 'readied_provider',
    sub {'MT::Test::DataAPI::Stats::Provider'} );

my @extra_permissions;
if ($test_env->addon_exists('Sync.pack')) {
    @extra_permissions = qw(manage_content_sync);
}

my $suite = suite();
test_data_api($suite);

done_testing;

sub suite {
    return +[

        # list_entries_for_category - limit - zero
        {   path     => '/v2/sites/1/categories/' . $cat->id . '/entries',
            method   => 'GET',
            params   => { limit => 0, },
            code     => 200,
            complete => sub {
                my ( $data, $body ) = @_;
                my $result = MT::Util::from_json($body);

                my @entries = MT->model('entry')->load(
                    { class => 'entry' },
                    {   join => MT->model('placement')->join_on(
                            'entry_id',
                            {   blog_id     => $cat->blog_id,
                                category_id => $cat->id,
                            },
                        ),
                    }
                );

                is( $result->{totalResults},
                    scalar @entries,
                    'Category has '
                        . scalar @entries
                        . 'entries - limit - one'
                );
            },
        },

        # list_entries_for_category - offset - zero
        {   path     => '/v2/sites/1/categories/' . $cat->id . '/entries',
            method   => 'GET',
            params   => { offset => 0, },
            code     => 200,
            complete => sub {
                my ( $data, $body ) = @_;
                my $result = MT::Util::from_json($body);

                my @entries = MT->model('entry')->load(
                    { class => 'entry' },
                    {   join => MT->model('placement')->join_on(
                            'entry_id',
                            {   blog_id     => $cat->blog_id,
                                category_id => $cat->id,
                            },
                        ),
                        limit  => 50,
                        offset => 0,
                    }
                );

                is( $result->{totalResults},
                    scalar @entries,
                    'Category has '
                        . scalar @entries
                        . 'entries - limit - one'
                );
            },
        },

        # list_entries_for_category - limit - one
        {   path     => '/v2/sites/1/categories/' . $cat->id . '/entries',
            method   => 'GET',
            params   => { limit => 1, },
            code     => 200,
            complete => sub {
                my ( $data, $body ) = @_;
                my $result = MT::Util::from_json($body);

                my @entries = MT->model('entry')->load(
                    { class => 'entry' },
                    {   join => MT->model('placement')->join_on(
                            'entry_id',
                            {   blog_id     => $cat->blog_id,
                                category_id => $cat->id,
                            },
                        ),
                    }
                );

                is( $result->{totalResults},
                    scalar @entries,
                    'Category has '
                        . scalar @entries
                        . 'entries - limit - one'
                );
            },
        },

        # list_entries_for_category - offset - one
        {   path   => '/v2/sites/1/categories/' . $cat->id . '/entries',
            method => 'GET',
            params => { offset => 1, },
            code   => 500,
            error  => qr/An error occurred while loading objects/,
        },

        # list_entries_for_category - limit - '1'*100
        {   path   => '/v2/sites/1/categories/' . $cat->id . '/entries',
            method => 'GET',
            params => { limit => REPEAT_1, },
            code   => 500,
            error =>
                qr/limit must be an integer and between 1 and 2147483647./,
        },

        # list_entries_for_category - offset - '1'*100
        {   path   => '/v2/sites/1/categories/' . $cat->id . '/entries',
            method => 'GET',
            params => { offset => REPEAT_1, },
            code   => 500,
            error =>
                qr/offset must be an integer and between 0 and 2147483647./,
        },

        # list_entries_for_category - limit - '0-9'*10
        {   path   => '/v2/sites/1/categories/' . $cat->id . '/entries',
            method => 'GET',
            params => { limit => CYCLE_0_9, },
            code   => 500,
            error =>
                qr/limit must be an integer and between 1 and 2147483647./,
        },

        # list_entries_for_category - offset - '0-9'*10
        {   path   => '/v2/sites/1/categories/' . $cat->id . '/entries',
            method => 'GET',
            params => { offset => CYCLE_0_9, },
            code   => 500,
            error =>
                qr/offset must be an integer and between 0 and 2147483647./,
        },

        # list_entries_for_category - limit - Int32 Min
        {   path   => '/v2/sites/1/categories/' . $cat->id . '/entries',
            method => 'GET',
            params => { limit => INT32_MIN, },
            code   => 500,
            error  => qr/limit must be a number./,
        },

        # list_entries_for_category - offset - Int32 Min
        {   path   => '/v2/sites/1/categories/' . $cat->id . '/entries',
            method => 'GET',
            params => { offset => INT32_MIN, },
            code   => 500,
            error  => qr/offset must be a number./,
        },

        # list_entries_for_category - limit - Int32 Max
        {   path     => '/v2/sites/1/categories/' . $cat->id . '/entries',
            method   => 'GET',
            params   => { limit => INT32_MAX, },
            code     => 200,
            complete => sub {
                my ( $data, $body ) = @_;
                my $result = MT::Util::from_json($body);

                my @entries = MT->model('entry')->load(
                    { class => 'entry' },
                    {   join => MT->model('placement')->join_on(
                            'entry_id',
                            {   blog_id     => $cat->blog_id,
                                category_id => $cat->id,
                            },
                        ),
                    }
                );

                is( $result->{totalResults},
                    scalar @entries,
                    'Category has '
                        . scalar @entries
                        . 'entries - limit - Int32 Max'
                );
            },
        },

        # list_entries_for_category - offset - Int32 Max
        {   path   => '/v2/sites/1/categories/' . $cat->id . '/entries',
            method => 'GET',
            params => { offset => INT32_MAX, },
            code   => 500,
            error  => qr/An error occurred while loading objects/,
        },

        # list_entries_for_category - limit - Int64 Min
        {   path   => '/v2/sites/1/categories/' . $cat->id . '/entries',
            method => 'GET',
            params => { limit => INT64_MIN, },
            code   => 500,
            error  => qr/limit must be a number./,
        },

        # list_entries_for_category - offset - Int64 Min
        {   path   => '/v2/sites/1/categories/' . $cat->id . '/entries',
            method => 'GET',
            params => { offset => INT64_MIN, },
            code   => 500,
            error  => qr/offset must be a number./,
        },

        # list_entries_for_category - limit - Int64 Max
        {   path   => '/v2/sites/1/categories/' . $cat->id . '/entries',
            method => 'GET',
            params => { limit => INT64_MAX, },
            code   => 500,
            error =>
                qr/limit must be an integer and between 1 and 2147483647./,
        },

        # list_entries_for_category - offset - Int64 Max
        {   path   => '/v2/sites/1/categories/' . $cat->id . '/entries',
            method => 'GET',
            params => { offset => INT64_MAX, },
            code   => 500,
            error =>
                qr/offset must be an integer and between 0 and 2147483647./,
        },

        # list_entries_for_category - limit - Decimal
        {   path   => '/v2/sites/1/categories/' . $cat->id . '/entries',
            method => 'GET',
            params => { limit => 0.6, },
            code   => 500,
            error  => qr/limit must be a number./,
        },

        # list_entries_for_category - offset - Decimal
        {   path   => '/v2/sites/1/categories/' . $cat->id . '/entries',
            method => 'GET',
            params => { offset => 0.6, },
            code   => 500,
            error  => qr/offset must be a number./,
        },

        # list_entries_for_category - limit - index
        {   path   => '/v2/sites/1/categories/' . $cat->id . '/entries',
            method => 'GET',
            params => { limit => '0e0', },
            code   => 500,
            error  => qr/limit must be a number./,
        },

        # list_entries_for_category - offset - index
        {   path   => '/v2/sites/1/categories/' . $cat->id . '/entries',
            method => 'GET',
            params => { offset => '0e0', },
            code   => 500,
            error  => qr/offset must be a number./,
        },

        # list_entries_for_category - limit - Infinity
        {   path   => '/v2/sites/1/categories/' . $cat->id . '/entries',
            method => 'GET',
            params => { limit => 'inf', },
            code   => 500,
            error  => qr/limit must be a number./,
        },

        # list_entries_for_category - offset - Infinity
        {   path   => '/v2/sites/1/categories/' . $cat->id . '/entries',
            method => 'GET',
            params => { offset => 'inf', },
            code   => 500,
            error  => qr/offset must be a number./,
        },

        # list_entries_for_category - limit - ascii only
        {   path   => '/v2/sites/1/categories/' . $cat->id . '/entries',
            method => 'GET',
            params => { limit => 'a', },
            code   => 500,
            error  => qr/limit must be a number./,
        },

        # list_entries_for_category - offset - ascii only
        {   path   => '/v2/sites/1/categories/' . $cat->id . '/entries',
            method => 'GET',
            params => { offset => 'a', },
            code   => 500,
            error  => qr/offset must be a number./,
        },

        # list_entries_for_category - limit - number, ascii and symbol
        {   path   => '/v2/sites/1/categories/' . $cat->id . '/entries',
            method => 'GET',
            params =>
                { limit => ';waerhpawe8y97342;jrn;fkadsu9p84378325p-', },
            code  => 500,
            error => qr/limit must be a number./,
        },

        # list_entries_for_category - offset - number, ascii and symbol
        {   path   => '/v2/sites/1/categories/' . $cat->id . '/entries',
            method => 'GET',
            params => { offset => '324978009-2309j;adjfjk90238475	[\'p;a', },
            code   => 500,
            error  => qr/offset must be a number./,
        },

        # list_pages_for_folder - limit - zero
        {   path     => '/v2/sites/1/folders/' . $folder->id . '/pages',
            method   => 'GET',
            params   => { limit => 0, },
            code     => 200,
            complete => sub {
                my ( $data, $body ) = @_;
                my $result = MT::Util::from_json($body);

                my @pages = MT->model('page')->load(
                    { class => 'page' },
                    {   join => MT->model('placement')->join_on(
                            'entry_id',
                            {   blog_id     => $folder->blog_id,
                                category_id => $folder->id,
                            },
                        ),
                    },
                    limit => 50,
                );

                is( $result->{totalResults},
                    scalar @pages,
                    'Folder has ' . scalar @pages . 'pages'
                );
            },
        },

        # list_pages_for_folder - offset - zero
        {   path     => '/v2/sites/1/folders/' . $folder->id . '/pages',
            method   => 'GET',
            params   => { offset => 0, },
            code     => 200,
            complete => sub {
                my ( $data, $body ) = @_;
                my $result = MT::Util::from_json($body);

                my @pages = MT->model('page')->load(
                    { class => 'page' },
                    {   join => MT->model('placement')->join_on(
                            'entry_id',
                            {   blog_id     => $folder->blog_id,
                                category_id => $folder->id,
                            },
                        ),
                        limit  => 50,
                        offset => 0,
                    }
                );

                is( $result->{totalResults},
                    scalar @pages,
                    'Folder has ' . scalar @pages . ' pages'
                );
            },
        },

        # list_pages_for_folder - limit - one
        {   path     => '/v2/sites/1/folders/' . $folder->id . '/pages',
            method   => 'GET',
            params   => { limit => 1, },
            code     => 200,
            complete => sub {
                my ( $data, $body ) = @_;
                my $result = MT::Util::from_json($body);

                my @pages = MT->model('page')->load(
                    { class => 'page' },
                    {   join => MT->model('placement')->join_on(
                            'entry_id',
                            {   blog_id     => $folder->blog_id,
                                category_id => $folder->id,
                            },
                        ),
                    },
                );

                is( $result->{totalResults},
                    scalar @pages,
                    'Folders has ' . scalar @pages . ' pages - limit - one'
                );
            },
        },

        # list_pages_for_folder - offset - one
        {   path   => '/v2/sites/1/folders/' . $folder->id . '/pages',
            method => 'GET',
            params => { offset => 1, },
            code   => 500,
            error  => qr/An error occurred while loading objects/,
        },

        # list_pages_for_folder - limit - '1'*100
        {   path   => '/v2/sites/1/folders/' . $folder->id . '/pages',
            method => 'GET',
            params => { limit => REPEAT_1, },
            code   => 500,
            error =>
                qr/limit must be an integer and between 1 and 2147483647./,
        },

        # list_pages_for_folder - offset - '1'*100
        {   path   => '/v2/sites/1/folders/' . $folder->id . '/pages',
            method => 'GET',
            params => { offset => REPEAT_1, },
            code   => 500,
            error =>
                qr/offset must be an integer and between 0 and 2147483647./,
        },

        # list_pages_for_folder - limit - '0-9'*10
        {   path   => '/v2/sites/1/folders/' . $folder->id . '/pages',
            method => 'GET',
            params => { limit => CYCLE_0_9, },
            code   => 500,
            error =>
                qr/limit must be an integer and between 1 and 2147483647./,
        },

        # list_pages_for_folder - offset - '0-9'*10
        {   path   => '/v2/sites/1/folders/' . $folder->id . '/pages',
            method => 'GET',
            params => { offset => CYCLE_0_9, },
            code   => 500,
            error =>
                qr/offset must be an integer and between 0 and 2147483647./,
        },

        # list_pages_for_folder - limit - Int32 Min
        {   path   => '/v2/sites/1/folders/' . $folder->id . '/pages',
            method => 'GET',
            params => { limit => INT32_MIN, },
            code   => 500,
            error  => qr/limit must be a number./,
        },

        # list_pages_for_folder - offset - Int32 Min
        {   path   => '/v2/sites/1/folders/' . $folder->id . '/pages',
            method => 'GET',
            params => { offset => INT32_MIN, },
            code   => 500,
            error  => qr/offset must be a number./,
        },

        # list_pages_for_folder - limit - Int32 Max
        {   path     => '/v2/sites/1/folders/' . $folder->id . '/pages',
            method   => 'GET',
            params   => { limit => INT32_MAX, },
            code     => 200,
            complete => sub {
                my ( $data, $body ) = @_;
                my $result = MT::Util::from_json($body);

                my @pages = MT->model('page')->load(
                    { class => 'page' },
                    {   join => MT->model('placement')->join_on(
                            'entry_id',
                            {   blog_id     => $folder->blog_id,
                                category_id => $folder->id,
                            },
                        ),
                        limit => INT32_MAX,
                    }
                );

                is( $result->{totalResults},
                    scalar @pages,
                    'Folder has '
                        . scalar @pages
                        . ' pages - limit - Int32 Max'
                );
            },
        },

        # list_pages_for_folder - offset - Int32 Max
        {   path   => '/v2/sites/1/folders/' . $folder->id . '/pages',
            method => 'GET',
            params => { offset => INT32_MAX, },
            code   => 500,
            error  => qr/An error occurred while loading objects/,
        },

        # list_pages_for_folder - limit - Int64 Min
        {   path   => '/v2/sites/1/folders/' . $folder->id . '/pages',
            method => 'GET',
            params => { limit => INT64_MIN, },
            code   => 500,
            error  => qr/limit must be a number./,
        },

        # list_pages_for_folder - offset - Int64 Min
        {   path   => '/v2/sites/1/folders/' . $folder->id . '/pages',
            method => 'GET',
            params => { offset => INT64_MIN, },
            code   => 500,
            error  => qr/offset must be a number./,
        },

        # list_pages_for_folder - limit - Int64 Max
        {   path   => '/v2/sites/1/folders/' . $folder->id . '/pages',
            method => 'GET',
            params => { limit => INT64_MAX, },
            code   => 500,
            error =>
                qr/limit must be an integer and between 1 and 2147483647./,
        },

        # list_pages_for_folder - offset - Int64 Max
        {   path   => '/v2/sites/1/folders/' . $folder->id . '/pages',
            method => 'GET',
            params => { offset => INT64_MAX, },
            code   => 500,
            error =>
                qr/offset must be an integer and between 0 and 2147483647./,
        },

        # list_pages_for_folder - limit - Decimal
        {   path   => '/v2/sites/1/folders/' . $folder->id . '/pages',
            method => 'GET',
            params => { limit => 0.6, },
            code   => 500,
            error  => qr/limit must be a number./,
        },

        # list_pages_for_folder - offset - Decimal
        {   path   => '/v2/sites/1/folders/' . $folder->id . '/pages',
            method => 'GET',
            params => { offset => 0.6, },
            code   => 500,
            error  => qr/offset must be a number./,
        },

        # list_pages_for_folder - limit - index
        {   path   => '/v2/sites/1/folders/' . $folder->id . '/pages',
            method => 'GET',
            params => { limit => '0e0', },
            code   => 500,
            error  => qr/limit must be a number./,
        },

        # list_pages_for_folder - offset - index
        {   path   => '/v2/sites/1/folders/' . $folder->id . '/pages',
            method => 'GET',
            params => { offset => '0e0', },
            code   => 500,
            error  => qr/offset must be a number./,
        },

        # list_pages_for_folder - limit - Infinity
        {   path   => '/v2/sites/1/folders/' . $folder->id . '/pages',
            method => 'GET',
            params => { limit => 'inf', },
            code   => 500,
            error  => qr/limit must be a number./,
        },

        # list_pages_for_folder - offset - Infinity
        {   path   => '/v2/sites/1/folders/' . $folder->id . '/pages',
            method => 'GET',
            params => { offset => 'inf', },
            code   => 500,
            error  => qr/offset must be a number./,
        },

        # list_pages_for_folder - limit - ascii only
        {   path   => '/v2/sites/1/folders/' . $folder->id . '/pages',
            method => 'GET',
            params => { limit => 'a', },
            code   => 500,
            error  => qr/limit must be a number./,
        },

        # list_pages_for_folder - offset - ascii only
        {   path   => '/v2/sites/1/folders/' . $folder->id . '/pages',
            method => 'GET',
            params => { offset => 'a', },
            code   => 500,
            error  => qr/offset must be a number./,
        },

        # list_pages_for_folder - limit - number, ascii and symbol
        {   path   => '/v2/sites/1/folders/' . $folder->id . '/pages',
            method => 'GET',
            params => {
                limit =>
                    '-4721348321=pqwei;rjdsafhwy8734  2893470q3weph--=$$&&',
            },
            code  => 500,
            error => qr/limit must be a number./,
        },

        # list_pages_for_folder - offset - number, ascii and symbol
        {   path   => '/v2/sites/1/folders/' . $folder->id . '/pages',
            method => 'GET',
            params => { offset => 'we07452q39400a-sdf[\'l Slkjd', },
            code   => 500,
            error  => qr/offset must be a number./,
        },

        # permission - limit - zero
        {   path         => '/v1/users/me/permissions',
            method       => 'GET',
            is_superuser => 1,
            params       => { limit => 0, },
            code         => 500,
            error =>
                qr/limit must be an integer and between 1 and 2147483647./,
        },

        # permission - offset - zero
        {   path         => '/v1/users/me/permissions',
            method       => 'GET',
            is_superuser => 1,
            params       => { offset => 0, },
            result       => +{
                'totalResults' => 3,
                'items'        => [
                    {   'permissions' => [
                            'administer',           'create_blog',
                            'create_site',          'create_website',
                            'edit_templates',       'manage_content_data',
                            'manage_content_types', 'manage_plugins',
                            'manage_users_groups',  'sign_in_cms',
                            'sign_in_data_api',     'view_log'
                        ],
                        'blog' => undef
                    },
                    {   'permissions' => [
                            sort
                            'administer_blog',     'administer_site',
                            'administer_website',  'comment',
                            'create_post',         'create_site',
                            'edit_all_posts',      'edit_assets',
                            'edit_categories',     'edit_config',
                            'edit_notifications',  'edit_tags',
                            'edit_templates',      'manage_category_set',
                            'manage_content_data', 'manage_content_types',
                            'manage_feedback',     'manage_member_blogs',
                            'manage_pages',        'manage_themes',
                            'manage_users',        'publish_post',
                            'rebuild',             'send_notifications',
                            'set_publish_paths',   'upload',
                            'view_blog_log',
                            @extra_permissions,
                        ],
                        'blog' => { 'id' => '1' }
                    },
                    {   'permissions' => [
                            sort
                            'administer_blog',     'administer_site',
                            'administer_website',  'comment',
                            'create_post',         'create_site',
                            'edit_all_posts',      'edit_assets',
                            'edit_categories',     'edit_config',
                            'edit_notifications',  'edit_tags',
                            'edit_templates',      'manage_category_set',
                            'manage_content_data', 'manage_content_types',
                            'manage_feedback',     'manage_member_blogs',
                            'manage_pages',        'manage_themes',
                            'manage_users',        'publish_post',
                            'rebuild',             'send_notifications',
                            'set_publish_paths',   'upload',
                            'view_blog_log',
                            @extra_permissions,
                        ],
                        'blog' => { 'id' => '2' }
                    }
                ]
            },
        },

        # permission - limit - one
        {   path         => '/v1/users/me/permissions',
            method       => 'GET',
            is_superuser => 1,
            params       => { limit => 1, },
            code         => 200,
            result       => +{
                'totalResults' => 3,
                'items'        => [
                    {   'permissions' => [
                            'administer',           'create_blog',
                            'create_site',          'create_website',
                            'edit_templates',       'manage_content_data',
                            'manage_content_types', 'manage_plugins',
                            'manage_users_groups',  'sign_in_cms',
                            'sign_in_data_api',     'view_log'
                        ],
                        'blog' => undef
                    },
                ]
            },
        },

        # permission - offset - one
        {   path         => '/v1/users/me/permissions',
            method       => 'GET',
            is_superuser => 1,
            params       => { offset => 1, },
            result       => +{
                'totalResults' => 3,
                'items'        => [
                    {   'permissions' => [
                            sort
                            'administer_blog',     'administer_site',
                            'administer_website',  'comment',
                            'create_post',         'create_site',
                            'edit_all_posts',      'edit_assets',
                            'edit_categories',     'edit_config',
                            'edit_notifications',  'edit_tags',
                            'edit_templates',      'manage_category_set',
                            'manage_content_data', 'manage_content_types',
                            'manage_feedback',     'manage_member_blogs',
                            'manage_pages',        'manage_themes',
                            'manage_users',        'publish_post',
                            'rebuild',             'send_notifications',
                            'set_publish_paths',   'upload',
                            'view_blog_log',
                            @extra_permissions,
                        ],
                        'blog' => { 'id' => '1' }
                    },
                    {   'permissions' => [
                            sort
                            'administer_blog',     'administer_site',
                            'administer_website',  'comment',
                            'create_post',         'create_site',
                            'edit_all_posts',      'edit_assets',
                            'edit_categories',     'edit_config',
                            'edit_notifications',  'edit_tags',
                            'edit_templates',      'manage_category_set',
                            'manage_content_data', 'manage_content_types',
                            'manage_feedback',     'manage_member_blogs',
                            'manage_pages',        'manage_themes',
                            'manage_users',        'publish_post',
                            'rebuild',             'send_notifications',
                            'set_publish_paths',   'upload',
                            'view_blog_log',
                            @extra_permissions,
                        ],
                        'blog' => { 'id' => '2' }
                    }
                ]
            },
        },

        # permission - limit - '1'*100
        {   path         => '/v1/users/me/permissions',
            method       => 'GET',
            is_superuser => 1,
            params       => { limit => REPEAT_1, },
            code         => 500,
            error =>
                qr/limit must be an integer and between 1 and 2147483647./,
        },

        # permission - offset - '1'*100
        {   path         => '/v1/users/me/permissions',
            method       => 'GET',
            is_superuser => 1,
            params       => { offset => REPEAT_1, },
            code         => 500,
            error =>
                qr/offset must be an integer and between 0 and 2147483647./,
        },

        # permission - limit - '0-9'*10
        {   path         => '/v1/users/me/permissions',
            method       => 'GET',
            is_superuser => 1,
            params       => { limit => CYCLE_0_9, },
            code         => 500,
            error =>
                qr/limit must be an integer and between 1 and 2147483647./,
        },

        # permission - offset - '0-9'*10
        {   path         => '/v1/users/me/permissions',
            method       => 'GET',
            is_superuser => 1,
            params       => { offset => CYCLE_0_9, },
            code         => 500,
            error =>
                qr/offset must be an integer and between 0 and 2147483647./,
        },

        # permission - limit - Int32 Min
        {   path         => '/v1/users/me/permissions',
            method       => 'GET',
            is_superuser => 1,
            params       => { limit => INT32_MIN, },
            code         => 500,
            error        => qr/limit must be a number./,
        },

        # permission - offset - Int32 Min
        {   path         => '/v1/users/me/permissions',
            method       => 'GET',
            is_superuser => 1,
            params       => { offset => INT32_MIN, },
            code         => 500,
            error        => qr/offset must be a number./,
        },

        # permission - limit - Int32 Max
        {   path         => '/v1/users/me/permissions',
            method       => 'GET',
            is_superuser => 1,
            params       => { limit => INT32_MAX, },
            code         => 200,
            result       => +{
                'totalResults' => 3,
                'items'        => [
                    {   'permissions' => [
                            'administer',           'create_blog',
                            'create_site',          'create_website',
                            'edit_templates',       'manage_content_data',
                            'manage_content_types', 'manage_plugins',
                            'manage_users_groups',  'sign_in_cms',
                            'sign_in_data_api',     'view_log'
                        ],
                        'blog' => undef
                    },
                    {   'permissions' => [
                            sort
                            'administer_blog',     'administer_site',
                            'administer_website',  'comment',
                            'create_post',         'create_site',
                            'edit_all_posts',      'edit_assets',
                            'edit_categories',     'edit_config',
                            'edit_notifications',  'edit_tags',
                            'edit_templates',      'manage_category_set',
                            'manage_content_data', 'manage_content_types',
                            'manage_feedback',     'manage_member_blogs',
                            'manage_pages',        'manage_themes',
                            'manage_users',        'publish_post',
                            'rebuild',             'send_notifications',
                            'set_publish_paths',   'upload',
                            'view_blog_log',
                            @extra_permissions,
                        ],
                        'blog' => { 'id' => '1' }
                    },
                    {   'permissions' => [
                            sort
                            'administer_blog',     'administer_site',
                            'administer_website',  'comment',
                            'create_post',         'create_site',
                            'edit_all_posts',      'edit_assets',
                            'edit_categories',     'edit_config',
                            'edit_notifications',  'edit_tags',
                            'edit_templates',      'manage_category_set',
                            'manage_content_data', 'manage_content_types',
                            'manage_feedback',     'manage_member_blogs',
                            'manage_pages',        'manage_themes',
                            'manage_users',        'publish_post',
                            'rebuild',             'send_notifications',
                            'set_publish_paths',   'upload',
                            'view_blog_log',
                            @extra_permissions,
                        ],
                        'blog' => { 'id' => '2' }
                    }
                ]
            },
        },

        # permission - offset - Int32 Max
        {   path         => '/v1/users/me/permissions',
            method       => 'GET',
            is_superuser => 1,
            params       => { offset => INT32_MAX, },
            code         => 500,
            error        => qr/An error occurred while loading objects/,
        },

        # permission - limit - Int64 Min
        {   path         => '/v1/users/me/permissions',
            method       => 'GET',
            is_superuser => 1,
            params       => { limit => INT64_MIN, },
            code         => 500,
            error        => qr/limit must be a number./,
        },

        # permission - offset - Int64 Min
        {   path         => '/v1/users/me/permissions',
            method       => 'GET',
            is_superuser => 1,
            params       => { offset => INT64_MIN, },
            code         => 500,
            error        => qr/offset must be a number./,
        },

        # permission - limit - Int64 Max
        {   path         => '/v1/users/me/permissions',
            method       => 'GET',
            is_superuser => 1,
            params       => { limit => INT64_MAX, },
            code         => 500,
            error =>
                qr/limit must be an integer and between 1 and 2147483647./,
        },

        # permission - offset - Int64 Max
        {   path         => '/v1/users/me/permissions',
            method       => 'GET',
            is_superuser => 1,
            params       => { offset => INT64_MAX, },
            code         => 500,
            error =>
                qr/offset must be an integer and between 0 and 2147483647./,
        },

        # permission - limit - Decimal
        {   path         => '/v1/users/me/permissions',
            method       => 'GET',
            is_superuser => 1,
            params       => { limit => 0.6, },
            code         => 500,
            error        => qr/limit must be a number./,
        },

        # permission - offset - Decimal
        {   path         => '/v1/users/me/permissions',
            method       => 'GET',
            is_superuser => 1,
            params       => { offset => 0.6, },
            code         => 500,
            error        => qr/offset must be a number./,
        },

        # permission - limit - index
        {   path         => '/v1/users/me/permissions',
            method       => 'GET',
            is_superuser => 1,
            params       => { limit => '0e0', },
            code         => 500,
            error        => qr/limit must be a number./,
        },

        # permission - offset - index
        {   path         => '/v1/users/me/permissions',
            method       => 'GET',
            is_superuser => 1,
            params       => { offset => '0e0', },
            code         => 500,
            error        => qr/offset must be a number./,
        },

        # permission - limit - Infinity
        {   path         => '/v1/users/me/permissions',
            method       => 'GET',
            is_superuser => 1,
            params       => { limit => 'inf', },
            code         => 500,
            error        => qr/limit must be a number./,
        },

        # permission - offset - Infinity
        {   path         => '/v1/users/me/permissions',
            method       => 'GET',
            is_superuser => 1,
            params       => { offset => 'inf', },
            code         => 500,
            error        => qr/offset must be a number./,
        },

        # permission - limit - ascii only
        {   path         => '/v1/users/me/permissions',
            method       => 'GET',
            is_superuser => 1,
            params       => { limit => 'a', },
            code         => 500,
            error        => qr/limit must be a number./,
        },

        # permission - offset - ascii only
        {   path         => '/v1/users/me/permissions',
            method       => 'GET',
            is_superuser => 1,
            params       => { offset => 'a', },
            code         => 500,
            error        => qr/offset must be a number./,
        },

        # permission - limit - ascii and symbol
        {   path         => '/v1/users/me/permissions',
            method       => 'GET',
            is_superuser => 1,
            params       => {
                limit =>
                    'oasidjfpiowaherphjwealrfiwae98r08239471\'qrwe;iioupqewury8q70t23ou	',
            },
            code  => 500,
            error => qr/limit must be a number./,
        },

        # permission - offset - ascii and symbol
        {   path         => '/v1/users/me/permissions',
            method       => 'GET',
            is_superuser => 1,
            params       => {
                offset =>
                    'dsiaurph;jkwerhpaio328974632807hip;\'k`1!~~))*&^(*%',
            },
            code  => 500,
            error => qr/offset must be a number./,
        },

        # stats - limit - zero
        {   path   => '/v1/sites/1/stats/path/pageviews',
            method => 'GET',
            params => { limit => 0, },
            code   => 500,
            error =>
                qr/limit must be an integer and between 1 and 2147483647./,
        },

        # stats - offset - zero
        {   path     => '/v1/sites/1/stats/path/pageviews',
            method   => 'GET',
            params   => { offset => 0, },
            code     => 200,
            complete => sub {
                my ( $data, $body ) = @_;
                my $result = MT::Util::from_json($body);

                my $fileinfo
                    = $app->model('fileinfo')
                    ->load( { blog_id => $app->blog->id }, { limit => 1 } );

                my $items = $result->{items}[0];
                is( $items->{entry}{id},
                    $fileinfo->entry_id, 'stats - offset - zero - entry' );
                is( $items->{path}, $fileinfo->url,
                    'stats - offset - zero - path' );
                is( $items->{category}, $fileinfo->category_id,
                    'stats - offset - zero - category' );
                is( $items->{author}, $fileinfo->author_id,
                    'stats - offset - zero - author' );
                is( $items->{archiveType}, $fileinfo->archive_type,
                    'stats - offset - zero - archiveType' );
                is( $items->{startDate}, $fileinfo->startdate,
                    'stats - offset - zero - startDate' );
            },
        },

        # stats - limit - one
        {   path   => '/v1/sites/1/stats/path/pageviews',
            method => 'GET',
            params => { limit => 1, },
            code   => 200,
            result => +{
                'items' => [
                    {   'entry' => { 'id' => '23' },
                        'path'        => '/nana/download/nightly/page-3.html',
                        'category'    => undef,
                        'author'      => undef,
                        'archiveType' => 'Page',
                        'startDate'   => undef
                    }
                ]
            },
        },

        # stats - offset - one
        {   path     => '/v1/sites/1/stats/path/pageviews',
            method   => 'GET',
            params   => { offset => 0, },
            code     => 200,
            complete => sub {
                my ( $data, $body ) = @_;
                my $result = MT::Util::from_json($body);

                my $fileinfo
                    = $app->model('fileinfo')
                    ->load( { blog_id => $app->blog->id }, { limit => 1 } );

                my $items = $result->{items}[0];
                is( $items->{entry}{id},
                    $fileinfo->entry_id, 'stats - offset - zero - entry' );
                is( $items->{path}, $fileinfo->url,
                    'stats - offset - zero - path' );
                is( $items->{category}, $fileinfo->category_id,
                    'stats - offset - zero - category' );
                is( $items->{author}, $fileinfo->author_id,
                    'stats - offset - zero - author' );
                is( $items->{archiveType}, $fileinfo->archive_type,
                    'stats - offset - zero - archiveType' );
                is( $items->{startDate}, $fileinfo->startdate,
                    'stats - offset - zero - startDate' );
            },
        },

        # stats - limit - '1'*100
        {   path   => '/v1/sites/1/stats/path/pageviews',
            method => 'GET',
            params => { limit => REPEAT_1, },
            code   => 500,
            error =>
                qr/limit must be an integer and between 1 and 2147483647./,
        },

        # stats - offset - '1'*100
        {   path   => '/v1/sites/1/stats/path/pageviews',
            method => 'GET',
            params => { offset => REPEAT_1, },
            code   => 500,
            error =>
                qr/offset must be an integer and between 0 and 2147483647./,
        },

        # stats - limit - '0-9'*10
        {   path   => '/v1/sites/1/stats/path/pageviews',
            method => 'GET',
            params => { limit => CYCLE_0_9, },
            code   => 500,
            error =>
                qr/limit must be an integer and between 1 and 2147483647./,
        },

        # stats - offset - '0-9'*10
        {   path   => '/v1/sites/1/stats/path/pageviews',
            method => 'GET',
            params => { offset => CYCLE_0_9, },
            code   => 500,
            error =>
                qr/offset must be an integer and between 0 and 2147483647./,
        },

        # stats - limit - Int32 Min
        {   path   => '/v1/sites/1/stats/path/pageviews',
            method => 'GET',
            params => { limit => INT32_MIN, },
            code   => 500,
            error  => qr/limit must be a number./,
        },

        # stats - offset - Int32 Min
        {   path   => '/v1/sites/1/stats/path/pageviews',
            method => 'GET',
            params => { offset => INT32_MIN, },
            code   => 500,
            error  => qr/offset must be a number./,
        },

        # stats - limit - Int32 Max
        {   path     => '/v1/sites/1/stats/path/pageviews',
            method   => 'GET',
            params   => { limit => INT32_MAX, },
            code     => 200,
            complete => sub {
                my ( $data, $body ) = @_;
                my $result = MT::Util::from_json($body);

                my $fileinfo
                    = $app->model('fileinfo')
                    ->load( { blog_id => $app->blog->id }, { limit => 1 } );

                my $items = $result->{items}[0];
                is( $items->{entry}{id},
                    $fileinfo->entry_id, 'stats - offset - zero - entry' );
                is( $items->{path}, $fileinfo->url,
                    'stats - offset - zero - path' );
                is( $items->{category}, $fileinfo->category_id,
                    'stats - offset - zero - category' );
                is( $items->{author}, $fileinfo->author_id,
                    'stats - offset - zero - author' );
                is( $items->{archiveType}, $fileinfo->archive_type,
                    'stats - offset - zero - archiveType' );
                is( $items->{startDate}, $fileinfo->startdate,
                    'stats - offset - zero - startDate' );
            },
        },

        # stats - offset - Int32 Max
        {   path     => '/v1/sites/1/stats/path/pageviews',
            method   => 'GET',
            params   => { offset => INT32_MAX, },
            code     => 200,
            complete => sub {
                my ( $data, $body ) = @_;
                my $result = MT::Util::from_json($body);

                my $fileinfo
                    = $app->model('fileinfo')
                    ->load( { blog_id => $app->blog->id }, { limit => 1 } );

                my $items = $result->{items}[0];
                is( $items->{entry}{id},
                    $fileinfo->entry_id, 'stats - offset - zero - entry' );
                is( $items->{path}, $fileinfo->url,
                    'stats - offset - zero - path' );
                is( $items->{category}, $fileinfo->category_id,
                    'stats - offset - zero - category' );
                is( $items->{author}, $fileinfo->author_id,
                    'stats - offset - zero - author' );
                is( $items->{archiveType}, $fileinfo->archive_type,
                    'stats - offset - zero - archiveType' );
                is( $items->{startDate}, $fileinfo->startdate,
                    'stats - offset - zero - startDate' );
            },
        },

        # stats - limit - Int64 Min
        {   path   => '/v1/sites/1/stats/path/pageviews',
            method => 'GET',
            params => { limit => INT64_MIN, },
            code   => 500,
            error  => qr/limit must be a number./,
        },

        # stats - offset - Int64 Min
        {   path   => '/v1/sites/1/stats/path/pageviews',
            method => 'GET',
            params => { offset => INT64_MIN, },
            code   => 500,
            error  => qr/offset must be a number./,
        },

        # stats - limit - Int64 Max
        {   path   => '/v1/sites/1/stats/path/pageviews',
            method => 'GET',
            params => { limit => INT64_MAX, },
            code   => 500,
            error =>
                qr/limit must be an integer and between 1 and 2147483647./,
        },

        # stats - offset - Int64 Max
        {   path   => '/v1/sites/1/stats/path/pageviews',
            method => 'GET',
            params => { offset => INT64_MAX, },
            code   => 500,
            error =>
                qr/offset must be an integer and between 0 and 2147483647./,
        },

        # stats - limit - Decimal
        {   path   => '/v1/sites/1/stats/path/pageviews',
            method => 'GET',
            params => { limit => 0.6, },
            code   => 500,
            error  => qr/limit must be a number./,
        },

        # stats - offset - Decimal
        {   path   => '/v1/sites/1/stats/path/pageviews',
            method => 'GET',
            params => { offset => 0.6, },
            code   => 500,
            error  => qr/offset must be a number./,
        },

        # stats - limit - index
        {   path   => '/v1/sites/1/stats/path/pageviews',
            method => 'GET',
            params => { limit => '0e0', },
            code   => 500,
            error  => qr/limit must be a number./,
        },

        # stats - offset - index
        {   path   => '/v1/sites/1/stats/path/pageviews',
            method => 'GET',
            params => { offset => '0e0', },
            code   => 500,
            error  => qr/offset must be a number./,
        },

        # stats - limit - Infinity
        {   path   => '/v1/sites/1/stats/path/pageviews',
            method => 'GET',
            params => { limit => 'inf', },
            code   => 500,
            error  => qr/limit must be a number./,
        },

        # stats - offset - Infinity
        {   path   => '/v1/sites/1/stats/path/pageviews',
            method => 'GET',
            params => { offset => 'inf', },
            code   => 500,
            error  => qr/offset must be a number./,
        },

        # stats - limit - ascii only
        {   path   => '/v1/sites/1/stats/path/pageviews',
            method => 'GET',
            params => { limit => 'a', },
            code   => 500,
            error  => qr/limit must be a number./,
        },

        # stats - offset - ascii only
        {   path   => '/v1/sites/1/stats/path/pageviews',
            method => 'GET',
            params => { offset => 'a', },
            code   => 500,
            error  => qr/offset must be a number./,
        },

        # stats - limit - ascii and symbol
        {   path   => '/v1/sites/1/stats/path/pageviews',
            method => 'GET',
            params => {
                limit =>
                    'oprew2347954oirq\'lfad[dsf[d;\dsf\'ermroitru434rosdf|||\\\'',
            },
            code  => 500,
            error => qr/limit must be a number./,
        },

        # stats - offset - ascii and symbol
        {   path   => '/v1/sites/1/stats/path/pageviews',
            method => 'GET',
            params => {
                offset => '87934789jfjksdhakjlfdsaljkdsfa89]][[\\ncnlkjashdf',
            },
            code  => 500,
            error => qr/offset must be a number./,
        },

    ];
}

