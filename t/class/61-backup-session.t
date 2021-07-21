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

use MT::Test;
use MT::BackupRestore::Session;

$test_env->prepare_fixture('db');

my $sess = MT::BackupRestore::Session->start('name', 'id');
is(ref $sess->sess, 'MT::Session', 'right class');
$sess->progress('some message');
is(@{$sess->sess->get('progress')}, 1, 'right number');
$sess->progress('some message');
is(@{$sess->sess->get('progress')}, 2, 'right number');
$sess->file('111.png');
is($sess->sess->get('files')->{'111.png'}, 1, 'file registered');
is($sess->get_file('111.png'), '111.png', 'file registered');
is($sess->get_file('111.png'), undef, 'file unregistered');

done_testing;
