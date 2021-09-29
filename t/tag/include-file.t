#!/usr/bin/perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";    # t/lib
use Test::More;
use MT::Test::Env;
use File::Temp qw( tempfile );
our $test_env;

BEGIN {
    $test_env = MT::Test::Env->new(
        AllowFileInclude => 1,
    );
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT;
use MT::Test;
use MT::Test::Permission;
use MT::Test::Tag;

my $app = MT->instance;

$test_env->prepare_fixture('db');

sub embed_path {
    my $in = shift;
    my $cont = filter_arguments;
    my ( $fh, $file ) = tempfile();
    print $fh $cont;
    close $fh;
    $in =~ s{PATH}{$file};
    $in;
}

MT::Test::Tag->run_perl_tests(1);
MT::Test::Tag->run_php_tests(1);

done_testing;

__DATA__

=== include file
--- template embed_path=FILE-CONTENT
left <mt:Include file="PATH"> right
--- expected
left FILE-CONTENT right
