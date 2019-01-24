#!/usr/bin/perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../../lib";    # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;

BEGIN {
    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT::Test::Tag;

plan tests => 2 * blocks;

use MT;
use MT::Test;
use MT::Test::Permission;

$test_env->prepare_fixture('db_data');

my $site = MT->model('website')->load or die;

MT::Test::Tag->run_perl_tests( $site->id );
MT::Test::Tag->run_php_tests( $site->id );

done_testing;

__END__

=== Used outside of MTContents
--- template
<MTContentPermalink>
--- expected
You used an 'mtContentPermalink' tag outside of the context of a content; Perhaps you mistakenly placed it outside of an 'MTContents' container tag?
