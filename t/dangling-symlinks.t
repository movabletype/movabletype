#!/usr/bin/env perl
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


# Check dangling symlinks. If there is some failed test,
# unnecessary symlink file may be added to this repository.

use Cwd;
use File::Find;
use Test::More;

if ( $^O eq 'MSWin32' ) {
    plan skip_all => 'These tests are not for Windows';
}

eval 'use Test::File';
if ($@) {
    plan skip_all => 'Test::File is not installed';
}

sub test {
    my $name = $File::Find::name;
    if ( -l $name ) {
        symlink_target_exists_ok($name);
    }
}

find( \&test, getcwd );

ok 1; # to pass when there's no symlink

done_testing;
