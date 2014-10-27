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

my @suite = (

    # list_tags - normal tests
    {   path      => '/v2/tags',
        method    => 'GET',
        callbacks => [
            {   name  => 'data_api_pre_load_filtered_list.tag',
                count => 2,
            },
        ],
        complete => sub {
            my ( $data, $body ) = @_;

            my $got_logs = $app->current_format->{unserialize}->($body);
            my @expected_logs
                = MT->model('tag')->load( undef, { sort => 'name' } );

            my @got_log_names = map { $_->{name} } @{ $got_logs->{items} };
            my @expected_log_names = map { $_->name } @expected_logs;

            is_deeply( \@got_log_names, \@expected_log_names );
        },
    },
    {    # Search name.
        path      => '/v2/tags',
        method    => 'GET',
        params    => { search => 'page' },
        callbacks => [
            {   name  => 'data_api_pre_load_filtered_list.tag',
                count => 2,
            },
        ],
        result => sub {
            my @tags = $app->model('tag')->load(
                { name => { like => '%page%' } },
                { sort => 'name', direction => 'ascend' },
            );

            $app->user($author);
            no warnings 'redefine';
            local *boolean::true  = sub {'true'};
            local *boolean::false = sub {'false'};

            return +{
                totalResults => 3,
                items        => MT::DataAPI::Resource->from_object( \@tags ),
            };
        },
    },

    {
        # Not logged in.
        path      => '/v2/tags',
        method    => 'GET',
        setup     => sub { $mock_app_api->unmock('authenticate') },
        callbacks => [
            {   name  => 'data_api_pre_load_filtered_list.tag',
                count => 2,
            },
        ],
        complete => sub {
            my ( $data, $body ) = @_;

            my $got_logs      = $app->current_format->{unserialize}->($body);
            my @expected_logs = MT->model('tag')
                ->load( { is_private => { not => 1 } }, { sort => 'name' } );

            my @got_log_names = map { $_->{name} } @{ $got_logs->{items} };
            my @expected_log_names = map { $_->name } @expected_logs;

            is_deeply( \@got_log_names, \@expected_log_names );

            $mock_app_api->mock( 'authenticate', $author );
        },
    },

    # list_tags_for_site - normal tests
    {   path      => '/v2/sites/1/tags',
        method    => 'GET',
        callbacks => [
            {   name  => 'data_api_pre_load_filtered_list.tag',
                count => 2,
            },
        ],
        complete => sub {
            my ( $data, $body ) = @_;

            my $got_logs      = $app->current_format->{unserialize}->($body);
            my @expected_logs = MT->model('tag')->load(
                undef,
                {   sort => 'name',
                    join => MT->model('objecttag')->join_on(
                        'tag_id',
                        { blog_id => 1 },
                        { unique  => 1 },
                    ),
                }
            );

            my @got_log_names = map { $_->{name} } @{ $got_logs->{items} };
            my @expected_log_names = map { $_->name } @expected_logs;

            is_deeply( \@got_log_names, \@expected_log_names );
        },
    },
    {    # System.
        path      => '/v2/sites/0/tags',
        method    => 'GET',
        callbacks => [
            {   name  => 'data_api_pre_load_filtered_list.tag',
                count => 2,
            },
        ],
        result => sub {
            my @tags = $app->model('tag')->load(
                undef,
                {   sort      => 'name',
                    direction => 'ascend',
                    join      => MT->model('objecttag')->join_on(
                        'tag_id',
                        { blog_id => 0 },
                        { unique  => 1 },
                    ),
                },
            );

            $app->user($author);
            no warnings 'redefine';
            local *boolean::true  = sub {'true'};
            local *boolean::false = sub {'false'};

            return +{
                totalResults => 1,
                items        => MT::DataAPI::Resource->from_object( \@tags ),
            };
        },
    },
    {    # Search name.
        path      => '/v2/sites/1/tags',
        method    => 'GET',
        params    => { search => 'flow' },
        callbacks => [
            {   name  => 'data_api_pre_load_filtered_list.tag',
                count => 2,
            },
        ],
        result => sub {
            my @tags = $app->model('tag')->load(
                { name => { like => '%flow%' } },
                {   sort      => 'name',
                    direction => 'ascend',
                    join      => MT->model('objecttag')->join_on(
                        'tag_id',
                        { blog_id => 1 },
                        { unique  => 1 },
                    ),
                },
            );

            $app->user($author);
            no warnings 'redefine';
            local *boolean::true  = sub {'true'};
            local *boolean::false = sub {'false'};

            return +{
                totalResults => 1,
                items        => MT::DataAPI::Resource->from_object( \@tags ),
            };
        },
    },

    # list_tags_for_site - irregular tests
    {
        # Non-existent site.
        path   => '/v2/sites/10/tags',
        method => 'GET',
        code   => 404,
    },

    # get_tag - normal tests
    {   path      => '/v2/tags/grandpa',
        method    => 'GET',
        callbacks => [
            {   name =>
                    'MT::App::DataAPI::data_api_view_permission_filter.tag',
                count => 1,
            },
        ],
        result => sub {
            return MT->model('tag')->load( { name => 'grandpa' } );
        },
    },

    # get_tag - irregular tests
    {    # Non-existent tag.
        path   => '/v2/tags/foobarbaz',
        method => 'GET',
        code   => 404,
    },

    # get_tag_for_site - normal tests
    {   path      => '/v2/sites/1/tags/grandpa',
        method    => 'GET',
        callbacks => [
            {   name =>
                    'MT::App::DataAPI::data_api_view_permission_filter.tag',
                count => 1,
            },
        ],
        result => sub {
            return MT->model('tag')->load( { name => 'grandpa' } );
        },
    },

    # get_tag_for_site - irregular tests
    {    # Existent tag via other site.
        path   => '/v2/sites/2/grandpa',
        method => 'GET',
        code   => 404,
    },
    {    # Existent tag via non-existent site.
        path   => '/v2/sites/10/grandpa',
        method => 'GET',
        code   => 404,
    },
    {    # Non-existent tag via existent site.
        path   => '/v2/sites/1/tags/foobarbaz',
        method => 'GET',
        code   => 404,
    },
    {    # Non-existent tag via non-existent site.
        path   => '/v2/sites/10/tags/foobarbaz',
        method => 'GET',
        code   => 404,
    },

    # rename_tag - irregular tests
    {    # Non-existent tag.
        path   => '/v2/tags/foobarbaz',
        method => 'PUT',
        code   => 404,
        result => sub {
            return +{
                error => {
                    code    => 404,
                    message => 'Tag not found',
                },
            };
        },
    },
    {    # Invalid parameter.
        path   => '/v2/tags/grandpa',
        method => 'PUT',
        code   => 400,
        result => sub {
            return +{
                error => {
                    code    => 400,
                    message => 'A resource "tag" is required.',
                },
            };
        },
    },

    # rename_tag - normal tests
    {   path      => '/v2/tags/grandpa',
        method    => 'PUT',
        params    => { tag => { name => 'grandma' }, },
        callbacks => [
            {   name =>
                    'MT::App::DataAPI::data_api_save_permission_filter.tag',
                count => 1,
            },
            {   name  => 'MT::App::DataAPI::data_api_save_filter.tag',
                count => 1,
            },
            {   name  => 'MT::App::DataAPI::data_api_pre_save.tag',
                count => 1,
            },
            {   name  => 'MT::App::DataAPI::data_api_post_save.tag',
                count => 1,
            },
        ],
        result   => sub { MT->model('tag')->load( { name => 'grandma' } ); },
        complete => sub {
            my $tag = MT->model('tag')->load( { name => 'grandpa' } );
            is( $tag, undef, 'Renamed "grandpa" tag.' );
        },
    },

    # rename_tag_for_site - irregular tests
    {    # Non-existent tag.
        path   => '/v2/sites/1/tags/foobarbaz',
        method => 'PUT',
        code   => 404,
        result => sub {
            return +{
                error => {
                    code    => 404,
                    message => 'Tag not found',
                },
            };
        },
    },
    {    # Non-existent site.
        path   => '/v2/sites/10/tags/rain',
        method => 'PUT',
        code   => 404,
        result => sub {
            return +{
                error => {
                    code    => 404,
                    message => 'Site not found',
                }
            };
        },
    },
    {    # Non-existent tag via non-existent site.
        path   => '/v2/sites/10/tags/foobarbaz',
        method => 'PUT',
        code   => 404,
        result => sub {
            return +{
                error => {
                    code    => 404,
                    message => 'Site not found',
                }
            };
        },
    },
    {    # Invalid paramter.
        path   => '/v2/sites/1/tags/rain',
        method => 'PUT',
        code   => 400,
        result => sub {
            return +{
                error => {
                    code    => 400,
                    message => 'A resource "tag" is required.',
                }
            };
        },
    },
    {    # Invalid parameter.
        path   => '/v2/sites/1/tags/rain',
        method => 'PUT',
        code   => 400,
        result => sub {
            +{  error => {
                    code    => 400,
                    message => 'A resource "tag" is required.',
                }
            };
        },
    },

    # rename_tag_for_site - normal tests
    {   path      => '/v2/sites/1/tags/rain',
        method    => 'PUT',
        params    => { tag => { name => 'snow' }, },
        callbacks => [
            {   name =>
                    'MT::App::DataAPI::data_api_save_permission_filter.tag',
                count => 1,
            },
            {   name  => 'MT::App::DataAPI::data_api_save_filter.tag',
                count => 1,
            },
            {   name  => 'MT::App::DataAPI::data_api_pre_save.tag',
                count => 1,
            },
            {   name  => 'MT::App::DataAPI::data_api_post_save.tag',
                count => 1,
            },
        ],
        result   => sub { MT->model('tag')->load( { name => 'snow' } ); },
        complete => sub {
            my $tag = MT->model('tag')->load( { name => 'rain' } );
            is( $tag, undef, 'Renamed "rain" tag.' );
        },
    },

    # delete_tag - irregular tests
    {    # Non-existent tag.
        path   => '/v2/tags/non_exsitent_tag',
        method => 'DELETE',
        code   => 404,
        result => sub {
            +{  error => {
                    code    => 404,
                    message => 'Tag not found',
                },
            };
        },
    },

    # delete_tag - normal tests
    {   path     => '/v2/tags/strolling',
        method   => 'DELETE',
        complete => sub {
            my $tag = MT->model('tag')->load( { name => 'strolling' } );
            is( $tag, undef, 'Deleted "strolling" tag.' );
        },
    },

    # delete_tag_for_site - irregular tests
    {    # Non-existent tag.
        path   => '/v2/sites/1/tags/non_existent_tag',
        method => 'DELETE',
        code   => 404,
        result => sub {
            +{  error => {
                    code    => 404,
                    message => 'Tag not found',
                },
            };
        },
    },
    {    # Non-existent site.
        path   => '/v2/sites/5/tags/anemones',
        method => 'DELETE',
        code   => 404,
        result => sub {
            +{  error => {
                    code    => 404,
                    message => 'Site not found',
                },
            };
        },
    },

    # delete_tag_for_site - normal tests
    {   path     => '/v2/sites/1/tags/anemones',
        method   => 'DELETE',
        complete => sub {
            my $tag = MT->model('tag')->load( { name => 'anemones' } );
            is( $tag, undef, 'Deleted "anemones" tag.' );
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
