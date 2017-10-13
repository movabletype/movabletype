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

use Test::More;
use MT::Test::DataAPI;
use MT::Test::Permission;

use MT::App::DataAPI;
my $app = MT::App::DataAPI->new;

# TODO: Avoid an error when installing GoogleAnalytics plugin.
my $mock_cms_common = Test::MockModule->new('MT::CMS::Common');
$mock_cms_common->mock( 'run_web_services_save_config_callbacks', sub { } );

my $page_comment = $app->model('comment')->new;
$page_comment->set_values(
    {   blog_id  => 1,
        entry_id => 20,    # page
    }
);
$page_comment->approve;
$page_comment->save or die $page_comment->errstr;

my $unpublished_page = MT::Test::Permission->make_page(
    blog_id => 1,
    status  => 1,
);

$app->config->allowComments( 1, 1 );

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
        sub {
            my @params = (
                { name => 'No one', value => 1, publish => 0 },
                {   name    => 'Trusted commenters only',
                    value   => 2,
                    publish => 1
                },
                {   name    => 'Any authenticated commenters',
                    value   => 3,
                    publish => 1
                },
                { name => 'Anyone', value => 0, publish => 1 },
            );

            my @unpublished_comment_suite;

            for my $p (@params) {
                push @unpublished_comment_suite, +{
                    note =>
                        'Unpublished comment is created when "Comment Policy" setting is "'
                        . $p->{name} . '".',
                    setup => sub {
                        my $blog = $app->model('blog')->load(1);
                        $blog->moderate_unreg_comments( $p->{value} );
                        $blog->save or die $blog->errstr;
                    },
                    path   => '/v1/sites/1/entries/1/comments',
                    method => 'POST',
                    params => {
                        comment => {
                            body => 'test-api-endopoint-comment-policy-'
                                . $p->{value},
                        },
                    },
                    callbacks => [
                        {   name =>
                                'MT::App::DataAPI::data_api_save_permission_filter.comment',
                            count => 1,
                        },
                        {   name =>
                                'MT::App::DataAPI::data_api_save_filter.comment',
                            count => 1,
                        },
                        {   name =>
                                'MT::App::DataAPI::data_api_pre_save.comment',
                            count => 1,
                        },
                        {   name =>
                                'MT::App::DataAPI::data_api_post_save.comment',
                            count => 1,
                        },
                    ],
                    result => sub {
                        MT->model('comment')->load(
                            {   text => 'test-api-endopoint-comment-policy-'
                                    . $p->{value},
                                visible     => $p->{publish},
                                junk_status => MT::Comment::NOT_JUNK(),
                            },
                            {   sort      => 'id',
                                direction => 'descend',
                            },
                        );
                    },
                };
            }

            for my $p (@params) {
                push @unpublished_comment_suite, +{
                    note =>
                        'Unpublished comment is replied when "Comment Policy" setting is "'
                        . $p->{name} . '".',
                    path  => '/v1/sites/1/entries/1/comments/1/replies',
                    setup => sub {
                        my $blog = $app->model('blog')->load(1);
                        $blog->moderate_unreg_comments( $p->{value} );
                        $blog->save or die $blog->errstr;
                    },
                    method => 'POST',
                    params => {
                        comment => {
                            body => 'test-api-endopoint-reply-comment-policy-'
                                . $p->{value},
                        },
                    },
                    callbacks => [
                        {   name =>
                                'MT::App::DataAPI::data_api_save_permission_filter.comment',
                            count => 1,
                        },
                        {   name =>
                                'MT::App::DataAPI::data_api_save_filter.comment',
                            count => 1,
                        },
                        {   name =>
                                'MT::App::DataAPI::data_api_pre_save.comment',
                            count => 1,
                        },
                        {   name =>
                                'MT::App::DataAPI::data_api_post_save.comment',
                            count => 1,
                        },
                    ],
                    result => sub {
                        MT->model('comment')->load(
                            {   text =>
                                    'test-api-endopoint-reply-comment-policy-'
                                    . $p->{value},
                                visible     => $p->{publish},
                                junk_status => MT::Comment::NOT_JUNK(),
                                parent_id   => 1,
                            },
                            {   sort      => 'id',
                                direction => 'descend',
                            },
                        );
                    },
                };
            }

            return @unpublished_comment_suite;
        }
            ->(),
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
        {   note   => 'Sanitize text field (v1) - No HTML',
            path   => '/v1/sites/1/comments/1',
            method => 'GET',
            setup  => sub {
                my $comment = $app->model('comment')->load(1);
                $comment->text('<p><script>alert(1);</script></p>');
                $comment->save or die $comment->errstr;

                my $blog = $comment->blog;
                $blog->allow_comment_html(0);
                $blog->save or die $blog->errstr;
            },
            result => sub {
                +{  'link' =>
                        'http://narnia.na/nana/archives/1978/01/a-rainy-day.html#comment-1',
                    'parent'    => undef,
                    'entry'     => { 'id' => '1' },
                    'status'    => 'Approved',
                    'date'      => '2004-07-14T18:28:00-03:30',
                    'updatable' => $JSON::true,
                    'blog'      => { 'id' => '1' },
                    'author'    => {
                        'userpicUrl'  => undef,
                        'displayName' => 'v14GrUH 4 cheep'
                    },
                    'body' => 'alert(1);',
                    'id'   => 1,
                    MT->component('commercial') ? ( customFields => [] ) : (),
                };
            },
        },
        {   note   => 'Sanitize text field (v1) - default setting',
            path   => '/v1/sites/1/comments/1',
            method => 'GET',
            setup  => sub {
                my $comment = $app->model('comment')->load(1);
                my $blog    = $comment->blog;
                $blog->allow_comment_html(1);
                $blog->save or die $blog->errstr;
            },
            result => sub {
                +{  'link' =>
                        'http://narnia.na/nana/archives/1978/01/a-rainy-day.html#comment-1',
                    'parent'    => undef,
                    'entry'     => { 'id' => '1' },
                    'status'    => 'Approved',
                    'date'      => '2004-07-14T18:28:00-03:30',
                    'updatable' => $JSON::true,
                    'blog'      => { 'id' => '1' },
                    'author'    => {
                        'userpicUrl'  => undef,
                        'displayName' => 'v14GrUH 4 cheep'
                    },
                    'body' => '<p>alert(1);</p>',
                    'id'   => 1,
                    MT->component('commercial') ? ( customFields => [] ) : (),
                };
            },
        },
        {   note   => 'Not sanitize text field (v1)',
            path   => '/v1/sites/1/comments/1',
            params => { sanitize => 0 },
            method => 'GET',
            result => sub {
                +{  'link' =>
                        'http://narnia.na/nana/archives/1978/01/a-rainy-day.html#comment-1',
                    'parent'    => undef,
                    'entry'     => { 'id' => '1' },
                    'status'    => 'Approved',
                    'date'      => '2004-07-14T18:28:00-03:30',
                    'updatable' => $JSON::true,
                    'blog'      => { 'id' => '1' },
                    'author'    => {
                        'userpicUrl'  => undef,
                        'displayName' => 'v14GrUH 4 cheep'
                    },
                    'body' => '<p><script>alert(1);</script></p>',
                    'id'   => 1,
                    MT->component('commercial') ? ( customFields => [] ) : (),
                };
            },
        },
        {   note   => 'Sanitize text field (v2) - No HTML',
            path   => '/v2/sites/1/comments/1',
            params => { no_text_filter => 1 },
            method => 'GET',
            setup  => sub {
                my $comment = $app->model('comment')->load(1);
                my $blog    = $comment->blog;
                $blog->allow_comment_html(0);
                $blog->save or die $blog->errstr;
            },
            result => sub {
                +{  'link' =>
                        'http://narnia.na/nana/archives/1978/01/a-rainy-day.html#comment-1',
                    'parent'       => undef,
                    'entry'        => { 'id' => '1' },
                    'status'       => 'Approved',
                    'date'         => '2004-07-14T18:28:00-03:30',
                    'createdDate'  => '2004-07-14T18:28:00-03:30',
                    'modifiedDate' => undef,
                    'updatable'    => $JSON::true,
                    'blog'         => { 'id' => '1' },
                    'author'       => {
                        'userpicUrl'  => undef,
                        'displayName' => 'v14GrUH 4 cheep'
                    },
                    'body' => 'alert(1);',
                    'id'   => 1,
                    MT->component('commercial') ? ( customFields => [] ) : (),
                };
            },
        },
        {   note   => 'Sanitize text field (v2) - default setting',
            path   => '/v2/sites/1/comments/1',
            params => { no_text_filter => 1 },
            method => 'GET',
            setup  => sub {
                my $comment = $app->model('comment')->load(1);
                my $blog    = $comment->blog;
                $blog->allow_comment_html(1);
                $blog->save or die $blog->errstr;
            },
            result => sub {
                +{  'link' =>
                        'http://narnia.na/nana/archives/1978/01/a-rainy-day.html#comment-1',
                    'parent'       => undef,
                    'entry'        => { 'id' => '1' },
                    'status'       => 'Approved',
                    'date'         => '2004-07-14T18:28:00-03:30',
                    'createdDate'  => '2004-07-14T18:28:00-03:30',
                    'modifiedDate' => undef,
                    'updatable'    => $JSON::true,
                    'blog'         => { 'id' => '1' },
                    'author'       => {
                        'userpicUrl'  => undef,
                        'displayName' => 'v14GrUH 4 cheep'
                    },
                    'body' => '<p>alert(1);</p>',
                    'id'   => 1,
                    MT->component('commercial') ? ( customFields => [] ) : (),
                };
            },
        },
        {   note   => 'Not sanitize text field (v2)',
            path   => '/v2/sites/1/comments/1',
            params => { sanitize => 0, no_text_filter => 1 },
            method => 'GET',
            result => sub {
                +{  'link' =>
                        'http://narnia.na/nana/archives/1978/01/a-rainy-day.html#comment-1',
                    'parent'       => undef,
                    'entry'        => { 'id' => '1' },
                    'status'       => 'Approved',
                    'date'         => '2004-07-14T18:28:00-03:30',
                    'createdDate'  => '2004-07-14T18:28:00-03:30',
                    'modifiedDate' => undef,
                    'updatable'    => $JSON::true,
                    'blog'         => { 'id' => '1' },
                    'author'       => {
                        'userpicUrl'  => undef,
                        'displayName' => 'v14GrUH 4 cheep'
                    },
                    'body' => '<p><script>alert(1);</script></p>',
                    'id'   => 1,
                    MT->component('commercial') ? ( customFields => [] ) : (),
                };
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

        # version 2.

        # list_comments_for_page - irregular tests.
        {    # Non-existent page.
            path   => '/v2/sites/1/pages/200/comments',
            method => 'GET',
            code   => 404,
            error  => 'Page not found',
        },
        {    # Entry.
            path   => '/v2/sites/1/pages/1/comments',
            method => 'GET',
            code   => 404,
            error  => 'Page not found',
        },
        {    # Non-existent site.
            path   => '/v2/sites/5/pages/20/comments',
            method => 'GET',
            code   => 404,
            error  => 'Site not found',
        },
        {    # System.
            path   => '/v2/sites/0/pages/20/comments',
            method => 'GET',
            code   => 404,
            error  => 'Page not found',
        },
        {    # Unpubished page and not logged in.
            path => '/v2/sites/1/pages/'
                . $unpublished_page->id
                . '/comments',
            method    => 'GET',
            author_id => 0,
            code      => 403,
            error =>
                'Do not have permission to retrieve the list of comments.',
        },
        {    # Unpublished page and no permissions.
            path => '/v2/sites/1/pages/'
                . $unpublished_page->id
                . '/comments',
            method       => 'GET',
            restrictions => { 1 => [qw/ open_page_edit_screen /], },
            code         => 403,
            error =>
                'Do not have permission to retrieve the list of comments.',
        },

        # list_comments_for_page - normal tests.
        {   path   => '/v2/sites/1/pages/20/comments',
            method => 'GET',
            result => sub {
                my ( $data, $body ) = @_;
                my $comment = $app->model('comment')
                    ->load( { blog_id => 1, entry_id => 20 } );
                return +{
                    totalResults => 1,
                    items => MT::DataAPI::Resource->from_object( [$comment] ),
                };
            },
        },

        # create_comment_for_page - normal tests.
        {   path   => '/v2/sites/1/pages/20/comments',
            method => 'POST',
            params => {
                comment => { body => 'test-api-endopoint-comment-for-page', },
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
            setup => sub {
                my $page = $app->model('page')->load(20);
                $page->allow_comments(1);
                $page->save or die $page->errstr;
            },
            result => sub {
                my $c = MT->model('comment')->load(
                    {   text        => 'test-api-endopoint-comment-for-page',
                        visible     => 1,
                        junk_status => MT::Comment::NOT_JUNK(),
                    },
                    {   sort      => 'id',
                        direction => 'descend',
                    },
                );
            },
        },

        # create_reply_comment_for_page - normal tests.
        {   path => '/v2/sites/1/pages/20/comments/'
                . $page_comment->id
                . '/replies',
            method => 'POST',
            params => {
                comment => { body => 'test-api-endopoint-reply-for-page', },
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
                    {   text        => 'test-api-endopoint-reply-for-page',
                        visible     => 1,
                        junk_status => MT::Comment::NOT_JUNK(),
                        parent_id   => $page_comment->id,
                    },
                    {   sort      => 'id',
                        direction => 'descend',
                    },
                );
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
            setup  => sub { $app->config->AllowComments( 0, 1 ) },
            method => 'POST',
            params =>
                { comment => { body => 'test-api-endopoint-comment', }, },
            code     => '409',
            complete => sub { $app->config->AllowComments( 1, 1 ) },
        },
    ];
}

