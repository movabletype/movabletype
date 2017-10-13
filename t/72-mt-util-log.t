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

use MT::Test;
use Test::MockModule;

require_ok('MT::Util::Log');

my $mt   = MT->instance;
my $path = File::Spec->catfile( $mt->config->TempDir );

# initialize
require MT::FileMgr;
my $fmgr = MT::FileMgr->new('Local');

for my $module (qw/ Log4perl Minimal /) {
    for my $level (qw/ debug warn /) {
    SKIP: {
            $mt->config( 'LoggerLevel',  $level );
            $mt->config( 'LoggerPath',   $path );
            $mt->config( 'LoggerModule', $module );
            unless ( MT::Util::Log::_find_module( $level, $path, $module ) ) {
                skip "Log::$module class isn't installed.", 1;
            }
            my $logfile_path = MT::Util::Log::_get_logfile_path();
            $fmgr->delete($logfile_path) if $fmgr->exists($logfile_path);
            MT::Util::Log->info("--- $module / $level ---");
            if ( $level eq 'debug' ) {
                ok( $fmgr->exists($logfile_path),
                    'A data was written to a file.'
                );
            }
            else {
                ok( !$fmgr->exists($logfile_path),
                    'A data was not written to a file.'
                );
            }
        }
    }
}

done_testing();
