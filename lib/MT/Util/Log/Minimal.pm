# Movable Type (r) (C) 2001-2017 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$
package MT::Util::Log::Minimal;
use strict;
use warnings;
use MT;
use base qw(MT::Util::Log);

BEGIN {
    use Log::Minimal;
}

sub new {
    my ( $self, $logger_level, $log_file ) = @_;

    $ENV{LM_DEBUG} = 1;

    my $fh;
    open( $fh, '>>', $log_file ) or die "Couldn't open $log_file: $!";
    local $SIG{HUP} = sub {
        undef $fh;
        open( $fh, '>>', $log_file ) or die "Couldn't open $log_file: $!";
    };

    $Log::Minimal::PRINT = sub {
        my ( $time, $type, $message, $trace, $raw_message ) = @_;
        print $fh "$message\n";
    };

    my $level = $logger_level || MT->config->Loggerlevel;
    my $log_level = $level eq 'error' ? 'CRITICAL' : uc $level;
    $Log::Minimal::LOG_LEVEL = $log_level;

    return $self;
}

sub debug {
    my ( $class, $msg ) = @_;
    debugf($msg);
}

sub info {
    my ( $class, $msg ) = @_;
    infof($msg);
}

sub warn {
    my ( $class, $msg ) = @_;
    warnf($msg);
}

sub error {
    my ( $class, $msg ) = @_;
    critf($msg);
}

1;
