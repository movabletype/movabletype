#!/usr/bin/perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";
use Test::More;
use MT::Test::Env;
our $test_env;

BEGIN {
    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT::Test::DataAPI;

$test_env->prepare_fixture('db_data');

use MT::App::DataAPI;
my $app = MT::App::DataAPI->new;

my $author = MT->model('author')->load(1);
$author->email('melody@example.com');
$author->save;

use MT::Group;

my $group1 = $app->model('group')->new;
$group1->set_values(
    {   name         => 'group1',
        display_name => 'Group 1',
        description  => 'This is "Group 1".',
        status       => MT::Group::ACTIVE(),
    }
);
$group1->save or die $group1->errstr;

my $group2 = $app->model('group')->new;
$group2->set_values(
    {   name         => 'group2',
        display_name => 'Group 2',
        description  => 'This is "Group 2".',
        status       => MT::Group::ACTIVE(),
    }
);
$group2->save or die $group2->errstr;

# test.
my $suite = suite();
test_data_api( $suite, { is_superuser => 1 } );

done_testing;

sub suite {
    return +[

        # grant_permission_to_group - irregular tests
        {    # Non-existent group.
            path   => '/v2/groups/100/permissions/grant',
            method => 'POST',
            code   => 404,
            result => sub {
                +{  error => {
                        code    => 404,
                        message => 'Group not found',
                    },
                };
            },
        },
        {    # No site_id.
            path   => '/v2/groups/' . $group1->id . '/permissions/grant',
            method => 'POST',
            code   => 400,
            result => sub {
                +{  error => {
                        code    => 400,
                        message => 'A parameter "site_id" is required.',
                    },
                };
            },
        },
        {    # Invalid site_id.
            path   => '/v2/groups/' . $group1->id . '/permissions/grant',
            method => 'POST',
            params => { site_id => 100, },
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
            path   => '/v2/groups/' . $group1->id . '/permissions/grant',
            method => 'POST',
            params => { site_id => 0, },
            code   => 404,
            result => sub {
                +{  error => {
                        code    => 404,
                        message => 'Site not found',
                    },
                };
            },
        },
        {    # No role_id.
            path   => '/v2/groups/' . $group1->id . '/permissions/grant',
            method => 'POST',
            params => { site_id => 1, },
            code   => 400,
            result => sub {
                +{  error => {
                        code    => 400,
                        message => 'A parameter "role_id" is required.',
                    },
                };
            },
        },
        {    # Invalid role_id.
            path   => '/v2/groups/' . $group1->id . '/permissions/grant',
            method => 'POST',
            params => {
                site_id => 1,
                role_id => 100,
            },
            code   => 404,
            result => sub {
                +{  error => {
                        code    => 404,
                        message => 'Role not found',
                    },
                };
            },
        },
        {    # Not logged in.
            path   => '/v2/groups/' . $group1->id . '/permissions/grant',
            method => 'POST',
            params => {
                site_id => 1,
                role_id => 2,
            },
            author_id => 0,
            code      => 401,
            error     => 'Unauthorized',
        },
        {    # No permissions.
            path   => '/v2/groups/' . $group1->id . '/permissions/grant',
            method => 'POST',
            params => {
                site_id => 1,
                role_id => 2,
            },
            setup => sub {
                $author->can_manage_users_groups(0);
                $author->save or die $author->errstr;
            },
            is_superuser => 0,
            restrictions =>
                { 1 => [qw/ grant_administer_role grant_role_for_blog /], },
            code  => 403,
            error => 'Do not have permission to grant a permission.',
        },

        # grant_permission_to_group - normal tests
        {    # Blog.
            path   => '/v2/groups/' . $group1->id . '/permissions/grant',
            method => 'POST',
            params => {
                site_id => 1,
                role_id => 2,
            },
            result   => sub { +{ status => 'success' } },
            complete => sub {
                my $assoc = $app->model('association')->load(
                    {   group_id => $group1->id,
                        blog_id  => 1,
                        role_id  => 2,
                    }
                );

                ok( $assoc, 'Granted permission.' );
            },
        },
        {    # Website.
            path   => '/v2/groups/' . $group1->id . '/permissions/grant',
            method => 'POST',
            params => {
                site_id => 2,
                role_id => 1,
            },
            result   => sub { +{ status => 'success' } },
            complete => sub {
                my $assoc = $app->model('association')->load(
                    {   group_id => $group1->id,
                        blog_id  => 2,
                        role_id  => 1,
                    }
                );

                ok( $assoc, 'Granted permission.' );
            },
        },

        # list_permissions_for_group - irregular tests
        {    # Non-existent group.
            path   => '/v2/groups/100/permissions',
            method => 'GET',
            code   => 404,
            result => sub {
                +{  error => {
                        code    => 404,
                        message => 'Group not found',
                    },
                };
            },
        },
        {    # Not logged in.
            path      => '/v2/groups/' . $group1->id . '/permissions',
            method    => 'GET',
            author_id => 0,
            code      => 401,
            error     => 'Unauthorized',
        },

        # list_permissions_for_group - normal tests
        {   path   => '/v2/groups/' . $group1->id . '/permissions',
            method => 'GET',
            result => sub {
                my @assoc = $app->model('association')
                    ->load( { group_id => $group1->id, } );

                $app->user($author);

                return +{
                    totalResults => 2,
                    items => MT::DataAPI::Resource->from_object( \@assoc ),
                };
            },
        },
        {    # Filter by blogIds.
            path   => '/v2/groups/' . $group1->id . '/permissions',
            method => 'GET',
            params => { blogIds => 1 },
            result => sub {
                my @assoc = $app->model('association')->load(
                    {   group_id => $group1->id,
                        blog_id  => 1,
                    }
                );

                $app->user($author);

                return +{
                    totalResults => 1,
                    items => MT::DataAPI::Resource->from_object( \@assoc ),
                };
            },
        },

        # delete_permission_from_group - irregular tests
        {    # Non-existent group.
            path   => '/v2/groups/100/permissions/revoke',
            method => 'POST',
            code   => 404,
            result => sub {
                +{  error => {
                        code    => 404,
                        message => 'Group not found',
                    },
                };
            },
        },
        {    # No site_id.
            path   => '/v2/groups/' . $group1->id . '/permissions/revoke',
            method => 'POST',
            code   => 400,
            result => sub {
                +{  error => {
                        code    => 400,
                        message => 'A parameter "site_id" is required.',
                    },
                };
            },
        },
        {    # Invalid site_id.
            path   => '/v2/groups/' . $group1->id . '/permissions/revoke',
            method => 'POST',
            params => { site_id => 100, },
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
            path   => '/v2/groups/' . $group1->id . '/permissions/revoke',
            method => 'POST',
            params => { site_id => 0, },
            code   => 404,
            result => sub {
                +{  error => {
                        code    => 404,
                        message => 'Site not found',
                    },
                };
            },
        },
        {    # No role_id.
            path   => '/v2/groups/' . $group1->id . '/permissions/revoke',
            method => 'POST',
            params => { site_id => 1, },
            code   => 400,
            result => sub {
                +{  error => {
                        code    => 400,
                        message => 'A parameter "role_id" is required.',
                    },
                };
            },
        },
        {    # Invalid role_id.
            path   => '/v2/groups/' . $group1->id . '/permissions/revoke',
            method => 'POST',
            params => {
                site_id => 1,
                role_id => 100,
            },
            code   => 404,
            result => sub {
                +{  error => {
                        code    => 404,
                        message => 'Role not found',
                    },
                };
            },
        },
        {    # Not logged in.
            path   => '/v2/groups/' . $group1->id . '/permissions/revoke',
            method => 'POST',
            params => {
                site_id => 1,
                role_id => 2,
            },
            author_id => 0,
            code      => 401,
            error     => 'Unauthorized',
        },
        {    # No permissions.
            path  => '/v2/groups/' . $group1->id . '/permissions/revoke',
            setup => sub {
                $author->can_manage_users_groups(0);
                $author->save or die $author->errstr;
            },
            method => 'POST',
            params => {
                site_id => 1,
                role_id => 2,
            },
            is_superuser => 0,
            restrictions => { 1 => [qw/ delete_association /], },
            code         => 403,
            error        => 'Do not have permission to revoke a permission.',
        },

        # delete_permission_from_group - normal tests
        {   path   => '/v2/groups/' . $group1->id . '/permissions/revoke',
            method => 'POST',
            params => {
                site_id => 1,
                role_id => 2,
            },
            setup => sub {
                die
                    if !$app->model('association')->load(
                    {   group_id => $group1->id,
                        blog_id  => 1,
                        role_id  => 2,
                    }
                    );
            },
            result   => sub { +{ status => 'success' } },
            complete => sub {
                my $assoc = $app->model('association')->load(
                    {   group_id => $group1->id,
                        blog_id  => 1,
                        role_id  => 2,
                    }
                );

                is( $assoc, undef, 'Revoked permission.' );
            },
        },
    ];
}
