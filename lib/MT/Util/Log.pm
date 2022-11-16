# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$
package MT::Util::Log;
use strict;
use warnings;
use MT;
use base qw( MT::ErrorHandler );

our %LoggerLevels;

BEGIN {
    %LoggerLevels = (
        DEBUG  => 0,
        INFO   => 1,
        NOTICE => 2,
        WARN   => 3,
        ERROR  => 4,
        NONE   => 99,
    );
}
use constant \%LoggerLevels;

our ( $Initialized, $Logger, $LoggerLevel, $LoggerLevelStr, $LoggerPathDate );

sub init {
    if ($Initialized) {
        return unless $Logger && $LoggerPathDate;
        return if _check_logger_path();
    }
    else {
        return if _find_module();
    }

    require MT::Util::Log::Stderr;
    $Logger = MT::Util::Log::Stderr->new;
    $LoggerLevelStr ||= 'INFO';
    $LoggerLevel    = $LoggerLevels{$LoggerLevelStr};
    $LoggerPathDate = undef;
}

sub _check_logger_path {
    my $day = ( localtime() )[3];
    return 1 if $LoggerPathDate == $day;

    my $logfile_path = _get_logfile_path() or return;

    my $logger_module = ref $Logger;

    $Logger = eval { $logger_module->new( $LoggerLevelStr, $logfile_path ) };
    return unless $@;
    return 1;
}

sub _find_module {
    my $logger_level = eval { MT->config->LoggerLevel };

    ## If MT is not ready, just return and use Stderr
    return if $@;

    # No need to reinitialize otherwise; keep using Stderr
    # if something turns out to be wrong
    $Initialized = 1;

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
    $LoggerLevelStr = $logger_level;
    $LoggerLevel    = $LoggerLevels{$logger_level};

    my $logger_module = MT->config->LoggerModule or return;

    $logger_module =~ s/^Log:://;
    $logger_module = 'MT::Util::Log::' . $logger_module;
    if ( !eval "require $logger_module; 1" ) {
        warn $@ if $@ !~ /Can't locate|Attempt to reload/;;
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

    my $config = MT->config('LoggerConfig');
    if ( $config && $logger_module->can('use_config') ) {
        if ( !-f $config ) {
            MT->log(
                {   class    => 'system',
                    category => 'logs',
                    level    => MT::Log::WARNING(),
                    message  => MT->translate( 'File not found: [_1]', $config ),
                }
            );
            return;
        }

        $Logger = eval { $logger_module->new($logger_level) };
        if ($@) {
            warn $@;
            MT->log(
                {   class    => 'system',
                    category => 'logs',
                    level    => MT::Log::WARNING(),
                    message =>
                        MT->translate(
                            'Logger configuration for Log module [_1] seems problematic',
                            MT->config->LoggerModule ),
                    metadata => $@,
                }
            );
            return;
        }
        return 1;
    }

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

sub notice {
    my ( $class, $msg ) = @_;
    return if $LoggerLevel > NOTICE;
    _write_log( 'notice', $msg );
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

sub none { return }

sub _write_log {
    my ( $level, $msg ) = @_;
    return unless $Logger;
    $Logger->$level( _get_message( uc($level), $msg ) );
}

sub _get_message {
    my ( $level, $message ) = @_;

    my $memory = '';
    if ( MT->config->PerformanceLogging ) {
        $memory = _get_memory();
    }

    my $i = 2;
    my ( $pkg, $filename, $line ) = caller($i);
    while ( index( $pkg, "MT::Util::Log" ) == 0 ) {
        ( $pkg, $filename, $line ) = caller(++$i);
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
    require File::Spec;
    my $file = MT->config('LoggerFileName');
    if ( $file and File::Spec->file_name_is_absolute($file) ) {
        return $file;
    }
    my $dir = MT->config('LoggerPath') or return;

    unless ($file) {
        my @time = localtime(time);
        $file = sprintf(
            "al-%04d%02d%02d.log",
            $time[5] + 1900,
            $time[4] + 1,
            $time[3]
        );
        $LoggerPathDate = $time[3];
    }

    return File::Spec->catfile( $dir, $file );
}

1;
