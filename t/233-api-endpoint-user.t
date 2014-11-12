#!/usr/bin/perl

use strict;
use warnings;

BEGIN {
    $ENV{MT_CONFIG} = 'mysql-test.cfg';
}

BEGIN {
    use Test::More;
    eval { require Test::MockModule }
        or plan skip_all => 'Test::MockModule is not installed';
}

use lib qw(lib extlib t/lib);

eval(
    $ENV{SKIP_REINITIALIZE_DATABASE}
    ? "use MT::Test qw(:app);"
    : "use MT::Test qw(:app :db :data);"
);

use boolean ();
use MT::Author;
use MT::Lockout;

use MT::App::DataAPI;
my $app = MT::App::DataAPI->new;
$app->config( 'MailTransfer', 'debug' );

my $author = MT->model('author')->load(1);
$author->email('melody@example.com');
$author->save;

my $mock_author  = Test::MockModule->new('MT::Author');
my $is_superuser = 0;
$mock_author->mock( 'is_superuser', sub {$is_superuser} );
my $mock_app_api = Test::MockModule->new('MT::App::DataAPI');
$mock_app_api->mock( 'authenticate', $author );
my $version;
$mock_app_api->mock( 'current_api_version',
    sub { $version = $_[1] if $_[1]; $version } );

