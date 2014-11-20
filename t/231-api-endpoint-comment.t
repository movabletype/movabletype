#!/usr/bin/perl

use strict;
use warnings;

use lib qw(lib extlib t/lib);

use Test::More;
use MT::Test::DataAPI;

use MT::App::DataAPI;
my $app = MT::App::DataAPI->new;

# TODO: Avoid an error when installing GoogleAnalytics plugin.
my $mock_cms_common = Test::MockModule->new('MT::CMS::Common');
$mock_cms_common->mock( 'run_web_services_save_config_callbacks', sub { } );

$app->config->allowComments(1);

my $suite = suite();
test_data_api($suite);

done_testing;

sub suite {
    return +[
        {   path      => '/v1/sites/1/comments',
            method    => 'GET',
            callbacks => [
                {   name  => 'data_api_pre_load_filtered_list.comment',
                    count => 2,
                },
            ],
        },
        {   path      => '/v1/sites/1/entries/1/comments',
            method    => 'GET',
            callbacks => [
                {   name  => 'data_api_pre_load_filtered_list.comment',
                    count => 2,
                },
            ],
        },
        {   path   => '/v1/sites/1/entries/1/comments',
            method => 'POST',
            params =>
                { comment => { body => 'test-api-endopoint-comment', }, },
            callbacks => [
                {   name =>
                        'MT::App::DataAPI::data_api_save_permission_filter.comment',
                    count => 1,
                },
                {   name  => 'MT::App::DataAPI::data_api_save_filter.comment',
                    count => 1,
                },
                {   name  => 'MT::App::DataAPI::data_api_pre_save.comment',
                    count => 1,
                },
                {   name  => 'MT::App::DataAPI::data_api_post_save.comment',
                    count => 1,
                },
            ],
            result => sub {
                MT->model('comment')->load(
                    {   text        => 'test-api-endopoint-comment',
                        visible     => 1,
                        junk_status => MT::Comment::NOT_JUNK(),
                    },
                    {   sort      => 'id',
                        direction => 'descend',
                    },
                );
            },
        },
        {   path   => '/v1/sites/1/entries/1/comments/1/replies',
            method => 'POST',
            params => { comment => { body => 'test-api-endopoint-reply', }, },
            callbacks => [
                {   name =>
                        'MT::App::DataAPI::data_api_save_permission_filter.comment',
                    count => 1,
                },
                {   name  => 'MT::App::DataAPI::data_api_save_filter.comment',
                    count => 1,
                },
                {   name  => 'MT::App::DataAPI::data_api_pre_save.comment',
                    count => 1,
                },
                {   name  => 'MT::App::DataAPI::data_api_post_save.comment',
                    count => 1,
                },
            ],
            result => sub {
                MT->model('comment')->load(
                    {   text        => 'test-api-endopoint-reply',
                        visible     => 1,
                        junk_status => MT::Comment::NOT_JUNK(),
                        parent_id   => 1,
                    },
                    {   sort      => 'id',
                        direction => 'descend',
                    },
                );
            },
        },
        {   path      => '/v1/sites/1/comments/1',
            method    => 'GET',
            callbacks => [
                {   name =>
                        'MT::App::DataAPI::data_api_view_permission_filter.comment',
                    count => 1,
                },
            ],
            result => sub {
                MT->model('comment')->load(1);
            },
        },
        {   path   => '/v1/sites/1/comments/1',
            method => 'PUT',
            params => {
                comment => {
                    body   => 'update-test-api-permission-comment',
                    status => 'Pending'
                },
            },
            callbacks => [
                {   name =>
                        'MT::App::DataAPI::data_api_save_permission_filter.comment',
                    count => 1,
                },
                {   name  => 'MT::App::DataAPI::data_api_save_filter.comment',
                    count => 1,
                },
                {   name  => 'MT::App::DataAPI::data_api_pre_save.comment',
                    count => 1,
                },
                {   name  => 'MT::App::DataAPI::data_api_post_save.comment',
                    count => 1,
                },
            ],
            result => sub {
                MT->model('comment')->load(
                    {   id          => 1,
                        text        => 'update-test-api-permission-comment',
                        visible     => 0,
                        junk_status => MT::Comment::NOT_JUNK(),
                    }
                );
            },
        },
        {   note   => 'reply to pending comment',
            path   => '/v1/sites/1/entries/1/comments/1/replies',
            method => 'POST',
            params => {
                comment => {
                    body => 'test-api-endopoint-reply-to-pending-comment',
                },
            },
            code => '409',
        },
        {   setup => sub {
                my ($data) = @_;
                $data->{comment} = MT->model('comment')->load(
                    { text => 'test-api-endopoint-reply', },
                    {   sort      => 'id',
                        direction => 'descend',
                    },
                );
            },
            note   => 'Update status when parent comment is pending',
            path   => '/v1/sites/1/comments/:comment_id',
            method => 'PUT',
            params => { comment => { status => 'Pending' }, },
            result => sub {
                MT->model('comment')->load(
                    {   text        => 'test-api-endopoint-reply',
                        visible     => 0,
                        junk_status => MT::Comment::NOT_JUNK(),
                        parent_id   => 1,
                    },
                    {   sort      => 'id',
                        direction => 'descend',
                    },
                );
            },
        },
        {   note   => 'status: Approved',
            path   => '/v1/sites/1/comments/1',
            method => 'PUT',
            params => { comment => { status => 'Approved' }, },
            result => sub {
                MT->model('comment')->load(
                    {   id          => 1,
                        text        => 'update-test-api-permission-comment',
                        visible     => 1,
                        junk_status => MT::Comment::NOT_JUNK(),
                    }
                );
            },
        },
        {   setup => sub {
                my ($data) = @_;
                $data->{comment} = MT->model('comment')->load(
                    { text => 'test-api-endopoint-reply', },
                    {   sort      => 'id',
                        direction => 'descend',
                    },
                );
            },
            path      => '/v1/sites/1/comments/:comment_id',
            method    => 'DELETE',
            callbacks => [
                {   name =>
                        'MT::App::DataAPI::data_api_delete_permission_filter.comment',
                    count => 1,
                },
                {   name  => 'MT::App::DataAPI::data_api_post_delete.comment',
                    count => 1,
                },
            ],
            complete => sub {
                my ( $data, $body ) = @_;
                my $deleted
                    = MT->model('comment')->load( $data->{comment}->id );
                is( $deleted, undef, 'deleted' );
            },
        },

        # Cannot comment to the entry whose allowComments is 0.
        {   path   => '/v1/sites/1/entries/1',
            method => 'PUT',
            params => { entry => { allowComments => 0 }, },
        },
        {   note   => 'post comment to an entry whose allowComments is false',
            path   => '/v1/sites/1/entries/1/comments',
            method => 'POST',
            params =>
                { comment => { body => 'test-api-endopoint-comment', }, },
            code => '409',
        },
        {   note => 'reply comment to an entry whose allowComments is false',
            path => '/v1/sites/1/entries/1/comments/1/replies',
            method => 'POST',
            params => { comment => { body => 'test-api-endopoint-reply', }, },
            code   => 409,
        },
        {   path   => '/v1/sites/1/entries/1',
            method => 'PUT',
            params => { entry => { allowComments => 1 }, },
        },

        # Cannot comment when the blog's "allowComments" is false.
        {   path   => '/v2/sites/1',
            method => 'PUT',
            params => { blog => { allowComments => 0, }, },
        },
        {   note =>
                'post comment to an entry whose blog\'s allowComments is false',
            path   => '/v1/sites/1/entries/1/comments',
            method => 'POST',
            params =>
                { comment => { body => 'test-api-endopoint-comment', }, },
            code => '409',
        },
        {   note => 'reply comment to an entry whose allowComments is false',
            path => '/v1/sites/1/entries/1/comments/1/replies',
            method => 'POST',
            params => { comment => { body => 'test-api-endopoint-reply', }, },
            code   => 409,
        },
        {   path   => '/v2/sites/1',
            method => 'PUT',
            params => { blog => { allowComments => 1, }, },
        },

        # Cannot comment when config directive "AllowComments" is false.
        {   path   => '/v1/sites/1/entries/1/comments',
            setup  => sub { $app->config->AllowComments(0) },
            method => 'POST',
            params =>
                { comment => { body => 'test-api-endopoint-comment', }, },
            code     => '409',
            complete => sub { $app->config->AllowComments(1) },
        },
    ];
}

