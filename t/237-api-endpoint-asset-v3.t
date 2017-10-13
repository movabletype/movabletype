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

use MT::Test::DataAPI;
use MT::Test::Permission;

use MT::App::DataAPI;
my $app = MT::App::DataAPI->new;

my $author = MT->model('author')->load(1);
$author->email('melody@example.com');
$author->save;

# Make a new role that including upload permission only.
require MT::Role;
my $role = MT::Role->new();
$role->name( 'upload' );
$role->description( 'upload' );
$role->clear_full_permissions;
$role->set_these_permissions( 'upload' );
$role->save;

# Make a new user who is associated with upload role.
my $uploader = MT::Author->new;
$uploader->set_values(
    {   name             => 'uploader',
        nickname         => 'Mr. Uploader',
        email            => 'uploader@example.com',
        url              => 'http://example.com/',
        userpic_asset_id => 3,
        api_password     => 'seecret',
        auth_type        => 'MT',
        created_on       => '19780131074500',
    }
);
$uploader->set_password("bass");
$uploader->type( MT::Author::AUTHOR() );
$uploader->id(100);
$uploader->save()
    or die "Couldn't save author record 100: " . $uploader->errstr;

require MT::Association;
my $assoc = MT::Association->new();
$assoc->author_id( $uploader->id );
$assoc->blog_id(1);
$assoc->role_id( $role->id );
$assoc->type(1);
$assoc->save();


my $mock_filemgr_local = Test::MockModule->new('MT::FileMgr::Local');
$mock_filemgr_local->mock( 'delete', sub {1} );

my $temp_data = undef;

my $unpublished_page = MT::Test::Permission->make_page(
    blog_id => 1,
    status  => 1,    # unpublished
);

# Clear cacne.
MT->model('asset')->driver->Disabled(1)
    if MT->model('asset')->driver->can('Disabled');

my $suite = suite();
test_data_api($suite);

done_testing;

