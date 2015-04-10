#!/usr/bin/env perl
use strict;
use warnings;

# Check dangling symlinks. If there is some failed test,
# unnecessary symlink file may be added to this repository.

use Test::More;
use Test::File;

use Cwd;
use File::Find;

sub test {
    my $name = $File::Find::name;
    if ( -l $name ) {
        symlink_target_exists_ok($name);
    }
}

find( \&test, getcwd );

done_testing;
