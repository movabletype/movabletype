#!/usr/bin/perl

use strict;
use warnings;

use lib qw(lib extlib t/lib);

use Test::More;
use MT::Test::DataAPI;

use MT::App::DataAPI;
my $app = MT::App::DataAPI->new;

# preparation.
my $author = MT->model('author')->load(1);
$author->email('melody@example.com');
$author->save;

my $blog = $app->model('blog')->load(1);
my $start_time
    = MT::Util::ts2iso( $blog, MT::Util::epoch2ts( $blog, time() ), 1 );

# test.
my $suite = suite();
test_data_api($suite);

done_testing;

sub suite {

    return +[
        {   path      => '/v1/users/me/permissions',
            method    => 'GET',
            callbacks => [
                {   name  => 'data_api_pre_load_filtered_list.permission',
                    count => 2,
                },
            ],
            result => +{
                totalResults => 2,
                items        => [
                    {   permissions => [
                            qw(administer create_blog create_site edit_templates
                                manage_content_data manage_content_types
                                manage_plugins manage_users_groups
                                sign_in_cms sign_in_data_api view_log)
                        ],
                        blog => undef
                    },
                    {   permissions => [
                            qw(administer_site comment create_post create_site
                                edit_all_posts edit_assets
                                edit_categories edit_config edit_notifications edit_tags edit_templates
                                manage_category_set manage_content_data
                                manage_content_types manage_feedback manage_pages
                                manage_themes manage_users publish_post rebuild
                                send_notifications set_publish_paths upload view_blog_log)
                        ],
                        blog => { id => 1 },
                    },
                ],
            },
        },
        {   path   => '/v1/users/1/permissions',
            method => 'GET',
        },
        {   path   => '/v1/users/2/permissions',
            method => 'GET',
            code   => '403',
        },

        # version 2

        # list_permissions_for_user - irregular tests
        {    # The other user.
            path   => '/v2/users/2/permissions',
            method => 'GET',
            code   => '403',
            result => sub {
                +{  error => {
                        code => 403,
                        message =>
                            'Do not have permission to retrieve the requested user\'s permissions.',
                    },
                };
            },
        },
        {    # Not logged in.
            path      => '/v2/users/2/permissions',
            method    => 'GET',
            author_id => 0,
            code      => 401,
            error     => 'Unauthorized',
        },

        # list_permissions_for_user - normal tests
        {   path      => '/v2/users/me/permissions',
            method    => 'GET',
            callbacks => [
                {   name  => 'data_api_pre_load_filtered_list.permission',
                    count => 2,
                },
            ],
            complete => sub {
                my ( $data, $body ) = @_;

                my $result = $app->current_format->{unserialize}->($body);
                my @perms  = MT->model('permission')->load(
                    {   blog_id     => { not => 0 },
                        author_id   => $author->id,
                        permissions => { not => '' },
                    },
                    { sort => 'blog_id' },
                );

                is( $result->{totalResults},
                    scalar @perms,
                    'totalResults is "' . $result->{totalResults} . '"'
                );

                my @result_ids   = map { $_->{id} } @{ $result->{items} };
                my @expected_ids = map { $_->id } @perms;
                is_deeply( \@result_ids, \@expected_ids,
                    'IDs of items are "' . "@result_ids" . '"' );
            },
        },
        {   path      => '/v2/users/1/permissions',
            method    => 'GET',
            callbacks => [
                {   name  => 'data_api_pre_load_filtered_list.permission',
                    count => 2,
                },
            ],
            result => sub {
                my @perms = $app->model('permission')->load(
                    {   author_id   => 1,
                        blog_id     => { not => 0 },
                        permissions => { not => '' },
                    }
                );

                $app->user($author);

                return +{
                    totalResults => scalar @perms,
                    items => MT::DataAPI::Resource->from_object( \@perms ),
                };
            },
        },
        {    # Sort by id.
            path   => '/v2/users/1/permissions',
            method => 'GET',
            params => { sortBy => 'id' },
        },
        {    # Sort by created_by.
            path   => '/v2/users/1/permissions',
            method => 'GET',
            params => { sortBy => 'created_by' },
        },
        {    # Sort by created_on.
            path   => '/v2/users/1/permissions',
            method => 'GET',
            params => { sortBy => 'created_on' },
        },
        {    # Sort by author_name.
            path   => '/v2/users/1/permissions',
            method => 'GET',
            params => { sortBy => 'author_id' },
        },

        # list_permissions - irregular tests.
        {    # Not logged in.
            path      => '/v2/permissions',
            method    => 'GET',
            author_id => 0,
            code      => 401,
            error     => 'Unauthorized',
        },

        # list_permissions - normal tests
        {
            # not superuser
            path      => '/v2/permissions',
            method    => 'GET',
            callbacks => [
                {   name  => 'data_api_pre_load_filtered_list.permission',
                    count => 2,
                },
            ],
            complete => sub {
                my ( $data, $body ) = @_;

                my $result = $app->current_format->{unserialize}->($body);
                my @perms  = MT->model('permission')->load(
                    {   blog_id     => { not => 0 },
                        author_id   => $author->id,
                        permissions => { not => '' }
                    },
                    { sort => 'blog_id', }
                );

                is( $result->{totalResults},
                    scalar @perms,
                    'totalResults is "' . $result->{totalResults} . '"'
                );

                my @result_ids   = map { $_->{id} } @{ $result->{items} };
                my @expected_ids = map { $_->id } @perms;
                is_deeply( \@result_ids, \@expected_ids,
                    'IDs of items are "' . "@result_ids" . '"' );
            },
        },
        {
            # Superuser.
            path         => '/v2/permissions',
            method       => 'GET',
            is_superuser => 1,
            callbacks    => [
                {   name  => 'data_api_pre_load_filtered_list.permission',
                    count => 2,
                },
            ],
            complete => sub {
                my ( $data, $body ) = @_;

                my $result = $app->current_format->{unserialize}->($body);
                my @perms  = MT->model('permission')->load(
                    {   blog_id     => { not => 0 },
                        permissions => { not => '' }
                    },
                    { sort => 'blog_id', }
                );

                is( $result->{totalResults},
                    scalar @perms,
                    'totalResults is "' . $result->{totalResults} . '"'
                );

                my @result_ids   = map { $_->{id} } @{ $result->{items} };
                my @expected_ids = map { $_->id } @perms;
                is_deeply( \@result_ids, \@expected_ids,
                    'IDs of items are "' . "@result_ids" . '"' );
            },
        },

        # list_permissions_for_site - irregular tests
        {    # Non-existent site.
            path   => '/v2/sites/5/permissions',
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
        {    # System.
            path   => '/v2/sites/0/permissions',
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
        {    # Not logged in.
            path      => '/v2/sites/1/permissions',
            method    => 'GET',
            author_id => 0,
            code      => 401,
            error     => 'Unauthorized',
        },

        # list_permissions_for_site - normal tests
        {
            # not superuser.
            path      => '/v2/sites/1/permissions',
            method    => 'GET',
            callbacks => [
                {   name  => 'data_api_pre_load_filtered_list.permission',
                    count => 2,
                },
            ],
            complete => sub {
                my ( $data, $body ) = @_;

                my $result = $app->current_format->{unserialize}->($body);
                my @perms  = MT->model('permission')->load(
                    {   blog_id     => 1,
                        author_id   => $author->id,
                        permissions => { not => '' },
                    },
                    { sort => 'blog_id', },
                );

                is( $result->{totalResults},
                    scalar @perms,
                    'totalResults is "' . $result->{totalResults} . '"'
                );

                my @result_ids   = map { $_->{id} } @{ $result->{items} };
                my @expected_ids = map { $_->id } @perms;
                is_deeply( \@result_ids, \@expected_ids,
                    'IDs of items are "' . "@result_ids" . '"' );

            },
        },
        {
            # superuser.
            path         => '/v2/sites/1/permissions',
            method       => 'GET',
            is_superuser => 1,
            callbacks    => [
                {   name  => 'data_api_pre_load_filtered_list.permission',
                    count => 2,
                },
            ],
            complete => sub {
                my ( $data, $body ) = @_;

                my $result = $app->current_format->{unserialize}->($body);
                my @perms  = MT->model('permission')->load(
                    {   blog_id     => 1,
                        permissions => { not => '' },
                    },
                    { sort => 'blog_id', },
                );

                is( $result->{totalResults},
                    scalar @perms,
                    'totalResults is "' . $result->{totalResults} . '"'
                );

                my @result_ids   = map { $_->{id} } @{ $result->{items} };
                my @expected_ids = map { $_->id } @perms;
                is_deeply( \@result_ids, \@expected_ids,
                    'IDs of items are "' . "@result_ids" . '"' );
            },
        },

        # list_permissions_for_role - irregular tests
        {    # Non-existent role.
            path   => '/v2/roles/100/permissions',
            method => 'GET',
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
            path      => '/v2/roles/1/permissions',
            method    => 'GET',
            author_id => 0,
            code      => 401,
            error     => 'Unauthorized',
        },
        {    # No permissions.
            path         => '/v2/roles/1/permissions',
            method       => 'GET',
            restrictions => { 0 => [qw/ edit_role /], },
            code         => 403,
            error =>
                'Do not have permission to retrieve the list of permissions.',
        },

        # list_permissions_for_role - normal tests
        {    # not superuser.
            path      => '/v2/roles/1/permissions',
            method    => 'GET',
            callbacks => [
                {   name  => 'data_api_pre_load_filtered_list.permission',
                    count => 2,
                },
            ],
            complete => sub {
                my ( $data, $body ) = @_;

                my $result = $app->current_format->{unserialize}->($body);
                my @perms  = MT->model('permission')->load(
                    {   blog_id     => { not => 0 },
                        author_id   => $author->id,
                        permissions => { not => '' },
                    },
                    {   sort => 'blog_id',
                        join => MT->model('association')->join_on(
                            undef,
                            {   blog_id   => \'= permission_blog_id',
                                author_id => \'= permission_author_id',
                                role_id   => 1,
                            },
                        ),
                    },
                );

                is( $result->{totalResults},
                    scalar @perms,
                    'totalResults is "' . $result->{totalResults} . '"'
                );

                my @result_ids   = map { $_->{id} } @{ $result->{items} };
                my @expected_ids = map { $_->id } @perms;
                is_deeply( \@result_ids, \@expected_ids,
                    'IDs of items are "' . "@result_ids" . '"' );

            },
        },
        {    # superuser.
            path         => '/v2/roles/1/permissions',
            method       => 'GET',
            is_superuser => 1,
            callbacks    => [
                {   name  => 'data_api_pre_load_filtered_list.permission',
                    count => 2,
                },
            ],
            complete => sub {
                my ( $data, $body ) = @_;

                my $result = $app->current_format->{unserialize}->($body);
                my @perms  = MT->model('permission')->load(
                    {   blog_id     => { not => 0 },
                        permissions => { not => '' },
                    },
                    {   sort => 'blog_id',
                        join => MT->model('association')->join_on(
                            undef,
                            {   blog_id   => \'= permission_blog_id',
                                author_id => \'= permission_author_id',
                                role_id   => 1,
                            },
                        ),
                    },
                );

                is( $result->{totalResults},
                    scalar @perms,
                    'totalResults is "' . $result->{totalResults} . '"'
                );

                my @result_ids   = map { $_->{id} } @{ $result->{items} };
                my @expected_ids = map { $_->id } @perms;
                is_deeply( \@result_ids, \@expected_ids,
                    'IDs of items are "' . "@result_ids" . '"' );
            },
        },

        # grant_permission_to_site - irregular tests
        {    # Non-existent site.
            path   => '/v2/sites/10/permissions/grant',
            method => 'POST',
            code   => 404,
            result => sub {
                +{  error => {
                        code    => 404,
                        message => 'Site not found',
                    },
                };
            },
        },
        {    # No author_id.
            path   => '/v2/sites/1/permissions/grant',
            method => 'POST',
            code   => 400,
            error  => "A parameter \"user_id\" is required.",
        },
        {    # Non-existent author.
            path   => '/v2/sites/1/permissions/grant',
            method => 'POST',
            code   => 404,
            params => { user_id => 10 },
            error  => "User not found",
        },
        {    # No role_id.
            path   => '/v2/sites/1/permissions/grant',
            method => 'POST',
            params => { user_id => $author->id },
            code   => 400,
            error  => "A parameter \"role_id\" is required.",
        },
        {    # Non-existent role.
            path   => '/v2/sites/1/permissions/grant',
            method => 'POST',
            params => {
                user_id => $author->id,
                role_id => 20,
            },
            code  => 404,
            error => "Role not found",
        },
        {    # System.
            path   => '/v2/sites/0/permissions/grant',
            method => 'POST',
            params => {
                user_id => $author->id,
                role_id => 2,
            },
            code   => 404,
            result => sub {
                +{  error => {
                        code    => 404,
                        message => 'Site not found',
                    },
                };
            },
        },
        {    # Not logged in.
            path   => '/v2/sites/1/permissions/grant',
            method => 'POST',
            params => {
                user_id => $author->id,
                role_id => 2,
            },
            author_id => 0,
            code      => 401,
            error     => 'Unauthorized',
        },
        {    # No permissions (not administer role).
            path   => '/v2/sites/1/permissions/grant',
            method => 'POST',
            params => {
                user_id => $author->id,
                role_id => 3,
            },
            restrictions =>
                { 1 => [qw/ grant_administer_role grant_role_for_blog /], },
            code  => 403,
            error => 'Do not have permission to grant a permission.',
        },
        {    # No permissions (administer role).
            path   => '/v2/sites/1/permissions/grant',
            method => 'POST',
            params => {
                user_id => $author->id,
                role_id => 1,
            },
            restrictions => { 1 => [qw/ grant_administer_role /], },
            code         => 403,
            error => 'Do not have permission to grant a permission.',
        },

        # grant_permission_to_site - normal tests
        {   path   => '/v2/sites/1/permissions/grant',
            method => 'POST',
            setup  => sub {
                my $assoc = MT->model('association')->load(
                    {   blog_id   => 1,
                        author_id => $author->id,
                        role_id   => 2,
                    }
                ) and die;
            },
            params => {
                user_id => $author->id,
                role_id => 2,
            },
            result   => +{ status => 'success', },
            complete => sub {
                my $assoc = MT->model('association')->load(
                    {   blog_id   => 1,
                        author_id => $author->id,
                        role_id   => 2,
                    }
                );
                ok( $assoc, 'Permission has been granted.' );
            },
        },

        # grant_permission_to_user - irregular tests
        {    # Non-existent user.
            path   => '/v2/users/10/permissions/grant',
            method => 'POST',
            code   => 404,
            result => sub {
                +{  error => {
                        code    => 404,
                        message => 'User not found',
                    },
                };
            },
        },
        {    # No site_id.
            path   => '/v2/users/1/permissions/grant',
            method => 'POST',
            code   => 400,
            error  => "A parameter \"site_id\" is required.",
        },
        {    # Non-existent site.
            path   => '/v2/users/1/permissions/grant',
            method => 'POST',
            params => { site_id => 10, },
            code   => 404,
            error  => "Site not found",
        },
        {    # No role_id.
            path   => '/v2/users/1/permissions/grant',
            method => 'POST',
            params => { site_id => 1 },
            code   => 400,
            error  => "A parameter \"role_id\" is required.",
        },
        {    # Non-existent role.
            path   => '/v2/users/1/permissions/grant',
            method => 'POST',
            params => { site_id => 1, role_id => 20 },
            code   => 404,
            error  => "Role not found",
        },
        {    # System.
            path   => '/v2/users/1/permissions/grant',
            method => 'POST',
            params => { site_id => 0, role_id => 20 },
            code   => 404,
            error  => "Site not found",
        },
        {    # Not logged in.
            path   => '/v2/users/1/permissions/grant',
            method => 'POST',
            params => {
                site_id => 1,
                role_id => 3,
            },
            author_id => 0,
            code      => 401,
            error     => 'Unauthorized',
        },
        {    # No permissions (not administer role).
            path   => '/v2/users/1/permissions/grant',
            method => 'POST',
            params => {
                site_id => 1,
                role_id => 3,
            },
            restrictions =>
                { 1 => [qw/ grant_administer_role grant_role_for_blog /], },
            code  => 403,
            error => 'Do not have permission to grant a permission.',
        },
        {    # No permissions (administer role).
            path   => '/v2/users/1/permissions/grant',
            method => 'POST',
            params => {
                site_id => 1,
                role_id => 1,
            },
            restrictions => { 1 => [qw/ grant_administer_role /], },
            code         => 403,
            error => 'Do not have permission to grant a permission.',
        },

        # grant_permission_to_user - normal tests
        {   path   => '/v2/users/1/permissions/grant',
            method => 'POST',
            setup  => sub {
                my $assoc = MT->model('association')->load(
                    {   blog_id   => 1,
                        author_id => $author->id,
                        role_id   => 3,
                    }
                ) and die;
            },
            params => {
                site_id => 1,
                role_id => 3,
            },
            result   => +{ status => 'success' },
            complete => sub {
                my $assoc = MT->model('association')->load(
                    {   blog_id   => 1,
                        author_id => $author->id,
                        role_id   => 3,
                    }
                );
                ok( $assoc, 'Permission has been granted.' );
            },
        },

        # revoke_permission_from_site - irregular tests
        {    # Non-existent site.
            path   => '/v2/sites/10/permissions/revoke',
            method => 'POST',
            code   => 404,
            result => sub {
                +{  error => {
                        code    => 404,
                        message => 'Site not found',
                    },
                };
            },
        },
        {    # No user_id.
            path   => '/v2/sites/1/permissions/revoke',
            method => 'POST',
            code   => 400,
            error  => "A parameter \"user_id\" is required.",
        },
        {    # Non-existent user.
            path   => '/v2/sites/1/permissions/revoke',
            method => 'POST',
            params => { user_id => 10, },
            code   => 404,
            error  => "User not found",
        },
        {    # No role_id.
            path   => '/v2/sites/1/permissions/revoke',
            method => 'POST',
            params => { user_id => $author->id },
            code   => 400,
            error  => "A parameter \"role_id\" is required.",
        },
        {    # Non-existent role.
            path   => '/v2/sites/1/permissions/revoke',
            method => 'POST',
            params => { user_id => $author->id, role_id => 20 },
            code   => 404,
            error  => "Role not found",
        },
        {    # System.
            path   => '/v2/sites/0/permissions/revoke',
            method => 'POST',
            params => {
                user_id => $author->id,
                role_id => 2,
            },
            code   => 404,
            result => sub {
                +{  error => {
                        code    => 404,
                        message => 'Site not found',
                    },
                };
            },
        },
        {    # Not logged in.
            path   => '/v2/sites/1/permissions/revoke',
            method => 'POST',
            params => {
                user_id => $author->id,
                role_id => 2,
            },
            author_id => 0,
            code      => 401,
            error     => 'Unauthorized',
        },
        {    # No permissions (not administer role).
            path   => '/v2/sites/1/permissions/revoke',
            method => 'POST',
            params => {
                user_id => $author->id,
                role_id => 3,
            },
            restrictions => { 1 => [qw/ revoke_role /], },
            code         => 403,
            error => 'Do not have permission to revoke a permission.',
        },
        {    # No permissions (administer role).
            path   => '/v2/sites/1/permissions/revoke',
            method => 'POST',
            params => {
                user_id => $author->id,
                role_id => 1,
            },
            restrictions => { 1 => [qw/ revoke_administer_role /], },
            code         => 403,
            error => 'Do not have permission to revoke a permission.',
        },

        # revoke_permission_from_site - normal tests
        {   path   => '/v2/sites/1/permissions/revoke',
            method => 'POST',
            setup  => sub {
                my $assoc = MT->model('association')->load(
                    {   blog_id   => 1,
                        author_id => $author->id,
                        role_id   => 2,
                    }
                ) or die;
            },
            params => {
                user_id => $author->id,
                role_id => 2,
            },
            result   => +{ status => 'success' },
            complete => sub {
                my $assoc = MT->model('association')->load(
                    {   blog_id   => 1,
                        author_id => $author->id,
                        role_id   => 2,
                    }
                );
                ok( !$assoc, 'Permission has been revoked.' );
            },
        },

        # revoke_permission_from_user - irregular tests
        {    # Non-existent user.
            path   => '/v2/users/10/permissions/revoke',
            method => 'POST',
            code   => 404,
        },
        {    # No site_id.
            path   => '/v2/users/1/permissions/revoke',
            method => 'POST',
            code   => 400,
            error  => "A parameter \"site_id\" is required.",
        },
        {    # Non-existent site.
            path   => '/v2/users/1/permissions/revoke',
            method => 'POST',
            params => { site_id => 10, },
            code   => 404,
            error  => "Site not found",
        },
        {    # No role_id.
            path   => '/v2/users/1/permissions/revoke',
            method => 'POST',
            params => { site_id => 1 },
            code   => 400,
            error  => "A parameter \"role_id\" is required.",
        },
        {    # Non-existent role.
            path   => '/v2/users/1/permissions/revoke',
            method => 'POST',
            params => { site_id => 1, role_id => 20 },
            code   => 404,
            error  => "Role not found",
        },
        {    # System.
            path   => '/v2/users/1/permissions/revoke',
            method => 'POST',
            params => {
                site_id => 0,
                role_id => 3,
            },
            code   => 404,
            result => sub {
                +{  error => {
                        code    => 404,
                        message => 'Site not found',
                    },
                };
            },
        },
        {    # Not logged in.
            path   => '/v2/users/1/permissions/revoke',
            method => 'POST',
            params => {
                site_id => 1,
                role_id => 3,
            },
            author_id => 0,
            code      => 401,
            error     => 'Unauthorized',
        },
        {    # No permissions (not administer role).
            path   => '/v2/users/1/permissions/revoke',
            method => 'POST',
            params => {
                site_id => 1,
                role_id => 3,
            },
            restrictions => { 1 => [qw/ revoke_role /], },
            code         => 403,
            error => 'Do not have permission to revoke a permission.',
        },
        {    # No permissions (administer role).
            path   => '/v2/users/1/permissions/revoke',
            method => 'POST',
            params => {
                site_id => 1,
                role_id => 1,
            },
            restrictions => { 1 => [qw/ revoke_administer_role /], },
            code         => 403,
            error => 'Do not have permission to revoke a permission.',
        },

        # revoke_permission_from_user - normal tests
        {   path   => '/v2/users/1/permissions/revoke',
            method => 'POST',
            setup  => sub {
                my $assoc = MT->model('association')->load(
                    {   blog_id   => 1,
                        author_id => $author->id,
                        role_id   => 3,
                    }
                ) or die;
            },
            params => {
                site_id => 1,
                role_id => 3,
            },
            result   => +{ status => 'success' },
            complete => sub {
                my $assoc = MT->model('association')->load(
                    {   blog_id   => 1,
                        author_id => $author->id,
                        role_id   => 3,
                    }
                );
                ok( !$assoc, 'Permission has been revoked.' );
            },
        },
    ];
}
