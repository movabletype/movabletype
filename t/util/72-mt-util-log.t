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
use File::Path qw(mkpath);

require_ok('MT::Util::Log');

my $mt = MT->instance;

# initialize
require MT::FileMgr;
my $fmgr = MT::FileMgr->new('Local');

for my $module (qw/ Log4perl Minimal /) {
    for my $level (qw/ debug warn /) {
    SKIP: {
            my $path = $test_env->path("log/$module/$level");
            mkpath $path;

            $mt->config( 'LoggerLevel',   $level );
            $mt->config( 'LoggerPath',    $path );
            $mt->config( 'LoggerModule',  $module );
            $mt->config( 'LoggerFileName', undef );

            no warnings 'once';
            $MT::Util::Log::Initialized = 0;
            $MT::Util::Log::Logger      = undef;
            $Log::Minimal::PRINT        = undef;

            my $logfile_path = MT::Util::Log::_get_logfile_path();
            $fmgr->delete($logfile_path) if $fmgr->exists($logfile_path);
            ok !-f $logfile_path, "logfile does not exist yet";

            unless ( MT::Util::Log::_find_module() ) {
                skip "Log::$module class isn't installed.", 1;
            }
            ok !-s $logfile_path, "logfile is empty";

            MT::Util::Log->info("--- $module / $level ---");
            if ( $level eq 'debug' ) {
                ok( -s $logfile_path,
                    "A data was written to a file. ($module)"
                );
            }
            else {
                ok( !-s $logfile_path,
                    "A data was not written to a file. ($module)"
                );
            }

            eval {
                use locale;
                use POSIX qw(locale_h);    ## no critic
                setlocale(LC_ALL, "ja_JP.UTF-8");
                my @warnings;
                local $SIG{__WARN__} = sub { push @warnings, @_ };
                mkdir $test_env->path("tmp");
                MT::Util::Log->error("$!");
                ok !@warnings, "Write Japanese error without warnings" or note explain \@warnings;
            };
            warn $@ if $@;

            if ($module eq 'Log4perl') {
                Log::Log4perl->reset;
            }
            if ($module eq 'Minimal') {
                undef $Log::Minimal::PRINT;
            }
        }
    }
}

done_testing();
