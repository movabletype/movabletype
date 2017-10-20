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

use MT::App::DataAPI;
my $app = MT::App::DataAPI->new;

use MT::Lockout;

$app->config( 'MailTransfer', 'debug', 1 );

my $author = MT->model('author')->load(1);
$author->email('melody@example.com');
$author->save;

my $suite = suite();
test_data_api($suite);

done_testing;

sub suite {
    return +[

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
                return +{
                    totalResults => scalar @users,
                    items => MT::DataAPI::Resource->from_object( \@users ),
                };
            },
        },
        {    # No parameters (superuser).
            path         => '/v2/users',
            method       => 'GET',
            is_superuser => 1,
            callbacks    => [
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
                return +{
                    totalResults => scalar @users,
                    items => MT::DataAPI::Resource->from_object( \@users ),
                };
            },
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
                return +{
                    totalResults => scalar @users,
                    items => MT::DataAPI::Resource->from_object( \@users ),
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
                return +{
                    totalResults => 1,
                    items => MT::DataAPI::Resource->from_object( [$user] ),
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
                return +{
                    totalResults => 1,
                    items => MT::DataAPI::Resource->from_object( [$user] ),
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
                return +{
                    totalResults => 3,
                    items => MT::DataAPI::Resource->from_object( \@users ),
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

                return +{
                    totalResults => 3,
                    items => MT::DataAPI::Resource->from_object( \@users ),
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
            path         => '/v2/users',
            method       => 'POST',
            is_superuser => 1,
            params       => { user => {}, },
            code         => 409,
            result       => sub {
                +{  error => {
                        code    => 409,
                        message => "User requires username\n",
                    },
                };
            },
        },
        {    # Same name.
            path         => '/v2/users',
            method       => 'POST',
            is_superuser => 1,
            params       => { user => { name => 'Chuck D', }, },
            code         => 409,
            result       => sub {
                +{  error => {
                        code => 409,
                        message =>
                            "A user with the same name already exists.\n",
                    },
                };
            },
        },
        {    # Invalid name.
            path         => '/v2/users',
            method       => 'POST',
            is_superuser => 1,
            params       => { user => { name => '<Chuck D>', }, },
            code         => 409,
            result       => sub {
                +{  error => {
                        code => 409,
                        message =>
                            "Username contains an invalid character: &lt;\n",
                    },
                };
            },
        },
        {    # No nickname.
            path         => '/v2/users',
            method       => 'POST',
            is_superuser => 1,
            params       => { user => { name => 'create-user', }, },
            code         => 409,
            result       => sub {
                +{  error => {
                        code    => 409,
                        message => "User requires display name\n",
                    },
                };
            },
        },
        {    # Invalid nickname.
            path         => '/v2/users',
            method       => 'POST',
            is_superuser => 1,
            params       => {
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
        },
        {    # No password.
            path         => '/v2/users',
            method       => 'POST',
            is_superuser => 1,
            params       => {
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
        },
        {    # No email.
            path         => '/v2/users',
            method       => 'POST',
            is_superuser => 1,
            params       => {
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
        },
        {    # Invalid email.
            path         => '/v2/users',
            method       => 'POST',
            is_superuser => 1,
            params       => {
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
        },
        {    # Invalid url.
            path         => '/v2/users',
            method       => 'POST',
            is_superuser => 1,
            params       => {
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
        },
        {    # Invalid dateFormat.
            path         => '/v2/users',
            method       => 'POST',
            is_superuser => 1,
            params       => {
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
        },
        {    # Invalid textFormat.
            path         => '/v2/users',
            method       => 'POST',
            is_superuser => 1,
            params       => {
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
        },
        {    # Invalid language.
            path         => '/v2/users',
            method       => 'POST',
            is_superuser => 1,
            params       => {
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
        },
        {    # Invalid password.
            path         => '/v2/users',
            method       => 'POST',
            is_superuser => 1,
            params       => {
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
        },
        {    # Not logged in.
            path      => '/v2/users',
            method    => 'POST',
            author_id => 0,
            params    => {
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
            code  => '401',
            error => 'Unauthorized',
        },
        {    # No permissions.
            path   => '/v2/users',
            method => 'POST',
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
            code  => '403',
            error => 'Do not have permission to create a user.',
        },

        # create_user - normal tests
        {   path         => '/v2/users',
            method       => 'POST',
            is_superuser => 1,
            params       => {
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
                return $app->model('author')
                    ->load( { name => 'create-user' } );
            },
        },
        {    # No url, no dateFormat, no textFormat, status is disabled,
                # no tagDelimiter, no language.
            path         => '/v2/users',
            method       => 'POST',
            is_superuser => 1,
            params       => {
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
        },
        {    # Grant system permissions.
            path         => '/v2/users',
            method       => 'POST',
            is_superuser => 1,
            params       => {
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
        },
        {    # Grant system permissions (superuser).
            path         => '/v2/users',
            method       => 'POST',
            is_superuser => 1,
            params       => {
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
        {    # Not logged in.
            path   => '/v2/users/3',
            method => 'PUT',
            params =>
                { user => { systemPermissions => [qw( create_site )], }, },
            author_id => 0,
            code      => 401,
            error     => 'Unauthorized',
        },
        {    # No permissions.
            path   => '/v2/users/3',
            method => 'PUT',
            params =>
                { user => { systemPermissions => [qw( create_site )], }, },
            code  => 403,
            error => 'Do not have permission to update the requested user.',
        },

        # update_user - normal tests
        {    # Grant permissions.
            path         => '/v2/users/3',
            method       => 'PUT',
            is_superuser => 1,
            params =>
                { user => { systemPermissions => [qw( create_site )], }, },
            result => sub {
                $app->model('author')->load(3);
            },
        },
        {    # Update permissions.
            path         => '/v2/users/3',
            method       => 'PUT',
            is_superuser => 1,
            params       => {
                user =>
                    { systemPermissions => [qw( view_log manage_plugins )], },
            },
            result => sub {
                $app->model('author')->load(3);
            },
        },

        # unlock_user - irregular tests
        {    # Non-existent user.
            path         => '/v2/users/100/unlock',
            method       => 'POST',
            is_superuser => 1,
            code         => 404,
            result       => sub {
                +{  error => {
                        code    => 404,
                        message => 'User not found',
                    },
                };
            },
        },
        {    # Not logged in.
            path      => '/v2/users/3/unlock',
            method    => 'POST',
            author_id => 0,
            code      => 401,
            error     => 'Unauthorized',
        },
        {    # No permissions (no superuser).
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
        },

        # unlock_user - normal tests
        {   path         => '/v2/users/3/unlock',
            method       => 'POST',
            is_superuser => 1,
            setup        => sub {
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
            },
        },

        # recover_password_for_user - irregular tests
        {    # Non superuser.
            path   => '/v2/users/3/recover_password',
            method => 'POST',
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
            path         => '/v2/users/100/recover_password',
            method       => 'POST',
            is_superuser => 1,
            code         => 404,
            result       => sub {
                +{  error => {
                        code    => 404,
                        message => 'User not found',
                    },
                };
            },
        },
        {    # Not logged in.
            path      => '/v2/users/3/recover_password',
            method    => 'POST',
            author_id => 0,
            code      => 401,
            error     => 'Unauthorized',
        },
        {    # No permissions (no superuser).
            path   => '/v2/users/3/recover_password',
            method => 'POST',
            code   => 403,
            error  => 'Do not have permission to recover password for user.',
        },

        # recover_password_for_user - normal tests
        {   path         => '/v2/users/3/recover_password',
            method       => 'POST',
            is_superuser => 1,
            setup        => sub {
                my $user = $app->model('author')->load(3);
                $user->password_reset_expires(0);
                $user->save or die $user->errstr;
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
            },
        },

        # recover_password - irregular tests.
        {    # No email.
            path      => '/v2/recover_password',
            method    => 'POST',
            author_id => 0,
            code      => 400,
            result    => sub {
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
            path      => '/v2/recover_password',
            method    => 'POST',
            author_id => 0,
            params    => { email => 'chuckd@sixapart.com', },
            code      => 409,
            result    => sub {
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
            path      => '/v2/recover_password',
            method    => 'POST',
            params    => { email => 'chuckd@example.com', },
            author_id => 0,
            complete  => sub {
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
            author_id => 0,
            setup     => sub {
                my $user
                    = $app->model('author')
                    ->load(
                    { email => 'chuckd@sixapart.com', name => 'create-user' }
                    );
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
                    { email => 'chuckd@sixapart.com', name => 'create-user' }
                    );
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
        {    # Not logged in.
            path      => '/v2/users/3',
            method    => 'DELETE',
            author_id => 0,
            code      => 401,
            error     => 'Unauthorized',
        },
        {    # No permissions.
            path         => '/v2/users/3',
            method       => 'DELETE',
            is_superuser => 0,
            code         => 403,
            error        => 'Do not have permission to delete a user.',
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
    ];
}

