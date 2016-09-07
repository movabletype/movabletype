# Movable Type (r) (C) 2001-2016 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$
package MT::Util::Log;
use strict;
use warnings;
use MT;
use base qw( Class::Accessor::Fast MT::ErrorHandler );
use vars qw( $Module $Can_use );

#__PACKAGE__->mk_accessors(qw( can_use ));

sub _find_module {

    # lookup argument for unit test.
    my ( $logger_level, $logger_path, $logger_module ) = @_;

    if ( !$logger_level ) {
        ## if MT was not yet instantiated, ignore the config directive.
        eval { $logger_level = MT->config->LoggerLevel || '' };
        return
            if (
               !$logger_level
            || uc $logger_level eq 'NONE'
            || (   uc $logger_level ne 'NONE'
                && uc $logger_level ne 'DEBUG'
                && uc $logger_level ne 'WARN'
                && uc $logger_level ne 'ERROR' )
            );
    }

    if ( !$logger_path ) {
        ## if MT was not yet instantiated, ignore the config directive.
        eval { $logger_path = MT->config->LoggerPath || '' };
        return unless $logger_path;
    }

    if ( !$logger_module ) {
        ## if MT was not yet instantiated, ignore the config directive.
        eval { $logger_module = MT->config->LoggerModule || '' };
    }
    if ($logger_module) {
        $logger_module =~ s/^Log:://;
        die 'Invalid Log module' if $logger_module =~ /[^\w:]/;
        if ( $logger_module !~ /::/ ) {
            $logger_module = 'MT::Util::Log::' . $logger_module;
        }
        eval "require $logger_module";
        die "Cannot load Log module: $@" if $@;
        $Module = $logger_module;
    }
    else {
        eval { require Log::Log4perl };
        $Module
            = $@
            ? 'MT::Util::Log::Minimal'
            : 'MT::Util::Log::Log4perl';
        eval "require $Module";
        return if $@;
    }

    $Can_use = 1;

    1;
}

BEGIN { _find_module() }

sub debug {
    my ( $class, $msg ) = @_;
    return unless $Can_use;
    _write_log( 'DEBUG', $msg );
}

sub info {
    my ( $class, $msg ) = @_;
    return unless $Can_use;
    _write_log( 'INFO', $msg );
}

sub warn {
    my ( $class, $msg ) = @_;
    return unless $Can_use;
    _write_log( 'WARN', $msg );
}

sub error {
    my ( $class, $msg ) = @_;
    return unless $Can_use;
    _write_log( 'ERROR', $msg );
}

sub _write_log {
    my ( $level, $msg ) = @_;
    return unless $Can_use;
    eval {
        my $logger = $Module->new( _get_logfile_path() );
        $logger->error( _get_message( $level, $msg ) );
    };
    if ($@) {
        my $errmsg = Encode::is_utf8($@) ? $@ : Encode::decode_utf8($@);
        die MT->translate( 'Failed to write log: [_1]', $errmsg );
    }
}

sub _get_message {
    my ( $level, $message ) = @_;

    my $memory;
    my $cmd = MT->config->ProcessMemoryCommand;
    if ($cmd) {
        my $re;
        if ( ref($cmd) eq 'HASH' ) {
            $re  = $cmd->{regex};
            $cmd = $cmd->{command};
        }
        $cmd =~ s/\$\$/$$/g;
        $memory = `$cmd`;
        if ($re) {
            if ( $memory =~ m/$re/ ) {
                $memory = $1;
                $memory =~ s/\D//g;
            }
        }
        else {
            $memory =~ s/\s+//gs;
        }
    }

    my ( $pkg, $filename, $line ) = caller(3);

    my @time = localtime(time);
    return
        sprintf "%04d-%02d-%02dT%02d:%02d:%02d [%s] %s %s at %s line %d.",
        $time[5] + 1900, $time[4] + 1, @time[ 3, 2, 1, 0 ],
        $level, $memory, $message, $filename, $line;
}

sub _get_logfile_path {
    my @time = localtime(time);

    require File::Spec;
    my $dir = MT->config('LoggerPath') or return;

    my $file = sprintf(
        "al-%04d%02d%02d.log",
        $time[5] + 1900,
        $time[4] + 1,
        $time[3]
    );

    return File::Spec->catfile( $dir, $file );
}

1;
