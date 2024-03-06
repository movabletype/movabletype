#!/usr/bin/perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib"; # t/lib
use Test::More;
use MT::Test::Env;
use MT::Test::Fluentd;
our $test_env;
BEGIN {
    $test_env = MT::Test::Env->new(
        LoggerLevel  => 'INFO',
        LoggerModule => 'Fluentd',
    );
    $ENV{MT_CONFIG} = $test_env->config_file;
}

my $fluentd = MT::Test::Fluentd->run;

my @logfiles = $fluentd->logfiles;
ok !@logfiles, "no logfiles";

my $mt = MT->instance;

require MT::Util::Log;
MT::Util::Log::init();
MT::Util::Log->info("Some information");
MT::Util::Log->notice("Some notice");
MT::Util::Log->warn("Some warning");
MT::Util::Log->error("Some error");

@logfiles = $fluentd->logfiles;
ok @logfiles, "logfiles exist";

my $log = $fluentd->slurp_logfiles;
like $log => qr/Some information/, "logfile contains correct info log";
like $log => qr/Some notice/, "logfile contains correct notice log";
like $log => qr/Some warning/, "logfile contains correct warning log";
like $log => qr/Some error/, "logfile contains correct error log";

eval {
    use locale;
    use POSIX qw(locale_h);    ## no critic
    setlocale(LC_ALL, "ja_JP.UTF-8");
    my @warnings;
    local $SIG{__WARN__} = sub { push @warnings, @_ };
    mkdir $test_env->path("tmp");
    MT::Util::Log->error("$!");
    ok !@warnings, "Log a Japanese error without warnings" or note explain \@warnings;
};
warn $@ if $@;

done_testing();
