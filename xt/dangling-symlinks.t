#!/usr/bin/env perl
use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../t/lib";    # t/lib
use Test::More;
use MT::Test::Env;
use Test::Requires 'Test::File';

BEGIN {
    if ( $^O eq 'MSWin32' ) {
        plan skip_all => 'These tests are not for Windows';
    }
}

our $test_env;

BEGIN {
    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;
}

# Check dangling symlinks. If there is some failed test,
# unnecessary symlink file may be added to this repository.

use File::Find;

my $mt_home     = $test_env->mt_home;
my $has_dot_git = -d "$mt_home/.git" ? 1 : 0;

sub test {
    my $name = $File::Find::name;
    if ( -l $name ) {
        if ( $has_dot_git && !version_controlled($name) ) {
            note "Symlink $name is not version controlled";
            return;
        }
        symlink_target_exists_ok($name);
    }
}

sub version_controlled {
    my $file = shift;
    my $res  = `git ls-files $file`;
    chomp $res;
    $res;
}

find(
    {   wanted   => \&test,
        no_chdir => 1,
    },
    $mt_home
);

ok 1;    # to pass when there's no symlink

done_testing;
