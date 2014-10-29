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

    # create_templatemap - irregular tests
    {    # Non-existent template.
        path   => '/v2/sites/1/templates/500/templatemaps',
        method => 'POST',
        code   => 404,
        result => sub {
            +{  error => {
                    code    => 404,
                    message => 'Template not found',
                },
            };
        },
    },
    {    # Non-existent site.
        path   => '/v2/sites/5/templates/96/templatemaps',
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
    {    # Other site.
        path   => '/v2/sites/2/templates/96/templatemaps',
        method => 'POST',
        code   => 404,
        result => sub {
            +{  error => {
                    code    => 404,
                    message => 'Template not found',
                },
            };
        },
    },
    {    # Other site (system).
        path   => '/v2/sites/0/templates/96/templatemaps',
        method => 'POST',
        code   => 404,
        result => sub {
            +{  error => {
                    code    => 404,
                    message => 'Template not found',
                },
            };
        },
    },
    {    # Not archive template.
        path   => '/v2/sites/1/templates/138/templatemaps',
        method => 'POST',
        code   => 400,
        result => sub {
            +{  error => {
                    code => 400,
                    message =>
                        'Template "header-line" is not archive template.',
                },
            };
        },
    },
    {    # No resource.
        path     => '/v2/sites/1/templates/96/templatemaps',
        method   => 'POST',
        code     => 400,
        complete => sub {
            my ( $data, $body ) = @_;
            check_error_message( $body,
                'A resource "templatemap" is required.' );
        },
    },
    {    # No arhichiveType.
        path     => '/v2/sites/1/templates/96/templatemaps',
        method   => 'POST',
        params   => { templatemap => {}, },
        code     => 409,
        complete => sub {
            my ( $data, $body ) = @_;
            check_error_message( $body,
                "A parameter \"archiveType\" is required.\n" );
        },
    },
    {    # Invalid archiveType.
        path     => '/v2/sites/1/templates/96/templatemaps',
        method   => 'POST',
        params   => { templatemap => { archiveType => 'invalid', }, },
        code     => 409,
        complete => sub {
            my ( $data, $body ) = @_;
            check_error_message( $body, "Invalid archiveType: invalid\n" );
        },
    },

    # create_templatemap - normal tests
    {   path   => '/v2/sites/1/templates/96/templatemaps',
        method => 'POST',
        setup  => sub {
            die
                if $app->model('templatemap')->exist(
                {   blog_id      => 1,
                    template_id  => 96,
                    is_preferred => { not => 1 },
                }
                );
        },
        params => {
            templatemap => {
                archiveType => 'Individual',
                buildType   => 'Static',
            },
        },
        result => sub {
            $app->model('templatemap')->load(
                {   blog_id      => 1,
                    template_id  => 96,
                    is_preferred => { not => 1 },
                }
            );
        },
    },

    # list_templatemaps - irregular tests
    {    # Non-existent template.
        path   => '/v2/sites/1/templates/500/templatemaps',
        method => 'GET',
        code   => 404,
        result => sub {
            +{  error => {
                    code    => 404,
                    message => 'Template not found',
                },
            };
        },
    },
    {    # Non-existent site.
        path   => '/v2/sites/5/templates/96/templatemaps',
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
    {    # Other site.
        path   => '/v2/sites/2/templates/96/templatemaps',
        method => 'GET',
        code   => 404,
        result => sub {
            +{  error => {
                    code    => 404,
                    message => 'Template not found',
                },
            };
        },
    },
    {    # Other site (system).
        path   => '/v2/sites/0/templates/96/templatemaps',
        method => 'GET',
        code   => 404,
        result => sub {
            +{  error => {
                    code    => 404,
                    message => 'Template not found',
                },
            };
        },
    },
    {    # Not archive template.
        path   => '/v2/sites/1/templates/138/templatemaps',
        method => 'GET',
        code   => 400,
        result => sub {
            +{  error => {
                    code => 400,
                    message =>
                        'Template "header-line" is not archive template.',
                },
            };
        },
    },

    # list_templatemaps - normal tests
    {   path   => '/v2/sites/1/templates/96/templatemaps',
        method => 'GET',
        result => sub {
            my @tm
                = $app->model('templatemap')->load( { template_id => 96, } );

            $app->user($author);

            no warnings 'redefine';
            local *boolean::true  = sub {'true'};
            local *boolean::false = sub {'false'};

            return +{
                totalResults => 2,
                items        => MT::DataAPI::Resource->from_object( \@tm ),
            };
        },
    },
    {    # Filtered by archiveType.
        path   => '/v2/sites/1/templates/96/templatemaps',
        method => 'GET',
        params => { archiveType => 'Category' },
        result => sub {
            +{  totalResults => 0,
                items        => [],
            };
        },
    },
    {    # Filtered by buildType.
        path   => '/v2/sites/1/templates/96/templatemaps',
        method => 'GET',
        params => { buildType => 'Static' },
        result => sub {
            require MT::PublishOption;
            my @tm = $app->model('templatemap')->load(
                {   template_id => 96,
                    build_type  => MT::PublishOption::ONDEMAND(),
                }
            );

            $app->user($author);

            no warnings 'redefine';
            local *boolean::true  = sub {'true'};
            local *boolean::false = sub {'false'};

            return +{
                totalResults => 2,
                items        => MT::DataAPI::Resource->from_object( \@tm ),
            };
        },
    },
    {    # Filtered by isPreferred.
        path   => '/v2/sites/1/templates/96/templatemaps',
        method => 'GET',
        params => { isPreferred => 'true' },
        result => sub {
            my @tm = $app->model('templatemap')->load(
                {   template_id  => 96,
                    is_preferred => 1,
                }
            );

            $app->user($author);

            no warnings 'redefine';
            local *boolean::true  = sub {'true'};
            local *boolean::false = sub {'false'};

            return +{
                totalResults => 1,
                items        => MT::DataAPI::Resource->from_object( \@tm ),
            };
        },
    },

    # get_templatemap - irregular tests
    {    # Non-existent templatemap.
        path   => '/v2/sites/1/templates/96/templatemaps/20',
        method => 'GET',
        code   => 404,
    },
    {    # Non-existent template.
        path   => '/v2/sites/1/templates/300/templatemaps/6',
        method => 'GET',
        code   => 404,
    },
    {    # Non-existent site.
        path   => '/v2/sites/5/templates/96/templatemaps/6',
        method => 'GET',
        code   => 404,
    },
    {    # Other template's templatemap.
        path   => '/v2/sites/1/templates/96/templatemaps/7',
        method => 'GET',
        code   => 404,
    },
    {    # Other site's templatemap.
        path   => '/v2/sites/1/templates/96/templatemaps/1',
        method => 'GET',
        code   => 404,
    },
    {    # Other template.
        path   => '/v2/sites/1/templates/110/templatemaps/6',
        method => 'GET',
        code   => 404,
    },
    {    # Other site.
        path   => '/v2/sites/2/templates/96/templatemaps/6',
        method => 'GET',
        code   => 404,
    },

    # get_templatemap - normal tests
    {   path   => '/v2/sites/1/templates/96/templatemaps/6',
        method => 'GET',
        result => sub {
            $app->model('templatemap')->load(6);
        },
    },

    # update_templatemap - normal tests
    {   path   => '/v2/sites/1/templates/96/templatemaps/6',
        method => 'PUT',
        params => { templatemap => { fileTemplate => 'foobarbaz', }, },
        result => sub {
            $app->model('templatemap')->load(6);
        },
    },

    # delete_templatemap - irregular tests
    {    # Non-existent templatemap.
        path   => '/v2/sites/1/templates/96/templatemaps/20',
        method => 'DELETE',
        code   => 404,
    },
    {    # Non-existent template.
        path   => '/v2/sites/1/templates/300/templatemaps/6',
        method => 'DELETE',
        code   => 404,
    },
    {    # Non-existent site.
        path   => '/v2/sites/5/templates/96/templatemaps/6',
        method => 'DELETE',
        code   => 404,
    },
    {    # Other template's templatemap.
        path     => '/v2/sites/1/templates/96/templatemaps/7',
        method   => 'DELETE',
        code     => 404,
        complete => sub {
            my $map = $app->model('templatemap')->load(7);
            is( ref $map, 'MT::TemplateMap',
                'Does not deleted templatemap.' );
        },
    },
    {    # Other site's templatemap.
        path     => '/v2/sites/1/templates/96/templatemaps/1',
        method   => 'DELETE',
        code     => 404,
        complete => sub {
            my $map = $app->model('templatemap')->load(1);
            is( ref $map, 'MT::TemplateMap',
                'Does not deleted templatemap.' );
        },
    },
    {    # Other template.
        path     => '/v2/sites/1/templates/110/templatemaps/6',
        method   => 'DELETE',
        code     => 404,
        complete => sub {
            my $map = $app->model('templatemap')->load(6);
            is( ref $map, 'MT::TemplateMap',
                'Does not deleted templatemap.' );
        },
    },
    {    # Other site.
        path     => '/v2/sites/2/templates/96/templatemaps/6',
        method   => 'DELETE',
        code     => 404,
        complete => sub {
            my $map = $app->model('templatemap')->load(6);
            is( ref $map, 'MT::TemplateMap',
                'Does not deleted templatemap.' );
        },
    },

    # delete_templatemap - normal tests
    {   path   => '/v2/sites/1/templates/96/templatemaps/6',
        method => 'DELETE',
        setup  => sub {
            die if !$app->model('templatemap')->load(6);
        },
        complete => sub {
            my $map = $app->model('templatemap')->load(6);
            is( $map, undef, 'Deleted templatemap.' );
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
