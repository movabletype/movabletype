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

    # list_themes - normal tests
    {   path   => '/v2/themes',
        method => 'GET',
    },

    # list_themes_for_site - normal tests
    {   path   => '/v2/sites/2/themes',
        method => 'GET',
    },
    {   path   => '/v2/sites/1/themes',
        method => 'GET',
    },
    {   path   => '/v2/sites/0/themes',
        method => 'GET',
    },

    # get_theme - irregular tests
    {   path   => '/v2/themes/non_existent_theme',
        method => 'GET',
        code   => 404,
    },

    # get_theme - normal tests
    {   path   => '/v2/themes/classic_website',
        method => 'GET',
    },

    # get_theme_for_site - normal tests
    {   path   => '/v2/sites/2/themes/classic_website',
        method => 'GET',
    },
    {   path   => '/v2/sites/1/themes/classic_blog',
        method => 'GET',
    },
    {   path   => '/v2/sites/0/themes/classic_website',
        method => 'GET',
    },

    # get_theme_for_site - irregular tests
    {    # Non-existent site.
        path   => '/v2/sites/10/cllassic_blog',
        method => 'GET',
        code   => 404,
    },
    {    # Non-existent theme.
        path   => '/v2/sites/2/themes/non_existent_theme',
        method => 'GET',
        code   => 404,
    },
    {    # get website theme via blog.
        path   => '/v2/sites/1/themes/classic_website',
        method => 'GET',
        code   => 404,
    },

    # apply_theme_to_site - normal tests
    {   path  => '/v2/sites/2/themes/pico/apply',
        setup => sub {
            my $site = MT->model('blog')->load(2);
            die if $site->theme_id eq 'pico';
        },
        method   => 'POST',
        complete => sub {
            my $site = MT->model('blog')->load(2);
            is( $site->theme_id, 'pico', 'Changed into pico.' );
        },
    },
    {   path  => '/v2/sites/1/themes/pico/apply',
        setup => sub {
            my $site = MT->model('blog')->load(1);
            die if $site->theme_id eq 'pico';
        },
        method   => 'POST',
        complete => sub {
            my $site = MT->model('blog')->load(1);
            is( $site->theme_id, 'pico', 'Changed into pico.' );
        },
    },

    # apply_theme_to_site - irregular tests
    {    # system scope.
        path   => '/v2/sites/0/themes/pico/apply',
        method => 'POST',
        code   => 404,
    },
    {    # Non-existent site.
        path   => '/v2/sites/10/themes/pico/apply',
        method => 'POST',
        code   => 404,
    },
    {    # Non-existent theme.
        path   => '/v2/sites/2/themes/non_existent_theme/apply',
        method => 'POST',
        code   => 404,
    },
    {    # Non-existent site and non-existent theme.
        path   => '/v2/sites/5/themes/non_existent_theme/apply',
        method => 'POST',
        code   => 404,
    },
    {    # Try to apply website theme to blog.
        path   => '/v2/sites/1/themes/classic_website/apply',
        method => 'POST',
        code   => 400,
    },

    # refresh_templates - normal tests
    {   path   => '/v2/sites/2/refresh_templates',
        method => 'POST',
    },
    {   path   => '/v2/sites/1/refresh_templates',
        method => 'POST',
    },
    {   path   => '/v2/sites/0/refresh_templates',
        method => 'POST',
    },

    {   path   => '/v2/sites/2/refresh_templates',
        method => 'POST',
        params => { backup => 1, },
    },
    {   path   => '/v2/sites/2/refresh_templates',
        method => 'POST',
        params => { refresh_type => 'refresh', },
    },
    {   path   => '/v2/sites/2/refresh_templates',
        method => 'POST',
        params => { refresh_type => 'clean', },
    },

    # refresh_templates - irregular tests
    {    # Non-existent site.
        path   => '/v2/sites/5/refresh_templates',
        method => 'POST',
        code   => 404,
    },
    {    # Invalid parameter.
        path   => '/v2/sites/2/refresh_templates',
        method => 'POST',
        params => { refresh_type => 'dummy', },
        code   => 400,
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
