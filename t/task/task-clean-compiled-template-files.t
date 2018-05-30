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
use MT::Test;
use MT::Test::Permission;
use MT::FileMgr;

$test_env->prepare_fixture('db');

my $mt = MT->new();

# Set config directives.
$mt->config->DynamicCacheTTL( 60 * 60 * 24 );    # once a day
$mt->config->save_config;

my $fmgr        = MT::FileMgr->new('Local');
my $website     = MT::Test::Permission->make_website();
my $compile_dir = File::Spec->catdir( $website->site_path, 'templates_c' );

sub make_dummy_compiled_file {
    my $mtime = shift;

    my @seed = ( 'a' .. 'z', 'A' .. 'Z', 0 .. 9 );

    # smarty compiled template filename is dummy
    my $filename = '';
    while ( length $filename < 42 ) {
        $filename .= @seed[ int rand( scalar @seed ) ];
    }
    my $compile_file
        = File::Spec->catfile( $compile_dir, $filename . ".php" );

    $fmgr->mkpath($compile_dir) unless -d $compile_dir;
    $fmgr->put_data( '', $compile_file );

    utime time, $mtime, $compile_file;
    return $compile_file;
}

my $effective = make_dummy_compiled_file(time);

my $expired
    = make_dummy_compiled_file( time - MT->config->DynamicCacheTTL - 1 );

MT::Test::_run_tasks( ["CleanCompiledTemplateFiles"] );

ok( $fmgr->exists($effective),
    'An effective compile template file is not remove' );
ok( !$fmgr->exists($expired),
    'An effective compile template file is remove' );

# delete test files
$fmgr->delete($effective);
$fmgr->delete($expired);
rmdir($compile_dir);

done_testing();
