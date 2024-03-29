#!/usr/bin/perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib"; # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;
BEGIN {
    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT;
use MT::Core;
use MT::Test;
use MT::Test::Permission;

$test_env->prepare_fixture('db');

my $session_class = MT->model('session');

# Cleanup
$session_class->remove_all;

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

my $effective = make_session(
    {   id    => 1,
        kind  => 'US',
        start => time,
    }
);

my $expired = make_session(
    {   id    => 2,
        kind  => 'US',
        start => time - MT->config->UserSessionTimeout - 1,
    }
);

my $remembered = make_session(
    {   id    => 3,
        kind  => 'US',
        start => time - MT->config->UserSessionTimeout - 1,
    },
    { remember => 1, }
);

MT::Core::purge_session_records();

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

$session_class->remove_all;

{
    MT->config('MaxUserSession', 2);

    my @target;
    my $time = time;
    my @kind = ('US', 'DS', 'US', 'DS');
    for (0 .. 3) {
        push @target, make_session({ id => $_, kind => $kind[$_], start => $time - $_ }, { remember => 1 });
    }
    my $not_target = make_session({ id => 4, kind => 'SI', start => $time - 4 });

    is(MT::Session->count, 5, 'right number');
    MT::Core::purge_session_records();
    is(MT::Session->count(), 3, 'right number');
    ok(MT::Session->load($target[0]->id),  'session remains');
    ok(MT::Session->load($target[1]->id),  'session remains');
    ok(MT::Session->load($not_target->id), 'session remains');
}

done_testing();
