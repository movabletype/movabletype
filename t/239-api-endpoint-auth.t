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

my $token_class   = MT->model('accesstoken');
my $session_class = MT->model('session');

# Cleanup
$session_class->remove_all;
$token_class->remove_all;

sub make_session {
    my ( $values, $data ) = @_;
    $data ||= {};

    my $s = MT->model('session')->new;

    $s->set_values($values);
    foreach my $k ( keys %$data ) {
        $s->set( $k, $data->{$k} );
    }

    $s->save;
    $s;
}

sub make_token {
    my ($values) = @_;

    my $a = MT->model('accesstoken')->new;

    $a->set_values($values);

    $a->save;
    $a;
}

my @suite = (
    {   path   => '/v1/authentication',
        method => 'DELETE',
        setup  => sub {
            my ($data) = @_;
            $app->{session} = $data->{session} = make_session(
                {   id    => 1,
                    kind  => 'DS',
                    start => time(),
                },
                { author_id => $author->id, }
            );
            make_token(
                {
                    id => 1,
                    session_id => $data->{session}->id,
                    start      => time(),
                }
            );
        },
        complete => sub {
            my ($data) = @_;
            my $s = delete $data->{session};
            is( $session_class->count( $s->id ), 0, 'A session is deleted' );
            is( $token_class->count( { session_id => $s->id } ),
                0, 'A token is deleted' );
        },
    },
    {   path   => '/v1/token',
        method => 'DELETE',
        setup  => sub {
            my ($data) = @_;
            $app->{session} = $data->{session} = make_session(
                {   id    => 2,
                    kind  => 'DS',
                    start => time(),
                },
                { author_id => $author->id, }
            );
            $data->{token} = make_token(
                {
                    id => 2,
                    session_id => $data->{session}->id,
                    start      => time(),
                }
            );
            $data->{mock} = Test::MockModule->new('MT::App::DataAPI');
            $data->{mock}->mock(
                'mt_authorization_data',
                +{
                    MTAuth => {
                        accessToken => $data->{token}->id,
                    },
                },
            );
        },
        complete => sub {
            my ($data) = @_;
            my $s = delete $data->{session};
            my $t = delete $data->{token};
            is( $session_class->count( $s->id ), 1, 'A session is not deleted' );
            is( $token_class->count( $t->id), 0, 'A token is deleted' );
            delete $data->{mock};
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