sub suite {
    return +[

        ### v3
        {   path   => '/v3/sites/1/assets/upload',
            method => 'POST',
            params => {  },
            setup  => sub {
                my $iter = $app->model('asset')->load_iter(
                    { id => \'> 4', blog_id => [ 0, 1] }, { no_class => 1 }
                );
                while ( my $a = $iter->() ) {
                    $a->remove;
                }
            },
            upload => [
                'file',
                File::Spec->catfile(
                    $ENV{MT_HOME}, "t", 'images', 'test.jpg'
                ),
            ],
        },

        # upload_asset_v3 - irregular tests.
        {    # Not logged in.
            path   => '/v3/assets/upload',
            method => 'POST',
            params => { site_id => 1, },
            upload => [
                'file',
                File::Spec->catfile(
                    $ENV{MT_HOME}, "t", 'images', 'test.png'
                ),
            ],
            author_id => 0,
            code      => 401,
            error     => 'Unauthorized',
        },
        {    # No permissions.
            path   => '/v3/assets/upload',
            method => 'POST',
            params => { site_id => 1, },
            upload => [
                'file',
                File::Spec->catfile(
                    $ENV{MT_HOME}, "t", 'images', 'test.png'
                ),
            ],
            restrictions => {
                1 => [qw/ upload /],
                0 => [qw/ upload /],
            },
            code  => 403,
            error => 'Do not have permission to upload.',
        },

        # upload_asset_v3 - normal tests.
        {    # Site.
            path   => '/v3/assets/upload',
            method => 'POST',
            params => { site_id => 1 },
            setup  => sub {
                my ($data) = @_;
                $data->{count} = $app->model('asset')->count;
            },
            upload => [
                'file',
                File::Spec->catfile(
                    $ENV{MT_HOME}, "t", 'images', 'test.png'
                ),
            ],
            result => sub {
                $app->model('asset')->load( { class => '*' },
                    { sort => [ { column => 'id', desc => 'DESC' }, ] } );
            },
        },
        # upload_asset_v3 - normal tests upload only user.
        {    # Site.
            path   => '/v3/assets/upload',
            method => 'POST',
            params => { site_id => 1 },
            setup  => sub {
                my ($data) = @_;
                $data->{count} = $app->model('asset')->count;
            },
            upload => [
                'file',
                File::Spec->catfile(
                    $ENV{MT_HOME}, "t", 'images', 'test.gif'
                ),
            ],
            author_id => 100,
            result => sub {
                $app->model('asset')->load( { class => '*' },
                    { sort => [ { column => 'id', desc => 'DESC' }, ] } );
            },
        },
        {    # Upload again. Already exists.
            path   => '/v3/assets/upload',
            method => 'POST',
            params => { site_id => 1, },
            code   => '409',
            upload => [
                'file',
                File::Spec->catfile(
                    $ENV{MT_HOME}, "t", 'images', 'test.jpg'
                ),
            ],
            complete => sub {
                my ( $data, $body ) = @_;
                my $result = MT::Util::from_json($body);
                $temp_data = $result->{error}{data};
            }
        },
        {    # Overwrite.
            path   => '/v3/assets/upload',
            method => 'POST',
            params => sub {
                +{  site_id   => 1,
                    overwrite => 1,
                    %$temp_data,
                };
            },
            upload => [
                'file',
                File::Spec->catfile(
                    $ENV{MT_HOME}, "t", 'images', 'test.jpg'
                ),
            ],
        },
        {    # Overwrite once. (version 2 or later)
            path   => '/v3/assets/upload',
            method => 'POST',
            params => { site_id => 1, overwrite_once => 1, },
            upload => [
                'file',
                File::Spec->catfile(
                    $ENV{MT_HOME}, "t", 'images', 'test.jpg'
                ),
            ],
        },

        # upload_asset_v3 - path parameter is allowed.
        {
            path   => '/v3/assets/upload',
            method => 'POST',
            params => {
                site_id => 1,
                path => '/images',
                overwrite_once => 1,
            },
            setup  => sub {
                my ($data) = @_;
                $data->{count} = $app->model('asset')->count;

                my $site = $app->model('blog')->load(1);
                $site->allow_to_change_at_upload(1);
                $site->upload_destination('%s');
                $site->extra_path('');
                $site->save;
            },
            upload => [
                'file',
                File::Spec->catfile(
                    $ENV{MT_HOME}, "t", 'images', 'test.png'
                ),
            ],
            complete => sub {
                my ( $data, $body ) = @_;
                my $result = MT::Util::from_json($body);
                is( $result->{url},'http://narnia.na/nana/images/test.png' );

                # Revert changes
                my $site = $app->model('blog')->load(1);
                $site->allow_to_change_at_upload(undef);
                $site->upload_destination(undef);
                $site->extra_path(undef);
                $site->save;
            },
        },

        # upload_asset_v3 - path parameter is disallowed.
        {
            path   => '/v3/assets/upload',
            method => 'POST',
            params => {
                site_id => 1,
                path => '/images',
                overwrite_once => 1,
            },
            setup  => sub {
                my ($data) = @_;
                $data->{count} = $app->model('asset')->count;

                my $site = $app->model('blog')->load(1);
                $site->allow_to_change_at_upload(0);
                $site->upload_destination('%s');
                $site->extra_path('');
                $site->save;
            },
            upload => [
                'file',
                File::Spec->catfile(
                    $ENV{MT_HOME}, "t", 'images', 'test.png'
                ),
            ],
            complete => sub {
                my ( $data, $body ) = @_;
                my $result = MT::Util::from_json($body);
                is( $result->{url},'http://narnia.na/nana/test.png' );

                # Revert changes
                my $site = $app->model('blog')->load(1);
                $site->allow_to_change_at_upload(undef);
                $site->upload_destination(undef);
                $site->extra_path(undef);
                $site->save;
            },
        },

        {    # System.
            path   => '/v3/assets/upload',
            method => 'POST',
            params => { site_id => 0, },
            setup  => sub {
                my ($data) = @_;
                $data->{count} = $app->model('asset')->count;
            },
            upload => [
                'file',
                File::Spec->catfile(
                    $ENV{MT_HOME}, "t", 'images', 'test.gif'
                ),
            ],
            result => sub {
                $app->model('asset')->load( { class => '*' },
                    { sort => [ { column => 'id', desc => 'DESC' }, ] } );
            },
        },

        # upload_asset_v3 - irregular tests.
        {    # No site_id.
            path   => '/v3/assets/upload',
            method => 'POST',
            code   => 400,
            result => sub {
                return +{
                    error => {
                        code    => 400,
                        message => 'A parameter "site_id" is required.',
                    },
                };
            },
        },
        {    # No site_id.
            path   => '/v3/assets/upload',
            method => 'POST',
            params => { site_id => 1, },
            code   => 500,
            result => sub {
                return +{
                    error => {
                        code    => 500,
                        message => "Please select a file to upload.\n",
                    },
                };
            },
        },

        # list_assets - irregular tests
        {   path   => '/v3/sites/3/assets',
            method => 'GET',
            code   => 404,
        },

        # list_assets - normal tests
        {    # System.
            path      => '/v3/sites/0/assets',
            method    => 'GET',
            callbacks => [
                {   name  => 'data_api_pre_load_filtered_list.asset',
                    count => 2,
                },
            ],
            complete => sub {
                my ( $data, $body ) = @_;
                my $result = MT::Util::from_json($body);
                is( $result->{totalResults},
                    3, 'The number of asset (blog_id=0) is 3.' );
            },
        },
        {    # Blog.
            path      => '/v3/sites/1/assets',
            method    => 'GET',
            callbacks => [
                {   name  => 'data_api_pre_load_filtered_list.asset',
                    count => 2,
                },
            ],
            complete => sub {
                my ( $data, $body ) = @_;
                my $result = MT::Util::from_json($body);
                is( $result->{totalResults},
                    6, 'The number of asset (blog_id=1) is 6.' );
            },
        },
        {    # Website.
            path      => '/v3/sites/2/assets',
            method    => 'GET',
            callbacks => [
                {   name  => 'data_api_pre_load_filtered_list.asset',
                    count => 1,
                },
            ],
            complete => sub {
                my ( $data, $body ) = @_;
                my $result = MT::Util::from_json($body);
                is( $result->{totalResults},
                    0, 'The number of asset (blog_id=2) is 0.' );
            },
        },
        {    # search parameter.
            path      => '/v3/sites/1/assets',
            method    => 'GET',
            params    => { search => 'template', },
            callbacks => [
                {   name  => 'data_api_pre_load_filtered_list.asset',
                    count => 2,
                },
            ],
            complete => sub {
                my ( $data, $body ) = @_;
                my $result = MT::Util::from_json($body);
                is( $result->{totalResults}, 1,
                    'The number of asset whose label contains "template" is 1.'
                );
                like( lc $result->{items}[0]{label},
                    qr/template/, 'The label of asset has "template".' );
            },
        },
        {    # class parameter.
            path      => '/v3/sites/1/assets',
            method    => 'GET',
            params    => { class => 'image', },
            callbacks => [
                {   name  => 'data_api_pre_load_filtered_list.asset',
                    count => 2,
                },
            ],
            complete => sub {
                my ( $data, $body ) = @_;
                my $result = MT::Util::from_json($body);
                is( $result->{totalResults},
                    5, 'The number of image asset is 5.' );
            },
        },
        {    # In order of created_by.
            path      => '/v3/sites/1/assets',
            method    => 'GET',
            params    => { sortBy => 'created_by', },
            callbacks => [
                {   name  => 'data_api_pre_load_filtered_list.asset',
                    count => 2,
                },
            ],
        },
        {    # In order of file_name.
            path      => '/v3/sites/1/assets',
            method    => 'GET',
            params    => { sortBy => 'file_name', },
            callbacks => [
                {   name  => 'data_api_pre_load_filtered_list.asset',
                    count => 2,
                },
            ],
            result => sub {
                $app->user($author);
                my @assets = $app->model('asset')->load(
                    { blog_id => 1,           class     => '*' },
                    { sort    => 'file_name', direction => 'descend' },
                );
                return +{
                    totalResults => scalar @assets,
                    items => MT::DataAPI::Resource->from_object( \@assets ),
                };
            },
        },
        {    # relatedAssets is false.
            path   => '/v3/sites/1/assets',
            method => 'GET',
            setup  => sub {
                my $asset = $app->model('asset')->load(1);
                $asset->set_values(
                    {   id     => 100,
                        parent => 1,
                    }
                );
                $asset->save or die $asset->errstr;
            },
            callbacks => [
                {   name  => 'data_api_pre_load_filtered_list.asset',
                    count => 2,
                },
            ],
            result => sub {
                my @assets = $app->model('asset')->load(
                    {   class   => '*',
                        blog_id => 1,
                        parent  => [ \'IS NULL', 0, '' ],
                    },
                    { sort => 'created_on', direction => 'descend', },
                );
                return +{
                    totalResults => scalar @assets,
                    items => MT::DataAPI::Resource->from_object( \@assets ),
                };
            },
        },
        {    # relatedAssets is true.
            path      => '/v3/sites/1/assets',
            method    => 'GET',
            params    => { relatedAssets => 1, },
            callbacks => [
                {   name  => 'data_api_pre_load_filtered_list.asset',
                    count => 2,
                },
            ],
            result => sub {
                my @assets = $app->model('asset')->load(
                    { class => '*',          blog_id   => 1, },
                    { sort  => 'created_on', direction => 'descend', },
                );
                return +{
                    totalResults => scalar @assets,
                    items => MT::DataAPI::Resource->from_object( \@assets ),
                };
            },
        },

        # list_assets_for_entry - irregular tests
        {    # Non-existent entry.
            path   => '/v3/sites/1/entries/100/assets',
            method => 'GET',
            code   => 404,
        },
        {    # Non-existent site.
            path   => '/v3/sites/5/entries/1/assets',
            method => 'GET',
            code   => 404,
        },
        {    # Other site.
            path   => '/v3/sites/2/entries/1/assets',
            method => 'GET',
            code   => 404,
        },
        {    # Other site (system).
            path   => '/v3/sites/0/entries/1/assets',
            method => 'GET',
            code   => 404,
        },
        {    # Not entry (page).
            path   => '/v3/sites/1/entries/20/assets',
            method => 'GET',
            code   => 404,
        },
        {    # Unpublished entry and not logged in.
            path      => '/v3/sites/1/entries/3/assets',
            method    => 'GET',
            author_id => 0,
            code      => 403,
            error =>
                'Do not have permission to retrieve the requested assets for entry.',
        },
        {    #  Unpublished entry and no permissions.
            path   => '/v3/sites/1/entries/3/assets',
            method => 'GET',
            restrictions =>
                { 1 => [qw/ edit_all_entries edit_all_unpublished_entry /], },
            code => 403,
            error =>
                'Do not have permission to retrieve the requested assets for entry.',
        },

        # list_assets_for_entry - normal tests
        {   path      => '/v3/sites/1/entries/1/assets',
            method    => 'GET',
            setup     => sub { $app->user($author) },
            callbacks => [
                {   name =>
                        'MT::App::DataAPI::data_api_view_permission_filter.entry',
                    count => 1,
                },
                {   name  => 'data_api_pre_load_filtered_list.asset',
                    count => 2,
                },
            ],
            result => sub {
                $app->user($author);
                my $asset = $app->model('asset')->load(1);
                my $res = +{
                    totalResults => 1,
                    items => MT::DataAPI::Resource->from_object( [$asset] ),
                };
            },
        },
        {    # In order of file_name.
            path      => '/v3/sites/1/entries/1/assets',
            method    => 'GET',
            params    => { sortBy => 'file_name', },
            setup     => sub { $app->user($author) },
            callbacks => [
                {   name =>
                        'MT::App::DataAPI::data_api_view_permission_filter.entry',
                    count => 1,
                },
                {   name  => 'data_api_pre_load_filtered_list.asset',
                    count => 2,
                },
            ],
        },
        {    # In order of created_by.
            path      => '/v3/sites/1/entries/1/assets',
            method    => 'GET',
            params    => { sortBy => 'created_by', },
            setup     => sub { $app->user($author) },
            callbacks => [
                {   name =>
                        'MT::App::DataAPI::data_api_view_permission_filter.entry',
                    count => 1,
                },
                {   name  => 'data_api_pre_load_filtered_list.asset',
                    count => 2,
                },
            ],
        },

        # list_assets_for_page - irregular tests
        {    # Non-existent page.
            path   => '/v3/sites/1/pages/100/assets',
            method => 'GET',
            code   => 404,
        },
        {    # Non-existent site.
            path   => '/v3/sites/5/pages/20/assets',
            method => 'GET',
            code   => 404,
        },
        {    # Other site.
            path   => '/v3/sites/2/pages/20/assets',
            method => 'GET',
            code   => 404,
        },
        {    # Other site (system).
            path   => '/v3/sites/0/pages/20/assets',
            method => 'GET',
            code   => 404,
        },
        {    # Not page (entry).
            path   => '/v3/sites/1/pages/1/assets',
            method => 'GET',
            code   => 404,
        },
        {    # Unpublished page and not logged in.
            path => '/v3/sites/1/pages/' . $unpublished_page->id . '/assets',
            method    => 'GET',
            author_id => 0,
            code      => 403,
            error =>
                'Do not have permission to retrieve the requested assets for page.',
        },
        {    # Unpublished page and no permissions.
            path => '/v3/sites/1/pages/' . $unpublished_page->id . '/assets',
            method       => 'GET',
            restrictions => { 1 => [qw/ open_page_edit_screen /], },
            code         => 403,
            error =>
                'Do not have permission to retrieve the requested assets for page.',
        },

        # list_assets_for_page - normal tests
        {   path      => '/v3/sites/1/pages/20/assets',
            method    => 'GET',
            callbacks => [
                {   name =>
                        'MT::App::DataAPI::data_api_view_permission_filter.page',
                    count => 1,
                },
                {   name  => 'data_api_pre_load_filtered_list.asset',
                    count => 2,
                },
            ],
            result => sub {
                $app->user($author);
                my $asset = $app->model('asset')->load(2);
                my $res = +{
                    totalResults => 1,
                    items => MT::DataAPI::Resource->from_object( [$asset] ),
                };
                return $res;
            },
        },
        {    # In order of file_name.
            path      => '/v3/sites/1/pages/20/assets',
            method    => 'GET',
            params    => { sortBy => 'file_name', },
            callbacks => [
                {   name =>
                        'MT::App::DataAPI::data_api_view_permission_filter.page',
                    count => 1,
                },
                {   name  => 'data_api_pre_load_filtered_list.asset',
                    count => 2,
                },
            ],
        },
        {    # In order of created_by.
            path      => '/v3/sites/1/pages/20/assets',
            method    => 'GET',
            params    => { sortBy => 'created_by', },
            callbacks => [
                {   name =>
                        'MT::App::DataAPI::data_api_view_permission_filter.page',
                    count => 1,
                },
                {   name  => 'data_api_pre_load_filtered_list.asset',
                    count => 2,
                },
            ],
        },

        # list_asset_for_site_and_tag - irregular tests
        {    # Non-existent tag.
            path   => '/v3/sites/1/tags/100/assets',
            method => 'GET',
            code   => 404,
        },
        {    # Non-existent site.
            path   => '/v3/sites/5/tags/6/assets',
            method => 'GET',
            code   => 404,
        },
        {    # System.
            path   => '/v3/sites/0/tags/6/assets',
            method => 'GET',
            code   => 404,
        },
        {    # Private tag and not logged in.
            path      => '/v3/sites/2/tags/17/assets',
            method    => 'GET',
            author_id => 0,
            code      => 403,
            error =>
                'Do not have permission to retrieve the requested assets for site and tag.',
        },

        # Private tag and no permissions.
        {   path         => '/v3/sites/2/tags/17/assets',
            method       => 'GET',
            restrictions => {
                2 => [qw/ edit_tags /],
                0 => [qw/ edit_tags /],
            },
            code => 403,
            error =>
                'Do not have permission to retrieve the requested assets for site and tag.',
        },
        {   path         => '/v3/sites/2/tags/17/assets',
            method       => 'GET',
            restrictions => {
                2 => [qw/ access_to_tag_list /],
                0 => [qw/ access_to_tag_list /],
            },
            code => 403,
            error =>
                'Do not have permission to retrieve the requested assets for site and tag.',
        },

        # list_assets_for_site_and_tag - normal tests
        {   path      => '/v3/sites/1/tags/6/assets',
            method    => 'GET',
            callbacks => [
                {   name =>
                        'MT::App::DataAPI::data_api_view_permission_filter.tag',
                    count => 1,
                },
                {   name  => 'data_api_pre_load_filtered_list.asset',
                    count => 2,
                },
            ],
            result => sub {
                $app->user($author);
                my $asset = $app->model('asset')->load(1);
                my $res = +{
                    totalResults => 1,
                    items => MT::DataAPI::Resource->from_object( [$asset] ),
                };
                return $res;
            },
        },
        {    # In order of file_name.
            path      => '/v3/sites/1/tags/6/assets',
            method    => 'GET',
            params    => { sortBy => 'file_name', },
            callbacks => [
                {   name =>
                        'MT::App::DataAPI::data_api_view_permission_filter.tag',
                    count => 1,
                },
                {   name  => 'data_api_pre_load_filtered_list.asset',
                    count => 2,
                },
            ],
        },
        {    # In order of created_by.
            path      => '/v3/sites/1/tags/6/assets',
            method    => 'GET',
            params    => { sortBy => 'created_by', },
            callbacks => [
                {   name =>
                        'MT::App::DataAPI::data_api_view_permission_filter.tag',
                    count => 1,
                },
                {   name  => 'data_api_pre_load_filtered_list.asset',
                    count => 2,
                },
            ],
        },


        # get_asset - irregular tests
        {   path   => '/v3/sites/2/assets/1',
            method => 'GET',
            code   => 404,
        },
        {   path   => '/v3/sites/1/assets/10',
            method => 'GET',
            code   => 404,
        },
        {   path   => '/v3/sites/3/assets/1',
            method => 'GET',
            code   => 404,
        },
        {   path   => '/v3/sites/3/assets/10',
            method => 'GET',
            code   => 404,
        },
        {   path   => '/v3/sites/1/assets/3',
            method => 'GET',
            code   => 404,
        },
        {   path   => '/v3/sites/0/assets/1',
            method => 'GET',
            code   => 404,
        },

        # get_asset - normal tests
        {   path      => '/v3/sites/1/assets/1',
            method    => 'GET',
            callbacks => [
                {   name =>
                        'MT::App::DataAPI::data_api_view_permission_filter.asset',
                    count => 1,
                },
            ],
            result => sub {
                MT->model('asset')->load(1);
            },
        },
        {   path   => '/v3/sites/0/assets/3',
            method => 'GET',
            result => sub {
                MT->model('asset')->load(3);
            },
        },

        # update_asset - irregular tests
        {   path     => '/v3/sites/1/assets/1',
            method   => 'PUT',
            code     => 400,
            complete => sub {
                my ( $data, $body ) = @_;
                my $result        = MT::Util::from_json($body);
                my $error_message = "A resource \"asset\" is required.";
                is( $result->{error}{message},
                    $error_message, 'Error message: ' . $error_message );
            },
        },
        {   path   => '/v3/sites/2/assets/1',
            method => 'PUT',
            params =>
                { asset => { label => 'update_asset in different scope', }, },
            code => 404,
        },
        {   path   => '/v3/sites/0/assets/1',
            method => 'PUT',
            params => {
                asset =>
                    { label => 'update_asset in different scope (system)', },
            },
            code => 404,
        },
        {   path   => '/v3/sites/10/assets/1',
            method => 'PUT',
            params => {
                asset => { label => 'update_asset in non-existent blog', },
            },
            code => 404,
        },
        {   path   => '/v3/sites/1/assets/10',
            method => 'PUT',
            params => {
                asset => { label => 'update_asset in non-existent asset', },
            },
            code => 404,
        },
        {    # Not logged in.
            path      => '/v3/sites/1/assets/1',
            method    => 'PUT',
            params    => { asset => {} },
            author_id => 0,
            code      => 401,
            error     => 'Unauthorized',
        },
        {    # No permissions.
            path         => '/v3/sites/1/assets/1',
            method       => 'PUT',
            params       => { asset => {} },
            restrictions => { 1 => [qw/ save_asset /], },
            code         => 403,
            error        => 'Do not have permission to update an asset.',
        },

        # update_asset - normal tests
        {   path      => '/v3/sites/1/assets/1',
            method    => 'PUT',
            params    => { asset => {} },
            callbacks => [
                {   name =>
                        'MT::App::DataAPI::data_api_save_permission_filter.asset',
                    count => 1,
                },
                {   name  => 'MT::App::DataAPI::data_api_save_filter.asset',
                    count => 1,
                },
                {   name  => 'MT::App::DataAPI::data_api_pre_save.asset',
                    count => 1,
                },
                {   name  => 'MT::App::DataAPI::data_api_post_save.asset',
                    count => 1,
                },
            ],
            result => sub {
                MT->model('asset')->load(1);
            },
        },
        {   path   => '/v3/sites/1/assets/1',
            method => 'PUT',
            params => {
                asset => {
                    label       => 'updated label',
                    description => 'updated description',
                    tags        => ['updated tag'],

                    filename => 'updated filename',
                    url      => 'updated url',
                    mimeType => 'updated mimeType',
                    id       => '10',
                },
            },
            callbacks => [
                {   name =>
                        'MT::App::DataAPI::data_api_save_permission_filter.asset',
                    count => 1,
                },
                {   name  => 'MT::App::DataAPI::data_api_save_filter.asset',
                    count => 1,
                },
                {   name  => 'MT::App::DataAPI::data_api_pre_save.asset',
                    count => 1,
                },
                {   name  => 'MT::App::DataAPI::data_api_post_save.asset',
                    count => 1,
                },
            ],
            complete => sub {
                my ( $data, $body ) = @_;
                my $result = MT::Util::from_json($body);

                is( $result->{label},
                    'updated label',
                    'Asset\'s label has been updated.'
                );
                is( $result->{description},
                    'updated description',
                    'Asset\'s description has been updated.'
                );
                is( scalar @{ $result->{tags} },
                    1, 'Asset\'s tag count is 1.' );
                is( $result->{tags}[0],
                    'updated tag', 'Asset\'s tags has been updated.' );

                isnt(
                    $result->{filename},
                    'updated filename',
                    'Asset\'s filename has not been updated.'
                );
                isnt( $result->{url}, 'updated url',
                    'Asset\'s url has not been updated.' );
                isnt(
                    $result->{mimeType},
                    'updated mimeType',
                    'Asset\'s mimeType has not been updated.'
                );
                isnt( $result->{id}, 10,
                    'Asset\'s id has not been updated.' );
            },
        },

        # get_thumbnail - irregular tests
        {    # Non-existent asset.
            path   => '/v3/sites/1/assets/400/thumbnail',
            method => 'GET',
            code   => 404,
        },
        {
            # Not image.
            path   => '/v3/sites/1/assets/2/thumbnail',
            method => 'GET',
            code   => 400,
            result => sub {
                +{  error => {
                        code => 400,
                        message =>
                            'The asset does not support generating a thumbnail file.',
                    },
                    },
                    ;
            },
        },
        {
            # Invalid width.
            path   => '/v3/sites/1/assets/5/thumbnail',
            method => 'GET',
            params => { width => 'width', },
            code   => 400,
            result => sub {
                +{  error => {
                        code    => 400,
                        message => 'Invalid width: width',
                    },
                    },
                    ;
            },
        },
        {
            # Invalid height.
            path   => '/v3/sites/1/assets/5/thumbnail',
            method => 'GET',
            params => { height => 'height', },
            code   => 400,
            result => sub {
                +{  error => {
                        code    => 400,
                        message => 'Invalid height: height',
                    },
                    },
                    ;
            },
        },
        {
            # Invalid scale.
            path   => '/v3/sites/1/assets/5/thumbnail',
            method => 'GET',
            params => { scale => 'scale', },
            code   => 400,
            result => sub {
                +{  error => {
                        code    => 400,
                        message => 'Invalid scale: scale',
                    },
                    },
                    ;
            },
        },

        # get_thumbnail - normal tests
        {   path      => '/v3/sites/1/assets/5/thumbnail',
            method    => 'GET',
            author_id => 0,
            result    => sub {
                my $image = $app->model('asset')->load(5);
                my ( $thumbnail, $w, $h ) = $image->thumbnail_url;
                return +{
                    url    => $thumbnail,
                    width  => $w,
                    height => $h,
                };
            },
        },

        # delete_asset - irregular tests
        {    # Other site.
            path   => '/v3/sites/2/assets/1',
            method => 'DELETE',
            code   => 404,
        },
        {    # Other site (system).
            path   => '/v3/sites/0/assets/1',
            method => 'DELETE',
            code   => 404,
        },
        {    # Non-exisitent site.
            path   => '/v3/sites/10/assets/1',
            method => 'DELETE',
            code   => 404,
        },
        {    # Non-existent site and non-existent asset.
            path   => '/v3/sites/10/assets/10',
            method => 'DELETE',
            code   => 404,
        },
        {    # Other site.
            path   => '/v3/sites/1/assets/3',
            method => 'DELETE',
            code   => 404,
        },
        {    # Non-existent site.
            path   => '/v3/sites/10/assets/3',
            method => 'DELETE',
            code   => 404,
        },
        {    # Non-existent asset.
            path   => '/v3/sites/0/assets/10',
            method => 'DELETE',
            code   => 404,
        },
        {    # Non-existent asset.
            path   => '/v3/sites/1/assets/10',
            method => 'DELETE',
            code   => 404,
        },
        {    # Non-existent asset.
            path   => '/v3/sites/2/assets/10',
            method => 'DELETE',
            code   => 404,
        },
        {    # Not logged in.
            path      => '/v3/sites/1/assets/1',
            method    => 'DELETE',
            author_id => 0,
            code      => 401,
            error     => 'Unauthorized',
        },
        {    # No permissions.
            path         => '/v3/sites/1/assets/1',
            method       => 'DELETE',
            restrictions => { 1 => [qw/ delete_asset /], },
            code         => 403,
            error        => 'Do not have permission to delete an asset.',
        },

        # delete_asset - normal tests
        {    # Blog.
            path      => '/v3/sites/1/assets/1',
            method    => 'DELETE',
            setup     => sub { die if !$app->model('asset')->load(1) },
            callbacks => [
                {   name =>
                        'MT::App::DataAPI::data_api_delete_permission_filter.asset',
                    count => 1,
                },
                {   name  => 'MT::App::DataAPI::data_api_post_delete.asset',
                    count => 1,
                },
            ],
            complete => sub {
                my $deleted = MT->model('asset')->load(1);
                is( $deleted, undef, 'deleted' );
            },
        },
        {    # System.
            path      => '/v3/sites/0/assets/3',
            method    => 'DELETE',
            setup     => sub { die if !$app->model('asset')->load(3) },
            callbacks => [
                {   name =>
                        'MT::App::DataAPI::data_api_delete_permission_filter.asset',
                    count => 1,
                },
                {   name  => 'MT::App::DataAPI::data_api_post_delete.asset',
                    count => 1,
                },
            ],
            complete => sub {
                my $deleted = MT->model('asset')->load(3);
                is( $deleted, undef, 'deleted' );
            },
        },
    ];
}

