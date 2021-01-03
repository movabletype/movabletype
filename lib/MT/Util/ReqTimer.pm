# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

=head1 NAME

MT::Util::ReqTimer

=head1 DESCRIPTION

This is a simple class to let us get custom and granular
and log parts of the request cycle.

Note that the timerlogger has got some custom stuff in
it to handle the data we're passing into it, so that
it can log pretty in some placess and machine-readable
in other places.

Requires installation of Time::HiRes and List::Util
(Time::HiRes is core to Perl 5.8.0 and later).

=cut

package MT::Util::ReqTimer;

use strict;
use warnings;
use List::Util qw( sum );
use Time::HiRes;

our $Timer;

sub instance {
    return $Timer ||= shift->new;
}

sub new {
    my $class = shift;
    $class = ref $class || $class;
    my $self = bless {}, $class;
    $self->start(@_);
    return $self;
}

sub start {
    my $self = shift;
    $self->{uri} = shift || '';
    $self->{prev} = $self->{first} = Time::HiRes::time();
    $self->{paused}  = [];
    $self->{elapsed} = 0;
    $self->{dur}     = [];
}

sub mark {
    my ( $self, $mark_str ) = @_;
    $mark_str = ( caller(1) )[3] unless $mark_str;
    my $now = Time::HiRes::time();
    my $dur = $now - $self->{prev};
    $self->{elapsed} += $dur;
    push @{ $self->{dur} }, [ $dur, $mark_str, $self->{elapsed} ];
    if ( @{ $self->{paused} } ) {
        my $paused = pop @{ $self->{paused} };
        if ( ref $paused ne 'ARRAY' ) {
            $paused = [];
        }
        my ( $start, $end ) = @$paused;

        #back up enough to account for the time spent doing other things
        $self->{prev} = $start - ( $end - $now );
    }
    else {
        $self->{prev} = $now;
    }
}

sub log {
    my $self = shift;

    #my $timerlogger = Log::Log4perl::get_logger('TypeCore::Util::ReqTimer');
    #$timerlogger->info($self->{uri}, $self->{dur});
}

sub dump_line {
    my $self = shift;
    my (@more) = @_;
    my @lines;
    push @lines, "pid=$$";
    push @lines, "uri=[" . $self->{uri} . ']' if $self->{uri};
    push @lines, @more if @more;
    my $total     = 0;
    my $threshold = MT->config->PerformanceLoggingThreshold;
    foreach ( @{ $self->{dur} } ) {
        my $dur = $_->[0];
        if ( $_->[1] =~ m/^total\b/ ) {
            $dur = $_->[2];
        }

        if ($dur >= $threshold) {
            push @lines, sprintf("%s=%.5f", $_->[1], $dur);
        }
        $total += $_->[0];
    }
    return '' if ( $total < $threshold );
    push @lines, sprintf( "Total=%.5f", $total );
    my @times = localtime(time);
    my $mon   = (
        'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    )[ $times[4] ];
    my $day
        = ( 'Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat' )[ $times[6] ];
    my $mday = $times[3];
    my $year = $times[5] + 1900;
    my ( $hr, $mn, $sc ) = ( $times[2], $times[1], $times[0] );
    my $ts = sprintf( "%s %s %s %02d:%02d:%02d %04d",
        $day, $mon, $mday, $hr, $mn, $sc, $year );

    require Sys::Hostname;    # available in core as of Perl 5.6.0
    my $hostname = Sys::Hostname::hostname();

    return "[$ts] $hostname pt-times: " . join( ", ", @lines ) . "\n";
}

sub dump {
    my $self      = shift;
    my $lines     = '';
    my $total     = 0;
    my $threshold = MT->config->PerformanceLoggingThreshold;
    foreach ( @{ $self->{dur} } ) {
        my $dur = $_->[0];
        if ( $_->[1] =~ m/^total\b/ ) {
            $dur = $_->[2];
        }
        if ( $dur >= $threshold ) {
            $lines .= sprintf( "%s - %.5f %s\n", $$, $dur, $_->[1] );
        }
        $total += $_->[0];
    }
    return '' if ( $total < $threshold );
    $lines .= sprintf( "%s - %.5f --Total-- %s\n", $$, $total, $self->{uri} );
    return $lines;
}

sub pause_partial {
    my $self = shift;
    my $now  = Time::HiRes::time();
    push @{ $self->{paused} }, [ $self->{prev}, $now ];

    $self->{prev} = $now;
}

sub unpause {
    my ($self) = @_;
    my $now    = Time::HiRes::time();
    my $dur    = $now - $self->{prev};
    $self->{elapsed} += $dur;
    if ( @{ $self->{paused} } ) {
        my $paused = pop @{ $self->{paused} };
        if ( ref $paused ne 'ARRAY' ) {
            $paused = [];
        }
        my ( $start, $end ) = @$paused;

        #back up enough to account for the time spent doing other things
        $self->{prev} = $start - ( $end - $now );
    }
    else {
        $self->{prev} = $now;
    }
}

sub total_elapsed {
    my $timer = shift;
    return Time::HiRes::time() - $timer->{first};
}

1;
