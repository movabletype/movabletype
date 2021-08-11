#!/usr/bin/perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib"; # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;
BEGIN {
    eval { require Log::Log4perl } or plan skip_all => 'requires Log::Log4perl';

    $test_env = MT::Test::Env->new(
        LoggerLevel  => 'INFO',
        LoggerModule => 'Log4perl',
        LoggerConfig => 'TEST_ROOT/logger.config',
        LoggerPath   => undef,
    );
    $ENV{MT_CONFIG} = $test_env->config_file;
}

my $config = $test_env->path('logger.config');
ok !-e $config, "config does not exist yet";

my $path = $test_env->path('log');
mkdir $path;
my $logfile = $test_env->path('log/test.log');
unlink $logfile if -f $logfile;
my $logfile2 = $test_env->path('log/test2.log');
unlink $logfile2 if -f $logfile2;

$test_env->save_file( 'logger.config', <<"CONFIG" );
log4perl.category = INFO, Logfile, Logfile2, Screen
log4perl.appender.Logfile = Log::Log4perl::Appender::File
log4perl.appender.Logfile.filename = $logfile
log4perl.appender.Logfile.autoflush = 1
log4perl.appender.Logfile.syswrite = 1
log4perl.appender.Logfile.utf8 = 1
log4perl.appender.Logfile.layout = Log::Log4perl::Layout::PatternLayout
log4perl.appender.Logfile.layout.ConversionPattern = [%r] %F %L %m%n
log4perl.appender.Logfile.Threshold = INFO
log4perl.appender.Logfile2 = Log::Log4perl::Appender::File
log4perl.appender.Logfile2.filename = $logfile2
log4perl.appender.Logfile2.autoflush = 1
log4perl.appender.Logfile2.syswrite = 1
log4perl.appender.Logfile2.utf8 = 1
log4perl.appender.Logfile2.layout = Log::Log4perl::Layout::PatternLayout
log4perl.appender.Logfile2.layout.ConversionPattern = [%r] %F %L %m%n
log4perl.appender.Logfile2.Threshold = WARN, ERROR
log4perl.appender.Screen        = Log::Log4perl::Appender::Screen
log4perl.appender.Screen.stderr = 0
log4perl.appender.Screen.utf8 = 1
log4perl.appender.Screen.layout = Log::Log4perl::Layout::SimpleLayout
CONFIG

ok -f $config, "logger.config exists";

my $mt = MT->instance;

require MT::Util::Log;
MT::Util::Log::init();
MT::Util::Log->info("Some information");
MT::Util::Log->notice("Some notice");
MT::Util::Log->warn("Some warning");
MT::Util::Log->error("Some error");

ok -f $logfile, "logfile exists";
my $log = $test_env->slurp($logfile);
like $log => qr/Some information/, "logfile contains correct info log";
like $log => qr/Some notice/, "logfile2 contains correct notice log";

ok -f $logfile2, "logfile2 exists";
my $log2 = $test_env->slurp($logfile2);
like $log2 => qr/Some warning/, "logfile2 contains correct warning log";
like $log2 => qr/Some error/, "logfile2 contains correct error log";

eval {
    use locale;
    use POSIX qw(locale_h);
    setlocale(LC_ALL, "ja_JP.UTF-8");
    my @warnings;
    local $SIG{__WARN__} = sub { push @warnings, @_ };
    mkdir $test_env->path("tmp");
    mkdir $test_env->path("tmp");
    MT::Util::Log->error("$!");
    ok !@warnings, "Log a Japanese error without warnings" or note explain \@warnings;
};
warn $@ if $@;

done_testing();
