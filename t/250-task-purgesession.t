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


use lib qw(extlib lib t/lib);

BEGIN {
    $ENV{MT_CONFIG} = 'mysql-test.cfg';
}

use MT;
use MT::App::DataAPI;
eval(
    $ENV{SKIP_REINITIALIZE_DATABASE}
    ? "use MT::Test;"
    : "use MT::Test qw(:db);"
);
use MT::Test::Permission;
use Test::More;

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

my $effective = make_session(
    {   id    => 1,
        kind  => 'DS',
        start => time(),
    }
);

my $expired = make_session(
    {   id    => 2,
        kind  => 'DS',
        start => time() - MT->config->UserSessionTimeout - 1,
    }
);

my $remembered = make_session(
    {   id    => 3,
        kind  => 'DS',
        start => time() - MT->config->UserSessionTimeout - 1,
    },
    { remember => 1, }
);

my $effective_token = make_token(
    {   id         => 1,
        session_id => 1,
        start      => time(),
    }
);

my $expired_token = make_token(
    {   id         => 2,
        session_id => 2,
        start      => time() - $token_class->ttl - 1,
    }
);

MT::App::DataAPI->purge_session_records();

# Clear cache.
$session_class->driver->Disabled(1) if $session_class->driver->can('Disabled');

ok( $session_class->load( $effective->id ),
    'An effective session record is not purged'
);
ok( !$session_class->load( $expired->id ),
    'An expired session record is purged'
);
ok( $session_class->load( $remembered->id ),
    'A remembered session record is not purged'
);

ok( $token_class->load( $effective_token->id ),
    'An effective token record is not purged'
);
ok( !$token_class->load( $expired_token->id ),
    'An expired token record is purged'
);

done_testing();
