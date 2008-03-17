# Movable Type (r) Open Source (C) 2001-2008 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

package MT::JobQueue;

use strict;
use base qw( MT::ErrorHandler );

sub new {
    my $class = shift;
    my $self = bless {}, $class;
    $self->init(@_);
    $self;
}

sub init {
    my $self = shift;
    $self->{os} = $^O;
    $self->get_status;
}

sub get_status {
    my $self = shift;
    my $cmd  = $self->_ps_command;
    open PS, $cmd . " |"
      or return MT->translate( "Can't get process: [_1].", "$!" );
    my @ps = <PS>;
    close PS;
    my @pq = grep /run-periodic-tasks/i, @ps;
    my ( $pid, $mem, $cpu, $uptime );
    if ( $self->{os} eq 'MSWin32' ) {

        if ( $pq[0] =~
m/^\S+\s+(\d+)\s+\w+\s+\d+\s+([\d,]+) K\s+\w+\s+\S+\s+(\d+:\d+:\d+).*/
          )
        {
            $pid = $1;
            $cpu = $3;
            $mem = $2;
            $mem =~ s/\D//g;
        }
    }
    else {
        if ( $pq[0] =~
m/^\s+(\d+)\s+((?:\d+-)?(?:\d+:)?\d+:\d+)\s(\d+)\s+((?:\d+-)?(?:\d+:)?\d+:\d+).*/
          )
        {
            $pid    = $1;
            $cpu    = $2;
            $mem    = $3;
            $uptime = $4;
        }
    }
    $self->{is_running} = scalar @pq;
    $self->{pid}        = $pid || '-';
    $self->{cpu}        = $cpu || '-';
    $self->{memory}     = $mem || '-';
    $self->{uptime}     = $uptime || '-';
}

sub _ps_command {
    my $self = shift;
    my $cmd;
    if ( $self->{os} eq 'MSWin32' ) {
        $cmd = 'tasklist /V';
    }
    else {

        # cputime: cumulative cpu time
        # pid: process id number
        # rss: resident set size of memory
        # etime: elapsed time since the process was started
        $cmd = 'ps axo pid,cputime,rss,etime,command';
    }
    $cmd;
}

sub is_running {
    my $self = shift;
    $self->{is_running};
}

sub pid {
    my $self = shift;
    $self->{pid};
}

sub cpu {
    my $self = shift;
    $self->{cpu};
}

sub memory {
    my $self = shift;
    $self->{memory};
}

sub uptime {
    my $self = shift;
    $self->{uptime};
}

1;
