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

use MT::App::DataAPI;
my $app    = MT::App::DataAPI->new;
my $author = MT->model('author')->load(1);
$author->email('melody@example.com');
$author->save;

my $mock_author = Test::MockModule->new('MT::Author');
$mock_author->mock( 'is_superuser', sub {0} );
my $mock_app_api = Test::MockModule->new('MT::App::DataAPI');
$mock_app_api->mock( 'authenticate', $author );
my $version;
$mock_app_api->mock( 'current_api_version',
    sub { $version = $_[1] if $_[1]; $version } );

my $blog = $app->model('blog')->load(1);
my $start_time
    = MT::Util::ts2iso( $blog, MT::Util::epoch2ts( $blog, time() ), 1 );

my @suite = (
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
                        qw(administer create_blog create_website edit_templates
                            manage_plugins view_log)
                    ],
                    blog => undef
                },
                {   permissions => [
                        qw(administer_blog administer_website comment create_post
                            edit_all_posts edit_assets edit_categories edit_config
                            edit_notifications edit_tags edit_templates manage_feedback
                            manage_member_blogs manage_pages manage_themes manage_users
                            publish_post rebuild save_image_defaults send_notifications
                            set_publish_paths upload view_blog_log)
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
    {   path   => '/v2/users/1/permissions',
        method => 'GET',
    },

    # list_permissions_for_user - irregular tests
    {   path   => '/v2/users/2/permissions',
        method => 'GET',
        code   => '403',
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

    # superuser

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

    # list_permissions_for_site - irregular tests

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

    # grant_permission_to_site - irregular tests
    {   path   => '/v2/sites/10/permissions/grant',
        method => 'POST',
        code   => 404,
    },
    {   path     => '/v2/sites/1/permissions/grant',
        method   => 'POST',
        code     => 400,
        complete => sub {
            my ( $data, $body ) = @_;
            check_error_message( $body,
                "A parameter \"author_id\" is required." );
        },
    },
    {   path     => '/v2/sites/1/permissions/grant',
        method   => 'POST',
        code     => 400,
        params   => { author_id => 10 },
        complete => sub {
            my ( $data, $body ) = @_;
            check_error_message( $body, "Author (ID:10) not found." );
        },
    },
    {   path     => '/v2/sites/1/permissions/grant',
        method   => 'POST',
        params   => { author_id => $author->id },
        code     => 400,
        complete => sub {
            my ( $data, $body ) = @_;
            check_error_message( $body,
                "A parameter \"role_id\" is required." );
        },
    },
    {   path   => '/v2/sites/1/permissions/grant',
        method => 'POST',
        params => {
            author_id => $author->id,
            role_id   => 20,
        },
        code     => 400,
        complete => sub {
            my ( $data, $body ) = @_;
            check_error_message( $body, "Role (ID:20) not found." );
        },
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
            author_id => $author->id,
            role_id   => 2,
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
    {   path   => '/v2/users/10/permissions/grant',
        method => 'POST',
        code   => 404,
    },
    {   path     => '/v2/users/1/permissions/grant',
        method   => 'POST',
        code     => 400,
        complete => sub {
            my ( $data, $body ) = @_;
            check_error_message( $body,
                "A parameter \"site_id\" is required." );
        },
    },
    {   path     => '/v2/users/1/permissions/grant',
        method   => 'POST',
        params   => { site_id => 10, },
        code     => 400,
        complete => sub {
            my ( $data, $body ) = @_;
            check_error_message( $body, "Site (ID:10) not found." );
        },
    },
    {   path     => '/v2/users/1/permissions/grant',
        method   => 'POST',
        params   => { site_id => 1 },
        code     => 400,
        complete => sub {
            my ( $data, $body ) = @_;
            check_error_message( $body,
                "A parameter \"role_id\" is required." );
        },
    },
    {   path     => '/v2/users/1/permissions/grant',
        method   => 'POST',
        params   => { site_id => 1, role_id => 20 },
        code     => 400,
        complete => sub {
            my ( $data, $body ) = @_;
            check_error_message( $body, "Role (ID:20) not found." );
        },
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
    {   path   => '/v2/sites/10/permissions/revoke',
        method => 'POST',
        code   => 404,
    },
    {   path     => '/v2/sites/1/permissions/revoke',
        method   => 'POST',
        code     => 400,
        complete => sub {
            my ( $data, $body ) = @_;
            check_error_message( $body,
                "A parameter \"author_id\" is required." );
        },
    },
    {   path     => '/v2/sites/1/permissions/revoke',
        method   => 'POST',
        params   => { author_id => 10, },
        code     => 400,
        complete => sub {
            my ( $data, $body ) = @_;
            check_error_message( $body, "Author (ID:10) not found." );
        },
    },
    {   path     => '/v2/sites/1/permissions/revoke',
        method   => 'POST',
        params   => { author_id => $author->id },
        code     => 400,
        complete => sub {
            my ( $data, $body ) = @_;
            check_error_message( $body,
                "A parameter \"role_id\" is required." );
        },
    },
    {   path     => '/v2/sites/1/permissions/revoke',
        method   => 'POST',
        params   => { author_id => $author->id, role_id => 20 },
        code     => 400,
        complete => sub {
            my ( $data, $body ) = @_;
            check_error_message( $body, "Role (ID:20) not found." );
        },
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
            author_id => $author->id,
            role_id   => 2,
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
    {   path   => '/v2/users/10/permissions/revoke',
        method => 'POST',
        code   => 404,
    },
    {   path     => '/v2/users/1/permissions/revoke',
        method   => 'POST',
        code     => 400,
        complete => sub {
            my ( $data, $body ) = @_;
            check_error_message( $body,
                "A parameter \"site_id\" is required." );
        },
    },
    {   path     => '/v2/users/1/permissions/revoke',
        method   => 'POST',
        params   => { site_id => 10, },
        code     => 400,
        complete => sub {
            my ( $data, $body ) = @_;
            check_error_message( $body, "Site (ID:10) not found." );
        },
    },
    {   path     => '/v2/users/1/permissions/revoke',
        method   => 'POST',
        params   => { site_id => 1 },
        code     => 400,
        complete => sub {
            my ( $data, $body ) = @_;
            check_error_message( $body,
                "A parameter \"role_id\" is required." );
        },
    },
    {   path     => '/v2/users/1/permissions/revoke',
        method   => 'POST',
        params   => { site_id => 1, role_id => 20 },
        code     => 400,
        complete => sub {
            my ( $data, $body ) = @_;
            check_error_message( $body, "Role (ID:20) not found." );
        },
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

sub check_error_message {
    my ( $body, $error ) = @_;
    my $result = $app->current_format->{unserialize}->($body);
    is( $result->{error}{message}, $error, 'Error message: ' . $error );
}
