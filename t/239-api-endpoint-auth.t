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

my $author = MT->model('author')->load(1);
$author->email('melody@example.com');
$author->save;

my $token_class   = MT->model('accesstoken');
my $session_class = MT->model('session');

# Cleanup
$session_class->remove_all;
$token_class->remove_all;

my $suite = suite();
test_data_api($suite);

done_testing;

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

sub suite {
    return [
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
                    {   id         => 1,
                        session_id => $data->{session}->id,
                        start      => time(),
                    }
                );
            },
            complete => sub {
                my ($data) = @_;
                my $s = delete $data->{session};
                is( $session_class->count( $s->id ),
                    0, 'A session is deleted' );
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
                    {   id         => 2,
                        session_id => $data->{session}->id,
                        start      => time(),
                    }
                );
                $data->{mock} = Test::MockModule->new('MT::App::DataAPI');
                $data->{mock}->mock( 'mt_authorization_data',
                    +{ MTAuth => { accessToken => $data->{token}->id, }, },
                );
            },
            complete => sub {
                my ($data) = @_;
                my $s      = delete $data->{session};
                my $t      = delete $data->{token};
                is( $session_class->count( $s->id ),
                    1, 'A session is not deleted' );
                is( $token_class->count( $t->id ), 0, 'A token is deleted' );
                delete $data->{mock};
            },
        },
    ];
}

