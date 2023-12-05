#!/usr/bin/perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib"; # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;
BEGIN {
    eval { require Log::Dispatch::Config } or plan skip_all => 'requires Log::Dispatch::Config';

    $test_env = MT::Test::Env->new(
        LoggerLevel  => 'INFO',
        LoggerModule => 'Dispatch',
        LoggerPath   => undef,
    );
    $ENV{MT_CONFIG} = $test_env->config_file;
}

my $path = $test_env->path('log');
mkdir $path;
my $logfile = $test_env->path('log/test.log');
my $logfile2 = $test_env->path('log/test2.log');

my $mt = MT->instance;

require MT::Util::Log;

for my $type (qw(default perl yaml)) {
    prepare_config($type) or next;

    unlink $logfile if -f $logfile;
    unlink $logfile2 if -f $logfile2;

    no warnings 'once';
    $MT::Util::Log::Initialized = 0;
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
        use POSIX qw(locale_h);    ## no critic
        setlocale(LC_ALL, "ja_JP.UTF-8");
        my @warnings;
        local $SIG{__WARN__} = sub { push @warnings, @_ };
        mkdir $test_env->path("tmp");
        mkdir $test_env->path("tmp");
        MT::Util::Log->error("$!");
        ok !@warnings, "Log a Japanese error without warnings" or note explain \@warnings;
    };
    warn $@ if $@;
}

done_testing();

sub prepare_config {
    my $type = shift;
    return prepare_default_config() if $type eq 'default';
    return prepare_perl_config() if $type eq 'perl';
    return prepare_yaml_config() if $type eq 'yaml';
}

sub prepare_default_config {
    my $config = $test_env->path('logger.config');
    ok !-e $config, "config does not exist yet";

    $test_env->save_file( 'logger.config', <<"CONFIG" );
dispatchers = file1 file2 screen
file1.class = Log::Dispatch::File
file1.filename = $logfile
file1.autoflush = 1
file1.newline = 1
file1.binmode = :utf8
file1.format = %m
file1.min_level = info
file1.mode = append
file2.class = Log::Dispatch::File
file2.filename = $logfile2
file2.autoflush = 1
file2.newline = 1
file2.binmode = :utf8
file2.format = %m
file2.min_level = warn
file2.max_level = error
file2.mode = append
screen.class = Log::Dispatch::Screen
screen.stderr = 0
screen.utf8 = 1
screen.newline = 1
screen.format = %m
screen.min_level = debug
CONFIG

    ok -f $config, "logger.config exists";

    $mt->config(LoggerConfig => $config);
    return $config;
}

sub prepare_perl_config {
    eval { require Log::Dispatch::Configurator::Perl; 1 } or do {
        note "requires Log::Dispatch::Configurator::Perl";
        return;
    };

    my $config = $test_env->path('logger.pl');
    ok !-e $config, "config does not exist yet";

    $test_env->save_file( 'logger.pl', <<"CONFIG" );
return +{
    dispatchers => [qw( file1 file2 screen )],
    file1 => {
        class => 'Log::Dispatch::File',
        filename => '$logfile',
        autoflush => 1,
        newline => 1,
        binmode => ':utf8',
        format => '%m',
        min_level => 'info',
        mode => 'append',
    },
    file2 => {
        class => 'Log::Dispatch::File',
        filename => '$logfile2',
        autoflush => 1,
        newline => 1,
        binmode => ':utf8',
        format => '%m',
        min_level => 'warn',
        max_level => 'error',
        mode => 'append',
    },
    screen => {
        class => 'Log::Dispatch::Screen',
        stderr => 0,
        newline => 1,
        utf8 => 1,
        format => '%m',
        min_level => 'debug',
    }
};
CONFIG

    ok -f $config, "logger.pl exists";

    $mt->config(LoggerConfig => $config);
    return $config;
}

sub prepare_yaml_config {
    eval { require Log::Dispatch::Configurator::YAML; 1 } or do {
        note "requires Log::Dispatch::Configurator::YAML";
        return;
    };

    my $config = $test_env->path('logger.yaml');
    ok !-e $config, "config does not exist yet";

    $test_env->save_file( 'logger.yaml', <<"CONFIG" );
dispatchers:
    - file1
    - file2
    - screen
file1:
    class: Log::Dispatch::File
    filename: $logfile
    autoflush: 1
    newline: 1
    binmode: ':utf8'
    format: %m
    min_level: info
    mode: append
file2:
    class: Log::Dispatch::File
    filename: $logfile2
    autoflush: 1
    newline: 1
    binmode: ':utf8'
    format: %m
    min_level: warn
    max_level: error
    mode: append
screen:
    class: Log::Dispatch::Screen
    stderr: 0
    newline: 1
    utf8: 1
    format: %m
    min_level: debug
CONFIG

    ok -f $config, "logger.yaml exists";

    $mt->config(LoggerConfig => $config);
    return $config;
}
