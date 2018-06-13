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

use MT::Association;
use MT::Group;

my $author = MT->model('author')->load(1);
$author->email('melody@example.com');
$author->save;

# test.
my $suite = suite();
test_data_api( $suite, { is_superuser => 1 } );

done_testing;

sub suite {
    return +[

        # group endoints tests

        # create_group - irregular tests
        {    # No resource.
            path   => '/v2/groups',
            method => 'POST',
            code   => 400,
            result => sub {
                +{  error => {
                        code    => 400,
                        message => 'A resource "group" is required.',
                    },
                };
            },
        },
        {    # No name.
            path   => '/v2/groups',
            method => 'POST',
            params => { group => {}, },
            code   => 409,
            result => sub {
                +{  error => {
                        code    => 409,
                        message => "Each group must have a name.\n",
                    },
                };
            },
        },
        {    # Invalid status.
            path   => '/v2/groups',
            method => 'POST',
            params => {
                group => {
                    name   => 'invalid-status',
                    status => 'INVALID',
                },
            },
            code   => 409,
            result => sub {
                +{  error => {
                        code    => 409,
                        message => "A parameter \"status\" is invalid.\n",
                    },
                };
            },
        },
        {    # Not logged in.
            path      => '/v2/groups',
            method    => 'POST',
            params    => { group => { name => 'group-1', }, },
            author_id => 0,
            code      => 401,
            error     => 'Unauthorized',
        },
        {    # No permissions.
            path         => '/v2/groups',
            method       => 'POST',
            params       => { group => { name => 'group-1', }, },
            is_superuser => 0,
            code         => 403,
            error        => 'Do not have permission to create a group.',
        },

        # create_group - normal tests
        {   path   => '/v2/groups',
            method => 'POST',
            params => { group => { name => 'group-1', }, },
            result => sub {
                MT->model('group')->load( { name => 'group-1' } );
            },
        },
        {   path   => '/v2/groups',
            method => 'POST',
            params => {
                group => {
                    name        => 'group-2',
                    displayName => 'Group-2 display',
                    description => 'This is Group-2.',
                    status      => 'Enabled',
                },
            },
            result => sub {
                MT->model('group')->load( { name => 'group-2' } );
            },
        },
        {   path   => '/v2/groups',
            method => 'POST',
            params => {
                group => {
                    name        => 'group-3',
                    displayName => 'Group-3 display',
                    description => 'This is Group-3.',
                    status      => 'Disabled',
                },
            },
            result => sub {
                MT->model('group')->load( { name => 'group-3' } );
            },
        },

        # list_groups - irregular tests.
        {    # Not logged in.
            path      => '/v2/groups',
            method    => 'GET',
            author_id => 0,
            code      => 401,
            error     => 'Unauthorized',
        },
        {    # No permisions.
            path         => '/v2/groups',
            method       => 'GET',
            is_superuser => 0,
            restrictions => { 0 => [qw/ administer /], },
            code         => 403,
            error =>
                'Do not have permission to retrieve the requested groups.',
        },

        # list_groups - normal_tests
        {   path     => '/v2/groups',
            method   => 'GET',
            complete => sub {
                my ( $data, $body ) = @_;
                my $app = MT->instance;

                my $got = $app->current_format->{unserialize}->($body);
                my @got_ids = map { $_->{id} } @{ $got->{items} };

                my @expected
                    = $app->model('group')->load( undef, { sort => 'name' } );
                my @expected_ids = map { $_->id } @expected;

                is_deeply( \@got_ids, \@expected_ids,
                    "Group IDs: @{got_ids}" );
            },
        },
        {    # Search name.
            path   => '/v2/groups',
            method => 'GET',
            params => { search => 'group-1', },
            result => sub {
                my @groups = $app->model('group')
                    ->load( { name => { like => '%group-1%' } } );

                $app->user($author);

                no warnings 'redefine';
                local *boolean::true  = sub {$JSON::true};
                local *boolean::false = sub {$JSON::false};

                return +{
                    totalResults => 1,
                    items => MT::DataAPI::Resource->from_object( \@groups ),
                };
            },
        },
        {    # Search displayName.
            path   => '/v2/groups',
            method => 'GET',
            params => { search => 'display', },
            result => sub {
                my @groups = $app->model('group')
                    ->load( { display_name => { like => '%display%' } } );

                $app->user($author);

                no warnings 'redefine';
                local *boolean::true  = sub {$JSON::true};
                local *boolean::false = sub {$JSON::false};

                return +{
                    totalResults => 2,
                    items => MT::DataAPI::Resource->from_object( \@groups ),
                };
            },
        },
        {    # Search description.
            path   => '/v2/groups',
            method => 'GET',
            params => { search => 'This', },
            result => sub {
                my @groups = $app->model('group')
                    ->load( { description => { like => '%This%' } } );

                $app->user($author);

                no warnings 'redefine';
                local *boolean::true  = sub {$JSON::true};
                local *boolean::false = sub {$JSON::false};

                return +{
                    totalResults => 2,
                    items => MT::DataAPI::Resource->from_object( \@groups ),
                };
            },
        },
        {    # Filter by status.
            path   => '/v2/groups',
            method => 'GET',
            params => { status => 'Disabled', },
            result => sub {
                my @groups = $app->model('group')
                    ->load( { status => MT::Group::INACTIVE() } );

                $app->user($author);

                no warnings 'redefine';
                local *boolean::true  = sub {$JSON::true};
                local *boolean::false = sub {$JSON::false};
                return +{
                    totalResults => 1,
                    items => MT::DataAPI::Resource->from_object( \@groups ),
                };
            },
        },

        # get_group - irregular tests
        {    # Non-existent group.
            path   => '/v2/groups/10',
            method => 'GET',
            code   => 404,
        },
        {    # Not superuser.
            path         => '/v2/groups/1',
            method       => 'GET',
            is_superuser => 0,
            code         => 403,
        },
        {    # Not logged in.
            path      => '/v2/groups/1',
            method    => 'GET',
            author_id => 0,
            code      => 401,
            error     => 'Unauthorized',
        },

        # get_group - normal tests
        {   path   => '/v2/groups/1',
            method => 'GET',
            result => sub {
                return MT->model('group')
                    ->load( { id => 1, name => 'group-1' } );
            },
        },
        {   path   => '/v2/groups/2',
            method => 'GET',
            result => sub {
                return MT->model('group')
                    ->load( { id => 2, name => 'group-2' } );
            },
        },

        # update_group - irregular tests
        {    # Non-existent group.
            path   => '/v2/groups/10',
            method => 'PUT',
            code   => 404,
            result => sub {
                +{  error => {
                        code    => 404,
                        message => 'Group not found',
                    },
                };
            },
        },
        {    # No resource.
            path   => '/v2/groups/1',
            method => 'PUT',
            code   => 400,
            result => sub {
                +{  error => {
                        code    => 400,
                        message => 'A resource "group" is required.',
                    },
                };
            },
        },
        {    # Not logged in.
            path      => '/v2/groups/1',
            method    => 'PUT',
            params    => { group => { name => 'update-group-1', }, },
            author_id => 0,
            code      => 401,
            error     => 'Unauthorized',
        },
        {    # No permissions.
            path         => '/v2/groups/1',
            method       => 'PUT',
            params       => { group => { name => 'update-group-1', }, },
            is_superuser => 0,
            code         => 403,
            error        => 'Do not have permission to update a group.',
        },

        # update_group - normal tests
        {   path   => '/v2/groups/1',
            method => 'PUT',
            params => { group => { name => 'update-group-1', }, },
            result => sub {
                return MT->model('group')
                    ->load( { id => 1, name => 'update-group-1' } );
            },
        },
        {   path   => '/v2/groups/2',
            method => 'PUT',
            params => {
                group => {
                    name        => 'update-group-2',
                    displayName => 'Update-Group-2',
                    description => 'This is Update-Group-2.',
                },
            },
            result => sub {
                return MT->model('group')
                    ->load( { id => 2, name => 'update-group-2' } );
            },
        },
        {   path   => '/v2/groups/2',
            method => 'PUT',
            params => {
                group => {
                    name   => 'not-update-group-2',
                    status => 'Disabled',
                },
            },
            result => sub {
                return MT->model('group')->load(
                    {   id     => 2,
                        status => MT::Group::INACTIVE(),
                        name   => 'update-group-2'
                    }
                );
            },
        },
        {   path   => '/v2/groups/3',
            method => 'PUT',
            params => { group => { name => 'not-update-group-3', }, },
            result => sub {
                return MT->model('group')
                    ->load( { id => 3, name => 'group-3' } );
            },
        },
        {   path   => '/v2/groups/3',
            method => 'PUT',
            params => {
                group => {
                    name   => 'update-group-3',
                    status => 'Enabled',
                },
            },
            result => sub {
                return MT->model('group')
                    ->load( { id => 3, name => 'update-group-3' } );
            },
        },

        # delete_group - irregular tests
        {    # Non-existent group.
            path   => '/v2/groups/10',
            method => 'DELETE',
            code   => 404,
        },
        {    # Not superuser.
            path         => '/v2/groups/1',
            method       => 'DELETE',
            is_superuser => 0,
            code         => 403,
        },
        {    # Not logged in.
            path      => '/v2/groups/1',
            method    => 'DELETE',
            author_id => 0,
            code      => 401,
            error     => 'Unauthorized',
        },

        # delete_group - normal tests
        {   path     => '/v2/groups/1',
            method   => 'DELETE',
            complete => sub {
                my $group = MT->model('group')->load(1);
                is( $group, undef, 'A group has been deleted.' );
            },
        },
        {   path     => '/v2/groups/2',
            method   => 'DELETE',
            complete => sub {
                my $group = MT->model('group')->load(2);
                is( $group, undef, 'A group has been deleted.' );
            },
        },

        # list_groups_for_user - irregular tests
        {    # Non-existent user.
            path   => '/v2/users/10/groups',
            method => 'GET',
            code   => 404,
        },
        {    # Not logged in.
            path      => '/v2/users/2/groups',
            method    => 'GET',
            author_id => 0,
            code      => 401,
            error     => 'Unauthorized',
        },
        {    # No permissions.
            path         => '/v2/users/2/groups',
            method       => 'GET',
            is_superuser => 0,
            restrictions => { 0 => [qw/ administer /], },
            code         => 403,
            error =>
                'Do not have permission to retrieve the requested user\'s groups.',
        },

        # list_groups_for_user - normal tests
        {   path     => '/v2/users/2/groups',
            method   => 'GET',
            complete => sub {
                my ( $data, $body ) = @_;
                my $got_groups = $app->current_format->{unserialize}->($body);
                my @got_group_ids
                    = map { $_->{id} } @{ $got_groups->{items} };

                require MT::Association;
                my @expected_groups = MT->model('group')->load(
                    undef,
                    {   sort => 'name',
                        join => MT::Association->join_on(
                            'group_id',
                            {   author_id => 2,
                                type      => MT::Association::USER_GROUP(),
                            },
                        ),
                    }
                );
                my @expected_group_ids = map { $_->id } @expected_groups;

                is_deeply( \@got_group_ids, \@expected_group_ids,
                    "Group IDs: @got_group_ids" );
            },
        },
        {   path   => '/v2/users/3/groups',
            method => 'GET',
            result => sub {
                return +{
                    totalResults => 0,
                    items        => [],
                };
            },
        },
        {    # Search.
            path   => '/v2/users/2/groups',
            method => 'GET',
            params => { search => 'dummy', },
            result => sub {
                return +{
                    totalResults => 0,
                    items        => [],
                };
            },
        },
        {    # Filter.
            path   => '/v2/users/2/groups',
            method => 'GET',
            params => { status => 'Disabled', },
            result => sub {
                return +{
                    totalResults => 0,
                    items        => [],
                };
            },
        },

        #### group member endpoints tests

        # add_member_to_group - irregular tests
        {    # Non-existent group.
            path   => '/v2/groups/1/members',
            method => 'POST',
            params => { member => { id => 1, }, },
            code   => 404,
        },
        {    # Non-existent member.
            path   => '/v2/groups/3/members',
            method => 'POST',
            params => { member => { id => 10, }, },
            code   => 404,
        },
        {    # Non-existent group and non-existent member.
            path   => '/v2/groups/1/members',
            method => 'POST',
            params => { member => { id => 10, }, },
            code   => 404,
        },
        {    # No member resource.
            path   => '/v2/groups/3/members',
            method => 'POST',
            code   => 400,
        },
        {    # No member id.
            path   => '/v2/groups/3/members',
            method => 'POST',
            params => { member => {}, },
            code   => 400,
        },
        {    # Not logged in.
            path      => '/v2/groups/3/members',
            method    => 'POST',
            params    => { member => { id => 1, }, },
            author_id => 0,
            code      => 401,
            error     => 'Unauthorized',
        },
        {    # No permissions.
            path         => '/v2/groups/3/members',
            method       => 'POST',
            params       => { member => { id => 1, }, },
            is_superuser => 0,
            code         => 403,
            error => 'Do not have permission to add a member to group.',
        },

        # add_member_to_group - normal tests
        {   path   => '/v2/groups/3/members',
            method => 'POST',
            params => { member => { id => 1, }, },
            result => sub {
                MT->model('author')->load(1);
            },
        },
        {   path   => '/v2/groups/3/members',
            method => 'POST',
            params => { member => { id => 2, }, },
            result => sub {
                MT->model('author')->load(2);
            },
        },

        # list_members_for_group - irregular tests
        {    # Non-existent group.
            path   => '/v2/groups/1/members',
            method => 'GET',
            code   => 404,
        },
        {    # Not logged in.
            path      => '/v2/groups/3/members',
            method    => 'GET',
            author_id => 0,
            code      => 401,
            error     => 'Unauthorized',
        },
        {    # No permissions.
            path         => '/v2/groups/3/members',
            method       => 'GET',
            is_superuser => 0,
            code         => 403,
            error =>
                'Do not have permission to retrieve the list of group members.',
        },

        # list_members_for_group - normal tests
        {   path   => '/v2/groups/3/members',
            method => 'GET',
            result => sub {
                my @users = $app->model('author')->load(
                    undef,
                    {   join => $app->model('association')->join_on(
                            'author_id',
                            {   type     => MT::Association::USER_GROUP(),
                                group_id => 3,
                            },
                        ),
                        sort      => 'name',
                        direction => 'ascend',
                    },
                );

                $app->user($author);
                no warnings 'redefine';
                local *boolean::true  = sub {$JSON::true};
                local *boolean::false = sub {$JSON::false};

                return +{
                    totalResults => scalar @users,
                    items => MT::DataAPI::Resource->from_object( \@users ),
                };
            },
        },

        # get_member_for_group - irregular tests
        {    # Non-existent member.
            path   => '/v2/groups/3/members/10',
            method => 'GET',
            code   => 404,
        },
        {    # Non-existent group.
            path   => '/v2/groups/1/members/1',
            method => 'GET',
            code   => 404,
        },
        {    # Non-existent group and non-existent member.
            path   => '/v2/groups/1/members/10',
            method => 'GET',
            code   => 404,
        },
        {    # Not logged in.
            path      => '/v2/groups/3/members/1',
            method    => 'GET',
            author_id => 0,
            code      => 401,
            error     => 'Unauthorized',
        },
        {    # No permissions.
            path         => '/v2/groups/3/members/1',
            method       => 'GET',
            is_superuser => 0,
            code         => 403,
            error =>
                'Do not have permission to retrieve the requested group member.',
        },

        # get_member_for_group - normal tests
        {   path   => '/v2/groups/3/members/1',
            method => 'GET',
            result => sub {
                MT->model('author')->load(1);
            },
        },

        # remove_member_for_group - irregular tests
        {    # Non-existent member.
            path   => '/v2/groups/3/members/10',
            method => 'DELETE',
            code   => 404,
        },
        {    # Non-existent group.
            path   => '/v2/groups/1/members/1',
            method => 'DELETE',
            code   => 404,
        },
        {    # Non-existent group and non-existent member.
            path   => '/v2/groups/1/members/10',
            method => 'DELETE',
            code   => 404,
        },
        {    # Not logged in.
            path      => '/v2/groups/3/members/1',
            method    => 'DELETE',
            author_id => 0,
            code      => 401,
            error     => 'Unauthorized',
        },
        {    # No permissions.
            path         => '/v2/groups/3/members/1',
            method       => 'DELETE',
            is_superuser => 0,
            code         => 403,
            error => 'Do not have permission to remove a member from group.',
        },

        # remove_member_for_group - normal tests
        {   path   => '/v2/groups/3/members/1',
            method => 'DELETE',
            result => sub {
                MT->model('author')->load(1);
            },
        },
    ];
}
