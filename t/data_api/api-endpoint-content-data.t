use strict;
use warnings;

use FindBin;
use lib "$FindBin::Bin/../lib";
use Test::More;
use MT::Test::Env;

our $test_env;

BEGIN {
    $test_env = MT::Test::Env->new(
        DefaultLanguage => 'en_US',  ## for now
    );
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT::Test;
use MT::Test::DataAPI;
use MT::Test::Permission;

$test_env->prepare_fixture('db');

use MT::App::DataAPI;
my $app = MT::App::DataAPI->new;

use MT::ContentStatus;

my $user = MT->model('author')->load(1);
$user->email('melody@example.com');
$user->save;

$app->user($user);

my $site_id = 1;

my $content_data_label_index = 0;
sub unique_content_data_label{ 'test:' . $content_data_label_index++ }

my $content_type
    = MT::Test::Permission->make_content_type( blog_id => $site_id );
my $content_type_id = $content_type->id;

my $single_field = MT::Test::Permission->make_content_field(
    blog_id         => $content_type->blog_id,
    content_type_id => $content_type->id,
    name            => 'single',
    type            => 'single_line_text',
);

my $fields = [
    {   id        => $single_field->id,
        order     => 1,
        type      => $single_field->type,
        options   => { label => $single_field->name },
        unique_id => $single_field->unique_id,
    }
];
$content_type->fields($fields);
$content_type->save or die $content_type->errstr;

my $other_content_type
    = MT::Test::Permission->make_content_type( blog_id => $site_id );
my $other_content_type_id = $other_content_type->id;

my $ct_with_data_label
    = MT::Test::Permission->make_content_type( blog_id => $site_id );

my $single_field2 = MT::Test::Permission->make_content_field(
    blog_id         => $site_id,
    content_type_id => $ct_with_data_label->id,
    name            => 'single',
    type            => 'single_line_text',
);
$ct_with_data_label->fields(
    [   {   id        => $single_field2->id,
            order     => 1,
            type      => $single_field2->type,
            options   => { label => $single_field2->name },
            unique_id => $single_field2->unique_id,
        }
    ]
);
$ct_with_data_label->data_label( $single_field2->unique_id );
$ct_with_data_label->save;
my $ct_with_data_label_id = $ct_with_data_label->id;

my $ct_with_datetime
    = MT::Test::Permission->make_content_type( blog_id => $site_id );
my $datetime_field = MT::Test::Permission->make_content_field(
    blog_id         => $site_id,
    content_type_id => $ct_with_datetime->id,
    name            => 'datetime',
    type            => 'date_and_time',
);
$ct_with_datetime->fields(
    [   {   id        => $datetime_field->id,
            order     => 1,
            type      => $datetime_field->type,
            options   => { label => $datetime_field->name },
            unique_id => $datetime_field->unique_id,
        }
    ]
);
$ct_with_datetime->save;
my $ct_with_datetime_id = $ct_with_datetime->id;

my $cd_with_datetime = MT::Test::Permission->make_content_data(
    content_type_id => $ct_with_datetime_id,
    label           => 'cd with datetime',
    blog_id         => $site_id,
    data            => { $datetime_field->id => '20200101000000', },
);

my $ct_with_content_type
    = MT::Test::Permission->make_content_type( blog_id => $site_id );
my $content_type_field = MT::Test::Permission->make_content_field(
    blog_id         => $site_id,
    content_type_id => $ct_with_content_type->id,
    name            => 'ct',
    type            => 'content_type',
);
$ct_with_content_type->fields(
    [   {   id      => $content_type_field->id,
            order   => 1,
            type    => $content_type_field->type,
            options => {
                label  => $content_type_field->name,
                source => $content_type_field->id,
            },
            unique_id => $content_type_field->unique_id,
        }
    ]
);
$ct_with_content_type->save;
my $ct_with_content_type_id = $ct_with_content_type->id;

my $category_set    = MT::Test::Permission->make_category_set(blog_id => $site_id);
my $parent_category = MT::Test::Permission->make_category(
    blog_id         => $site_id,
    category_set_id => $category_set->id,
);
my $parent_category_id  = $parent_category->id;
my $ct_with_category    = MT::Test::Permission->make_content_type(blog_id => $site_id);
my $ct_with_category_id = $ct_with_category->id;
my $category_field      = MT::Test::Permission->make_content_field(
    blog_id         => $site_id,
    content_type_id => $ct_with_category_id,
    name            => 'category_set',
    type            => 'categories',
);
$ct_with_category->fields([{
    id      => $category_field->id,
    options => {
        category_set => $category_set->id,
        label        => $category_field->name,
    },
    order     => 1,
    type      => $category_field->type,
    unique_id => $category_field->unique_id,
}]);
$ct_with_category->save;

my $asset            = MT::Test::Permission->make_asset(blog_id => $site_id);
my $asset_id         = $asset->id;
my $ct_with_asset    = MT::Test::Permission->make_content_type(blog_id => $site_id);
my $ct_with_asset_id = $ct_with_asset->id;
my $asset_field      = MT::Test::Permission->make_content_field(
    blog_id         => $site_id,
    content_type_id => $ct_with_asset_id,
    name            => 'asset',
    type            => 'asset',
);
$ct_with_asset->fields([{
    id      => $asset_field->id,
    options => {
        label => $asset_field->name,
    },
    order     => 1,
    type      => $asset_field->type,
    unique_id => $asset_field->unique_id,
}]);
$ct_with_asset->save;

my $ct_with_multi_line_text = MT::Test::Permission->make_content_type(blog_id => $site_id);
my $multi_line_text_field   = MT::Test::Permission->make_content_field(
    blog_id         => $site_id,
    content_type_id => $ct_with_multi_line_text->id,
    name            => 'Editor',
    type            => 'multi_line_text',
);
$ct_with_multi_line_text->fields([{
    id        => $multi_line_text_field->id,
    order     => 1,
    type      => $multi_line_text_field->type,
    options   => { label => $multi_line_text_field->name },
    unique_id => $multi_line_text_field->unique_id,
}]);
$ct_with_multi_line_text->save;

$user->permissions(0)->rebuild;
$user->permissions($site_id)->rebuild;

MT->request->reset;
MT::CMS::ContentType::init_content_type(sub { die }, $app);

irregular_tests_for_create();
normal_tests_for_create();

normal_tests_for_list();
irregular_tests_for_list();

irregular_tests_for_get();
normal_tests_for_get();

irregular_tests_for_update();
normal_tests_for_update();

irregular_tests_for_delete();
normal_tests_for_delete();

restriction_tests_for_list();

done_testing;

sub irregular_tests_for_create {
    test_data_api(
        {   note   => 'not logged in',
            path   => "/v4/sites/$site_id/contentTypes/$content_type_id/data",
            method => 'POST',
            author_id => 0,
            code      => 401,
        }
    );
    test_data_api(
        {   note   => 'invalid site_id',
            path   => "/v4/sites/1000/contentTypes/$content_type_id/data",
            method => 'POST',
            code   => 404,
        }
    );
    test_data_api(
        {   note   => 'invalid content_type_id',
            path   => "/v4/sites/$site_id/contentTypes/1000/data",
            method => 'POST',
            code   => 404,
        }
    );
    test_data_api(
        {   note   => 'no permission',
            path   => "/v4/sites/$site_id/contentTypes/$content_type_id/data",
            method => 'POST',
            params => { content_data => { label => 'test' } },
            restrictions => {
                0 => [
                    'create_new_content_data', 'publish_all_content_data',
                ],
                $site_id => [
                    'create_new_content_data',
                    'create_new_content_data_' . $content_type->unique_id,
                    'publish_all_content_data',
                    'publish_all_content_data_' . $content_type->unique_id,
                    'publish_own_content_data_' . $content_type->unique_id,
                ],
            },
            code => 403,
        }
    );
    test_data_api(
        {   note   => 'not draft content_data without publish permission',
            path   => "/v4/sites/$site_id/contentTypes/$content_type_id/data",
            method => 'POST',
            params =>
                { content_data => { label => 'test', status => 'Publish' } },
            restrictions => {
                0 => [

                    # 'create_new_content_data',
                    'publish_all_content_data',
                ],
                $site_id => [

                    # 'create_new_content_data',
                    # 'create_new_content_data_' . $content_type->unique_id,
                    'publish_all_content_data',
                    'publish_all_content_data_' . $content_type->unique_id,
                    'publish_own_content_data_' . $content_type->unique_id,
                ],
            },
            code => 403,
        }
    );
    test_data_api(
        {   note   => 'basename is too long (ascii)',
            path   => "/v4/sites/$site_id/contentTypes/$content_type_id/data",
            method => 'POST',
            params => {
                content_data => {
                    label => 'test',
                    data  => [
                        {   id   => $single_field->id,
                            data => 'single',
                        },
                    ],
                    basename => 'a' x 247,
                },
            },
            restrictions => {
                $site_id => [
                    'create_new_content_data',
                    'create_new_content_data_' . $content_type->unique_id,
                    'publish_all_content_data',
                    'publish_all_content_data_' . $content_type->unique_id,
                    'publish_own_content_data_' . $content_type->unique_id,
                ],
            },
            code  => 500,
            error => qr/basename is too long./,
        }
    );
    test_data_api(
        {   note   => 'basename is too long (utf8)',
            path   => "/v4/sites/$site_id/contentTypes/$content_type_id/data",
            method => 'POST',
            params => {
                content_data => {
                    label => 'test',
                    data  => [
                        {   id   => $single_field->id,
                            data => 'single',
                        },
                    ],
                    basename => chr(0x3042) x 83,
                },
            },
            restrictions => {
                $site_id => [
                    'create_new_content_data',
                    'create_new_content_data_' . $content_type->unique_id,
                    'publish_all_content_data',
                    'publish_all_content_data_' . $content_type->unique_id,
                    'publish_own_content_data_' . $content_type->unique_id,
                ],
            },
            code  => 500,
            error => qr/basename is too long./,
        }
    );
    test_data_api(
        {   note   => 'no label',
            path   => "/v4/sites/$site_id/contentTypes/$content_type_id/data",
            method => 'POST',
            params => {
                content_data => {
                    data => [
                        {   id   => $single_field->id,
                            data => 'single',
                        },
                    ],
                },
            },
            code  => 409,
            error => qr/"Data Label" is required./,
        }
    );
    test_data_api(
        {   note => 'no label',
            path =>
                "/v4/sites/$site_id/contentTypes/$ct_with_data_label_id/data",
            method => 'POST',
            params => {
                content_data => {
                    data => [
                        {   id   => $single_field2->id,
                            data => '',
                        },
                    ],
                },
            },
            code  => 409,
            error => qr/"Data Label" is required./,
        }
    );
    test_data_api(
        {   note => 'Invalid datetime field (MTC-26264)',
            path =>
                "/v4/sites/$site_id/contentTypes/$ct_with_datetime_id/data",
            method       => 'POST',
            is_superuser => 1,
            params       => {
                content_data => {
                    label => 'Invalid datetime value',
                    data  => [
                        {   id   => $datetime_field->id,
                            data => 'a',
                        }
                    ],
                },
            },
            code  => 409,
            error => qq{Invalid date_and_time in "datetime" field.\n},
        }
    );

}

sub normal_tests_for_create {
    test_data_api(
        {   note   => 'system permission',
            path   => "/v4/sites/$site_id/contentTypes/$content_type_id/data",
            method => 'POST',
            params => {
                content_data => {
                    label => unique_content_data_label(),
                    data  => [
                        {   id   => $single_field->id,
                            data => 'single',
                        },
                    ],
                },
            },
            restrictions => {

                # 0 => [
                #     'create_new_content_data', 'publish_all_content_data',
                # ],
                $site_id => [
                    'create_new_content_data',
                    'create_new_content_data_' . $content_type->unique_id,
                    'publish_all_content_data',
                    'publish_all_content_data_' . $content_type->unique_id,
                    'publish_own_content_data_' . $content_type->unique_id,
                ],
            },
            callbacks => [
                {   name =>
                        'MT::App::DataAPI::data_api_save_permission_filter.content_data',
                    count => 1,
                },
                {   name =>
                        'MT::App::DataAPI::data_api_save_filter.content_data',
                    count => 1,
                },
                {   name =>
                        'MT::App::DataAPI::data_api_pre_save.content_data',
                    count => 1,
                },
                {   name =>
                        'MT::App::DataAPI::data_api_post_save.content_data',
                    count => 1,
                },
            ],
            result => sub {
                MT->model('content_data')->load(
                    { content_type_id => $content_type_id, },
                    {   sort      => 'id',
                        direction => 'descend',
                        limit     => 1,
                    },
                );
            },
        }
    );

    test_data_api(
        {   note   => 'system permission and draft content_data',
            path   => "/v4/sites/$site_id/contentTypes/$content_type_id/data",
            method => 'POST',
            params =>
                { content_data => { label => unique_content_data_label() , status => 'Draft', }, },
            restrictions => {
                0 => [

                    # 'create_new_content_data',
                    'publish_all_content_data',
                ],
                $site_id => [
                    'create_new_content_data',
                    'create_new_content_data_' . $content_type->unique_id,
                    'publish_all_content_data',
                    'publish_all_content_data_' . $content_type->unique_id,
                    'publish_own_content_data_' . $content_type->unique_id,
                ],
            },
            callbacks => [
                {   name =>
                        'MT::App::DataAPI::data_api_save_permission_filter.content_data',
                    count => 1,
                },
                {   name =>
                        'MT::App::DataAPI::data_api_save_filter.content_data',
                    count => 1,
                },
                {   name =>
                        'MT::App::DataAPI::data_api_pre_save.content_data',
                    count => 1,
                },
                {   name =>
                        'MT::App::DataAPI::data_api_post_save.content_data',
                    count => 1,
                },
            ],
            result => sub {
                MT->model('content_data')->load(
                    { content_type_id => $content_type_id, },
                    {   sort      => 'id',
                        direction => 'descend',
                        limit     => 1,
                    },
                );
            },
        }
    );

    test_data_api(
        {   note   => 'blog.manage_content_data',
            path   => "/v4/sites/$site_id/contentTypes/$content_type_id/data",
            method => 'POST',
            params => { content_data => { label => unique_content_data_label() }, },
            restrictions => {
                0 => [
                    'create_new_content_data', 'publish_all_content_data',
                ],
                $site_id => [

                    # 'create_new_content_data',
                    'create_new_content_data_' . $content_type->unique_id,

                    # 'publish_all_content_data',
                    'publish_all_content_data_' . $content_type->unique_id,
                    'publish_own_content_data_' . $content_type->unique_id,
                ],
            },
            callbacks => [
                {   name =>
                        'MT::App::DataAPI::data_api_save_permission_filter.content_data',
                    count => 1,
                },
                {   name =>
                        'MT::App::DataAPI::data_api_save_filter.content_data',
                    count => 1,
                },
                {   name =>
                        'MT::App::DataAPI::data_api_pre_save.content_data',
                    count => 1,
                },
                {   name =>
                        'MT::App::DataAPI::data_api_post_save.content_data',
                    count => 1,
                },
            ],
            result => sub {
                MT->model('content_data')->load(
                    { content_type_id => $content_type_id, },
                    {   sort      => 'id',
                        direction => 'descend',
                        limit     => 1,
                    },
                );
            },
        }
    );

    test_data_api(
        {   note   => 'blog.manage_content_data and draft content_data',
            path   => "/v4/sites/$site_id/contentTypes/$content_type_id/data",
            method => 'POST',
            params =>
                { content_data => { label => unique_content_data_label(), status => 'Draft', }, },
            restrictions => {
                0 => [
                    'create_new_content_data', 'publish_all_content_data',
                ],
                $site_id => [

                    # 'create_new_content_data',
                    'create_new_content_data_' . $content_type->unique_id,

                    'publish_all_content_data',
                    'publish_all_content_data_' . $content_type->unique_id,
                    'publish_own_content_data_' . $content_type->unique_id,
                ],
            },
            callbacks => [
                {   name =>
                        'MT::App::DataAPI::data_api_save_permission_filter.content_data',
                    count => 1,
                },
                {   name =>
                        'MT::App::DataAPI::data_api_save_filter.content_data',
                    count => 1,
                },
                {   name =>
                        'MT::App::DataAPI::data_api_pre_save.content_data',
                    count => 1,
                },
                {   name =>
                        'MT::App::DataAPI::data_api_post_save.content_data',
                    count => 1,
                },
            ],
            result => sub {
                MT->model('content_data')->load(
                    { content_type_id => $content_type_id, },
                    {   sort      => 'id',
                        direction => 'descend',
                        limit     => 1,
                    },
                );
            },
        }
    );

    test_data_api(
        {   note   => 'blog.manage_content_data:???',
            path   => "/v4/sites/$site_id/contentTypes/$content_type_id/data",
            method => 'POST',
            params => { content_data => { label => unique_content_data_label() }, },
            restrictions => {
                0 => [
                    'create_new_content_data', 'publish_all_content_data',
                ],
                $site_id => [

                    'create_new_content_data',

                    # 'create_new_content_data_' . $content_type->unique_id,

                    'publish_all_content_data',

                    # 'publish_all_content_data_' . $content_type->unique_id,
                    'publish_own_content_data_' . $content_type->unique_id,
                ],
            },
            callbacks => [
                {   name =>
                        'MT::App::DataAPI::data_api_save_permission_filter.content_data',
                    count => 1,
                },
                {   name =>
                        'MT::App::DataAPI::data_api_save_filter.content_data',
                    count => 1,
                },
                {   name =>
                        'MT::App::DataAPI::data_api_pre_save.content_data',
                    count => 1,
                },
                {   name =>
                        'MT::App::DataAPI::data_api_post_save.content_data',
                    count => 1,
                },
            ],
            result => sub {
                MT->model('content_data')->load(
                    { content_type_id => $content_type_id, },
                    {   sort      => 'id',
                        direction => 'descend',
                        limit     => 1,
                    },
                );
            },
        }
    );

    test_data_api(
        {   note   => 'blog.manage_content_data:??? and own content_data',
            path   => "/v4/sites/$site_id/contentTypes/$content_type_id/data",
            method => 'POST',
            params => { content_data => { label => unique_content_data_label() }, },
            restrictions => {
                0 => [
                    'create_new_content_data', 'publish_all_content_data',
                ],
                $site_id => [

                    'create_new_content_data',

                    # 'create_new_content_data_' . $content_type->unique_id,

                    'publish_all_content_data',
                    'publish_all_content_data_' . $content_type->unique_id,

                    # 'publish_own_content_data_' . $content_type->unique_id,
                ],
            },
            callbacks => [
                {   name =>
                        'MT::App::DataAPI::data_api_save_permission_filter.content_data',
                    count => 1,
                },
                {   name =>
                        'MT::App::DataAPI::data_api_save_filter.content_data',
                    count => 1,
                },
                {   name =>
                        'MT::App::DataAPI::data_api_pre_save.content_data',
                    count => 1,
                },
                {   name =>
                        'MT::App::DataAPI::data_api_post_save.content_data',
                    count => 1,
                },
            ],
            result => sub {
                MT->model('content_data')->load(
                    { content_type_id => $content_type_id, },
                    {   sort      => 'id',
                        direction => 'descend',
                        limit     => 1,
                    },
                );
            },
        }
    );

    test_data_api(
        {   note   => 'blog.manage_content_data:??? and draft content_data',
            path   => "/v4/sites/$site_id/contentTypes/$content_type_id/data",
            method => 'POST',
            params =>
                { content_data => { label => unique_content_data_label(), status => 'Draft' }, },
            restrictions => {
                0 => [
                    'create_new_content_data', 'publish_all_content_data',
                ],
                $site_id => [

                    'create_new_content_data',

                    # 'create_new_content_data_' . $content_type->unique_id,

                    'publish_all_content_data',
                    'publish_all_content_data_' . $content_type->unique_id,
                    'publish_own_content_data_' . $content_type->unique_id,
                ],
            },
            callbacks => [
                {   name =>
                        'MT::App::DataAPI::data_api_save_permission_filter.content_data',
                    count => 1,
                },
                {   name =>
                        'MT::App::DataAPI::data_api_save_filter.content_data',
                    count => 1,
                },
                {   name =>
                        'MT::App::DataAPI::data_api_pre_save.content_data',
                    count => 1,
                },
                {   name =>
                        'MT::App::DataAPI::data_api_post_save.content_data',
                    count => 1,
                },
            ],
            result => sub {
                MT->model('content_data')->load(
                    { content_type_id => $content_type_id, },
                    {   sort      => 'id',
                        direction => 'descend',
                        limit     => 1,
                    },
                );
            },
        }
    );

    test_data_api(
        {   note   => 'unpublished_on',
            path   => "/v4/sites/$site_id/contentTypes/$content_type_id/data",
            method => 'POST',
            params => {
                content_data => {
                    label           => unique_content_data_label(),
                    unpublishedDate => '2020-01-01 00:00:00'
                },
            },
            complete => sub {
                my $cd = MT->model('content_data')->load(
                    { content_type_id => $content_type_id, },
                    {   sort      => 'id',
                        direction => 'descend',
                        limit     => 1,
                    },
                );
                is( int($cd->unpublished_on) => '20200101000000' );
            },
        }
    );

    test_data_api(
        {   note   => 'empty unpublished_on',
            path   => "/v4/sites/$site_id/contentTypes/$content_type_id/data",
            method => 'POST',
            params => {
                content_data => { label => unique_content_data_label(), unpublishedDate => '' },
            },
            complete => sub {
                my $cd = MT->model('content_data')->load(
                    { content_type_id => $content_type_id, },
                    {   sort      => 'id',
                        direction => 'descend',
                        limit     => 1,
                    },
                );
                is( $cd->unpublished_on => undef );
            },
        }
    );

    test_data_api(
        {   note   => 'superuser',
            path   => "/v4/sites/$site_id/contentTypes/$content_type_id/data",
            method => 'POST',
            is_superuser => 1,
            restrictions => {
                0 => [
                    'create_new_content_data', 'publish_all_content_data',
                ],
                $site_id => [
                    'create_new_content_data',
                    'create_new_content_data_' . $content_type->unique_id,
                    'publish_all_content_data',
                    'publish_all_content_data_' . $content_type->unique_id,
                    'publish_own_content_data_' . $content_type->unique_id,
                ],
            },
            params    => { content_data => { label => unique_content_data_label() }, },
            callbacks => [
                {   name =>
                        'MT::App::DataAPI::data_api_save_permission_filter.content_data',
                    count => 0,
                },
                {   name =>
                        'MT::App::DataAPI::data_api_save_filter.content_data',
                    count => 1,
                },
                {   name =>
                        'MT::App::DataAPI::data_api_pre_save.content_data',
                    count => 1,
                },
                {   name =>
                        'MT::App::DataAPI::data_api_post_save.content_data',
                    count => 1,
                },
            ],
            result => sub {
                MT->model('content_data')->load(
                    { content_type_id => $content_type_id, },
                    {   sort      => 'id',
                        direction => 'descend',
                        limit     => 1,
                    },
                );
            },
        }
    );

    test_data_api(
        {   note => 'content type field (MTC-26261)',
            path =>
                "/v4/sites/$site_id/contentTypes/$ct_with_content_type_id/data",
            method       => 'POST',
            is_superuser => 1,
            params       => {
                content_data => {
                    label => 'cd with content type',
                    data  => [
                        {   id   => $content_type_field->id,
                            data => [ $cd_with_datetime->id ],
                        },
                    ],
                },
            },
            result => sub {
                my $cd = MT->model('content_data')->load(
                    { content_type_id => $ct_with_content_type_id, },
                    {   sort      => 'id',
                        direction => 'descend',
                        limit     => 1,
                    },
                );
                ok $cd && %{ $cd->data };
                $cd;
            },
        }
    );

    test_data_api(
        {   note => 'datetime field (MTC-26262; no data field)',
            path =>
                "/v4/sites/$site_id/contentTypes/$ct_with_datetime_id/data",
            method       => 'POST',
            is_superuser => 1,
            params => { content_data => { label => 'no data field', }, },
            result => sub {
                ok my $cd = MT->model('content_data')->load(
                    { content_type_id => $ct_with_datetime_id, },
                    {   sort      => 'id',
                        direction => 'descend',
                        limit     => 1,
                    },
                );
                $cd;
            },
        }
    );

    test_data_api(
        {   note => 'datetime field (MTC-26262/26264; empty)',
            path =>
                "/v4/sites/$site_id/contentTypes/$ct_with_datetime_id/data",
            method       => 'POST',
            is_superuser => 1,
            params       => {
                content_data => {
                    label => 'empty',
                    data  => [
                        {   id   => $datetime_field->id,
                            data => '',
                        }
                    ],
                },
            },
            result => sub {
                ok my $cd = MT->model('content_data')->load(
                    { content_type_id => $ct_with_datetime_id, },
                    {   sort      => 'id',
                        direction => 'descend',
                        limit     => 1,
                    },
                );
                ok %{ $cd->data };
                $cd;
            },
        }
    );

    test_data_api(
        {   note => 'datetime field (MTC-26262/26264; yyyymmddHHMMSS format)',
            path =>
                "/v4/sites/$site_id/contentTypes/$ct_with_datetime_id/data",
            method       => 'POST',
            is_superuser => 1,
            params       => {
                content_data => {
                    label => 'yyyymmddHHMMSS',
                    data  => [
                        {   id   => $datetime_field->id,
                            data => '20190228000000',
                        }
                    ],
                },
            },
            result => sub {
                ok my $cd = MT->model('content_data')->load(
                    { content_type_id => $ct_with_datetime_id, },
                    {   sort      => 'id',
                        direction => 'descend',
                        limit     => 1,
                    },
                );
                ok %{ $cd->data };
                $cd;
            },
        }
    );

    test_data_api(
        {   note =>
                'datetime field (MTC-26262/26264; yyyy-mm-dd HH:MM:SS format)',
            path =>
                "/v4/sites/$site_id/contentTypes/$ct_with_datetime_id/data",
            method       => 'POST',
            is_superuser => 1,
            params       => {
                content_data => {
                    label => 'yyyy-mm-dd HH:MM:SS',
                    data  => [
                        {   id   => $datetime_field->id,
                            data => '2019-02-28 00:00:00',
                        }
                    ],
                },
            },
            result => sub {
                ok my $cd = MT->model('content_data')->load(
                    { content_type_id => $ct_with_datetime_id, },
                    {   sort      => 'id',
                        direction => 'descend',
                        limit     => 1,
                    },
                );
                ok %{ $cd->data };
                $cd;
            },
        }
    );

    test_data_api(
        {   note =>
                'datetime field (MTC-26262/26264; yyyy-mm-dd HH:MM:SS+Z format)',
            path =>
                "/v4/sites/$site_id/contentTypes/$ct_with_datetime_id/data",
            method       => 'POST',
            is_superuser => 1,
            params       => {
                content_data => {
                    label => 'yyyy-mm-dd HH:MM:SS+Z',
                    data  => [
                        {   id   => $datetime_field->id,
                            data => '2019-02-28 00:00:00+Z',
                        }
                    ],
                },
            },
            result => sub {
                ok my $cd = MT->model('content_data')->load(
                    { content_type_id => $ct_with_datetime_id, },
                    {   sort      => 'id',
                        direction => 'descend',
                        limit     => 1,
                    },
                );
                ok %{ $cd->data };
                $cd;
            },
        }
    );

    test_data_api(
        {   note => 'content type with data_label',
            path =>
                "/v4/sites/$site_id/contentTypes/$ct_with_data_label_id/data",
            method       => 'POST',
            is_superuser => 1,
            params       => {
                content_data => {
                    data => [
                        {   id   => $single_field2->id,
                            data => 'test',
                        }
                    ],
                },
            },
            result => sub {
                ok my $cd = MT->model('content_data')->load(
                    { content_type_id => $ct_with_data_label_id, },
                    {   sort      => 'id',
                        direction => 'descend',
                        limit     => 1,
                    },
                );
                ok %{ $cd->data };
                $cd;
            },
        }
    );

    test_data_api({
        note         => 'Category Set field (MTC-26481; no data field)',
        path         => "/v4/sites/$site_id/contentTypes/$ct_with_category_id/data",
        method       => 'POST',
        is_superuser => 1,
        params       => { content_data => { label => 'no category field', }, },
        result       => sub {
            ok my $cd = MT->model('content_data')->load(
                { content_type_id => $ct_with_category_id, },
                {
                    sort      => 'id',
                    direction => 'descend',
                    limit     => 1,
                },
            );
            $cd;
        },
    });

    test_data_api({
        note         => 'Category Set field (MTC-26481)',
        path         => "/v4/sites/$site_id/contentTypes/$ct_with_category_id/data",
        method       => 'POST',
        is_superuser => 1,
        params       => {
            content_data => {
                label => 'category field',
                data  => [{
                        id   => $category_field->id,
                        data => [$parent_category_id],
                    },
                ],
            },
        },
        result => sub {
            ok my $cd = MT->model('content_data')->load(
                { content_type_id => $ct_with_category_id, },
                {
                    sort      => 'id',
                    direction => 'descend',
                    limit     => 1,
                },
            );
            $cd;
        },
    });

    test_data_api({
        note         => 'Asset field (MTC-26481; no data field)',
        path         => "/v4/sites/$site_id/contentTypes/$ct_with_asset_id/data",
        method       => 'POST',
        is_superuser => 1,
        params       => { content_data => { label => 'no asset field', }, },
        result       => sub {
            ok my $cd = MT->model('content_data')->load(
                { content_type_id => $ct_with_asset_id, },
                {
                    sort      => 'id',
                    direction => 'descend',
                    limit     => 1,
                },
            );
            $cd;
        },
    });

    test_data_api({
        note         => 'Asset field (MTC-26481)',
        path         => "/v4/sites/$site_id/contentTypes/$ct_with_asset_id/data",
        method       => 'POST',
        is_superuser => 1,
        params       => {
            content_data => {
                label => 'asset field',
                data  => [{
                        id   => $asset_field->id,
                        data => [$asset_id],
                    },
                ],
            },
        },
        result => sub {
            ok my $cd = MT->model('content_data')->load(
                { content_type_id => $ct_with_asset_id, },
                {
                    sort      => 'id',
                    direction => 'descend',
                    limit     => 1,
                },
            );
            $cd;
        },
    });

    test_data_api({
        note         => 'Retrieve convert_breaks as format field (MTC-26477)',
        path         => "/v5/sites/$site_id/contentTypes/@{[$ct_with_multi_line_text->id]}/data",
        method       => 'POST',
        is_superuser => 1,
        params       => {
            content_data => {
                label => 'Multi line text',
                data  => [{
                        id     => $multi_line_text_field->id,
                        data   => <<'TEXT',
ただいま試験中

1. 本日は晴天なり
TEXT
                        format => 'markdown',
                    },
                ],
            },
        },
        complete => sub {
            my ($data, $body, $header) = @_;
            my $obj = MT::Util::from_json($body);
            is($obj->{data}[0]{format}, 'markdown', 'Check format field in the response.');
            my $cd             = MT->model('cd')->load($obj->{id});
            my $convert_breaks = MT::Serialize->unserialize($cd->convert_breaks);
            is($$convert_breaks->{ $multi_line_text_field->id }, 'markdown', 'Check format value in DB.');
        },
    });
}

sub irregular_tests_for_list {
    test_data_api(
        {   note   => 'invalid site_id',
            path   => "/v4/sites/1000/contentTypes/$content_type_id/data",
            method => 'GET',
            code   => 404,
        }
    );
    test_data_api(
        {   note   => 'invalid content_type_id',
            path   => "/v4/sites/$site_id/contentTypes/1000/data",
            method => 'GET',
            code   => 404,
        }
    );
    test_data_api(
        {   note   => 'other site',
            path   => "/v4/sites/2/contentTypes/$content_type_id/data",
            method => 'GET',
            code   => 404,
        }
    );
    test_data_api(
        {   note   => 'system scope',
            path   => "/v4/sites/0/contentTypes/$content_type_id/data",
            method => 'GET',
            code   => 404,
        }
    );
}

sub normal_tests_for_list {
    my $exists_draft = MT->model('content_data')->exist(
        {   content_type_id => $content_type_id,
            status          => MT::ContentStatus::HOLD(),
        }
    );
    unless ($exists_draft) {
        MT::Test::Permission->make_content_data(
            blog_id         => $site_id,
            content_type_id => $content_type_id,
            status          => MT::ContentStatus::HOLD(),
        );
    }
    my $exists_others = MT->model('content_data')->exist(
        {   content_type_id => $other_content_type_id,
            status          => MT::ContentStatus::RELEASE(),
        }
    );
    unless ($exists_others) {
        MT::Test::Permission->make_content_data(
            blog_id         => $site_id,
            content_type_id => $other_content_type_id,
            status          => MT::ContentStatus::RELEASE(),
        );
    }

    test_data_api(
        {   note   => 'not logged in',
            path   => "/v4/sites/$site_id/contentTypes/$content_type_id/data",
            method => 'GET',
            author_id => 0,
            callbacks => [
                {   name =>
                        'MT::App::DataAPI::data_api_list_permission_filter.content_data',
                    count => 1,
                },
                {   name  => 'data_api_pre_load_filtered_list.content_data',
                    count => 2,
                },
            ],
            result => sub {
                my @cd = MT->model('content_data')->load(
                    {   content_type_id => $content_type_id,
                        status          => MT::ContentStatus::RELEASE(),
                    },
                    { sort => 'modified_on', direction => 'descend', },
                );
                +{  totalResults => scalar @cd,
                    items => MT::DataAPI::Resource->from_object( \@cd ),
                };
            },
        }
    );

    test_data_api(
        {   note   => 'logged in',
            path   => "/v4/sites/$site_id/contentTypes/$content_type_id/data",
            method => 'GET',
            callbacks => [
                {   name =>
                        'MT::App::DataAPI::data_api_list_permission_filter.content_data',
                    count => 1,
                },
                {   name  => 'data_api_pre_load_filtered_list.content_data',
                    count => 2,
                },
            ],
            result => sub {
                my @cd = MT->model('content_data')->load(
                    { content_type_id => $content_type_id, },
                    { sort => 'modified_on', direction => 'descend', },
                );
                +{  totalResults => scalar @cd,
                    items => MT::DataAPI::Resource->from_object( \@cd ),
                };
            },
        }
    );

    test_data_api(
        {   note   => 'sortBy',
            path   => "/v4/sites/$site_id/contentTypes/$content_type_id/data",
            method => 'GET',
            params => { sortBy => 'label' },
            result => sub {
                my @cd = MT->model('content_data')->load(
                    { content_type_id => $content_type_id, },
                    { sort            => 'label', direction => 'descend', },
                );
                +{  totalResults => scalar @cd,
                    items => MT::DataAPI::Resource->from_object( \@cd ),
                };
            },
        }
    );

    test_data_api({
        note      => 'Retrieve format field by not logged in user (MTC-27955)',
        path      => "/v5/sites/$site_id/contentTypes/@{[$ct_with_multi_line_text->id]}/data",
        method    => 'GET',
        author_id => 0,
        complete  => sub {
            my ($data, $body, $header) = @_;
            my $obj       = MT::Util::from_json($body);
            my $cd        = MT->model('cd')->load($obj->{items}[0]{id});
            my $body_text = $obj->{items}[0]{data}[0]{data};
            my $expected  = Encode::decode_utf8(<<'HTML');
<p>ただいま試験中</p>

<ol start='1'>
<li>本日は晴天なり</li>
</ol>
HTML
            my $trim = sub {
                my ($str) = @_;
                $str =~ s/\A(\r\n|\r|\n|\s)+|(\r\n|\r|\n|\s)+\z//g;
                return $str;
            };
            is($trim->($body_text), $trim->($expected));
            ok(!exists $obj->{items}[0]{data}[0]{format});
        },
    });

    test_data_api({
        note     => 'Retrieve format field by logged in user (MTC-27955)',
        path     => "/v5/sites/$site_id/contentTypes/@{[$ct_with_multi_line_text->id]}/data",
        method   => 'GET',
        complete => sub {
            my ($data, $body, $header) = @_;
            my $obj                 = MT::Util::from_json($body);
            my $cd                  = MT->model('cd')->load($obj->{items}[0]{id});
            my $body_text = $obj->{items}[0]{data}[0]{data};
            my $expected  = Encode::decode_utf8(<<'HTML');
<p>ただいま試験中</p>

<ol start='1'>
<li>本日は晴天なり</li>
</ol>
HTML
            my $trim = sub {
                my ($str) = @_;
                $str =~ s/\A(\r\n|\r|\n|\s)+|(\r\n|\r|\n|\s)+\z//g;
                return $str;
            };
            is($trim->($body_text), $trim->($expected));
            ok(exists $obj->{items}[0]{data}[0]{format});
        },
    });

    test_data_api({
        note     => 'noTextFilter=1 with logged in user (MTC-27955)',
        path     => "/v5/sites/$site_id/contentTypes/@{[$ct_with_multi_line_text->id]}/data",
        method   => 'GET',
        params   => { noTextFilter => 1 },
        complete => sub {
            my ($data, $body, $header) = @_;
            my $obj = MT::Util::from_json($body);
            my $cd  = MT->model('cd')->load($obj->{items}[0]{id});
            is($obj->{items}[0]{data}[0]{data}, $cd->data->{ $multi_line_text_field->id });
            ok(exists $obj->{items}[0]{data}[0]{format});
        },
    });
}

sub irregular_tests_for_get {
    my $cd
        = MT->model('content_data')
        ->load( { content_type_id => $content_type_id } )
        or die;

    test_data_api(
        {   note => 'invalid site_id',
            path => "/v4/sites/1000/contentTypes/$content_type_id/data/"
                . $cd->id,
            method => 'GET',
            code   => 404,
        }
    );
    test_data_api(
        {   note   => 'invalid content_type_id',
            path   => "/v4/sites/$site_id/contentTypes/1000/data/" . $cd->id,
            method => 'GET',
            code   => 404,
        }
    );
    test_data_api(
        {   note => 'invalid content_data_id',
            path =>
                "/v4/sites/$site_id/contentTypes/$content_type_id/data/1000",
            method => 'GET',
            code   => 404,
        }
    );
    test_data_api(
        {   note => 'other site',
            path => "/v4/sites/2/contentTypes/$content_type_id/data/"
                . $cd->id,
            method => 'GET',
            code   => 404,
        }
    );
    test_data_api(
        {   note => 'other content_type',
            path =>
                "/v4/sites/$site_id/contentTypes/$other_content_type_id/data/"
                . $cd->id,
            method => 'GET',
            code   => 404,
        }
    );

    $cd->status( MT::ContentStatus::HOLD() );
    $cd->save or die;
    test_data_api(
        {   note => 'draft content_data without permission',
            path => "/v4/sites/$site_id/contentTypes/$content_type_id/data/"
                . $cd->id,
            method       => 'GET',
            restrictions => {
                0        => ['edit_all_content_data'],
                $site_id => [
                    'edit_all_content_data',
                    'edit_all_content_data_' . $content_type->unique_id,
                    'edit_own_published_content_data_'
                        . $content_type->unique_id,
                    'edit_all_published_content_data_'
                        . $content_type->unique_id,
                    'edit_own_unpublished_content_data_'
                        . $content_type->unique_id,
                    'edit_all_unpublished_content_data_'
                        . $content_type->unique_id,
                ],
            },
            code => 403,
        }
    );

    test_data_api(
        {   note => 'draft content_data when not logged in',
            path => "/v4/sites/$site_id/contentTypes/$content_type_id/data/"
                . $cd->id,
            method    => 'GET',
            author_id => 0,
            code      => 403,
        }
    );

}

sub normal_tests_for_get {
    my $cd
        = MT->model('content_data')
        ->load( { content_type_id => $content_type_id } )
        or die;

    $cd->status( MT::ContentStatus::RELEASE() );
    $cd->save or die;
    test_data_api(
        {   note => 'not logged in',
            path => "/v4/sites/$site_id/contentTypes/$content_type_id/data/"
                . $cd->id,
            author_id => 0,
            method    => 'GET',
            callbacks => [
                {   name =>
                        'MT::App::DataAPI::data_api_view_permission_filter.content_data',
                    count => 1,
                },
            ],
            result => sub {$cd},
        }
    );

    test_data_api(
        {   note => 'permitted user',
            path => "/v4/sites/$site_id/contentTypes/$content_type_id/data/"
                . $cd->id,
            method    => 'GET',
            callbacks => [
                {   name =>
                        'MT::App::DataAPI::data_api_view_permission_filter.content_data',
                    count => 1,
                },
            ],
            result => sub {$cd},
        }
    );

    $cd->status( MT::ContentStatus::HOLD() );
    $cd->save or die;
    test_data_api(
        {   note => 'draft content_data by permitted user',
            path => "/v4/sites/$site_id/contentTypes/$content_type_id/data/"
                . $cd->id,
            method       => 'GET',
            restrictions => {
                0        => ['edit_all_content_data'],
                $site_id => [
                    'edit_all_content_data',
                    'edit_all_content_data_' . $content_type->unique_id,
                    'edit_own_published_content_data_'
                        . $content_type->unique_id,
                    'edit_all_published_content_data_'
                        . $content_type->unique_id,

                    # 'edit_own_unpublished_content_data_'
                    # . $content_type->unique_id,
                    'edit_all_unpublished_content_data_'
                        . $content_type->unique_id,
                ],
            },
            callbacks => [
                {   name =>
                        'MT::App::DataAPI::data_api_view_permission_filter.content_data',
                    count => 1,
                },
            ],
            result => sub {$cd},
        }
    );
}

sub irregular_tests_for_update {
    my $cd
        = MT->model('content_data')
        ->load( { content_type_id => $content_type_id } )
        or die;

    test_data_api(
        {   note => 'not logged in',
            path => "/v4/sites/$site_id/contentTypes/$content_type_id/data/"
                . $cd->id,
            method    => 'PUT',
            author_id => 0,
            code      => 401,
        }
    );
    test_data_api(
        {   note => 'invalid site_id',
            path => "/v4/sites/1000/contentTypes/$content_type_id/data/"
                . $cd->id,
            method => 'PUT',
            code   => 404,
        }
    );
    test_data_api(
        {   note   => 'invalid content_type_id',
            path   => "/v4/sites/$site_id/contentTypes/1000/data/" . $cd->id,
            method => 'PUT',
            code   => 404,
        }
    );
    test_data_api(
        {   note => 'invalid content_data_id',
            path =>
                "/v4/sites/$site_id/contentTypes/$content_type_id/data/1000",
            method => 'PUT',
            code   => 404,
        }
    );
    test_data_api(
        {   note => 'other site',
            path => "/v4/sites/2/contentTypes/$content_type_id/data/"
                . $cd->id,
            method => 'PUT',
            code   => 404,
        }
    );
    test_data_api(
        {   note => 'other content_type',
            path =>
                "/v4/sites/$site_id/contentTypes/$other_content_type_id/data/"
                . $cd->id,
            method => 'PUT',
            code   => 404,
        }
    );
    test_data_api(
        {   note => 'no permission',
            path => "/v4/sites/$site_id/contentTypes/$content_type_id/data/"
                . $cd->id,
            method       => 'PUT',
            params       => { content_data => {} },
            restrictions => {
                0        => ['edit_all_content_data'],
                $site_id => [
                    'edit_all_content_data',
                    'edit_all_content_data_' . $content_type->unique_id,
                    'edit_own_published_content_data_'
                        . $content_type->unique_id,
                    'edit_all_published_content_data_'
                        . $content_type->unique_id,
                    'edit_own_unpublished_content_data_'
                        . $content_type->unique_id,
                    'edit_all_unpublished_content_data_'
                        . $content_type->unique_id,
                ],
            },
            code => 403,
        }
    );

    $cd->status( MT::ContentStatus::HOLD() );
    $cd->save or die;
    test_data_api(
        {   note => 'published permissions and draft content_data',
            path => "/v4/sites/$site_id/contentTypes/$content_type_id/data/"
                . $cd->id,
            method       => 'PUT',
            params       => { content_data => {} },
            restrictions => {
                0        => ['edit_all_content_data'],
                $site_id => [
                    'edit_all_content_data',
                    'edit_all_content_data_' . $content_type->unique_id,

                    # 'edit_own_published_content_data_'
                    #     . $content_type->unique_id,
                    # 'edit_all_published_content_data_'
                    #     . $content_type->unique_id,
                    'edit_own_unpublished_content_data_'
                        . $content_type->unique_id,
                    'edit_all_unpublished_content_data_'
                        . $content_type->unique_id,
                ],
            },
            code => 403,
        }
    );

    $cd->status( MT::ContentStatus::RELEASE() );
    $cd->save or die;
    test_data_api(
        {   note => 'unpublished permissions and published content_data',
            path => "/v4/sites/$site_id/contentTypes/$content_type_id/data/"
                . $cd->id,
            method       => 'PUT',
            params       => { content_data => {} },
            restrictions => {
                0        => ['edit_all_content_data'],
                $site_id => [
                    'edit_all_content_data',
                    'edit_all_content_data_' . $content_type->unique_id,
                    'edit_own_published_content_data_'
                        . $content_type->unique_id,
                    'edit_all_published_content_data_'
                        . $content_type->unique_id,

                    # 'edit_own_unpublished_content_data_'
                    # . $content_type->unique_id,
                    # 'edit_all_unpublished_content_data_'
                    # . $content_type->unique_id,
                ],
            },
            code => 403,
        }
    );

    $cd->author_id(2);
    $cd->save or die;
    test_data_api(
        {   note => 'own permissions and other content_data',
            path => "/v4/sites/$site_id/contentTypes/$content_type_id/data/"
                . $cd->id,
            method       => 'PUT',
            params       => { content_data => {} },
            restrictions => {
                0        => ['edit_all_content_data'],
                $site_id => [
                    'edit_all_content_data',
                    'edit_all_content_data_' . $content_type->unique_id,

                    # 'edit_own_published_content_data_'
                    #    . $content_type->unique_id,
                    'edit_all_published_content_data_'
                        . $content_type->unique_id,

                    #  'edit_own_unpublished_content_data_'
                    # . $content_type->unique_id,
                    'edit_all_unpublished_content_data_'
                        . $content_type->unique_id,
                ],
            },
            code => 403,
        }
    );
    test_data_api(
        {   note => 'basename is too long (ascii)',
            path => "/v4/sites/$site_id/contentTypes/$content_type_id/data/"
                . $cd->id,
            method       => 'PUT',
            params       => { content_data => { basename => 'a' x 247 }, },
            restrictions => {
                $site_id => [
                    'edit_all_content_data',
                    'edit_all_content_data_' . $content_type->unique_id,
                    'edit_own_published_content_data_'
                        . $content_type->unique_id,
                    'edit_all_published_content_data_'
                        . $content_type->unique_id,
                    'edit_own_unpublished_content_data_'
                        . $content_type->unique_id,
                    'edit_all_unpublished_content_data_'
                        . $content_type->unique_id,
                ],
            },
            code  => 500,
            error => qr/basename is too long/,
        }
    );
    test_data_api(
        {   note => 'basename is too long (utf8)',
            path => "/v4/sites/$site_id/contentTypes/$content_type_id/data/"
                . $cd->id,
            method => 'PUT',
            params => { content_data => { basename => chr(0x3042) x 83 }, },
            restrictions => {
                $site_id => [
                    'edit_all_content_data',
                    'edit_all_content_data_' . $content_type->unique_id,
                    'edit_own_published_content_data_'
                        . $content_type->unique_id,
                    'edit_all_published_content_data_'
                        . $content_type->unique_id,
                    'edit_own_unpublished_content_data_'
                        . $content_type->unique_id,
                    'edit_all_unpublished_content_data_'
                        . $content_type->unique_id,
                ],
            },
            code  => 500,
            error => qr/basename is too long/,
        }
    );
}

sub normal_tests_for_update {
    my $cd
        = MT->model('content_data')
        ->load( { content_type_id => $content_type_id } )
        or die;

    $cd->status( MT::ContentStatus::HOLD() );
    $cd->save or die;
    test_data_api(
        {   note => 'system permission',
            path => "/v4/sites/$site_id/contentTypes/$content_type_id/data/"
                . $cd->id,
            method       => 'PUT',
            params       => { content_data => {}, },
            restrictions => {

                # 0        => ['edit_all_content_data'],
                $site_id => [
                    'edit_all_content_data',
                    'edit_all_content_data_' . $content_type->unique_id,
                    'edit_own_published_content_data_'
                        . $content_type->unique_id,
                    'edit_all_published_content_data_'
                        . $content_type->unique_id,
                    'edit_own_unpublished_content_data_'
                        . $content_type->unique_id,
                    'edit_all_unpublished_content_data_'
                        . $content_type->unique_id,
                ],
            },
            callbacks => [
                {   name =>
                        'MT::App::DataAPI::data_api_save_permission_filter.content_data',
                    count => 1,
                },
                {   name =>
                        'MT::App::DataAPI::data_api_save_filter.content_data',
                    count => 1,
                },
                {   name =>
                        'MT::App::DataAPI::data_api_pre_save.content_data',
                    count => 1,
                },
                {   name =>
                        'MT::App::DataAPI::data_api_post_save.content_data',
                    count => 1,
                },
            ],
            result => sub {
                $cd = MT->model('content_data')->load( $cd->id );
            },
        }
    );

    test_data_api(
        {   note => 'blog permission',
            path => "/v4/sites/$site_id/contentTypes/$content_type_id/data/"
                . $cd->id,
            method       => 'PUT',
            params       => { content_data => {}, },
            restrictions => {
                0        => ['edit_all_content_data'],
                $site_id => [

                    # 'edit_all_content_data',
                    'edit_all_content_data_' . $content_type->unique_id,
                    'edit_own_published_content_data_'
                        . $content_type->unique_id,
                    'edit_all_published_content_data_'
                        . $content_type->unique_id,
                    'edit_own_unpublished_content_data_'
                        . $content_type->unique_id,
                    'edit_all_unpublished_content_data_'
                        . $content_type->unique_id,
                ],
            },
            callbacks => [
                {   name =>
                        'MT::App::DataAPI::data_api_save_permission_filter.content_data',
                    count => 1,
                },
                {   name =>
                        'MT::App::DataAPI::data_api_save_filter.content_data',
                    count => 1,
                },
                {   name =>
                        'MT::App::DataAPI::data_api_pre_save.content_data',
                    count => 1,
                },
                {   name =>
                        'MT::App::DataAPI::data_api_post_save.content_data',
                    count => 1,
                },
            ],
            result => sub {
                $cd = MT->model('content_data')->load( $cd->id );
            },
        }
    );

    test_data_api(
        {   note => 'content_type permission',
            path => "/v4/sites/$site_id/contentTypes/$content_type_id/data/"
                . $cd->id,
            method       => 'PUT',
            params       => { content_data => {}, },
            restrictions => {
                0        => ['edit_all_content_data'],
                $site_id => [
                    'edit_all_content_data',

                    # 'edit_all_content_data_' . $content_type->unique_id,
                    'edit_own_published_content_data_'
                        . $content_type->unique_id,
                    'edit_all_published_content_data_'
                        . $content_type->unique_id,
                    'edit_own_unpublished_content_data_'
                        . $content_type->unique_id,
                    'edit_all_unpublished_content_data_'
                        . $content_type->unique_id,
                ],
            },
            callbacks => [
                {   name =>
                        'MT::App::DataAPI::data_api_save_permission_filter.content_data',
                    count => 1,
                },
                {   name =>
                        'MT::App::DataAPI::data_api_save_filter.content_data',
                    count => 1,
                },
                {   name =>
                        'MT::App::DataAPI::data_api_pre_save.content_data',
                    count => 1,
                },
                {   name =>
                        'MT::App::DataAPI::data_api_post_save.content_data',
                    count => 1,
                },
            ],
            result => sub {
                $cd = MT->model('content_data')->load( $cd->id );
            },
        }
    );

    $cd->author_id(2);
    $cd->save or die;
    test_data_api(
        {   note => 'content_type edit_all_unpublished permission',
            path => "/v4/sites/$site_id/contentTypes/$content_type_id/data/"
                . $cd->id,
            method       => 'PUT',
            params       => { content_data => {}, },
            restrictions => {
                0        => ['edit_all_content_data'],
                $site_id => [
                    'edit_all_content_data',
                    'edit_all_content_data_' . $content_type->unique_id,
                    'edit_own_published_content_data_'
                        . $content_type->unique_id,
                    'edit_all_published_content_data_'
                        . $content_type->unique_id,
                    'edit_own_unpublished_content_data_'
                        . $content_type->unique_id,

                    # 'edit_all_unpublished_content_data_'
                    # . $content_type->unique_id,
                ],
            },
            callbacks => [
                {   name =>
                        'MT::App::DataAPI::data_api_save_permission_filter.content_data',
                    count => 1,
                },
                {   name =>
                        'MT::App::DataAPI::data_api_save_filter.content_data',
                    count => 1,
                },
                {   name =>
                        'MT::App::DataAPI::data_api_pre_save.content_data',
                    count => 1,
                },
                {   name =>
                        'MT::App::DataAPI::data_api_post_save.content_data',
                    count => 1,
                },
            ],
            result => sub {
                $cd = MT->model('content_data')->load( $cd->id );
            },
        }
    );

    $cd->status( MT::ContentStatus::RELEASE() );
    $cd->save or die;
    test_data_api(
        {   note => 'content_type edit_all published permission',
            path => "/v4/sites/$site_id/contentTypes/$content_type_id/data/"
                . $cd->id,
            method       => 'PUT',
            params       => { content_data => {}, },
            restrictions => {
                0        => ['edit_all_content_data'],
                $site_id => [
                    'edit_all_content_data',
                    'edit_all_content_data_' . $content_type->unique_id,
                    'edit_own_published_content_data_'
                        . $content_type->unique_id,

                    # 'edit_all_published_content_data_'
                    # . $content_type->unique_id,
                    'edit_own_unpublished_content_data_'
                        . $content_type->unique_id,
                    'edit_all_unpublished_content_data_'
                        . $content_type->unique_id,
                ],
            },
            callbacks => [
                {   name =>
                        'MT::App::DataAPI::data_api_save_permission_filter.content_data',
                    count => 1,
                },
                {   name =>
                        'MT::App::DataAPI::data_api_save_filter.content_data',
                    count => 1,
                },
                {   name =>
                        'MT::App::DataAPI::data_api_pre_save.content_data',
                    count => 1,
                },
                {   name =>
                        'MT::App::DataAPI::data_api_post_save.content_data',
                    count => 1,
                },
            ],
            result => sub {
                $cd = MT->model('content_data')->load( $cd->id );
            },
        }
    );

    $cd->author_id(1);
    $cd->status( MT::ContentStatus::HOLD() );
    $cd->save or die;
    test_data_api(
        {   note => 'content_type edit_own_unpublished permission',
            path => "/v4/sites/$site_id/contentTypes/$content_type_id/data/"
                . $cd->id,
            method       => 'PUT',
            params       => { content_data => {}, },
            restrictions => {
                0        => ['edit_all_content_data'],
                $site_id => [
                    'edit_all_content_data',
                    'edit_all_content_data_' . $content_type->unique_id,
                    'edit_own_published_content_data_'
                        . $content_type->unique_id,
                    'edit_all_published_content_data_'
                        . $content_type->unique_id,

                    # 'edit_own_unpublished_content_data_'
                    # . $content_type->unique_id,
                    'edit_all_unpublished_content_data_'
                        . $content_type->unique_id,
                ],
            },
            callbacks => [
                {   name =>
                        'MT::App::DataAPI::data_api_save_permission_filter.content_data',
                    count => 1,
                },
                {   name =>
                        'MT::App::DataAPI::data_api_save_filter.content_data',
                    count => 1,
                },
                {   name =>
                        'MT::App::DataAPI::data_api_pre_save.content_data',
                    count => 1,
                },
                {   name =>
                        'MT::App::DataAPI::data_api_post_save.content_data',
                    count => 1,
                },
            ],
            result => sub {
                $cd = MT->model('content_data')->load( $cd->id );
            },
        }
    );

    $cd->status( MT::ContentStatus::RELEASE() );
    $cd->save or die;
    test_data_api(
        {   note => 'content_type edit_own_published permission',
            path => "/v4/sites/$site_id/contentTypes/$content_type_id/data/"
                . $cd->id,
            method       => 'PUT',
            params       => { content_data => {}, },
            restrictions => {
                0        => ['edit_all_content_data'],
                $site_id => [
                    'edit_all_content_data',
                    'edit_all_content_data_' . $content_type->unique_id,

                    # 'edit_own_published_content_data_'
                    #    . $content_type->unique_id,
                    'edit_all_published_content_data_'
                        . $content_type->unique_id,
                    'edit_own_unpublished_content_data_'
                        . $content_type->unique_id,
                    'edit_all_unpublished_content_data_'
                        . $content_type->unique_id,
                ],
            },
            callbacks => [
                {   name =>
                        'MT::App::DataAPI::data_api_save_permission_filter.content_data',
                    count => 1,
                },
                {   name =>
                        'MT::App::DataAPI::data_api_save_filter.content_data',
                    count => 1,
                },
                {   name =>
                        'MT::App::DataAPI::data_api_pre_save.content_data',
                    count => 1,
                },
                {   name =>
                        'MT::App::DataAPI::data_api_post_save.content_data',
                    count => 1,
                },
            ],
            result => sub {
                $cd = MT->model('content_data')->load( $cd->id );
            },
        }
    );

    test_data_api(
        {   note => 'empty unpublished_on',
            path => "/v4/sites/$site_id/contentTypes/$content_type_id/data/"
                . $cd->id,
            method   => 'PUT',
            params   => { content_data => { unpublishedDate => '' }, },
            complete => sub {
                $cd = MT->model('content_data')->load( $cd->id );
                is( $cd->unpublished_on => undef );
            },
        }
    );

    test_data_api(
        {   note => 'unpublished_on',
            path => "/v4/sites/$site_id/contentTypes/$content_type_id/data/"
                . $cd->id,
            method => 'PUT',
            params => {
                content_data => { unpublishedDate => '2020-01-01 00:00:00' },
            },
            complete => sub {
                $cd = MT->model('content_data')->load( $cd->id );
                is( int($cd->unpublished_on) => '20200101000000' );
            },
        }
    );

    test_data_api(
        {   note => 'superuser',
            path => "/v4/sites/$site_id/contentTypes/$content_type_id/data/"
                . $cd->id,
            method       => 'PUT',
            params       => { content_data => {}, },
            is_superuser => 1,
            restrictions => {
                0        => ['edit_all_content_data'],
                $site_id => [
                    'edit_all_content_data',
                    'edit_all_content_data_' . $content_type->unique_id,
                    'edit_own_published_content_data_'
                        . $content_type->unique_id,
                    'edit_all_published_content_data_'
                        . $content_type->unique_id,
                    'edit_own_unpublished_content_data_'
                        . $content_type->unique_id,
                    'edit_all_unpublished_content_data_'
                        . $content_type->unique_id,
                ],
            },
            callbacks => [
                {   name =>
                        'MT::App::DataAPI::data_api_save_permission_filter.content_data',
                    count => 0,
                },
                {   name =>
                        'MT::App::DataAPI::data_api_save_filter.content_data',
                    count => 1,
                },
                {   name =>
                        'MT::App::DataAPI::data_api_pre_save.content_data',
                    count => 1,
                },
                {   name =>
                        'MT::App::DataAPI::data_api_post_save.content_data',
                    count => 1,
                },
            ],
            result => sub {
                $cd = MT->model('content_data')->load( $cd->id );
            },
        }
    );
}

sub irregular_tests_for_delete {
    my $cd
        = MT->model('content_data')
        ->load( { content_type_id => $content_type_id } )
        or die;

    test_data_api(
        {   note => 'not logged in',
            path => "/v4/sites/$site_id/contentTypes/$content_type_id/data/"
                . $cd->id,
            method    => 'DELETE',
            author_id => 0,
            code      => 401,
        }
    );
    test_data_api(
        {   note => 'invalid site_id',
            path => "/v4/sites/1000/contentTypes/$content_type_id/data/"
                . $cd->id,
            method => 'DELETE',
            code   => 404,
        }
    );
    test_data_api(
        {   note   => 'invalid content_type_id',
            path   => "/v4/sites/$site_id/contentTypes/1000/data/" . $cd->id,
            method => 'DELETE',
            code   => 404,
        }
    );
    test_data_api(
        {   note => 'invalid content_data_id',
            path =>
                "/v4/sites/$site_id/contentTypes/$content_type_id/data/1000",
            method => 'DELETE',
            code   => 404,
        }
    );
    test_data_api(
        {   note => 'other site',
            path => "/v4/sites/2/contentTypes/$content_type_id/data/"
                . $cd->id,
            method => 'DELETE',
            code   => 404,
        }
    );
    test_data_api(
        {   note => 'other content_type',
            path =>
                "/v4/sites/$site_id/contentTypes/$other_content_type_id/data/"
                . $cd->id,
            method => 'DELETE',
            code   => 404,
        }
    );
    test_data_api(
        {   note => 'no permission',
            path => "/v4/sites/$site_id/contentTypes/$content_type_id/data/"
                . $cd->id,
            method       => 'DELETE',
            restrictions => {
                0        => ['edit_all_content_data'],
                $site_id => [
                    'edit_all_content_data',
                    'edit_all_content_data_' . $content_type->unique_id,
                    'edit_own_published_content_data_'
                        . $content_type->unique_id,
                    'edit_all_published_content_data_'
                        . $content_type->unique_id,
                    'edit_own_unpublished_content_data_'
                        . $content_type->unique_id,
                    'edit_all_unpublished_content_data_'
                        . $content_type->unique_id,
                ],
            },
            code => 403,
        }
    );

    $cd->status( MT::ContentStatus::RELEASE() );
    $cd->save or die $cd->errstr;
    test_data_api(
        {   note =>
                'remove published content data with unpublished permission',
            path => "/v4/sites/$site_id/contentTypes/$content_type_id/data/"
                . $cd->id,
            method       => 'DELETE',
            restrictions => {
                0        => ['edit_all_content_data'],
                $site_id => [
                    'edit_all_content_data',
                    'edit_all_content_data_' . $content_type->unique_id,
                    'edit_own_published_content_data_'
                        . $content_type->unique_id,
                    'edit_all_published_content_data_'
                        . $content_type->unique_id,

                    # 'edit_own_unpublished_content_data_'
                    # . $content_type->unique_id,
                    # 'edit_all_unpublished_content_data_'
                    # . $content_type->unique_id,
                ],
            },
            code => 403,
        }
    );

    $cd->status( MT::ContentStatus::HOLD() );
    $cd->save or die $cd->errstr;
    test_data_api(
        {   note =>
                'remove unpublished content data with published permission',
            path => "/v4/sites/$site_id/contentTypes/$content_type_id/data/"
                . $cd->id,
            method       => 'DELETE',
            restrictions => {
                0        => ['edit_all_content_data'],
                $site_id => [
                    'edit_all_content_data',
                    'edit_all_content_data_' . $content_type->unique_id,

                    # 'edit_own_published_content_data_'
                    #     . $content_type->unique_id,
                    # 'edit_all_published_content_data_'
                    #     . $content_type->unique_id,
                    'edit_own_unpublished_content_data_'
                        . $content_type->unique_id,
                    'edit_all_unpublished_content_data_'
                        . $content_type->unique_id,
                ],
            },
            code => 403,
        }
    );

    $cd->status( MT::ContentStatus::RELEASE() );
    $cd->author_id(2);
    $cd->save or die $cd->errstr;
    test_data_api(
        {   note => 'remove other published content data without permission',
            path => "/v4/sites/$site_id/contentTypes/$content_type_id/data/"
                . $cd->id,
            method       => 'DELETE',
            restrictions => {
                0        => ['edit_all_content_data'],
                $site_id => [
                    'edit_all_content_data',
                    'edit_all_content_data_' . $content_type->unique_id,

                    # 'edit_own_published_content_data_'
                    #     . $content_type->unique_id,
                    'edit_all_published_content_data_'
                        . $content_type->unique_id,
                    'edit_own_unpublished_content_data_'
                        . $content_type->unique_id,
                    'edit_all_unpublished_content_data_'
                        . $content_type->unique_id,
                ],
            },
            code => 403,
        }
    );

    $cd->status( MT::ContentStatus::HOLD() );
    $cd->author_id(2);
    $cd->save or die $cd->errstr;
    test_data_api(
        {   note =>
                'remove other unpublished content data without permission',
            path => "/v4/sites/$site_id/contentTypes/$content_type_id/data/"
                . $cd->id,
            method       => 'DELETE',
            restrictions => {
                0        => ['edit_all_content_data'],
                $site_id => [
                    'edit_all_content_data',
                    'edit_all_content_data_' . $content_type->unique_id,
                    'edit_own_published_content_data_'
                        . $content_type->unique_id,
                    'edit_all_published_content_data_'
                        . $content_type->unique_id,

                    # 'edit_own_unpublished_content_data_'
                    # . $content_type->unique_id,
                    'edit_all_unpublished_content_data_'
                        . $content_type->unique_id,
                ],
            },
            code => 403,
        }
    );
}

sub normal_tests_for_delete {
    my $cd;

    $cd = MT::Test::Permission->make_content_data(
        blog_id         => $site_id,
        content_type_id => $content_type_id,
    );
    test_data_api(
        {   note => 'system permission',
            path => "/v4/sites/$site_id/contentTypes/$content_type_id/data/"
                . $cd->id,
            method       => 'DELETE',
            restrictions => {

                # 0        => ['edit_all_content_data'],
                $site_id => [
                    'edit_all_content_data',
                    'edit_all_content_data_' . $content_type->unique_id,
                    'edit_own_published_content_data_'
                        . $content_type->unique_id,
                    'edit_all_published_content_data_'
                        . $content_type->unique_id,
                    'edit_own_unpublished_content_data_'
                        . $content_type->unique_id,
                    'edit_all_unpublished_content_data_'
                        . $content_type->unique_id,
                ],
            },
            callbacks => [
                {   name =>
                        'MT::App::DataAPI::data_api_delete_permission_filter.content_data',
                    count => 1,
                },
                {   name =>
                        'MT::App::DataAPI::data_api_post_delete.content_data',
                    count => 1,
                },
            ],
            result   => sub {$cd},
            complete => sub {
                ok( !MT->model('content_data')->load( $cd->id ) );
            },
        }
    );

    $cd = MT::Test::Permission->make_content_data(
        blog_id         => $site_id,
        content_type_id => $content_type_id,
    );
    test_data_api(
        {   note => 'site permission',
            path => "/v4/sites/$site_id/contentTypes/$content_type_id/data/"
                . $cd->id,
            method       => 'DELETE',
            restrictions => {
                0        => ['edit_all_content_data'],
                $site_id => [

                    # 'edit_all_content_data',
                    'edit_all_content_data_' . $content_type->unique_id,
                    'edit_own_published_content_data_'
                        . $content_type->unique_id,
                    'edit_all_published_content_data_'
                        . $content_type->unique_id,
                    'edit_own_unpublished_content_data_'
                        . $content_type->unique_id,
                    'edit_all_unpublished_content_data_'
                        . $content_type->unique_id,
                ],
            },
            callbacks => [
                {   name =>
                        'MT::App::DataAPI::data_api_delete_permission_filter.content_data',
                    count => 1,
                },
                {   name =>
                        'MT::App::DataAPI::data_api_post_delete.content_data',
                    count => 1,
                },
            ],
            result   => sub {$cd},
            complete => sub {
                ok( !MT->model('content_data')->load( $cd->id ) );
            },
        }
    );

    $cd = MT::Test::Permission->make_content_data(
        blog_id         => $site_id,
        content_type_id => $content_type_id,
    );
    test_data_api(
        {   note => 'content_type permission',
            path => "/v4/sites/$site_id/contentTypes/$content_type_id/data/"
                . $cd->id,
            method       => 'DELETE',
            restrictions => {
                0        => ['edit_all_content_data'],
                $site_id => [

                    'edit_all_content_data',

                    # 'edit_all_content_data_' . $content_type->unique_id,
                    'edit_own_published_content_data_'
                        . $content_type->unique_id,
                    'edit_all_published_content_data_'
                        . $content_type->unique_id,
                    'edit_own_unpublished_content_data_'
                        . $content_type->unique_id,
                    'edit_all_unpublished_content_data_'
                        . $content_type->unique_id,
                ],
            },
            callbacks => [
                {   name =>
                        'MT::App::DataAPI::data_api_delete_permission_filter.content_data',
                    count => 1,
                },
                {   name =>
                        'MT::App::DataAPI::data_api_post_delete.content_data',
                    count => 1,
                },
            ],
            result   => sub {$cd},
            complete => sub {
                ok( !MT->model('content_data')->load( $cd->id ) );
            },
        }
    );

    $cd = MT::Test::Permission->make_content_data(
        blog_id         => $site_id,
        author_id       => 1,
        content_type_id => $content_type_id,
        status          => MT::ContentStatus::RELEASE(),
    );
    test_data_api(
        {   note => 'content_type edit_own_published permission',
            path => "/v4/sites/$site_id/contentTypes/$content_type_id/data/"
                . $cd->id,
            method       => 'DELETE',
            restrictions => {
                0        => ['edit_all_content_data'],
                $site_id => [
                    'edit_all_content_data',
                    'edit_all_content_data_' . $content_type->unique_id,

                    # 'edit_own_published_content_data_'
                    #   . $content_type->unique_id,

                    'edit_all_published_content_data_'
                        . $content_type->unique_id,
                    'edit_own_unpublished_content_data_'
                        . $content_type->unique_id,
                    'edit_all_unpublished_content_data_'
                        . $content_type->unique_id,
                ],
            },
            result   => sub {$cd},
            complete => sub {
                ok( !MT->model('content_data')->load( $cd->id ) );
            },
        }
    );

    $cd = MT::Test::Permission->make_content_data(
        blog_id         => $site_id,
        author_id       => 2,
        content_type_id => $content_type_id,
        status          => MT::ContentStatus::RELEASE(),
    );
    test_data_api(
        {   note => 'content_data edit_all_published permission',
            path => "/v4/sites/$site_id/contentTypes/$content_type_id/data/"
                . $cd->id,
            method       => 'DELETE',
            restrictions => {
                0        => ['edit_all_content_data'],
                $site_id => [
                    'edit_all_content_data',
                    'edit_all_content_data_' . $content_type->unique_id,

                    'edit_own_published_content_data_'
                        . $content_type->unique_id,

                    # 'edit_all_published_content_data_'
                    # . $content_type->unique_id,
                    'edit_own_unpublished_content_data_'
                        . $content_type->unique_id,
                    'edit_all_unpublished_content_data_'
                        . $content_type->unique_id,
                ],
            },
            callbacks => [
                {   name =>
                        'MT::App::DataAPI::data_api_delete_permission_filter.content_data',
                    count => 1,
                },
                {   name =>
                        'MT::App::DataAPI::data_api_post_delete.content_data',
                    count => 1,
                },
            ],
            result   => sub {$cd},
            complete => sub {
                ok( !MT->model('content_data')->load( $cd->id ) );
            },
        }
    );

    $cd = MT::Test::Permission->make_content_data(
        blog_id         => $site_id,
        author_id       => 1,
        content_type_id => $content_type_id,
        status          => MT::ContentStatus::HOLD(),
    );
    test_data_api(
        {   note => 'content_type edit_own_unpublished permission',
            path => "/v4/sites/$site_id/contentTypes/$content_type_id/data/"
                . $cd->id,
            method       => 'DELETE',
            restrictions => {
                0        => ['edit_all_content_data'],
                $site_id => [
                    'edit_all_content_data',
                    'edit_all_content_data_' . $content_type->unique_id,
                    'edit_own_published_content_data_'
                        . $content_type->unique_id,
                    'edit_all_published_content_data_'
                        . $content_type->unique_id,

                    # 'edit_own_unpublished_content_data_'
                    # . $content_type->unique_id,
                    'edit_all_unpublished_content_data_'
                        . $content_type->unique_id,
                ],
            },
            callbacks => [
                {   name =>
                        'MT::App::DataAPI::data_api_delete_permission_filter.content_data',
                    count => 1,
                },
                {   name =>
                        'MT::App::DataAPI::data_api_post_delete.content_data',
                    count => 1,
                },
            ],
            result   => sub {$cd},
            complete => sub {
                ok( !MT->model('content_data')->load( $cd->id ) );
            },
        }
    );

    $cd = MT::Test::Permission->make_content_data(
        blog_id         => $site_id,
        author_id       => 2,
        content_type_id => $content_type_id,
        status          => MT::ContentStatus::HOLD(),
    );
    test_data_api(
        {   note => 'content_type edit_all_unpublished permission',
            path => "/v4/sites/$site_id/contentTypes/$content_type_id/data/"
                . $cd->id,
            method       => 'DELETE',
            restrictions => {
                0        => ['edit_all_content_data'],
                $site_id => [
                    'edit_all_content_data',
                    'edit_all_content_data_' . $content_type->unique_id,
                    'edit_own_published_content_data_'
                        . $content_type->unique_id,
                    'edit_all_published_content_data_'
                        . $content_type->unique_id,
                    'edit_own_unpublished_content_data_'
                        . $content_type->unique_id,

                    # 'edit_all_unpublished_content_data_'
                    #     . $content_type->unique_id,
                ],
            },
            callbacks => [
                {   name =>
                        'MT::App::DataAPI::data_api_delete_permission_filter.content_data',
                    count => 1,
                },
                {   name =>
                        'MT::App::DataAPI::data_api_post_delete.content_data',
                    count => 1,
                },
            ],
            result   => sub {$cd},
            complete => sub {
                ok( !MT->model('content_data')->load( $cd->id ) );
            },
        }
    );

    $cd = MT::Test::Permission->make_content_data(
        blog_id         => $site_id,
        content_type_id => $content_type_id,
    );
    test_data_api(
        {   note => 'superuser',
            path => "/v4/sites/$site_id/contentTypes/$content_type_id/data/"
                . $cd->id,
            method       => 'DELETE',
            is_superuser => 1,
            restrictions => {
                0        => ['edit_all_content_data'],
                $site_id => [
                    'edit_all_content_data',
                    'edit_all_content_data_' . $content_type->unique_id,
                    'edit_own_published_content_data_'
                        . $content_type->unique_id,
                    'edit_all_published_content_data_'
                        . $content_type->unique_id,
                    'edit_own_unpublished_content_data_'
                        . $content_type->unique_id,
                    'edit_all_unpublished_content_data_'
                        . $content_type->unique_id,
                ],
            },
            callbacks => [
                {   name =>
                        'MT::App::DataAPI::data_api_delete_permission_filter.content_data',
                    count => 0,
                },
                {   name =>
                        'MT::App::DataAPI::data_api_post_delete.content_data',
                    count => 1,
                },
            ],
            result   => sub {$cd},
            complete => sub {
                ok( !MT->model('content_data')->load( $cd->id ) );
            },
        }
    );
}

sub restriction_tests_for_list {
    test_data_api(
        {   note   => 'restrict sitei_id = 1',
            path   => "/v4/sites/$site_id/contentTypes/$content_type_id/data",
            method => 'GET',
            setup        => sub {
                $app->config->DataAPIDisableSite(1);
                $app->config->save_config;
            },
            code => 403,
        }
    );

    test_data_api(
        {   note   => 'restrict site_id = 2',
            path   => "/v4/sites/$site_id/contentTypes/$content_type_id/data",
            method => 'GET',
            setup        => sub {
                $app->config->DataAPIDisableSite(2);
                $app->config->save_config;
            },
            callbacks => [
                {   name =>
                        'MT::App::DataAPI::data_api_list_permission_filter.content_data',
                    count => 1,
                },
                {   name  => 'data_api_pre_load_filtered_list.content_data',
                    count => 2,
                },
            ],
            result => sub {
                my @cd = MT->model('content_data')->load(
                    { content_type_id => $content_type_id, blog_id => { 'not' => 2 } },
                    { sort => 'modified_on', direction => 'descend', },
                );
                +{  totalResults => scalar @cd,
                    items => MT::DataAPI::Resource->from_object( \@cd ),
                };
            },
        }
    );
}

