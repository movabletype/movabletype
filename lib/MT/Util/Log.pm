# Movable Type (r) (C) 2001-2020 Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$
package MT::Util::Log;
use strict;
use warnings;
use MT;
use base qw( MT::ErrorHandler );
use vars qw( $Module $Logger );

our %LoggerLevels;
BEGIN {
    %LoggerLevels = (
        DEBUG => 0,
        INFO  => 1,
        WARN  => 2,
        ERROR => 3,
        NONE  => 99,
    );
}
use constant \%LoggerLevels;

our $LoggerLevel;

sub init {
    return if _find_module();

    require MT::Util::Log::Stderr;
    $Logger = MT::Util::Log::Stderr->new;
}

sub _find_module {
    my $logger_level = eval { MT->config->LoggerLevel };

    ## If MT is not ready, just return and use Stderr
    return if $@;

    $logger_level = uc( $logger_level || 'INFO' );

    if ( !defined $LoggerLevels{$logger_level} ) {
        MT->log(
            {   class    => 'system',
                category => 'logs',
                level    => MT::Log::WARNING(),
                message  => MT->translate(
                    'Unknown Logger Level: [_1]',
                    $logger_level
                ),
            }
        );
        return;
    }
    $LoggerLevel = $LoggerLevels{$logger_level};

    my $logger_module = MT->config->LoggerModule or return;

    $logger_module =~ s/^Log:://;
    $logger_module = 'MT::Util::Log::' . $logger_module;
    if ( !eval "require $logger_module; 1" ) {
        warn $@;
        MT->log(
            {   class    => 'system',
                category => 'logs',
                level    => MT::Log::WARNING(),
                message  => MT->translate(
                    'Cannot load Log module: [_1]',
                    MT->config->LoggerModule
                ),
            }
        );
        return;
    }

    return if $logger_module eq 'MT::Util::Log::Stderr';

    my $logfile_path = _get_logfile_path() or return;

    $Logger = eval { $logger_module->new( $logger_level, $logfile_path ) };
    if ($@) {
        warn $@;
        MT->log(
            {   class    => 'system',
                category => 'logs',
                level    => MT::Log::WARNING(),
                message =>
                    MT->translate( '[_1] is not writable.', $logfile_path ),
            }
        );
        return;
    }

    1;
}

sub debug {
    my ( $class, $msg ) = @_;
    return if $LoggerLevel > DEBUG;
    _write_log( 'debug', $msg );
}

sub info {
    my ( $class, $msg ) = @_;
    return if $LoggerLevel > INFO;
    _write_log( 'info', $msg );
}

sub warn {
    my ( $class, $msg ) = @_;
    return if $LoggerLevel > WARN;
    _write_log( 'warn', $msg );
}

sub error {
    my ( $class, $msg ) = @_;
    return if $LoggerLevel > ERROR;
    _write_log( 'error', $msg );
}

sub _write_log {
    my ( $level, $msg ) = @_;
    $Logger->$level( _get_message( uc($level), $msg ) );
}

sub _get_message {
    my ( $level, $message ) = @_;

    my $memory = '';
    if ( MT->config->PerformanceLogging ) {
        $memory = _get_memory();
    }

    my ( $pkg, $filename, $line ) = caller(3);
    unless ($filename) {
        ( $pkg, $filename, $line ) = caller(2);
    }

    my @time = localtime(time);
    return
        sprintf "%04d-%02d-%02dT%02d:%02d:%02d [%s] %s %s at %s line %d.",
        $time[5] + 1900, $time[4] + 1, @time[ 3, 2, 1, 0 ],
        $level, $memory, $message, $filename, $line;
}

sub _get_memory {
    my $cmd = MT->config->ProcessMemoryCommand or return '';
    my $re;
    if ( ref($cmd) eq 'HASH' ) {
        $re  = $cmd->{regex};
        $cmd = $cmd->{command};
    }
    $cmd =~ s/\$\$/$$/g;
    my $memory = `$cmd` or return '';
    if ($re) {
        if ( $memory =~ m/$re/ ) {
            $memory = $1;
            $memory =~ s/\D//g;
        }
    }
    else {
        $memory =~ s/\s+//gs;
    }
    return $memory;
}

sub _get_logfile_path {
    my $dir = MT->config('LoggerPath') or return;

    my @time = localtime(time);
    my $file = sprintf(
        "al-%04d%02d%02d.log",
        $time[5] + 1900,
        $time[4] + 1,
        $time[3]
    );

    require File::Spec;
    return File::Spec->catfile( $dir, $file );
}

1;
