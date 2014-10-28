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

use MT::Theme;
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

    # create_template - irregular tests
    {    # No resource.
        path     => '/v2/sites/2/templates',
        method   => 'POST',
        code     => 400,
        complete => sub {
            my ( $data, $body ) = @_;
            check_error_message( $body,
                'A resource "template" is required.' );
        },
    },
    {    # No name.
        path     => '/v2/sites/2/templates',
        method   => 'POST',
        params   => { template => {}, },
        code     => 409,
        complete => sub {
            my ( $data, $body ) = @_;
            check_error_message( $body,
                "A parameter \"name\" is required.\n" );
        },
    },
    {    # No type.
        path     => '/v2/sites/2/templates',
        method   => 'POST',
        params   => { template => { name => 'create-template', }, },
        code     => 409,
        complete => sub {
            my ( $data, $body ) = @_;
            check_error_message( $body,
                "A parameter \"type\" is required.\n" );
        },
    },
    {    # Invalid type.
        path   => '/v2/sites/2/templates',
        method => 'POST',
        params => {
            template => {
                name => 'create-template',
                type => 'invalid-type',
            },
        },
        code     => 409,
        complete => sub {
            my ( $data, $body ) = @_;
            check_error_message( $body, "Invalid type: invalid-type\n" );
        },
    },
    {    # Invalid type (system).
        path   => '/v2/sites/0/templates',
        method => 'POST',
        params => {
            template => {
                name => 'create-template',
                type => 'index',
            },
        },
        code     => 409,
        complete => sub {
            my ( $data, $body ) = @_;
            check_error_message( $body, "Invalid type: index\n" );
        },
    },
    {    # No outputFile.
        path   => '/v2/sites/2/templates',
        method => 'POST',
        params => {
            template => {
                name => 'create-template',
                type => 'index',
            },
        },
        code     => 409,
        complete => sub {
            my ( $data, $body ) = @_;
            check_error_message( $body,
                "A parameter \"outputFile\" is required.\n" );
        },
    },

    # create_template - normal tests
    {   path   => '/v2/sites/2/templates',
        method => 'POST',
        setup  => sub {
            die
                if $app->model('template')->exist(
                {   blog_id => 2,
                    name    => 'create-template',
                }
                );
        },
        params => {
            template => {
                name       => 'create-template',
                type       => 'index',
                outputFile => 'create_template.html',
            },
        },
        result => sub {
            $app->model('template')->load(
                {   blog_id => 2,
                    name    => 'create-template',
                    outfile => 'create_template.html',
                }
            );
        },
    },

    # list_templates - irregular tests
    {    # Non-existent site.
        path   => '/v2/sites/5/templates',
        method => 'GET',
        code   => 404,
    },

    # list_templates - normal tests
    {   path   => '/v2/sites/2/templates',
        method => 'GET',
    },
    {    # Search name.
        path   => '/v2/sites/2/templates',
        method => 'GET',
        params => {
            searchFields => 'name',
            search       => 'create-template',
        },
        result => sub {
            my @tmpl = $app->model('template')->load(
                {   blog_id => 2,
                    name    => { like => '%create-template%' },
                },
                {   sort      => 'name',
                    direction => 'ascend',
                },
            );

            $app->user($author);

            no warnings 'redefine';
            local *boolean::true  = sub {'true'};
            local *boolean::false = sub {'false'};

            return +{
                totalResults => 1,
                items        => MT::DataAPI::Resource->from_object( \@tmpl ),
            };
        },
    },
    {    # Search identifier.
        path   => '/v2/sites/2/templates',
        method => 'GET',
        params => {
            searchFields => 'templateType',
            search       => 'banner_footer',
        },
        result => sub {
            my @tmpl = $app->model('template')->load(
                {   blog_id    => 2,
                    identifier => { like => '%banner_footer%' },
                },
                {   sort      => 'name',
                    direction => 'ascend',
                },
            );

            $app->user($author);

            no warnings 'redefine';
            local *boolean::true  = sub {'true'};
            local *boolean::false = sub {'false'};

            return +{
                totalResults => 1,
                items        => MT::DataAPI::Resource->from_object( \@tmpl ),
            };
        },
    },
    {    # Search text.
        path   => '/v2/sites/2/templates',
        method => 'GET',
        params => {
            searchFields => 'text',
            search       => 'DOCTYPE',
        },
        result => sub {
            my @terms_args = (
                {   blog_id => 2,
                    text    => { like => '%DOCTYPE%' },
                },
                {   sort      => 'name',
                    direction => 'ascend',
                    limit     => 10,
                },
            );

            my $total_count = $app->model('template')->count(@terms_args);
            my @tmpl        = $app->model('template')->load(@terms_args);

            $app->user($author);

            no warnings 'redefine';
            local *boolean::true  = sub {'true'};
            local *boolean::false = sub {'false'};

            return +{
                totalResults => $total_count,
                items        => MT::DataAPI::Resource->from_object( \@tmpl ),
            };
        },
    },
    {    # Filter by type.
        path   => '/v2/sites/2/templates',
        method => 'GET',
        params => { type => 'index', },
        result => sub {
            my @tmpl = $app->model('template')->load(
                {   blog_id => 2,
                    type    => 'index',
                },
                {   sort      => 'name',
                    direction => 'ascend',
                },
            );

            $app->user($author);

            no warnings 'redefine';
            local *boolean::true  = sub {'true'};
            local *boolean::false = sub {'false'};

            return +{
                totalResults => scalar @tmpl,
                items        => MT::DataAPI::Resource->from_object( \@tmpl ),
            };
        },
    },

    # get_template - irregular tests
    {    # Non-existent template.
        path   => '/v2/sites/2/templates/300',
        method => 'GET',
        code   => 404,
    },
    {    # Non-existent site.
        path   => '/v2/sites/5/templates/34',
        method => 'GET',
        code   => 404,
    },
    {    # Other site.
        path   => '/v2/sites/1/templates/34',
        method => 'GET',
        code   => 404,
    },
    {    # Other site (system).
        path   => '/v2/sites/0/templates/34',
        method => 'GET',
        code   => 404,
    },

    # get_template - normal tests
    {   path   => '/v2/sites/2/templates/34',
        method => 'GET',
        result => sub {
            $app->model('template')->load(34);
        },
    },

    # update_template - irregular tests
    {    # Non-existent template.
        path   => '/v2/sites/2/templates/500',
        method => 'PUT',
        params => {
            template => {
                name => 'update-template',
                type => 'custom',
            },
        },
        code => 404,
    },

    # update_template - normal tests
    {   path   => '/v2/sites/2/templates/34',
        method => 'PUT',
        params => { template => { name => 'update-template', }, },
        result => sub {
            $app->model('template')->load(34);
        },
    },

    # delete_template - irregular tests
    {    # Non-existent template.
        path   => '/v2/sites/2/templates/300',
        method => 'DELETE',
        code   => 404,
    },
    {    # Non-existent site.
        path   => '/v2/sites/5/templates/34',
        method => 'DELETE',
        code   => 404,
    },
    {    # Other site.
        path   => '/v2/sites/1/templates/34',
        method => 'DELETE',
        code   => 404,
    },
    {    # Other site (system).
        path   => '/v2/sites/0/templates/34',
        method => 'DELETE',
        code   => 404,
    },
    {    # Email template.
        path   => '/v2/sites/0/templates/33',
        method => 'DELETE',
        code   => 403,
    },
    {    # System template.
        path   => '/v2/sites/0/templates/27',
        method => 'DELETE',
        code   => 403,
    },

    # delete_template - normal tests
    {   path   => '/v2/sites/2/templates/34',
        method => 'DELETE',
        setup  => sub {
            die if !$app->model('template')->load(34);
        },
        complete => sub {
            my $tmpl = $app->model('template')->load(34);
            is( $tmpl, undef, 'Deleted template.' );
        },
    },

    # publish_template - irregular tests
    {    # Template module.
        path   => '/v2/sites/1/templates/138/publish',
        method => 'POST',
        code   => 400,
    },

    # publish_template - normal tests
    {    # Index template.
        path   => '/v2/sites/1/templates/133/publish',
        method => 'POST',
        result => sub {
            return +{ status => 'success' };
        },
    },

    # refresh_template - irregular tests
    {   path   => '/v2/sites/1/templates/300/refresh',
        method => 'POST',
        code   => 404,
    },

    # refresh_template - normal tests
    {   path   => '/v2/sites/1/templates/133/refresh',
        method => 'POST',
    },

    # clone_template - irregular tests
    {    # Email template.
        path   => '/v2/sites/0/templates/33/clone',
        method => 'POST',
        code   => 400,
    },
    {    # System template.
        path   => '/v2/sites/0/templates/27/clone',
        method => 'POST',
        code   => 400,
    },

    # clone_template - normal tests
    {   path   => '/v2/sites/1/templates/133/clone',
        method => 'POST',
        result => sub {
            return +{ status => 'success' };
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
