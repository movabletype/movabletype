# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$
package MT::Util::Log::Dispatch;
use strict;
use warnings;
use MT;
use base qw(MT::Util::Log);
use Log::Dispatch::Config;

sub uses_config { 1 }

sub new {
    my ($self, $logger_level, $log_file) = @_;

    my $config = _get_config() || _default_config($logger_level, $log_file);
    Log::Dispatch::Config->configure($config);
    return $self;
}

sub _get_config {
    my $config = MT->config('LoggerConfig');
    return if !$config or !-f $config;

    if ($config =~ /\.pl$/) {
        require Log::Dispatch::Configurator::Perl;
        return Log::Dispatch::Configurator::Perl->new($config);
    }
    if ($config =~ /\.yaml$/) {
        require Log::Dispatch::Configurator::YAML;
        return Log::Dispatch::Configurator::YAML->new($config);
    }
    # suppose it's AppConfig formatted file
    $config;
}

sub _default_config {
    my ($level, $file) = @_;
    $level = lc $level;
    require IO::String;
    return IO::String->new(<<"CONF");
dispatchers = file
file.class = Log::Dispatch::File
file.min_level = $level
file.filename = $file
file.mode = append
file.format = %m
file.binmode = :utf8
file.newline = 1
CONF
}

sub debug {
    my ($class, $msg) = @_;
    my $logger = Log::Dispatch::Config->instance;
    $logger->debug($msg);
}

sub info {
    my ($class, $msg) = @_;
    my $logger = Log::Dispatch::Config->instance;
    $logger->info($msg);
}

sub notice {
    my ($class, $msg) = @_;
    my $logger = Log::Dispatch::Config->instance;
    $logger->notice($msg);
}

sub warn {
    my ($class, $msg) = @_;
    my $logger = Log::Dispatch::Config->instance;
    $logger->warning($msg);
}

sub error {
    my ($class, $msg) = @_;
    my $logger = Log::Dispatch::Config->instance;
    $logger->error($msg);
}

1;