my @suite = (

    # version 1
    {   path      => '/v1/users/me',
        method    => 'GET',
        callbacks => [
            {   name =>
                    'MT::App::DataAPI::data_api_view_permission_filter.author',
                count => 1,
            },
        ],
        result => $author,
    },
    {   path      => '/v1/users/' . $author->id,
        method    => 'GET',
        callbacks => [
            {   name =>
                    'MT::App::DataAPI::data_api_view_permission_filter.author',
                count => 1,
            },
        ],
        result => $author,
    },
    {   path      => '/v1/users/2',
        method    => 'GET',
        callbacks => [
            {   name =>
                    'MT::App::DataAPI::data_api_view_permission_filter.author',
                count => 1,
            },
        ],
        result => $app->model('author')->load(2),
    },
    {   path      => '/v1/users/me',
        method    => 'PUT',
        params    => { user => { displayName => 'api-endpoint-user' } },
        callbacks => [
            {   name =>
                    'MT::App::DataAPI::data_api_save_permission_filter.author',
                count => 1,
            },
            {   name  => 'MT::App::DataAPI::data_api_save_filter.author',
                count => 1,
            },
            {   name  => 'MT::App::DataAPI::data_api_pre_save.author',
                count => 1,
            },
            {   name  => 'MT::App::DataAPI::data_api_post_save.author',
                count => 1,
            },
        ],
        result => sub {
            MT->model('author')->load(
                {   id       => $author->id,
                    nickname => 'api-endpoint-user',
                }
            );
        },
    },

    # version 2

    # list_users - normal tests
    {    # No parameters.
        path      => '/v2/users',
        method    => 'GET',
        callbacks => [
            {   name  => 'data_api_pre_load_filtered_list.author',
                count => 2,
            },
        ],
        result => sub {
            my @users = $app->model('author')->load(
                {   type   => MT::Author::AUTHOR(),
                    status => MT::Author::ACTIVE()
                },
                { sort => 'name', direction => 'ascend' },
            );

            $app->user($author);
            no warnings 'redefine';
            local *boolean::true  = sub {'true'};
            local *boolean::false = sub {'false'};
            return +{
                totalResults => scalar @users,
                items        => MT::DataAPI::Resource->from_object( \@users ),
            };
        },
    },
    {    # No parameters (superuser).
        path      => '/v2/users',
        method    => 'GET',
        setup     => sub { $is_superuser = 1 },
        callbacks => [
            {   name  => 'data_api_pre_load_filtered_list.author',
                count => 2,
            },
        ],
        result => sub {
            my @users = $app->model('author')->load(
                { type => MT::Author::AUTHOR() },
                { sort => 'name', direction => 'ascend' },
            );

            $app->user($author);
            no warnings 'redefine';
            local *boolean::true  = sub {'true'};
            local *boolean::false = sub {'false'};
            return +{
                totalResults => scalar @users,
                items        => MT::DataAPI::Resource->from_object( \@users ),
            };
        },
        complete => sub { $is_superuser = 0 },
    },
    {    # Search name.
        path      => '/v2/users',
        method    => 'GET',
        params    => { search => 'Chuck D', },
        callbacks => [
            {   name  => 'data_api_pre_load_filtered_list.author',
                count => 2,
            },
        ],
        result => sub {
            my @users = $app->model('author')->load(
                {   name   => 'Chuck D',
                    type   => MT::Author::AUTHOR(),
                    status => MT::Author::ACTIVE()
                },
                { sort => 'name', direction => 'ascend' },
            );

            $app->user($author);
            no warnings 'redefine';
            local *boolean::true  = sub {'true'};
            local *boolean::false = sub {'false'};
            return +{
                totalResults => scalar @users,
                items        => MT::DataAPI::Resource->from_object( \@users ),
            };
        },
    },
    {    # Search displayName.
        path      => '/v2/users',
        method    => 'GET',
        params    => { search => 'Chucky Dee', },
        callbacks => [
            {   name  => 'data_api_pre_load_filtered_list.author',
                count => 2,
            },
        ],
        result => sub {
            my $user = $app->model('author')->load(
                {   nickname => 'Chucky Dee',
                    type     => MT::Author::AUTHOR(),
                    status   => MT::Author::ACTIVE()
                },
                { sort => 'name', direction => 'ascend' },
            );

            $app->user($author);
            no warnings 'redefine';
            local *boolean::true  = sub {'true'};
            local *boolean::false = sub {'false'};
            return +{
                totalResults => 1,
                items        => MT::DataAPI::Resource->from_object( [$user] ),
            };
        },
    },
    {    # Search mail.
        path      => '/v2/users',
        method    => 'GET',
        params    => { search => 'heroes.com', },
        callbacks => [
            {   name  => 'data_api_pre_load_filtered_list.author',
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
    {    # Search url.
        path      => '/v2/users',
        method    => 'GET',
        params    => { search => 'chuckd.com', },
        callbacks => [
            {   name  => 'data_api_pre_load_filtered_list.author',
                count => 2,
            },
        ],
        result => sub {
            my $user = $app->model('author')->load(
                {   url    => { like => '%chuckd.com%' },
                    type   => MT::Author::AUTHOR(),
                    status => MT::Author::ACTIVE()
                },
                { sort => 'name', direction => 'ascend' },
            );

            $app->user($author);
            no warnings 'redefine';
            local *boolean::true  = sub {'true'};
            local *boolean::false = sub {'false'};
            return +{
                totalResults => 1,
                items        => MT::DataAPI::Resource->from_object( [$user] ),
            };
        },
    },
    {    # Status is active.
        path      => '/v2/users',
        method    => 'GET',
        params    => { status => 'Active' },
        callbacks => [
            {   name  => 'data_api_pre_load_filtered_list.author',
                count => 2,
            },
        ],
        result => sub {
            my @users = $app->model('author')->load(
                {   status => MT::Author::ACTIVE(),
                    type   => MT::Author::AUTHOR(),
                    status => MT::Author::ACTIVE()
                },
                { sort => 'name', direction => 'ascend' },
            );

            $app->user($author);
            no warnings 'redefine';
            local *boolean::true  = sub {'true'};
            local *boolean::false = sub {'false'};
            return +{
                totalResults => 3,
                items        => MT::DataAPI::Resource->from_object( \@users ),
            };
        },
    },
    {    # Status is disabled.
        path      => '/v2/users',
        method    => 'GET',
        params    => { status => 'Disabled' },
        callbacks => [
            {   name  => 'data_api_pre_load_filtered_list.author',
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
    {    # Lock out.
        path      => '/v2/users',
        method    => 'GET',
        params    => { lockout => 'locked_out' },
        callbacks => [
            {   name  => 'data_api_pre_load_filtered_list.author',
                count => 1,
            },
        ],
        result => sub {
            my @users = $app->model('author')->load(
                {   type   => MT::Author::AUTHOR(),
                    status => MT::Author::ACTIVE()
                },
                { sort => 'name', direction => 'ascend' },
            );

            @users = grep { $_->locked_out } @users;

            $app->user($author);
            no warnings 'redefine';
            local *boolean::true  = sub {'true'};
            local *boolean::false = sub {'false'};
            return +{
                totalResults => 0,
                items        => [],
            };
        },
    },
    {    # Not lock out.
        path      => '/v2/users',
        method    => 'GET',
        params    => { lockout => 'not_locked_out' },
        callbacks => [
            {   name  => 'data_api_pre_load_filtered_list.author',
                count => 2,
            },
        ],
        result => sub {
            my @users = $app->model('author')->load(
                {   type   => MT::Author::AUTHOR(),
                    status => MT::Author::ACTIVE()
                },
                { sort => 'name', direction => 'ascend' },
            );

            @users = grep { !$_->locked_out } @users;

            $app->user($author);
            no warnings 'redefine';
            local *boolean::true  = sub {'true'};
            local *boolean::false = sub {'false'};

            return +{
                totalResults => 3,
                items        => MT::DataAPI::Resource->from_object( \@users ),
            };
        },
    },

    # create_user - irregular tests
    {    # No resource.
        path   => '/v2/users',
        method => 'POST',
        code   => 400,
        result => sub {
            +{  error => {
                    code    => 400,
                    message => 'A resource "user" is required.',
                },
            };
        },
    },
    {    # No name.
        path   => '/v2/users',
        method => 'POST',
        setup  => sub { $is_superuser = 1 },
        params => { user => {}, },
        code   => 409,
        result => sub {
            +{  error => {
                    code    => 409,
                    message => "User requires username\n",
                },
            };
        },
        complete => sub { $is_superuser = 0 },
    },
    {    # Same name.
        path   => '/v2/users',
        method => 'POST',
        setup  => sub { $is_superuser = 1 },
        params => { user => { name => 'Chuck D', }, },
        code   => 409,
        result => sub {
            +{  error => {
                    code    => 409,
                    message => "A user with the same name already exists.\n",
                },
            };
        },
        complete => sub { $is_superuser = 0 },
    },
    {    # Invalid name.
        path   => '/v2/users',
        method => 'POST',
        setup  => sub { $is_superuser = 1 },
        params => { user => { name => '<Chuck D>', }, },
        code   => 409,
        result => sub {
            +{  error => {
                    code => 409,
                    message =>
                        "Username contains an invalid character: &lt;\n",
                },
            };
        },
        complete => sub { $is_superuser = 0 },
    },
    {    # No nickname.
        path   => '/v2/users',
        method => 'POST',
        setup  => sub { $is_superuser = 1 },
        params => { user => { name => 'create-user', }, },
        code   => 409,
        result => sub {
            +{  error => {
                    code    => 409,
                    message => "User requires display name\n",
                },
            };
        },
        complete => sub { $is_superuser = 0 },
    },
    {    # Invalid nickname.
        path   => '/v2/users',
        method => 'POST',
        setup  => sub { $is_superuser = 1 },
        params => {
            user => {
                name        => 'create-user',
                displayName => '<create user>',
            },
        },
        code   => 409,
        result => sub {
            +{  error => {
                    code => 409,
                    message =>
                        "Display Name contains an invalid character: &lt;\n",
                },
            };
        },
        complete => sub { $is_superuser = 0 },
    },
    {    # No password.
        path   => '/v2/users',
        method => 'POST',
        setup  => sub { $is_superuser = 1 },
        params => {
            user => {
                name        => 'create-user',
                displayName => 'create user',
            },
        },
        code   => 409,
        result => sub {
            +{  error => {
                    code    => 409,
                    message => "User requires password\n",
                },
            };
        },
        complete => sub { $is_superuser = 0 },
    },
    {    # No email.
        path   => '/v2/users',
        method => 'POST',
        setup  => sub { $is_superuser = 1 },
        params => {
            user => {
                name        => 'create-user',
                displayName => 'create user',
                password    => 'password',
            },
        },
        code   => 409,
        result => sub {
            +{  error => {
                    code => 409,
                    message =>
                        "Email Address is required for password reset.\n",
                },
            };
        },
        complete => sub { $is_superuser = 0 },
    },
    {    # Invalid email.
        path   => '/v2/users',
        method => 'POST',
        setup  => sub { $is_superuser = 1 },
        params => {
            user => {
                name        => 'create-user',
                displayName => 'create user',
                password    => 'password',
                email       => 'invalid email',
            },
        },
        code   => 409,
        result => sub {
            +{  error => {
                    code    => 409,
                    message => "Email Address is invalid.\n",
                },
            };
        },
        complete => sub { $is_superuser = 0 },
    },
    {    # Invalid url.
        path   => '/v2/users',
        method => 'POST',
        setup  => sub { $is_superuser = 1 },
        params => {
            user => {
                name        => 'create-user',
                displayName => 'create user',
                password    => 'password',
                email       => 'chuckd@sixapart.com',
                url         => 'invalid url',
            },
        },
        code   => 409,
        result => sub {
            +{  error => {
                    code    => 409,
                    message => "URL is invalid.\n",
                },
            };
        },
        complete => sub { $is_superuser = 0 },
    },
    {    # Invalid dateFormat.
        path   => '/v2/users',
        method => 'POST',
        setup  => sub { $is_superuser = 1 },
        params => {
            user => {
                name        => 'create-user',
                displayName => 'create user',
                password    => 'password',
                email       => 'chuckd@sixapart.com',
                dateFormat  => 'invalid',
            },
        },
        code   => 409,
        result => sub {
            +{  error => {
                    code    => 409,
                    message => "Invalid dateFormat: invalid\n",
                },
            };
        },
        complete => sub { $is_superuser = 0 },
    },
    {    # Invalid textFormat.
        path   => '/v2/users',
        method => 'POST',
        setup  => sub { $is_superuser = 1 },
        params => {
            user => {
                name        => 'create-user',
                displayName => 'create user',
                password    => 'password',
                email       => 'chuckd@sixapart.com',
                textFormat  => 'invalid',
            },
        },
        code   => 409,
        result => sub {
            +{  error => {
                    code    => 409,
                    message => "Invalid textFormat: invalid\n",
                },
            };
        },
        complete => sub { $is_superuser = 0 },
    },
    {    # Invalid language.
        path   => '/v2/users',
        method => 'POST',
        setup  => sub { $is_superuser = 1 },
        params => {
            user => {
                name        => 'create-user',
                displayName => 'create user',
                password    => 'password',
                email       => 'chuckd@sixapart.com',
                language    => 'invalid',
            },
        },
        code   => 409,
        result => sub {
            +{  error => {
                    code    => 409,
                    message => "Invalid language: invalid\n",
                },
            };
        },
        complete => sub { $is_superuser = 0 },
    },
    {    # Invalid password.
        path   => '/v2/users',
        method => 'POST',
        setup  => sub { $is_superuser = 1 },
        params => {
            user => {
                name        => 'create-user',
                displayName => 'create user',
                password    => 'short',
                email       => 'chuckd@sixapart.com',
            },
        },
        code   => 409,
        result => sub {
            +{  error => {
                    code => 409,
                    message =>
                        "Password should be longer than 8 characters\n",
                },
            };
        },
        complete => sub { $is_superuser = 0 },
    },

    # create_user - normal tests
    {   path   => '/v2/users',
        method => 'POST',
        setup  => sub { $is_superuser = 1 },
        params => {
            user => {
                name         => 'create-user',
                displayName  => 'create user',
                password     => 'password',
                email        => 'chuckd@sixapart.com',
                url          => 'http://www.sixapart.com/',
                dateFormat   => 'full',
                textFormat   => 'richtext',
                tagDelimiter => 'space',
                language     => 'ja',
            },
        },
        result => sub {
            return $app->model('author')->load( { name => 'create-user' } );
        },
        complete => sub { $is_superuser = 0 },
    },
    {    # No url, no dateFormat, no textFormat, status is disabled,
            # no tagDelimiter, no language.
        path   => '/v2/users',
        method => 'POST',
        setup  => sub { $is_superuser = 1 },
        params => {
            user => {
                status      => 'Disabled',
                name        => 'create-user-without-url',
                displayName => 'create user without url',
                password    => 'password',
                email       => 'chuckd@sixapart.com',
            },
        },
        result => sub {
            return $app->model('author')
                ->load( { name => 'create-user-without-url' } );
        },
        complete => sub { $is_superuser = 0 },
    },
    {    # Grant system permissions.
        path   => '/v2/users',
        method => 'POST',
        setup  => sub { $is_superuser = 1 },
        params => {
            user => {
                name              => 'create-user-with-permissions',
                displayName       => 'create user with permissions',
                password          => 'password',
                email             => 'chuckd@sixapart.com',
                systemPermissions => [ qw( create_blog view_log ), ],
            },
        },
        result => sub {
            $app->user($author);
            return $app->model('author')
                ->load( { name => 'create-user-with-permissions' } );
        },
        complete => sub { $is_superuser = 0 },
    },
    {    # Grant system permissions (superuser).
        path   => '/v2/users',
        method => 'POST',
        setup  => sub { $is_superuser = 1 },
        params => {
            user => {
                name              => 'create-super-user',
                displayName       => 'create super user',
                password          => 'password',
                email             => 'chuckd@sixapart.com',
                systemPermissions => [ qw( administer ), ],
            },
        },
        result => sub {
            return $app->model('author')
                ->load( { name => 'create-super-user' } );
        },
        complete => sub { $is_superuser = 0 },
    },

    # update_user - irregular tests.
    {    # Non-existent user.
        path   => '/v2/users/100',
        method => 'PUT',
        code   => 404,
        result => sub {
            return +{
                error => {
                    code    => 404,
                    message => 'User not found',
                },
            };
        },
    },
    {    # No resource.
        path   => '/v2/users/3',
        method => 'PUT',
        code   => 400,
        result => sub {
            return +{
                error => {
                    code    => 400,
                    message => 'A resource "user" is required.',
                },
            };
        },
    },

    # update_user - normal tests
    {    # Grant permissions.
        path   => '/v2/users/3',
        method => 'PUT',
        setup  => sub { $is_superuser = 1 },
        params =>
            { user => { systemPermissions => [qw( create_website )], }, },
        result => sub {
            $app->model('author')->load(3);
        },
        complete => sub { $is_superuser = 0 },
    },
    {    # Update permissions.
        path   => '/v2/users/3',
        method => 'PUT',
        setup  => sub { $is_superuser = 1 },
        params => {
            user => { systemPermissions => [qw( view_log manage_plugins )], },
        },
        result => sub {
            $app->model('author')->load(3);
        },
        complete => sub { $is_superuser = 0 },
    },

    # unlock_user - irregular tests
    {    # Non-existent user.
        path   => '/v2/users/100/unlock',
        method => 'POST',
        setup  => sub {
            $is_superuser = 1;
        },
        code   => 404,
        result => sub {
            +{  error => {
                    code    => 404,
                    message => 'User not found',
                },
            };
        },
        complete => sub { $is_superuser = 0 },
    },
    {    # No superuser.
        path   => '/v2/users/3/unlock',
        method => 'POST',
        code   => 403,
        result => sub {
            return +{
                error => {
                    code    => 403,
                    message => 'Do not have permission to unlock a user.',
                },
            };
        },
        complete => sub { $is_superuser = 0 },
    },

    # unlock_user - normal tests
    {   path   => '/v2/users/3/unlock',
        method => 'POST',
        setup  => sub {
            $is_superuser = 1;

            my $user = $app->model('author')->load(3);
            MT::Lockout->lock($user);
            $user->save or die $user->errstr;
            die if !$user->locked_out;
        },
        result => sub {
            return +{ status => 'success' };
        },
        complete => sub {
            my $user = $app->model('author')->load(3);
            ok( !$user->locked_out, 'Unlocked user.' );

            $is_superuser = 0;
        },
    },

    # recover_password_for_user - irregular tests
    {    # Non superuser.
        path   => '/v2/users/3/recover_password',
        method => 'POST',
        setup  => sub { $is_superuser = 0 },
        code   => 403,
        result => sub {
            return +{
                error => {
                    code => 403,
                    message =>
                        'Do not have permission to recover password for user.',
                },
            };
        },
    },
    {    # Non-existent user.
        path   => '/v2/users/100/recover_password',
        method => 'POST',
        setup  => sub { $is_superuser = 1 },
        code   => 404,
        result => sub {
            +{  error => {
                    code    => 404,
                    message => 'User not found',
                },
            };
        },
        complete => sub { $is_superuser = 0 },
    },

    # recover_password_for_user - normal tests
    {   path   => '/v2/users/3/recover_password',
        method => 'POST',
        setup  => sub {
            my $user = $app->model('author')->load(3);
            $user->password_reset_expires(0);
            $user->save or die $user->errstr;

            $is_superuser = 1;
        },
        result => sub {
            return +{
                status => 'success',
                message =>
                    'A password reset link has been sent to bobd@example.com for user  \'Bob D\' (user #3).',
            };
        },
        complete => sub {
            my $user = $app->model('author')->load(3);
            ok( $user->password_reset_expires > time,
                'password_reset_expires is set.'
            );

            $is_superuser = 0;
        },
    },

    # recover_password - irregular tests.
    {    # No email.
        path   => '/v2/recover_password',
        method => 'POST',
        code   => 400,
        result => sub {
            return +{
                error => {
                    code => 400,
                    message =>
                        "Email address is required for password reset.",
                },
            };
        },
    },
    {    # Not unique.
        path   => '/v2/recover_password',
        method => 'POST',
        params => { email => 'chuckd@sixapart.com', },
        code   => 409,
        result => sub {
            return +{
                error => {
                    code => 409,
                    message =>
                        "The email address provided is not unique. Please enter your username by \"name\" parameter.",
                },
            };
        },
    },

    # recover_password - normal tests.
    {    # Unique.
        path     => '/v2/recover_password',
        method   => 'POST',
        params   => { email => 'chuckd@example.com', },
        complete => sub {
            my $user = $app->model('author')
                ->load( { email => 'chuckd@example.com' } );
            $user->password_reset_expires(0);
            $user->save or die $user->errstr;
        },
        result => sub {
            return +{
                status => 'success',
                message =>
                    'An email with a link to reset your password has been sent to your email address (chuckd@example.com).',
            };
        },
        complete => sub {
            my $user = $app->model('author')
                ->load( { email => 'chuckd@example.com' } );
            ok( $user->password_reset_expires > time,
                'password_reset_expires is set.'
            );
        },
    },
    {    # Not unique.
        path   => '/v2/recover_password',
        method => 'POST',
        params => {
            email => 'chuckd@sixapart.com',
            name  => 'create-user',
        },
        setup => sub {
            my $user
                = $app->model('author')
                ->load(
                { email => 'chuckd@sixapart.com', name => 'create-user' } );
            $user->password_reset_expires(0);
            $user->save or die $user->errstr;
        },
        result => sub {
            return +{
                status => 'success',
                message =>
                    'An email with a link to reset your password has been sent to your email address (chuckd@sixapart.com).',
            };
        },
        complete => sub {
            my $user
                = $app->model('author')
                ->load(
                { email => 'chuckd@sixapart.com', name => 'create-user' } );
            ok( $user->password_reset_expires > time,
                'password_reset_expires is set.'
            );
        },
    },

    # delete_user - irregular tests
    {    # Non-existent user.
        path   => '/v2/users/100',
        method => 'DELETE',
        code   => 404,
        result => sub {
            +{  error => {
                    code    => 404,
                    message => 'User not found',
                },
            };
        },
    },

    # delete_user - normal tests
    {   path   => '/v2/users/3',
        method => 'DELETE',
        setup  => sub {
            my $user = $app->model('author')->load(3) or die;
            $user->created_by( $author->id );
            $user->save or die $user->errstr;
        },
        callbacks => [
            {   name =>
                    'MT::App::DataAPI::data_api_delete_permission_filter.author',
                count => 1,
            },
            {   name  => 'MT::App::DataAPI::data_api_post_delete.author',
                count => 1,
            },
        ],
        complete => sub {
            my $user = $app->model('author')->load(3);
            is( $user, undef, 'Deleted user.' );
        },
    },
);

my %callbacks = ();
my $mock_mt   = Test::MockModule->new('MT');
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
